package com.raj.learn.app.modules.singleton;

import android.app.Application;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.room.Room;
import androidx.room.RoomDatabase;
import androidx.sqlite.db.SupportSQLiteDatabase;

import com.raj.learn.database.AppDatabase;

import javax.inject.Singleton;

import dagger.Module;
import dagger.Provides;

@Module
public class DatabaseModule {
    private static final String TAG = "DatabaseModule";

    @Provides
    @Singleton
    public AppDatabase provideDataBase(Application application) {
        return Room.databaseBuilder(application, AppDatabase.class, "learn_comm")
                .addCallback(new RoomDatabase.Callback() {
                    @Override
                    public void onCreate(@NonNull SupportSQLiteDatabase db) {
                        super.onCreate(db);
                        onCreateCalled(db);
                    }

                    @Override
                    public void onOpen(@NonNull SupportSQLiteDatabase db) {
                        super.onOpen(db);
                        onOpenCalled(db);
                    }
                })
                .build();
    }

    private void onCreateCalled(SupportSQLiteDatabase db) {
        Log.i(TAG, "onCreateCalled");
    }

    private void onOpenCalled(SupportSQLiteDatabase db) {
        Log.i(TAG, "onOpenCalled");
    }
}
