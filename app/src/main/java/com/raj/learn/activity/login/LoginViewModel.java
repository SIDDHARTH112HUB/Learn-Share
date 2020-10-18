package com.raj.learn.activity.login;

import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

import com.raj.learn.app.Resource;
import com.raj.learn.components.user.dto.UserDetails;

import javax.inject.Inject;

public class LoginViewModel extends ViewModel implements LoginMethods{
    private final LoginRepository loginRepository;

    @Inject
    public LoginViewModel(LoginRepository loginRepository) {
        this.loginRepository = loginRepository;
    }

    @Override
    public MutableLiveData<Resource<UserDetails>> getUserDetails() {
        return loginRepository.getUserDetails();
    }

    @Override
    public void login(String emailId, String password) {
        loginRepository.login(emailId, password);
    }

    @Override
    public void dispose() {
        loginRepository.dispose();
    }
}
