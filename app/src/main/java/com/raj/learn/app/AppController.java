package com.raj.learn.app;

import android.content.Context;
import javax.inject.Inject;

public class AppController {
    private Context context;

    @Inject
    public AppController(Context context) {
        this.context = context;
    }

    public boolean isContextNull() {
        return context == null;
    }
}
