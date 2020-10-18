package com.raj.learn.activity;

import android.content.Context;
import android.content.res.Configuration;

import androidx.annotation.NonNull;
import androidx.lifecycle.ViewModel;
import androidx.lifecycle.ViewModelProvider;
import androidx.lifecycle.ViewModelStoreOwner;
import androidx.recyclerview.widget.DefaultItemAnimator;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.OrientationHelper;
import androidx.recyclerview.widget.RecyclerView;
import androidx.recyclerview.widget.StaggeredGridLayoutManager;

import dagger.android.support.DaggerAppCompatActivity;
import io.reactivex.disposables.CompositeDisposable;

public abstract class BaseActivity extends DaggerAppCompatActivity {
    protected CompositeDisposable disposable = new CompositeDisposable();

    public <T extends ViewModel> T getViewModel(@NonNull ViewModelStoreOwner owner, @NonNull ViewModelProvider.Factory factory, @NonNull Class<T> modelClass) {
        return new ViewModelProvider(owner, factory).get(modelClass);
    }

    public void initAdapter(Context context, RecyclerView recyclerView, RecyclerView.Adapter<RecyclerView.ViewHolder> adapter, RecyclerView.ItemDecoration decorator, RecyclerView.OnScrollListener listener, int orientation) {
        try {
            LinearLayoutManager linearLayoutManager = new LinearLayoutManager(context,
                    orientation, false){
                @Override
                public boolean canScrollVertically() {
                    return true;
                }

                @Override
                public boolean canScrollHorizontally() {
                    return false;
                }
            };
            linearLayoutManager.setSmoothScrollbarEnabled(true);
            linearLayoutManager.setAutoMeasureEnabled(false);

            recyclerView.setAdapter(adapter);
            recyclerView.setLayoutManager(linearLayoutManager);
            recyclerView.setNestedScrollingEnabled(false);
            recyclerView.setFocusable(false);
            recyclerView.setItemAnimator(new DefaultItemAnimator());

            recyclerView.addItemDecoration(decorator);

            if(listener != null) {
                recyclerView.addOnScrollListener(listener);
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    public void initAdapter(Context context, RecyclerView recyclerView, RecyclerView.Adapter<RecyclerView.ViewHolder> adapter, RecyclerView.ItemDecoration decorator, RecyclerView.OnScrollListener listener, int orientation, int spanCount) {
        try {
            if(getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE) {
                spanCount *= 2;
            }

            StaggeredGridLayoutManager staggeredGridLayoutManager = new StaggeredGridLayoutManager(spanCount, orientation){
                @Override
                public boolean canScrollVertically() {
                    if(orientation == OrientationHelper.VERTICAL) {
                        return true;
                    }else {
                        return false;
                    }
                }

                @Override
                public boolean canScrollHorizontally() {
                    if(orientation == OrientationHelper.HORIZONTAL) {
                        return true;
                    }else {
                        return false;
                    }
                }
            };

            staggeredGridLayoutManager.setGapStrategy(StaggeredGridLayoutManager.GAP_HANDLING_MOVE_ITEMS_BETWEEN_SPANS);

            recyclerView.setAdapter(adapter);
            recyclerView.setLayoutManager(staggeredGridLayoutManager);
//            if(getResources().getConfiguration().orientation == Configuration.ORIENTATION_PORTRAIT) {
//                recyclerView.setLayoutManager(new GridLayoutManager(context, 2));
//            }else {
//                recyclerView.setLayoutManager(new GridLayoutManager(context, 4));
//            }
            recyclerView.setNestedScrollingEnabled(false);
            recyclerView.setFocusable(false);
            recyclerView.setItemAnimator(new DefaultItemAnimator());

            recyclerView.addItemDecoration(decorator);

            if(listener != null) {
                recyclerView.addOnScrollListener(listener);
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        if(!disposable.isDisposed()) {
            disposable.dispose();
        }
    }


    protected abstract void initData();
    protected abstract void addListeners();
    protected abstract void loadData();
}
