package com.raj.learn.activity.login;

import android.content.Context;

import com.raj.learn.app.util.EmailValidator;
import com.raj.learn.app.util.PasswordValidator;
import com.raj.learn.database.AppDatabase;
import com.raj.learn.components.user.dao.UserDao;
import com.raj.learn.components.user.service.UserService;

import dagger.Module;
import dagger.Provides;
import retrofit2.Retrofit;

@Module
public class LoginModule {
    @Provides
    static EmailValidator provideEmailValidator(Context context) {
        return new EmailValidator(context);
    }

    @Provides
    static PasswordValidator providePasswordValidator(Context context) {
        return new PasswordValidator(context);
    }

    @Provides
    static UserService provideUserService(Retrofit retrofit) {
        return retrofit.create(UserService.class);
    }

    @Provides
    static UserDao provideUserDao(AppDatabase appDatabase) {
        return appDatabase.getUserDao();
    }
}
