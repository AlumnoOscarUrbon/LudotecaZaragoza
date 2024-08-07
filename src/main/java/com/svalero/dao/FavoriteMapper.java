package com.svalero.dao;

import com.svalero.domain.Favorite;
import com.svalero.domain.Game;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

public class FavoriteMapper implements RowMapper<Favorite> {

    @Override
    public Favorite map(ResultSet rs, StatementContext ctx) throws SQLException {

        String gameId = rs.getString("gameId");
        List<Game> gameFav = Database.jdbi.withExtension(GameDao.class, dao -> dao.getGameById(gameId));
        LocalDateTime regDateTime = rs.getTimestamp("regDateTime").toLocalDateTime();

        return new Favorite(
                rs.getString("favoriteId"),
                regDateTime,
                rs.getString("userId"),
                rs.getString("gameId"),
                gameFav.get(0)


        );
    }
}


