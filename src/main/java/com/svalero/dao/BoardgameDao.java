package com.svalero.dao;

import java.util.List;

import org.jdbi.v3.sqlobject.statement.SqlQuery;
import org.jdbi.v3.sqlobject.statement.UseRowMapper;
import java.sql.Date;

import com.svalero.domain.Boardgame;

public interface BoardgameDao {
    @SqlQuery("SELECT * FROM Boardgames")
    @UseRowMapper(BoardgameMapper.class)
    List<Boardgame> getAllBoardgames();

    @SqlQuery("SELECT * FROM Boardgames LIMIT ?, ?")
    @UseRowMapper(BoardgameMapper.class)
    List<Boardgame> getPaginatedBoardgames(int primerResultado, int numeroResultados);
}
