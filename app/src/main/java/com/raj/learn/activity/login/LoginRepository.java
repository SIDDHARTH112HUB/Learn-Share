package com.raj.learn.activity.login;

import android.util.Log;

import androidx.lifecycle.MutableLiveData;

import com.raj.learn.app.Resource;
import com.raj.learn.components.user.dto.UserDetails;
import com.raj.learn.components.user.dao.UserDao;
import com.raj.learn.components.user.table.UserTable;
import com.raj.learn.components.user.service.UserService;

import java.util.UUID;

import javax.inject.Inject;

import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.schedulers.Schedulers;

public class LoginRepository implements LoginMethods{
    private static final String TAG = "LoginRepository";

    private final UserService userService;
    private final UserDao userDao;
    private final MutableLiveData<Resource<UserDetails>> userDetails;
    private final CompositeDisposable disposable;

    @Inject
    public LoginRepository(UserService userService, UserDao userDao) {
        this.userService = userService;
        this.userDao = userDao;
        this.userDetails = new MutableLiveData<>();
        this.disposable = new CompositeDisposable();
    }

    @Override
    public MutableLiveData<Resource<UserDetails>> getUserDetails() {
        return userDetails;
    }

    @Override
    public void login(String emailId, String password) {
        this.userDetails.setValue(Resource.loading());
        //TODO replace it with server call
        disposable.add(userDao.findByEmailId(emailId)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(this::onSuccess, this::onError, this::onComplete));
    }

    @Override
    public void dispose() {
        if(!disposable.isDisposed()) {
            disposable.dispose();
        }
    }

    private void onSuccess(UserTable user) {
        if(user == null) {
            userDetails.setValue(Resource.error("No user found"));
        }
        assert user != null;
        userDetails.setValue(Resource.success(convert(user)));
    }
    private void onError(Throwable e) {
        userDetails.setValue(Resource.error(e.getMessage()));
    }
    private void onComplete(){
        Log.i(TAG, "Login Completed");
    }
    private UserDetails convert(UserTable userTable) {
        return new UserDetails(UUID.randomUUID(), userTable.getFirstName(), userTable.getLastName(), userTable.getEmailId(), "", userTable.getImageUrl(), true);
    }
}
