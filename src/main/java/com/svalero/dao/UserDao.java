package com.svalero.dao;

import com.svalero.domain.User;
import org.jdbi.v3.sqlobject.customizer.Bind;
import org.jdbi.v3.sqlobject.statement.SqlQuery;
import org.jdbi.v3.sqlobject.statement.SqlUpdate;
import org.jdbi.v3.sqlobject.statement.UseRowMapper;
import org.jdbi.v3.sqlobject.transaction.Transaction;

import java.sql.Date;
import java.util.List;

public interface UserDao {
    @SqlQuery("SELECT * FROM Users WHERE Username=? AND Password= SHA1(?)")
    @UseRowMapper(UserMapper.class)
    User getUser(String username, String password);

    @SqlQuery("SELECT * FROM Users WHERE UserId=?")
    @UseRowMapper(UserMapper.class)
    List <User> getUserById (String userId);

    @SqlUpdate("INSERT INTO Users SET Username = ? , Email = ? , BirthDate = ? , Password = SHA1(?) , Role = ? ")
    int registerUser (String username, String email, Date birthDate, String password, String role);


    @SqlUpdate("UPDATE Users SET Username = ? , Email = ? , BirthDate = ? , Role = ? WHERE UserId = ? ")
    int updateUserWOPassword(String username, String email, Date birthDate, String role, String userId);

    @SqlUpdate("UPDATE Users SET Username = ? , Email = ? , BirthDate = ? , Password = SHA1(?), Role = ? WHERE UserId = ? ")
    int updateUserWithPassword(String username, String email, Date birthDate, String password, String role, String userId);

    //Borrar todas las dependencias en una sola ejecución
    @Transaction
    default void deleteUserWithDependencies(int userId) {
        deleteFavoritesByUserId(userId);
        deleteSignUpsByUserId(userId);
        deleteUser(userId);
    }

    @SqlUpdate ("DELETE FROM Favorites WHERE UserId = ?")
    void deleteFavoritesByUserId(int userId);

    @SqlUpdate ("DELETE FROM Users WHERE UserId = ?")
    void deleteUser (int userId);

    @SqlUpdate ("DELETE FROM SignUps WHERE UserId = ?")
    void deleteSignUpsByUserId (int userId);

    @SqlQuery("SELECT * FROM Users WHERE Username LIKE CONCAT('%',:searchTerm,'%') " +
            "OR Role LIKE CONCAT('%',:searchTerm,'%') " +
            "ORDER BY CASE WHEN UserId = :userId THEN 0 ELSE 1 END, Username")
    @UseRowMapper(UserMapper.class)
    List<User> getUsersSearch(@Bind("searchTerm")String searchTerm, @Bind("userId")String userId);
}