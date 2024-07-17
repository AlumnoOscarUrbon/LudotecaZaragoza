package com.svalero.dao;

import com.svalero.domain.SignUp;
import org.jdbi.v3.sqlobject.customizer.Bind;
import org.jdbi.v3.sqlobject.statement.SqlQuery;
import org.jdbi.v3.sqlobject.statement.SqlUpdate;
import org.jdbi.v3.sqlobject.statement.UseRowMapper;

import java.util.List;

public interface SignUpDao {

    @SqlQuery("SELECT * FROM SignUps WHERE UserId = ? AND ActivityId = ?")
    @UseRowMapper(SignUpMapper.class)
    SignUp getSignUpsFromUserAndActivity(String userId, String signUpId);

    @SqlUpdate("INSERT INTO SignUps  SET UserId = ? , ActivityId = ? ")
    void addSignUp(String userId, String activityId);

    @SqlUpdate("DELETE FROM SignUps WHERE UserId = ? AND ActivityId = ?")
    void deleteSignUpByActivityId(String userId, String activityId);

    @SqlUpdate("DELETE FROM SignUps WHERE SignUpId = ?")
    void deleteSignUpBySignUpId(String signUpId);

    @SqlQuery("SELECT s.* " +
            "FROM SignUps s " +
            "JOIN Activities a ON s.ActivityId = a.ActivityId " +
            "JOIN ActivitiesCategories ac ON a.ActivityCategoryId = ac.ActivityCategoryId " +
            "WHERE s.UserId = :userId " +
            "  AND (a.Name LIKE CONCAT('%', :searchTerm, '%') " +
            "       OR ac.Name LIKE CONCAT('%', :searchTerm, '%')" +
            ")"
    )
    @UseRowMapper(SignUpMapper.class)
    List<SignUp> getSignUpsSearch(@Bind("searchTerm") String searchTerm, @Bind("userId") String userId);

}

