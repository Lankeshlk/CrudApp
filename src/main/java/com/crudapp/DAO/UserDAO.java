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


    private static final String insert = "insert into crud_users (name, password, email, image_path) values(?,?,?,?)";
    private static final String update = "update crud_users set name = ?, password = ?, email = ?, image_path = ? where id = ?";
    private static final String delete = "delete from crud_users where id=?";
    private static final String selectUser = "select * from crud_users where id = ?";
    private static final String image = "SELECT image_path FROM crud_users WHERE id=?";
    private static final String old_password = "SELECT password FROM crud_users WHERE id=?";
    private static final String selectAll = "select * from crud_users";
    private static final String forgetPassword = "select * from crud_users where name =? and email = ?";
    private static final String hashedPassword = "select * from crud_users where binary name = ?";
    private static final String userName = "select count(*) from crud_users where binary name = ?";
    //private static final String Name = "select name from crud-users where id = ?";

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
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(insert)) {
            preparedStatement.setString(1,
                    (!user.getName().isEmpty() && user.getName() != null) ? user.getName() : "N/A");
            preparedStatement.setString(2,
                    hashPassword(!user.getPassword().isEmpty() && user.getPassword() != null ? user.getPassword() : "N/A"));
            preparedStatement.setString(3,
                    (!user.getEmail().isEmpty() && user.getEmail() != null) ? user.getEmail() : "N/A");
            preparedStatement.setBlob(4, user.getImage_path());
            System.out.println(user.getImage_path());
            preparedStatement.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    public int existingUser(String name) throws SQLException {
        int userCount = 0;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(userName)) {
            preparedStatement.setString(1, name);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    userCount = resultSet.getInt(1);
                }
            }
        }
        return userCount;
    }


    public boolean updateUser(User user) throws SQLException {
        boolean rowupdated;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(update)) {
            statement.setString(1,
                    (!user.getName().isEmpty() && user.getName() != null) ? user.getName() : "N/A" );
            statement.setString(2,
                    (!user.getPassword().isEmpty() && user.getPassword() != null) ? user.getPassword() : "N/A");
            statement.setString(3,
                    (!user.getEmail().isEmpty() && user.getEmail() != null) ? user.getEmail() : "N/A");
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

                user = new User(id, name, password, email, null, base64Image);
            }
        }
        return user;
    }

    public InputStream getExistingImage_stream(int id) throws SQLException {
        InputStream imageStream = null;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(image)) {
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                imageStream = resultSet.getBinaryStream("image_path");
            }
        }
        return imageStream;
    }

    public String getExistingPassword(int id) throws SQLException {
        String password = null;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(old_password)) {
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                password = resultSet.getString("password");
            }
        }
        return password;
    }


    public boolean deleteUser(int id) throws SQLException {
        boolean rowdeleted;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(delete)) {
            preparedStatement.setInt(1, id);
            rowdeleted = preparedStatement.executeUpdate() > 0;
        }
        return rowdeleted;
    }

    public List<User> selectAllUser() {
        List<User> users = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectAll)) {
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                int id = Integer.parseInt(resultSet.getString("id"));
                String name = resultSet.getString("name");
                String password = resultSet.getString("password");
                String email = resultSet.getString("email");
                InputStream imageStream = resultSet.getBinaryStream("image_path");
                String base64Image = convertToBase64(imageStream);
                users.add(new User(id, name, password, email, null, base64Image));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public boolean loginUser(String name, String password) throws SQLException {
        boolean login = false;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(hashedPassword)) {
            preparedStatement.setString(1, name);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                String storedHash = resultSet.getString("password");
                login = BCrypt.checkpw(password, storedHash);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return login;
    }

    public boolean ForgetPassword(String name, String email) throws SQLException {
        boolean status = false;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(forgetPassword)) {
            preparedStatement.setString(1, name);
            preparedStatement.setString(2, email);
            ResultSet resultSet = preparedStatement.executeQuery();
            status = resultSet.next();
        } catch (Exception e) {
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

    public String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }
}