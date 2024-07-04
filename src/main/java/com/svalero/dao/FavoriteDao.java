package com.svalero.dao;

import com.svalero.domain.Favorite;
import com.svalero.domain.GameCategory;
import org.jdbi.v3.sqlobject.statement.SqlQuery;
import org.jdbi.v3.sqlobject.statement.UseRowMapper;

import java.util.List;

public interface FavoriteDao {
    @SqlQuery("SELECT * FROM Favorites")
    @UseRowMapper(FavoriteMapper.class)
    List<Favorite> getAllGameFavorites();
}
