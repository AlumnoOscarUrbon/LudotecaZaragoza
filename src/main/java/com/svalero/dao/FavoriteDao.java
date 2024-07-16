package com.svalero.dao;

import com.svalero.domain.Favorite;
import com.svalero.domain.GameCategory;
import com.svalero.domain.User;
import org.jdbi.v3.sqlobject.customizer.Bind;
import org.jdbi.v3.sqlobject.statement.SqlQuery;
import org.jdbi.v3.sqlobject.statement.SqlUpdate;
import org.jdbi.v3.sqlobject.statement.UseRowMapper;

import java.sql.Date;
import java.util.List;

public interface FavoriteDao {

    @SqlQuery("SELECT * FROM Favorites WHERE UserId = ? AND GameId = ?")
    @UseRowMapper(FavoriteMapper.class)
    Favorite getFavoritesFromUserAndGame(String userId, String favoriteId);


    @SqlQuery("SELECT * FROM Favorites WHERE UserId = ? ")
    @UseRowMapper(FavoriteMapper.class)
    List <Favorite> getFavoritesByUserId(String userId);

    @SqlUpdate("INSERT INTO Favorites  SET UserId = ? , GameId = ? ")
    int addFavorite (String userId, String gameId);

    @SqlUpdate ("DELETE FROM Favorites WHERE UserId = ? AND GameId = ?")
    void deleteFavoriteByGameId (String userId, String gameId);

    @SqlUpdate ("DELETE FROM Favorites WHERE FavoriteId = ?")
    void deleteFavoriteByFavId (String favoriteId);

    @SqlQuery("SELECT f.* " +
            "FROM Favorites f " +
            "JOIN Games g ON f.GameId = g.GameId " +
            "JOIN GameCategories gc ON g.GameCategoryId = gc.GameCategoryId " +
            "WHERE f.UserId = :userId AND ( " +
                " g.Name LIKE CONCAT('%', :searchTerm, '%') " +
                    " OR gc.Name LIKE CONCAT('%', :searchTerm, '%')" +
            ")"
    )
    @UseRowMapper(FavoriteMapper.class)
    List<Favorite> getFavoritesSearch(@Bind("searchTerm")String searchTerm, @Bind("userId")String userId);
}
