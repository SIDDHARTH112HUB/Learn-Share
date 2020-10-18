package com.raj.learn.activity.splash;

import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.view.Window;

import androidx.databinding.DataBindingUtil;

import com.raj.learn.R;
import com.raj.learn.activity.BaseActivity;
import com.raj.learn.activity.login.LoginActivity;
import com.raj.learn.activity.main.MainActivity;
import com.raj.learn.app.preference.UserCredentials;
import com.raj.learn.components.user.dto.UserDetails;
import com.raj.learn.databinding.ActivitySplashBinding;

import java.util.Optional;

import javax.inject.Inject;

public class SplashActivity extends BaseActivity {
    private static final String TAG = "SplashActivity";

    @Inject
    public Context context;

    @Inject
    public UserCredentials userCredentials;

    private ActivitySplashBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_splash);

        binding = DataBindingUtil.setContentView(this, R.layout.activity_splash);
        Optional<UserDetails> userDetails = userCredentials.getUserDetails();

        if(userDetails.isPresent()) {
            new Handler().postDelayed(() -> {
                MainActivity.startNewActivity(this);
                finish();
            }, 1000);
        }else {
            new Handler().postDelayed(() -> {
                LoginActivity.startNewActivity(this);
                finish();
            }, 1000);
        }
    }

    @Override
    protected void initData() {

    }

    @Override
    protected void addListeners() {

    }

    @Override
    protected void loadData() {

    }
}