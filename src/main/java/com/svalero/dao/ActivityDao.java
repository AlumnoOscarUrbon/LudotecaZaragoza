package com.svalero.dao;

import com.svalero.domain.Activity;
import org.jdbi.v3.sqlobject.customizer.Bind;
import org.jdbi.v3.sqlobject.statement.SqlQuery;
import org.jdbi.v3.sqlobject.statement.SqlUpdate;
import org.jdbi.v3.sqlobject.statement.UseRowMapper;
import org.jdbi.v3.sqlobject.transaction.Transaction;

import java.sql.Date;
import java.util.List;

public interface ActivityDao {
    @SqlQuery("SELECT * FROM Activities ORDER BY Name")
    @UseRowMapper(ActivityMapper.class)
    List<Activity> getAllActivities();

    @SqlQuery("SELECT * FROM Activities LIMIT ?, ? ORDER BY Name")
    @UseRowMapper(ActivityMapper.class)
    List<Activity> getPaginatedActivities(int primerResultado, int numeroResultados);

    @SqlQuery("SELECT * FROM Activities WHERE ActivityId = ?")
    @UseRowMapper(ActivityMapper.class)
    List <Activity> getActivityById(String activityId);

    @SqlQuery("SELECT * FROM Activities WHERE Name = ?")
    @UseRowMapper(ActivityMapper.class)
    List <Activity> getActivityByName(String activityName);

    @SqlQuery("SELECT * FROM Activities WHERE Name LIKE CONCAT('%',:searchTerm,'%') " +
            "OR Description LIKE CONCAT('%',:searchTerm,'%') ORDER BY Name")
    @UseRowMapper(ActivityMapper.class)
    List<Activity> getFilteredActivities(@Bind("searchTerm")String searchTerm);

    @SqlUpdate ("INSERT INTO Activities  SET Name = ? , ActivityCategoryId = ? , Description = ? , ReleaseDate = ? , Picture = ? ")
    int registerActivity (String activityName, int activityCategoryId, String activityDescription, Date activityRelease, String picture);

    @SqlUpdate ("UPDATE Activities  SET Name = ? , ActivityCategoryId = ? , Description = ? , ReleaseDate = ? , Picture = ? WHERE ActivityId = ?")
    int updateAllActivity (String activityName, int activityCategoryId, String activityDescription, Date gactivityRelease, String picture, String activityId);

    @SqlUpdate ("UPDATE Activities  SET Name = ? , ActivityCategoryId = ? , Description = ? , ReleaseDate = ?  WHERE ActivityId = ?")
    int updateActivityNoImage (String activityName, int activityCategoryId, String activityDescription, Date activityRelease, String activityId);

    @Transaction
    default void deleteActivityWithDependencies(int activityId) {
        deleteSignUpsByActivityId(activityId);
        deleteActivity(activityId);
    };

    @SqlUpdate("DELETE FROM SignUps WHERE ActivityId = :activityId")
    void deleteSignUpsByActivityId(@Bind("activityId") int activityId);

    @SqlUpdate ("DELETE FROM Activities WHERE ActivityId = ?")
    void deleteActivity (int activityId);

    @SqlQuery("SELECT * FROM Activities a JOIN SignUps f ON a.ActivityId = f.SignUpId JOIN Users u ON f.UserId = u.UserId WHERE u.UserId=?")
    @UseRowMapper(ActivityMapper.class)
    List<Activity> getAllActivitiesSignUpsByUser(String idUser);
}