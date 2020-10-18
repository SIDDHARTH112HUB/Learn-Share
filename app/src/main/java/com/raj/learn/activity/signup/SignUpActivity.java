package com.raj.learn.activity.signup;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import androidx.databinding.DataBindingUtil;

import com.jakewharton.rxbinding3.view.RxView;
import com.raj.learn.R;
import com.raj.learn.activity.BaseActivity;
import com.raj.learn.activity.login.LoginActivity;
import com.raj.learn.databinding.ActivitySignUpBinding;

import javax.inject.Inject;

public class SignUpActivity extends BaseActivity {
    private static final String TAG = "SignUpActivity";

    @Inject
    public Context context;

    private ActivitySignUpBinding binding;

    public static void startNewActivity(Context context) {
        Intent intent = new Intent(context, SignUpActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(intent);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sign_up);
        this.binding = DataBindingUtil.setContentView(this, R.layout.activity_sign_up);

        disposable.add(RxView.clicks(binding.btnLogin).subscribe((view) -> {
            LoginActivity.startNewActivity(context);
            finish();
        }));
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