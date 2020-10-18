package com.raj.learn.database;

import androidx.room.Database;
import androidx.room.RoomDatabase;

import com.raj.learn.components.user.dao.UserDao;
import com.raj.learn.components.user.table.UserTable;

@Database(entities = {UserTable.class}, version = 1, exportSchema = false)
public abstract class AppDatabase extends RoomDatabase {
    public abstract UserDao getUserDao();
}
