package io.github.vtinder.api.repositories.rowmappers;

import io.github.vtinder.api.models.User;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;

import java.sql.ResultSet;
import java.sql.SQLException;

public class RowToUserMapper implements RowMapper<User> {
    @Override
    public User map(ResultSet rs, StatementContext ctx) throws SQLException {
        return new User(
            rs.getString("uuid"),
            rs.getString("name"),
            rs.getString("email"),
            rs.getInt("is_moderator") == 1
        );
    }
}
