package com.svalero.dao;

import java.sql.ResultSet;
import java.sql.SQLException;

import com.svalero.domain.Game;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;

public class GameMapper implements RowMapper<Game>{

    @Override
    public Game map(ResultSet rs, StatementContext ctx) throws SQLException {
        return new Game(
                rs.getString("gameId"),
                rs.getString("name"),
                rs.getString("gameCategoryId"),
                rs.getString("description"),
                rs.getDate("releaseDate"),
                rs.getString("picture")
        );
    }
}

