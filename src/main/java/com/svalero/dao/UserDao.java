package com.svalero.dao;

import com.svalero.domain.User;
import org.jdbi.v3.sqlobject.statement.SqlQuery;
import org.jdbi.v3.sqlobject.statement.UseRowMapper;

public interface UserDao {
    @SqlQuery("SELECT * FROM Users WHERE Username=? AND Password=?")
    @UseRowMapper(UserMapper.class)
    User getUser(String username, String password);

    @SqlQuery("SELECT * FROM Users WHERE Username=?")
    @UseRowMapper(UserMapper.class)
    User getUserFromName(String username);
}
