package io.github.vtinder.api.repositories.rowmappers;

import io.github.vtinder.api.models.Message;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.Instant;

public class RowToMessageMapper implements RowMapper<Message> {

    @Override
    public Message map(ResultSet rs, StatementContext ctx) throws SQLException {
        return new Message(
            rs.getLong("id"),
            rs.getString("sender_uuid"),
            rs.getString("receiver_uuid"),
            Instant.ofEpochSecond(rs.getLong("timestamp")),
            rs.getString("message"),
            rs.getInt("from_me") == 1
        );
    }

}
