package com.svalero.dao;

import com.svalero.domain.Activity;
import org.jdbi.v3.sqlobject.customizer.Bind;
import org.jdbi.v3.sqlobject.statement.SqlQuery;
import org.jdbi.v3.sqlobject.statement.SqlUpdate;
import org.jdbi.v3.sqlobject.statement.UseRowMapper;
import org.jdbi.v3.sqlobject.transaction.Transaction;

import java.time.LocalDateTime;
import java.util.List;

public interface ActivityDao {
    @SqlQuery("SELECT * FROM Activities ORDER BY Name")
    @UseRowMapper(ActivityMapper.class)
    List<Activity> getAllActivities();

    @SqlQuery("SELECT * FROM Activities WHERE ActivityId = ?")
    @UseRowMapper(ActivityMapper.class)
    List <Activity> getActivityById(String activityId);

    @SqlQuery("SELECT * FROM Activities WHERE Name LIKE CONCAT('%',:searchTerm,'%') " +
            "OR Description LIKE CONCAT('%',:searchTerm,'%') ORDER BY Name")
    @UseRowMapper(ActivityMapper.class)
    List<Activity> getFilteredActivities(@Bind("searchTerm")String searchTerm);

    @SqlUpdate ("INSERT INTO Activities  SET Name = ? , ActivityCategoryId = ? , Description = ? , ActivityStart = ? , Picture = ? ")
    int registerActivity (String activityName, int activityCategoryId, String activityDescription, LocalDateTime activityStart, String picture);

    @SqlUpdate ("UPDATE Activities  SET Name = ? , ActivityCategoryId = ? , Description = ? , ActivityStart = ? , Picture = ? WHERE ActivityId = ?")
    int updateAllActivity (String activityName, int activityCategoryId, String activityDescription, LocalDateTime activityStart, String picture, int activityId);

    @SqlUpdate ("UPDATE Activities  SET Name = ? , ActivityCategoryId = ? , Description = ? , ActivityStart = ?  WHERE ActivityId = ?")
    int updateActivityNoImage (String activityName, int activityCategoryId, String activityDescription, LocalDateTime activityStart, int activityId);

    @Transaction
    default void deleteActivityWithDependencies(int activityId) {
        deleteSignUpsByActivityId(activityId);
        deleteActivity(activityId);
    }

    @SqlUpdate("DELETE FROM SignUps WHERE ActivityId = :activityId")
    void deleteSignUpsByActivityId(@Bind("activityId") int activityId);

    @SqlUpdate ("DELETE FROM Activities WHERE ActivityId = ?")
    void deleteActivity (int activityId);
}