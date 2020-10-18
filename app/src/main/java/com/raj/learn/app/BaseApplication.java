package com.raj.learn.app;

import com.raj.learn.app.modules.exception.LoggingExceptionHandler;

import dagger.android.AndroidInjector;
import dagger.android.support.DaggerApplication;

public class BaseApplication extends DaggerApplication {

    @Override
    protected AndroidInjector<? extends DaggerApplication> applicationInjector() {
        new LoggingExceptionHandler();
        return DaggerAppComponent.builder().application(this).build();
    }
}
