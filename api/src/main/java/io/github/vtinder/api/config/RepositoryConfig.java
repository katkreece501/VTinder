package io.github.vtinder.api.config;

import io.github.vtinder.api.repositories.rowmappers.RowToProfileMapper;
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
import org.sqlite.SQLiteDataSource;

import javax.sql.DataSource;

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
                    batch.add(table);
                }
                batch.execute();
                handle.commit();
            });

            if (jdbi.withHandle(handle -> handle.createQuery("SELECT COUNT(*) FROM users").mapTo(Integer.class).one()) == 0) {
                String mockData = ClasspathSqlLocator.create().locate("/sql/mockdata");
                String[] inserts = mockData.split(";");
                jdbi.useHandle(handle -> {
                    Batch batch = handle.createBatch();
                    for (String insert : inserts) {
                        batch.add(insert);
                    }
                    batch.execute();
                    handle.commit();
                });
            }

        };
    }

}
