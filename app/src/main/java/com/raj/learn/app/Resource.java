package com.raj.learn.app;

public class Resource<T> {
    private Status status;
    private T data;
    private String message;

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }


    public static <T> Resource<T> loading() {
        Resource<T> resource = new Resource<>();
        resource.status = Status.LOADING;

        return resource;
    }

    public static <T> Resource<T> error(String message) {
        Resource<T> resource = new Resource<>();
        resource.status = Status.ERROR;
        resource.setMessage(message);

        return resource;
    }

    public static <T> Resource<T> success(T data) {
        Resource<T> resource = new Resource<>();
        resource.status = Status.SUCCESS;
        resource.setData(data);

        return resource;
    }

    public enum Status {
        LOADING, ERROR, SUCCESS
    }
}
