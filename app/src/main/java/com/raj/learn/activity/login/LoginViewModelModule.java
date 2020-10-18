package com.raj.learn.activity.login;

import androidx.lifecycle.ViewModel;

import com.raj.learn.app.viewmodel.ViewModelKey;

import dagger.Binds;
import dagger.Module;
import dagger.multibindings.IntoMap;

@Module
public abstract class LoginViewModelModule {
    @Binds
    @IntoMap
    @ViewModelKey(LoginViewModel.class)
    public abstract ViewModel bindViewModel(LoginViewModel viewModel);
}
