package com.raj.learn.app.modules;

import android.content.Context;

import com.raj.learn.app.AppController;
import com.raj.learn.app.SpacingItemDecorator;
import com.raj.learn.app.modules.singleton.ContextModule;
import com.raj.learn.app.modules.singleton.DatabaseModule;
import com.raj.learn.app.modules.singleton.GlideModule;
import com.raj.learn.app.modules.singleton.RetrofitModule;

import javax.inject.Singleton;

import dagger.Module;
import dagger.Provides;

@Module(includes = {
        ContextModule.class,
        GlideModule.class,
        RetrofitModule.class,
        DatabaseModule.class
})
public class AppModule {

    @Provides
    @Singleton
    public AppController provideAppController(Context context) {
        return new AppController(context);
    }

    @Provides
    @Singleton
    public SpacingItemDecorator provideSpacingItemDecorator() {
        return new SpacingItemDecorator(10, 0, 0, 0);
    }
}
