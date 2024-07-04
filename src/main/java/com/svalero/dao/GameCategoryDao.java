package com.svalero.dao;

import com.svalero.domain.Game;
import com.svalero.domain.GameCategory;
import org.jdbi.v3.sqlobject.statement.SqlQuery;
import org.jdbi.v3.sqlobject.statement.UseRowMapper;

import java.util.List;

public interface GameCategoryDao {

    @SqlQuery("SELECT * FROM GameCategories")
    @UseRowMapper(GameCategoryMapper.class)
    List<GameCategory> getAllGameCategories();

    @SqlQuery("SELECT * FROM GameCategories WHERE GameCategoryId = ?")
    @UseRowMapper(GameCategoryMapper.class)
    GameCategory getGameCategoryById(String gameCategoryId);
}
