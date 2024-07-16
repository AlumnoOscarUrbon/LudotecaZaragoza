package com.svalero.dao;

import com.svalero.domain.Activity;
import com.svalero.domain.ActivityCategory;
import com.svalero.domain.Game;
import com.svalero.domain.GameCategory;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;

public class ActivityMapper implements RowMapper<Activity>{

    @Override
    public Activity map(ResultSet rs, StatementContext ctx) throws SQLException {

        String activityCategoryId = rs.getString("activityCategoryId");
        ActivityCategory activityCategory = Database.jdbi.withExtension(ActivityCategoryDao.class, dao -> dao.getActivityCategoryById(activityCategoryId));

        LocalDateTime activityDateTime = rs.getTimestamp("ActivityStart").toLocalDateTime();
        return new Activity(
                rs.getString("activityId"),
                rs.getString("name"),
                rs.getString("activityCategoryId"),
                rs.getString("description"),
                activityDateTime,
                rs.getString("picture"),
                activityCategory
        );
    }
}

