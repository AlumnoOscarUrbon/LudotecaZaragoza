package com.svalero.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import com.svalero.domain.Game;
import com.svalero.domain.GameCategory;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;

public class GameMapper implements RowMapper<Game>{

    @Override
    public Game map(ResultSet rs, StatementContext ctx) throws SQLException {

        String gameCategoryId = rs.getString("gameCategoryId");
        GameCategory gameCategory = Database.jdbi.withExtension(GameCategoryDao.class, dao -> dao.getGameCategoryById(gameCategoryId));

        return new Game(
                rs.getString("gameId"),
                rs.getString("name"),
                rs.getString("gameCategoryId"),
                rs.getString("description"),
                rs.getDate("releaseDate"),
                rs.getString("picture"),
                gameCategory
        );
    }
}

