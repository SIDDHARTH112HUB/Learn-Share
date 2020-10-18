package com.raj.learn.app.util;

import android.content.Context;
import android.util.Patterns;
import android.widget.Toast;

import com.raj.learn.R;

import java.util.Objects;

public class EmailValidator {
    private static final String TAG = "EmailValidator";
    private Context context;

    public EmailValidator(Context context) {
        this.context = context;
    }

    public boolean isValidEmailId(String emailId) {
        if(Objects.isNull(emailId) || "".equals(emailId)) {
            Toast.makeText(context, R.string.emptyEmailId, Toast.LENGTH_LONG).show();
            return false;
        }else if(!Patterns.EMAIL_ADDRESS.matcher(emailId).matches()) {
            Toast.makeText(context, R.string.invalidEmailId, Toast.LENGTH_LONG).show();
            return false;
        }
        return true;
    }
}
