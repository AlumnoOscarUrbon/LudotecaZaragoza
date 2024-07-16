package com.svalero.dao;

import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.sqlobject.SqlObjectPlugin;

import java.sql.SQLException;

import static com.svalero.util.Constants.*;

public class Database {

    public static Jdbi jdbi;
    public static Handle db;

    public static void connect () throws SQLException, ClassNotFoundException{
        Class.forName(DRIVER);
        jdbi = Jdbi.create(URL, USERNAME, PASSWORD);
        jdbi.installPlugin(new SqlObjectPlugin());
        db = jdbi.open();
        System.out.println("Conexion abierta");
    }

    public static void close() throws SQLException{
        db.close();
        System.out.println("Conexion cerrada");
    }
}