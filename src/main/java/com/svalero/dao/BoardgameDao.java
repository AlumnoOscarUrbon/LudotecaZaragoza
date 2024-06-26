package com.svalero.dao;

import java.util.List;

import org.jdbi.v3.sqlobject.customizer.Bind;
import org.jdbi.v3.sqlobject.statement.SqlQuery;
import org.jdbi.v3.sqlobject.statement.UseRowMapper;

import com.svalero.domain.Boardgame;

public interface BoardgameDao {
    @SqlQuery("SELECT * FROM Boardgames")
    @UseRowMapper(BoardgameMapper.class)
    List<Boardgame> getAllBoardgames();

    @SqlQuery("SELECT * FROM Boardgames LIMIT ?, ?")
    @UseRowMapper(BoardgameMapper.class)
    List<Boardgame> getPaginatedBoardgames(int primerResultado, int numeroResultados);

    @SqlQuery("SELECT * FROM Boardgames WHERE BoardgameId = ?")
    @UseRowMapper(BoardgameMapper.class)
    Boardgame getdBoardgameById(String boardgameId);

    @SqlQuery("SELECT * FROM Boardgames WHERE Name LIKE CONCAT('%',:searchTerm,'%') " +
            "OR Description LIKE CONCAT('%',:searchTerm,'%')")
    @UseRowMapper(BoardgameMapper.class)
    List<Boardgame> getFilteredBoardgames(@Bind("searchTerm")String searchTerm);
}
