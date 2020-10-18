package com.raj.learn.app.preference;

import android.content.Context;
import android.content.SharedPreferences;

import androidx.security.crypto.EncryptedSharedPreferences;
import androidx.security.crypto.MasterKeys;

import com.google.gson.Gson;
import com.raj.learn.R;

import java.io.IOException;
import java.lang.reflect.Type;
import java.security.GeneralSecurityException;

public class SharedPreferenceManager {
    private SharedPreferences sharedPreferences;
    private Gson gson;

    public SharedPreferenceManager(Context context, Gson gson) {
        this.gson = gson;
        try {
            String masterKeyAlias = MasterKeys.getOrCreate(MasterKeys.AES256_GCM_SPEC);
            this.sharedPreferences = EncryptedSharedPreferences.create(context.getString(R.string.preference_file_key),
                    masterKeyAlias,
                    context,
                    EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                    EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
            );
        }catch (GeneralSecurityException | IOException e) {
            sharedPreferences = context.getSharedPreferences(context.getString(R.string.preference_file_key), Context.MODE_PRIVATE);
        }
    }

    public int getInteger(String key, int defaultVal) {
        return sharedPreferences.getInt(key, defaultVal);
    }

    public void putInteger(String key, int defaultVal) {
        sharedPreferences.edit().putInt(key, defaultVal).apply();
    }

    public boolean getBoolean(String key, boolean defaultVal) {
        return sharedPreferences.getBoolean(key, defaultVal);
    }

    public void putBoolean(String key, boolean defaultVal) {
        sharedPreferences.edit().putBoolean(key, defaultVal).apply();
    }

    public void putObject(String key, Object value) {
        sharedPreferences.edit().putString(key, gson.toJson(value)).apply();
    }

    public <T> T getObject(String key, Class<T> typeOfObject) {
        String value = getString(key, null);
        if (value == null) {
            return null;
        }
        return gson.fromJson(value, typeOfObject);
    }

    public String getString(String key, String defaultVal) {
        return sharedPreferences.getString(key, defaultVal);
    }

    public Object getObject(String key, Type type) {
        String value = getString(key, null);
        if (value == null) {
            return null;
        }
        return gson.fromJson(value, type);
    }

    public void putString(String key, String value) {
        sharedPreferences.edit().putString(key, value).apply();
    }

    public long getLong(String key, long defaultVal) {
        return sharedPreferences.getLong(key, defaultVal);
    }

    public void putLong(String key, long value) {
        sharedPreferences.edit().putLong(key, value).apply();
    }

    public void reset() {
        sharedPreferences.edit().clear().apply();
    }

    public boolean contains(String key) {
        return sharedPreferences.contains(key);
    }
}
