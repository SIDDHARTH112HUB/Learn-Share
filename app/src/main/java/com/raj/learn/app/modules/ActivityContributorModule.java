package com.raj.learn.app.modules;
import com.raj.learn.activity.login.LoginActivity;
import com.raj.learn.activity.login.LoginModule;
import com.raj.learn.activity.login.LoginViewModelModule;
import com.raj.learn.activity.main.MainActivity;
import com.raj.learn.activity.main.MainModule;
import com.raj.learn.activity.main.MainViewModelModule;
import com.raj.learn.activity.signup.SignUpActivity;
import com.raj.learn.activity.signup.SignupModule;
import com.raj.learn.activity.signup.SignupViewModelModule;
import com.raj.learn.activity.splash.SplashActivity;
import com.raj.learn.activity.splash.SplashModule;
import com.raj.learn.activity.splash.SplashViewModelModule;

import dagger.Module;
import dagger.android.ContributesAndroidInjector;

@Module
public abstract class ActivityContributorModule {

    @ContributesAndroidInjector(modules = {MainModule.class, MainViewModelModule.class})
    public abstract MainActivity contributeMainActivity();

    @ContributesAndroidInjector(modules = {SplashModule.class, SplashViewModelModule.class})
    public abstract SplashActivity contributeSplashActivity();

    @ContributesAndroidInjector(modules = {LoginModule.class, LoginViewModelModule.class})
    public abstract LoginActivity contributeLoginActivity();

    @ContributesAndroidInjector(modules = {SignupModule.class, SignupViewModelModule.class})
    public abstract SignUpActivity contributeSignupActivity();
}
