package com.raj.learn.app;

import android.app.Application;

import com.raj.learn.app.modules.ActivityContributorModule;
import com.raj.learn.app.modules.AppModule;
import com.raj.learn.app.modules.FragmentContributorModule;
import com.raj.learn.app.modules.singleton.ViewModelProviderFactoryModule;
import com.raj.learn.app.preference.PreferenceModule;

import javax.inject.Singleton;

import dagger.BindsInstance;
import dagger.Component;
import dagger.android.AndroidInjector;
import dagger.android.support.AndroidSupportInjectionModule;

@Singleton
@Component(modules = {
        AndroidSupportInjectionModule.class,
        ViewModelProviderFactoryModule.class,
        AppModule.class,
        PreferenceModule.class,
        ActivityContributorModule.class,
        FragmentContributorModule.class,
})
public interface AppComponent extends AndroidInjector<BaseApplication> {

    @Component.Builder
    interface Builder {
        @BindsInstance
        Builder application(Application application);

        AppComponent build();
    }

//    @Component.Builder
//    abstract class Builder extends AndroidInjector.Builder<BaseApplication> { }
}
