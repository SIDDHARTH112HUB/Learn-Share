package com.raj.learn.activity.login;

import androidx.lifecycle.MutableLiveData;

import com.raj.learn.app.Resource;
import com.raj.learn.components.user.dto.UserDetails;

public interface LoginMethods {
    MutableLiveData<Resource<UserDetails>> getUserDetails();
    void login(String emailId, String password);
    void dispose();
}
