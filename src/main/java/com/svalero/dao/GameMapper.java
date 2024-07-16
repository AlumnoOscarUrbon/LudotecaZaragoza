package com.svalero.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
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
        LocalDateTime releaseDateTime= rs.getTimestamp("releaseDate").toLocalDateTime();
        return new Game(
                rs.getString("gameId"),
                rs.getString("name"),
                rs.getString("gameCategoryId"),
                rs.getString("description"),
                releaseDateTime,
                rs.getString("picture"),
                gameCategory
        );
    }
}

