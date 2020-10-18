package com.raj.learn.components.user.dao;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Query;
import androidx.room.Update;

import com.raj.learn.components.user.table.UserTable;

import java.util.List;

import io.reactivex.Flowable;
import io.reactivex.Observable;

@Dao
public interface UserDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    void add(UserTable... items);

    @Update
    void update(UserTable... items);

    @Delete
    void delete(UserTable... items);

    @Query("SELECT * FROM user")
    Flowable<List<UserTable>> getAll();

    @Query("SELECT * FROM user where email_id = :emailId")
    Observable<UserTable> findByEmailId(String emailId);
}
