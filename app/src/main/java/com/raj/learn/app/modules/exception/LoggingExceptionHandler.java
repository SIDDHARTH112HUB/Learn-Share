package com.raj.learn.app.modules.exception;

import android.util.Log;

import androidx.annotation.NonNull;

public class LoggingExceptionHandler implements Thread.UncaughtExceptionHandler {
    private final String TAG = "LoggingExceptionHandler";

    @Override
    public void uncaughtException(@NonNull Thread thread, @NonNull Throwable ex) {
        Log.e(TAG, String.format("Exception [%s], Cause [%s], Called for [%s]", ex.getMessage(), ex.getCause(), ex.getClass()));
    }
}
