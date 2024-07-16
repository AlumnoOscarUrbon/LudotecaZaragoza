package com.svalero.dao;

import com.svalero.domain.ActivityCategory;
import org.jdbi.v3.sqlobject.statement.SqlQuery;
import org.jdbi.v3.sqlobject.statement.UseRowMapper;

import java.util.List;

public interface ActivityCategoryDao {

    @SqlQuery("SELECT * FROM ActivitiesCategories")
    @UseRowMapper(ActivityCategoryMapper.class)
    List<ActivityCategory> getAllActivityCategories();

    @SqlQuery("SELECT * FROM ActivitiesCategories WHERE ActivityCategoryId = ?")
    @UseRowMapper(ActivityCategoryMapper.class)
    ActivityCategory getActivityCategoryById(String activityCategoryId);
}
