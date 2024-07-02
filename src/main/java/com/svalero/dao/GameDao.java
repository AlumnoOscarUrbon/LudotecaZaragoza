package com.svalero.dao;

import java.sql.Date;
import java.util.List;

import com.svalero.domain.Game;
import org.jdbi.v3.sqlobject.customizer.Bind;
import org.jdbi.v3.sqlobject.statement.SqlQuery;
import org.jdbi.v3.sqlobject.statement.SqlUpdate;
import org.jdbi.v3.sqlobject.statement.UseRowMapper;
import org.jdbi.v3.sqlobject.transaction.Transaction;

public interface GameDao {
    @SqlQuery("SELECT * FROM Games")
    @UseRowMapper(GameMapper.class)
    List<Game> getAllGames();

    @SqlQuery("SELECT * FROM Games LIMIT ?, ?")
    @UseRowMapper(GameMapper.class)
    List<Game> getPaginatedGames(int primerResultado, int numeroResultados);

    @SqlQuery("SELECT * FROM Games WHERE GameId = ?")
    @UseRowMapper(GameMapper.class)
    List <Game> getGameById(String gameId);

    @SqlQuery("SELECT * FROM Games WHERE Name LIKE CONCAT('%',:searchTerm,'%') " +
            "OR Description LIKE CONCAT('%',:searchTerm,'%')")
    @UseRowMapper(GameMapper.class)
    List<Game> getFilteredGames(@Bind("searchTerm")String searchTerm);

    @SqlUpdate ("UPDATE Games  SET Name = ? , CategoryId = ? , Description = ? , ReleaseDate = ? , Picture = ? WHERE GameId = ?")
    int registerGame (String gameName, int gameCategory, String gameDescription, Date gameRelease, String picture, String gameId);

    @Transaction
    default void deleteGameWithDependencies(int gameId) {
        // Eliminar dependencias en favoritos
        deleteFavoritesByGameId(gameId);
        // Eliminar el juego
        deleteGame(gameId);
    };

    @SqlUpdate("DELETE FROM Favorites WHERE GameId = :gameId")
    void deleteFavoritesByGameId(@Bind("gameId") int gameId);

    @SqlUpdate ("DELETE FROM Games WHERE GameId = ?")
    void deleteGame (int gameId);

}
