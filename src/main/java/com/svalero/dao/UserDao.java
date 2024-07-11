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
    @SqlQuery("SELECT * FROM Users WHERE Username=? AND Password=?")
    @UseRowMapper(UserMapper.class)
    User getUser(String username, String password);

    @SqlQuery("SELECT * FROM Users WHERE UserId=?")
    @UseRowMapper(UserMapper.class)
    List <User> getUserById (String userId);


    @SqlQuery("SELECT * FROM Users WHERE Username = ?")
    @UseRowMapper(UserMapper.class)
    User getUserByUsername (String username);

    @SqlQuery("SELECT * FROM Users ORDER BY CASE WHEN UserId = ? THEN 0 ELSE 1 END, Username")
    @UseRowMapper(UserMapper.class)
    List<User> getAllUsers(String userId);

    @SqlUpdate("INSERT INTO Users SET Username = ? , Email = ? , BirthDate = ? , Password = ? , Role = ? ")
    int registerUser (String username, String email, Date birthDate, String password, String role);


    @SqlUpdate("UPDATE Users SET Username = ? , Email = ? , BirthDate = ? , Role = ? WHERE UserId = ? ")
    int updateUserWOPassword(String username, String email, Date birthDate, String role, String userId);

    @SqlUpdate("UPDATE Users SET Username = ? , Email = ? , BirthDate = ? , Password = ?, Role = ? WHERE UserId = ? ")
    int updateUserWithPassword(String username, String email, Date birthDate, String password, String role, String userId);

    @Transaction
    default void deleteUserWithDependencies(int userId) {
        // Eliminar dependencias en favoritos
        deleteFavoritesByUserId(userId);
        // Eliminar el user
        deleteUser(userId);
    };

    @SqlUpdate ("DELETE FROM Favorites WHERE UserId = ?")
    void deleteFavoritesByUserId(int userId);

    @SqlUpdate ("DELETE FROM Users WHERE UserId = ?")
    void deleteUser (int userId);
}