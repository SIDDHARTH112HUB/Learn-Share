package com.raj.learn.activity.login;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Toast;

import androidx.databinding.DataBindingUtil;

import com.jakewharton.rxbinding3.view.RxView;
import com.raj.learn.R;
import com.raj.learn.activity.BaseActivity;
import com.raj.learn.activity.main.MainActivity;
import com.raj.learn.activity.signup.SignUpActivity;
import com.raj.learn.app.util.EmailValidator;
import com.raj.learn.app.util.PasswordValidator;
import com.raj.learn.app.viewmodel.ViewModelProviderFactory;
import com.raj.learn.components.user.dto.UserDetails;
import com.raj.learn.databinding.ActivityLoginBinding;

import javax.inject.Inject;

public class LoginActivity extends BaseActivity {
    private static final String TAG = "LoginActivity";

    @Inject
    public Context context;

    @Inject
    public EmailValidator emailValidator;

    @Inject
    public PasswordValidator passwordValidator;

    @Inject
    public ViewModelProviderFactory factory;

    private LoginViewModel viewModel;

    private ActivityLoginBinding binding;

    public static void startNewActivity(Context context) {
        Intent intent = new Intent(context, LoginActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(intent);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        initData();
        addListeners();
        loadData();
    }

    @Override
    protected void initData() {
        this.binding = DataBindingUtil.setContentView(this, R.layout.activity_login);
        this.viewModel = getViewModel(this, factory, LoginViewModel.class);
    }

    @Override
    protected void addListeners() {
        disposable.add(RxView.clicks(binding.btnSignup).subscribe((view) -> {
            SignUpActivity.startNewActivity(context);
            finish();
        }));

        disposable.add(RxView.clicks(binding.emailEditText).subscribe((view) -> {

        }));

        disposable.add(RxView.clicks(binding.loginButton).subscribe((view) -> {
            final String emailId = binding.emailEditText.getText().toString();
            final String password = binding.passwordEditText.getText().toString();

            if(emailValidator.isValidEmailId(emailId) && passwordValidator.isValidPassword(password)) {
                login(emailId, password);
            }
        }));
    }

    @Override
    protected void loadData() {
        this.viewModel.getUserDetails().observe(this, (resource) -> {
            switch (resource.getStatus()) {
                case LOADING:
                    setLoading(true);
                    break;
                case ERROR:
                    setLoading(false);
                    loginFailure();
                    break;
                case SUCCESS:
                    setLoading(false);
                    loginSuccess(resource.getData());
                    break;
            }
        });
    }

    private void setLoading(boolean status) {
//        this.binding.loginButton.setVisibility(status ? View.INVISIBLE : View.VISIBLE);
    }

    private void login(String emailId, String password) {
        viewModel.login(emailId, password);
    }

    private void loginFailure() {
        Toast.makeText(context, R.string.loginError, Toast.LENGTH_LONG).show();
    }

    private void loginSuccess(UserDetails userDetails) {
        Toast.makeText(context, R.string.loginSuccessMessage, Toast.LENGTH_LONG).show();
        MainActivity.startNewActivity(context);
        finish();
    }
}