package com.svalero.dao;

import com.svalero.domain.Favorite;
import com.svalero.domain.Game;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;

import java.sql.ResultSet;
import java.sql.SQLException;

public class FavoriteMapper implements RowMapper<Favorite> {

    @Override
    public Favorite map(ResultSet rs, StatementContext ctx) throws SQLException {
        return new Favorite(
                rs.getString("favoriteId"),
                rs.getDate("regDate"),
                rs.getString("userId"),
                rs.getString("gameId")
        );
    }
}


