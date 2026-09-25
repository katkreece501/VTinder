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
                rs.getInt("id"),
                rs.getString("name"),
                rs.getString("year"),
                rs.getString("bio"),
                rs.getString("major"),
                rs.getString("interests"),
                rs.getString("gradDate"),
                rs.getString("nextSteps"),
                rs.getInt("age"),
                rs.getInt("heightInches"),
                rs.getString("gender"),
                rs.getBytes("image")
        );
    }

}
