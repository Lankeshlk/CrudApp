package com.crudapp.DAO;

import com.crudapp.Model.User;
import org.mindrot.jbcrypt.BCrypt;

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
    //private static final String loginUser = "select * from crud_system where name = ? and password = ?";
    private static final String forgetPassword = "select * from crud_system where name =? and email = ?";
    private static final String hashedPassword = "select * from crud_system where name = ?";
    private static final String userName = "select name from crud_system where name = ?";

    protected static Connection getConnection() throws SQLException {
        Connection conn = DBConnection.getConnection();
        if (conn != null) {
            System.out.println("Database connected successfully!");
        } else {
            System.out.println("Failed to connect to the database!");
        }
        return conn;
    }

        public boolean insertUser(User user) throws SQLException {
        try (Connection connection=getConnection();
             PreparedStatement preparedStatement2 = connection.prepareStatement(userName)){
        preparedStatement2.setString(1, user.getName());
            ResultSet resultSet = preparedStatement2.executeQuery();
        if (resultSet.next()) {
            return false;
        }
            try (PreparedStatement preparedStatement = connection.prepareStatement(insert)){
            preparedStatement.setString(1, user.getName());
            preparedStatement.setString(2, hashPassword(user.getPassword()));
            preparedStatement.setString(3, user.getEmail());
            preparedStatement.setBlob(4, user.getImage_path());
            preparedStatement.executeUpdate();
                System.out.println("Inserted user successfully!");
            return true;
        }


        }catch (Exception e) {
            e.printStackTrace();
        }
        return false;
        }

    public boolean updateUser(User user) throws SQLException {
        boolean rowupdated;
        try (Connection connection=getConnection();
             PreparedStatement statement = connection.prepareStatement(update)) {
            statement.setString(1, user.getName());
            statement.setString(2, hashPassword(user.getPassword()));
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
//    public boolean selectUserByNameandPassword(String name, String password) throws SQLException {
//        boolean status = false ;
//        try (Connection connection=getConnection();
//             PreparedStatement preparedStatement = connection.prepareStatement(loginUser)) {
//            preparedStatement.setString(1, name);
//            preparedStatement.setString(2, password);
//            ResultSet resultSet = preparedStatement.executeQuery();
//            status = resultSet.next();
//            }catch (Exception e) {
//            e.printStackTrace();
//
//        }return status;
//    }

    public boolean loginUser(String name, String password) throws SQLException {
        boolean login = false;
        try (Connection connection=getConnection();
        PreparedStatement preparedStatement = connection.prepareStatement(hashedPassword)) {
            preparedStatement.setString(1, name);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                String storedHash = resultSet.getString("password");
                login = BCrypt.checkpw(password,storedHash);
            }
        }catch (SQLException e) {
            e.printStackTrace();
        }
        return login;
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
    private String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }
}