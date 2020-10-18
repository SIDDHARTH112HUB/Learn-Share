package com.raj.learn.components.user.service;

import com.raj.learn.components.user.dto.UserDetails;


import io.reactivex.Observable;
import retrofit2.http.GET;

public interface UserService {
    @GET("/user/me")
    Observable<UserDetails> getUserDetails();
}
