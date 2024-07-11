package com.svalero.dao;

import com.svalero.domain.User;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;

import java.sql.ResultSet;
import java.sql.SQLException;

public class UserMapper implements RowMapper<User>{

    @Override
    public User map(ResultSet rs, StatementContext ctx) throws SQLException {
        return new User(
                rs.getString("userId"),
                rs.getString("username"),
                rs.getString("email"),
                rs.getDate("birthDate"),
                rs.getString("password"),
                rs.getString("role")
        );
    }
}

