package com.crudapp.DAO;

import com.crudapp.Model.User;
import com.password4j.BcryptFunction;
import com.password4j.Hash;
import com.password4j.Password;
import com.password4j.types.Bcrypt;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.sql.*;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

public class UserDAO {


    private static final String insert = "insert into crud_system (name, password, email, image_path) values(?,?,?,?)";
    private static final String update = "update crud_system set name = ?, password = ?, email = ?, image_path = ? where id = ?";
    private static final String delete = "delete from crud_system where id=?";
    private static final String selectUser = "select * from crud_system where id = ?";
    private static final String selectAll = "select * from crud_system";
    private static final String loginUser = "select * from crud_system where name = ? and password = ?";
    private static final String forgetPassword = "select * from crud_system where name =? and email = ?";

    protected static Connection getConnection() throws SQLException {
        Connection conn = DBConnection.getConnection();
        if (conn != null) {
            System.out.println("Database connected successfully!");
        } else {
            System.out.println("Failed to connect to the database!");
        }
        return conn;
    }

        public void insertUser(User user) throws SQLException {
        try (Connection connection=getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(insert)) {
        preparedStatement.setString(1, user.getName());
        preparedStatement.setString(2, user.getPassword());
        preparedStatement.setString(3, user.getEmail());
        preparedStatement.setBlob(4, user.getImage_path());
        preparedStatement.executeUpdate();
        }catch (Exception e) {
            e.printStackTrace();
        }
    }
    public boolean updateUser(User user) throws SQLException {
        boolean rowupdated;
        try (Connection connection=getConnection();
             PreparedStatement statement = connection.prepareStatement(update)) {
            statement.setString(1, user.getName());
            statement.setString(2, user.getPassword());
            statement.setString(3, user.getEmail());
            statement.setBlob(4, user.getImage_path());
            statement.setInt(5, user.getId());
            rowupdated = statement.executeUpdate() > 0;
        }
        return rowupdated;
    }
    public User selectUserById(int id) throws SQLException {
        User user = null;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(selectUser)) {
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                String name = resultSet.getString("name");
                String password = resultSet.getString("password");
                String email = resultSet.getString("email");
                InputStream imageStream = resultSet.getBinaryStream("image_path");

                String base64Image = convertToBase64(imageStream);

                user = new User(id, name, password, email,null ,base64Image);
            }
        }
        return user;
    }
    public boolean deleteUser(int id) throws SQLException {
        boolean rowdeleted;
        try (Connection connection=getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(delete)) {
            preparedStatement.setInt(1, id);
            rowdeleted = preparedStatement.executeUpdate() > 0;
        }
        return rowdeleted;
    }
    public List<User> selectAllUser() {
        List<User> users = new ArrayList<>();
        try (Connection connection=getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectAll)) {
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                int id = Integer.parseInt(resultSet.getString("id"));
                String name = resultSet.getString("name");
                String password = resultSet.getString("password");
                String email = resultSet.getString("email");
                InputStream imageStream = resultSet.getBinaryStream("image_path");
                String base64Image = convertToBase64(imageStream);
                users.add(new User(id,name, password,email,null,base64Image));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
    public boolean selectUserByNameandPassword(String name, String password) throws SQLException {
        boolean status = false ;
        try (Connection connection=getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(loginUser)) {
            preparedStatement.setString(1, name);
            preparedStatement.setString(2, password);
            ResultSet resultSet = preparedStatement.executeQuery();
            status = resultSet.next();
            }catch (Exception e) {
            e.printStackTrace();

        }return status;
    }
    public boolean ForgetPassword(String name, String email) throws SQLException {
        boolean status = false ;
        try (Connection connection=getConnection();
        PreparedStatement preparedStatement = connection.prepareStatement(forgetPassword)) {
            preparedStatement.setString(1, name);
            preparedStatement.setString(2, email);
            ResultSet resultSet = preparedStatement.executeQuery();
            status = resultSet.next();
        }catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    public static String convertToBase64(InputStream imageStream) {
        if (imageStream == null) {
            return null;
        }
        try (ByteArrayOutputStream outputStream = new ByteArrayOutputStream()) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = imageStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
            byte[] imageBytes = outputStream.toByteArray();
            return Base64.getEncoder().encodeToString(imageBytes);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static String hash(String password) throws SQLException{
        try{
            System.out.println("DAO"+password);
            BcryptFunction bcrypt = BcryptFunction.getInstance(Bcrypt.B, 12);
            Hash hash = Password.hash(password)
                    .with(bcrypt);
            hash.getResult();
            password = hash.getResult();
            return password;
        }catch (Exception e) {
            e.printStackTrace();
        }
        return password;
    }


}