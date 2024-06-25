package com.svalero.dao;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;

import com.svalero.domain.Boardgame;

public class BoardgameMapper implements RowMapper<Boardgame>{

    @Override
    public Boardgame map(ResultSet rs, StatementContext ctx) throws SQLException {
        return new Boardgame(
                rs.getString("boardgameId"),
                rs.getString("name"),
                rs.getString("brandId"),
                rs.getString("description"),
                rs.getDate("date"),
                rs.getString("picture")
        );
    }
}

