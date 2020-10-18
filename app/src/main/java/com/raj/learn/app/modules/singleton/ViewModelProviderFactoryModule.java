package com.raj.learn.app.modules.singleton;

import androidx.lifecycle.ViewModelProvider;

import com.raj.learn.app.viewmodel.ViewModelProviderFactory;

import javax.inject.Singleton;

import dagger.Module;
import dagger.Provides;

@Module
public class ViewModelProviderFactoryModule {

    @Singleton
    @Provides
    static ViewModelProvider.Factory provideViewModelProviderFactory(ViewModelProviderFactory viewModelProviderFactory){
        return viewModelProviderFactory;
    }
}
