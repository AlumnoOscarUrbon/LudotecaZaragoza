package com.svalero.dao;

import java.time.LocalDate;
import java.util.List;

import com.svalero.domain.Game;
import org.jdbi.v3.sqlobject.customizer.Bind;
import org.jdbi.v3.sqlobject.statement.SqlQuery;
import org.jdbi.v3.sqlobject.statement.SqlUpdate;
import org.jdbi.v3.sqlobject.statement.UseRowMapper;
import org.jdbi.v3.sqlobject.transaction.Transaction;

public interface GameDao {
    @SqlQuery("SELECT * FROM Games ORDER BY Name")
    @UseRowMapper(GameMapper.class)
    List<Game> getAllGames();

    @SqlQuery("SELECT * FROM Games WHERE GameId = ?")
    @UseRowMapper(GameMapper.class)
    List <Game> getGameById(String gameId);

    @SqlQuery("SELECT * FROM Games WHERE Name LIKE CONCAT('%',:searchTerm,'%') " +
            "OR Description LIKE CONCAT('%',:searchTerm,'%') ORDER BY Name")
    @UseRowMapper(GameMapper.class)
    List<Game> getFilteredGames(@Bind("searchTerm")String searchTerm);

    @SqlUpdate ("INSERT INTO Games  SET Name = ? , GameCategoryId = ? , Description = ? , ReleaseDate = ? , Picture = ? ")
    int registerGame (String gameName, int gameCategoryId, String gameDescription, LocalDate gameRelease, String picture);

    @SqlUpdate ("UPDATE Games  SET Name = ? , GameCategoryId = ? , Description = ? , ReleaseDate = ? , Picture = ? WHERE GameId = ?")
    int updateAllGame (String gameName, int gameCategoryId, String gameDescription, LocalDate gameRelease, String picture, int gameId);

    @SqlUpdate ("UPDATE Games  SET Name = ? , GameCategoryId = ? , Description = ? , ReleaseDate = ?  WHERE GameId = ?")
    int updateGameNoImage (String gameName, int gameCategoryId, String gameDescription, LocalDate gameRelease, int gameId);

    @Transaction
    default void deleteGameWithDependencies(int gameId) {
        // Eliminar dependencias en favoritos
        deleteFavoritesByGameId(gameId);
        // Eliminar el juego
        deleteGame(gameId);
    }

    @SqlUpdate("DELETE FROM Favorites WHERE GameId = :gameId")
    void deleteFavoritesByGameId(@Bind("gameId") int gameId);

    @SqlUpdate ("DELETE FROM Games WHERE GameId = ?")
    void deleteGame (int gameId);
}
