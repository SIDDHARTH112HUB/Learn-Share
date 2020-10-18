package com.raj.learn.activity.main;

import androidx.databinding.DataBindingUtil;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import com.raj.learn.R;
import com.raj.learn.activity.BaseActivity;
import com.raj.learn.databinding.ActivityMainBinding;

public class MainActivity extends BaseActivity {
    private static final String TAG = "MainActivity";

    public static void startNewActivity(Context context) {
        Intent intent = new Intent(context, MainActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(intent);
    }

    private ActivityMainBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        this.binding = DataBindingUtil.setContentView(this, R.layout.activity_main);
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