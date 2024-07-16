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


    @SqlQuery("SELECT * FROM SignUps WHERE UserId = ? ")
    @UseRowMapper(SignUpMapper.class)
    List<SignUp> getSignUpsByUserId(String userId);

    @SqlUpdate("INSERT INTO SignUps  SET UserId = ? , ActivityId = ? ")
    int addSignUp(String userId, String activityId);

    @SqlUpdate("DELETE FROM SignUps WHERE UserId = ? AND ActivityId = ?")
    void deleteSignUpByActivityId(String userId, String activityId);

    @SqlUpdate("DELETE FROM SignUps WHERE SignUpId = ?")
    void deleteSignUpBySignUpId(String signUpId);

    @SqlQuery("SELECT f.* " +
            "FROM SignUps f " +
            "JOIN Activities g ON f.ActivityId = g.ActivityId " +
            "JOIN ActivitiesCategories gc ON g.ActivityCategoryId = gc.ActivityCategoryId " +
            "WHERE f.UserId = :userId " +
            "  AND (g.Name LIKE CONCAT('%', :searchTerm, '%') " +
            "       OR gc.Name LIKE CONCAT('%', :searchTerm, '%')" +
            ")"
    )
    @UseRowMapper(SignUpMapper.class)
    List<SignUp> getSignUpsSearch(@Bind("searchTerm") String searchTerm, @Bind("userId") String userId);

}

