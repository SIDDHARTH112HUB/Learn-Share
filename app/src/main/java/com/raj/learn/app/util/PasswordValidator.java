package com.raj.learn.app.util;

import android.content.Context;
import android.widget.Toast;

import com.raj.learn.R;

import java.util.Objects;

public class PasswordValidator {
    private static final String TAG = "PasswordValidator";
    private Context context;
    private final int MIN_LENGTH = 8;
    private final int MAX_LENGTH = 10;

    public PasswordValidator(Context context) {
        this.context = context;
    }

    public boolean isValidPassword(String password) {
        if(Objects.isNull(password) || "".equals(password)) {
            Toast.makeText(context, R.string.emptyPassword, Toast.LENGTH_LONG).show();
            return false;
        }else if(password.length() < MIN_LENGTH || password.length() > MAX_LENGTH) {
            Toast.makeText(context, String.format("Password length should be within %d - %d", MIN_LENGTH, MAX_LENGTH), Toast.LENGTH_LONG).show();
            return false;
        }
        return true;
    }
}
