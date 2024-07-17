package com.svalero.dao;

import com.svalero.domain.GameCategory;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;

import java.sql.ResultSet;
import java.sql.SQLException;

public class GameCategoryMapper implements RowMapper<GameCategory> {

    @Override
    public GameCategory map(ResultSet rs, StatementContext ctx) throws SQLException {
        return new GameCategory(
                rs.getString("gameCategoryId"),
                rs.getString("name")
        );
    }
}


