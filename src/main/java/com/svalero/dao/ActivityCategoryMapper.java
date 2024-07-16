package com.svalero.dao;

import com.svalero.domain.ActivityCategory;
import com.svalero.domain.GameCategory;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;

import java.sql.ResultSet;
import java.sql.SQLException;

public class ActivityCategoryMapper implements RowMapper<ActivityCategory> {

    @Override
    public ActivityCategory map(ResultSet rs, StatementContext ctx) throws SQLException {
        return new ActivityCategory(
                rs.getString("activityCategoryId"),
                rs.getString("name")
        );
    }
}


