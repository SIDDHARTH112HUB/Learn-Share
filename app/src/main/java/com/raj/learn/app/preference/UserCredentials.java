package com.raj.learn.app.preference;

import com.raj.learn.components.user.dto.UserDetails;

import java.util.Optional;

public class UserCredentials {
    private SharedPreferenceManager sharedPreferenceManager;

    public UserCredentials(SharedPreferenceManager sharedPreferenceManager) {
        this.sharedPreferenceManager = sharedPreferenceManager;
    }

    public Optional<UserDetails> getUserDetails() {
        UserDetails userDetails = sharedPreferenceManager.getObject("userDetails", UserDetails.class);
        if(userDetails == null) {
            return Optional.empty();
        }
        return Optional.of(userDetails);
    }

    public void putUserDetails(UserDetails userDetails) {
        sharedPreferenceManager.putObject("userDetails", userDetails);
    }
}
