package com.raj.learn.app.modules.singleton;

import android.app.Application;
import android.content.Context;

import javax.inject.Singleton;

import dagger.Module;
import dagger.Provides;

@Module
public class ContextModule {
    @Singleton
    @Provides
    static Context provideContext(Application application) {
        return application.getApplicationContext();
    }
}
