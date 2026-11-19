package io.github.vtinder.api.config;

import io.github.vtinder.api.repositories.rowmappers.RowToMessageMapper;
import io.github.vtinder.api.repositories.rowmappers.RowToProfileMapper;
import io.github.vtinder.api.repositories.rowmappers.RowToReportMapper;
import io.github.vtinder.api.repositories.rowmappers.RowToUserMapper;
import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.HandleListener;
import org.jdbi.v3.core.Handles;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.locator.ClasspathSqlLocator;
import org.jdbi.v3.core.statement.Batch;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.sqlite.SQLiteDataSource;

import javax.sql.DataSource;
import java.io.IOException;
import java.io.InputStream;
import java.io.UncheckedIOException;

@Configuration
class RepositoryConfig {

    @Bean
    public DataSource dataSource() {
        SQLiteDataSource dataSource = new SQLiteDataSource();
        dataSource.setUrl("jdbc:sqlite:vtinder.db");
        return dataSource;
    }

    @Bean
    public Jdbi jdbi(DataSource dataSource) {
        Jdbi jdbi = Jdbi.create(dataSource);
        jdbi.registerRowMapper(new RowToProfileMapper());
        jdbi.registerRowMapper(new RowToUserMapper());
        jdbi.registerRowMapper(new RowToMessageMapper());
        jdbi.registerRowMapper(new RowToReportMapper());
        jdbi.getConfig(Handles.class).addListener(new HandleListener() {
            @Override
            public void handleCreated(Handle handle) {
                handle.execute("PRAGMA foreign_keys = ON");
            }
        });
        return jdbi;
    }

    @Bean
    @Order(1)
    public CommandLineRunner setupSqliteDatabase(
            Jdbi jdbi) {
        return args -> {
            String schema = ClasspathSqlLocator.create().locate("/sql/schema");
            String[] tables = schema.split(";");
            jdbi.useHandle(handle -> {
                Batch batch = handle.createBatch();
                for (String table : tables) {
                    if (!table.isBlank()) {
                        batch.add(table);
                    }
                }
                batch.execute();
                handle.commit();
            });

            if (jdbi.withHandle(handle -> handle.createQuery("SELECT COUNT(*) FROM users").mapTo(Integer.class).one()) == 0) {
                String mockData = ClasspathSqlLocator.create().locate("/sql/mockdata");
                String[] inserts = mockData.split(";");
                jdbi.useHandle(handle -> {
                    for (String insert : inserts) {
                        if (!insert.isBlank()) {
                            handle.execute(insert);
                        }
                    }
                    handle.commit();
                });
                insertPhotos(jdbi);
            }

        };
    }

    /**
     * Loads every image in the demoimages resource folder and stores it in the
     * image column of the profile whose user_uuid matches the file name
     * (e.g. 1111...jpg -> profile with user_uuid 1111...).
     */
    static void insertPhotos(Jdbi jdbi) {
        try {
            Resource[] images = new PathMatchingResourcePatternResolver()
                    .getResources("classpath:demoimages/*");
            jdbi.useHandle(handle -> {
                for (Resource image : images) {
                    String filename = image.getFilename();
                    if (filename == null || !image.isReadable()) {
                        continue;
                    }
                    int dot = filename.lastIndexOf('.');
                    String uuid = dot > 0 ? filename.substring(0, dot) : filename;
                    try (InputStream in = image.getInputStream()) {
                        handle.createUpdate("UPDATE profiles SET image = :image WHERE user_uuid = :uuid")
                                .bind("image", in.readAllBytes())
                                .bind("uuid", uuid)
                                .execute();
                    } catch (IOException e) {
                        throw new UncheckedIOException("Failed to read demo image " + filename, e);
                    }
                }
            });
        } catch (IOException e) {
            throw new UncheckedIOException("Failed to load demo images", e);
        }
    }

}
