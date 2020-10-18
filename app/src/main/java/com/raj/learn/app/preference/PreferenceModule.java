package com.raj.learn.app.preference;

import android.content.Context;

import com.google.gson.Gson;

import javax.inject.Singleton;

import dagger.Module;
import dagger.Provides;

@Module
public class PreferenceModule {
    @Singleton
    @Provides
    static SharedPreferenceManager provideSharedPreference(Context context, Gson gson) {
        return new SharedPreferenceManager(context, gson);
    }

    @Singleton
    @Provides
    static UserCredentials provideUserCredentials(SharedPreferenceManager sharedPreferenceManager) {
        return new UserCredentials(sharedPreferenceManager);
    }
}
