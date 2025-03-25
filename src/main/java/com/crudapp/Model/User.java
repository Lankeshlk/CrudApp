package com.crudapp.Model;

import java.io.InputStream;
import java.sql.Blob;

public class User {
    private int id;
    private String name;
    private String password;
    private String email;
    private InputStream image_path;
    private String image;


    public User(int id, String name, String password, String email, InputStream image_path, String image) {
        this.id = id;
        this.name = name;
        this.password = password;
        this.email = email;
        this.image_path = image_path;
        this.image = image;
    }

    public User(String name, String password, String email, InputStream image_path) {
        this.name = name;
        this.password = password;
        this.email = email;
        this.image_path = image_path;
    }


    public User(int id, String name, String email, InputStream imageStream) {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public InputStream getImage_path() {
        return image_path;
    }

    public void setImage_path(InputStream image_path) {
        this.image_path = image_path;
    }

    public String getImage() {
        return image;
    }


}


