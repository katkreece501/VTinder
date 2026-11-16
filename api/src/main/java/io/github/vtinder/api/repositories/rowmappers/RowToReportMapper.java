package io.github.vtinder.api.repositories.rowmappers;

import io.github.vtinder.api.models.Report;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.Instant;

public class RowToReportMapper implements RowMapper<Report> {

    @Override
    public Report map(ResultSet rs, StatementContext ctx) throws SQLException {
        return new Report(
            rs.getLong("id"),
            rs.getString("reporter_uuid"),
            rs.getString("reporter_name"),
            rs.getString("reported_uuid"),
            rs.getString("reported_name"),
            Instant.ofEpochSecond(rs.getLong("timestamp")),
            rs.getString("reason")
        );
    }

}
