package io.github.vtinder.api.config;

import io.github.vtinder.api.repositories.rowmappers.RowToProfileMapper;
import org.jdbi.v3.core.Jdbi;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.Resource;
import org.sqlite.SQLiteDataSource;

import javax.sql.DataSource;
import java.nio.charset.StandardCharsets;

@Configuration
class RepositoryConfig {

    private final String DB_URL = "vtinder.db";

    @Bean
    public DataSource dataSource() {
        SQLiteDataSource dataSource = new SQLiteDataSource();
        dataSource.setUrl("jdbc:sqlite:" + DB_URL);
        return dataSource;
    }

    @Bean
    public Jdbi jdbi(DataSource dataSource) {
        Jdbi jdbi = Jdbi.create(dataSource);
        jdbi.registerRowMapper(new RowToProfileMapper());
        return jdbi;
    }

    @Bean
    CommandLineRunner setupSqliteDatabase(
            Jdbi jdbi,
            @Value("classpath:sql/schema.sql") Resource schemaResource) {
        return args -> {
            String schema = schemaResource.getContentAsString(StandardCharsets.UTF_8);
            jdbi.withHandle(handle -> handle.execute(schema));
        };
    }

}
