package com.svalero.dao;

import com.svalero.domain.Activity;
import com.svalero.domain.SignUp;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

public class SignUpMapper implements RowMapper<SignUp> {

    @Override
    public SignUp map(ResultSet rs, StatementContext ctx) throws SQLException {

        String activityId = rs.getString("activityId");
        List<Activity> activitySignUp = Database.jdbi.withExtension(ActivityDao.class, dao -> dao.getActivityById(activityId));
        LocalDateTime regDateTime = rs.getTimestamp("regDateTime").toLocalDateTime();

        return new SignUp(
                rs.getString("signUpId"),
                regDateTime,
                rs.getString("userId"),
                rs.getString("activityId"),
                activitySignUp.get(0)
        );
    }
}


