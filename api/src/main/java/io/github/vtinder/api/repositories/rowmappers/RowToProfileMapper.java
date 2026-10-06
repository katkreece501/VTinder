package io.github.vtinder.api.repositories.rowmappers;

import io.github.vtinder.api.models.Profile;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;

import java.sql.ResultSet;
import java.sql.SQLException;

public class RowToProfileMapper implements RowMapper<Profile> {

    @Override
    public Profile map(ResultSet rs, StatementContext ctx) throws SQLException {
        return new Profile(
            rs.getString("user_uuid"),
            rs.getString("school_year"),
            rs.getString("bio"),
            rs.getString("major"),
            rs.getString("interests"),
            rs.getString("grad_date"),
            rs.getString("next_steps"),
            rs.getInt("age"),
            rs.getInt("height_inches"),
            rs.getString("gender"),
            rs.getBytes("image")
        );
    }

}
