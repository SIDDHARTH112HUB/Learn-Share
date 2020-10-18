package com.raj.learn.app.modules.singleton;

import android.app.Application;

import com.bumptech.glide.Glide;
import com.bumptech.glide.RequestManager;
import com.bumptech.glide.request.RequestOptions;
import com.raj.learn.R;

import javax.inject.Singleton;

import dagger.Module;
import dagger.Provides;

@Module
public class GlideModule {
    @Singleton
    @Provides
    static RequestOptions provideRequestOptions() {
        return RequestOptions
                .placeholderOf(R.drawable.no_thumbnail)
                .error(R.drawable.default_image);
    }

    @Singleton
    @Provides
    static RequestManager provideGlideInstance(Application application, RequestOptions requestOptions) {
        return Glide.with(application)
                .setDefaultRequestOptions(requestOptions);
    }
}
