package com.crudapp.Servlet;

import java.io.*;
import java.sql.SQLException;
import java.util.List;

import com.crudapp.DAO.UserDAO;
import com.crudapp.Model.User;
import com.password4j.BcryptFunction;
import com.password4j.Hash;
import com.password4j.Password;
import com.password4j.types.Bcrypt;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import static java.util.Objects.hash;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)

@WebServlet(name = "UserServlet", value = {"/user-servlet", "/list", "/new", "/insert", "/update", "/delete","/edit","/login","/forget","/logout"})
public class UserServlet extends HttpServlet {
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }



    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        this.doGet(request, response);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action =request.getServletPath();
        switch(action){
            case "/new":
                showNewForm(request, response);
                break;
            case "/insert":
                try {
                    NewUser(request, response);
                }catch (Exception e){
                    e.printStackTrace();
                }
                break;
            case "/edit":
                try {
                    showEditForm(request, response);
                }catch (Exception e){
                    e.printStackTrace();
                }
                break;
            case "/update":
                try {
                    UpdateUser(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                break;
            case "/delete":
                try {
                    DeleteUser(request, response);
                }catch (Exception e){
                    e.printStackTrace();
                }
                break;
            case "/login":
                try {
                    LoginUser(request, response);
                }catch (Exception e){
                    e.printStackTrace();
                }
                break;
            case "/logout":
                try {
                    LogoutUser(request, response);
                }catch (Exception e){
                    e.printStackTrace();
                }
                break;
            case "/forget":
                try {
                    RetriveUser(request, response);
                }catch (Exception e){
                    e.printStackTrace();
                }
                break;
//            case "/list":
            default:
                try {
                    ListUsers(request, response);
                }catch (Exception e){
                    e.printStackTrace();
                }
                break;
        }
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("new-form.jsp");
        dispatcher.forward(request, response);
    }



    private void NewUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String name = request.getParameter("name");

        String password_A = request.getParameter("password_A");
        String password_B = request.getParameter("password_B");
        String password = null;
        if (password_A != null && password_A.equals(password_B)) {
            password= password_A;
        }else {
            request.setAttribute("errorMessage", "Check confirm password");
            RequestDispatcher dispatcher = request.getRequestDispatcher("new-form.jsp");
            dispatcher.forward(request, response);
            response.sendRedirect( request.getContextPath() + "/insert");
        }
        String email = request.getParameter("email");
        Part image = request.getPart("image_path");
        InputStream image_stream = null;
        if (image != null && image.getSize() > 0) {
            image_stream = image.getInputStream();
        } else {
            System.out.println("No image uploaded!");
        }
        User newUser = new User(name,password,email,image_stream);
        boolean Register = userDAO.insertUser(newUser);

        if (Register == false) {
            request.setAttribute("errorMessage", "Invalid username");
            RequestDispatcher dispatcher = request.getRequestDispatcher("new-form.jsp");
            dispatcher.forward(request, response);
            response.sendRedirect( request.getContextPath() + "/insert");
        }else {
            response.sendRedirect( request.getContextPath() + "/list");
        }

    }



    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        User existingUser = userDAO.selectUserById(id);
        RequestDispatcher dispatcher = request.getRequestDispatcher("edit-user.jsp");
        request.setAttribute("user", existingUser);
        dispatcher.forward(request, response);
    }



    private void UpdateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        Part image = request.getPart("image_path");
        InputStream image_stream = null;
        if (image != null && image.getSize() > 0) {
            image_stream = image.getInputStream();
        } else {
            System.out.println("No image uploaded!");
        }
        User newUser = new User( id, name, password, email, image_stream,"");
        userDAO.updateUser(newUser);
        response.sendRedirect(request.getContextPath() + "/list");
    }



    private void DeleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean isDeleted = userDAO.deleteUser(id);
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(isDeleted ? "success" : "failure");
    }



    private void LoginUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String name = request.getParameter("name");
        String password = request.getParameter("password");

        try {
            boolean isValidUser = userDAO.loginUser(name, password);

            if (isValidUser) {
                HttpSession session = request.getSession();
                session.setAttribute("user", name);
                response.sendRedirect(request.getContextPath() + "/list");
            } else {
                request.setAttribute("errorMessage", "Invalid username or password");
                RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
                dispatcher.forward(request, response);
                response.sendRedirect("login.jsp?error=Invalid credentials");
                //response.sendRedirect( request.getContextPath() + "/login");
            }return;
        }catch (Exception e){
            e.printStackTrace();
        }
        request.getSession().invalidate();
    }


    private void LogoutUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute("user");
        }
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }




    private void RetriveUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        try {
            boolean isValidUser = userDAO.ForgetPassword(name, email);
            if (isValidUser) {
                HttpSession session = request.getSession();
                session.setAttribute("user", name);
                response.sendRedirect(request.getContextPath() + "/list");
            } else {
                request.setAttribute("errorMessage", "Invalid login");
                RequestDispatcher dispatcher = request.getRequestDispatcher("forget-password.jsp");
                dispatcher.forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            //response.sendRedirect("forget-password.jsp?error=Something went wrong");
        }
    }



    private void ListUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<User> listUser = userDAO.selectAllUser();

        if (listUser == null || listUser.isEmpty()) {
            System.out.println("User list is empty!");
        } else {
            System.out.println("Users retrieved: " + listUser.size());
        }
        request.setAttribute("listUser", listUser);
        RequestDispatcher dispatcher = request.getRequestDispatcher("list-users.jsp");
        dispatcher.forward(request, response);
    }
}