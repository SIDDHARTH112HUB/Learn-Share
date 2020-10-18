package com.raj.learn.app;

import android.widget.AbsListView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.recyclerview.widget.StaggeredGridLayoutManager;

public abstract class RecyclerViewScrollListener extends RecyclerView.OnScrollListener {
    private final int scrollPosition;
    private int previousLastPostion = 0;

    public RecyclerViewScrollListener(int scrollPosition){
        this.scrollPosition = scrollPosition;
    }

    @Override
    public void onScrollStateChanged(@NonNull RecyclerView recyclerView, int scrollState) {
        super.onScrollStateChanged(recyclerView, scrollState);
        try{
            if(scrollState == AbsListView.OnScrollListener.SCROLL_STATE_TOUCH_SCROLL) {
                RecyclerView.LayoutManager layoutManager = recyclerView.getLayoutManager();
                int lastPostion = 0;
                if(layoutManager instanceof LinearLayoutManager) {
                    lastPostion = ((LinearLayoutManager) layoutManager).findLastVisibleItemPosition();
                }else if(layoutManager instanceof StaggeredGridLayoutManager){
                    int[] positions = null;
                    positions = ((StaggeredGridLayoutManager) layoutManager).findLastCompletelyVisibleItemPositions(positions);
                    if(positions != null && positions.length > 0){
                        lastPostion = positions[0];
                    }
                }
                if(previousLastPostion <= lastPostion){
                    //when scroll down....
                    previousLastPostion = lastPostion;
                    int totalItem = layoutManager.getItemCount();
                    if (lastPostion >= (totalItem - scrollPosition)) {
                        onScrollDown();
                    }
                }else {
                    //when scroll up...
                    previousLastPostion = lastPostion;
                    onScrollUp();
                }
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    @Override
    public void onScrolled(@NonNull RecyclerView recyclerView, int dx, int dy) {
        super.onScrolled(recyclerView, dx, dy);
    }

    public abstract void onScrollDown();
    public abstract void onScrollUp();
}
