package com.crudapp.Servlet;

import java.io.*;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import com.crudapp.DAO.UserDAO;
import com.crudapp.Model.User;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;


@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)

@WebServlet(name = "UserServlet", value = {"/user-servlet", "/list", "/new", "/insert",
        "/update", "/delete", "/edit", "/login", "/forget", "/logout", "/checkUsername"})
public class UserServlet extends HttpServlet {
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }


    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        this.doGet(request, response);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        switch (action) {
            case "/new":
                showNewForm(request, response);
                break;
            case "/insert":
                try {
                    NewUser(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                break;
            case "/checkUsername":
                try {
                    checkUserName(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                break;
            case "/edit":
                try {
                    showEditForm(request, response);
                } catch (Exception e) {
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
                } catch (Exception e) {
                    e.printStackTrace();
                }
                break;
            case "/login":
                try {
                    LoginUser(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                break;
            case "/logout":
                try {
                    LogoutUser(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                break;
            case "/forget":
                try {
                    RetriveUser(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                break;
            default:
                try {
                    ListUsers(request, response);
                } catch (Exception e) {
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
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        Part image = request.getPart("image_path");
        InputStream image_stream = null;
        if (image != null && image.getSize() > 0) {
            image_stream = image.getInputStream();
        } else {
            System.out.println("No image uploaded!");
        }
        User newUser = new User(name, password, email, image_stream);
        try {
            boolean Register = userDAO.insertUser(newUser);
            if (Register == false) {
                request.setAttribute("errorMessage", "Invalid username");
                RequestDispatcher dispatcher = request.getRequestDispatcher("new-form.jsp");
                dispatcher.forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("user", name);
                response.sendRedirect(request.getContextPath() + "/list");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Invalid username");
            RequestDispatcher dispatcher = request.getRequestDispatcher("new-form.jsp");
            dispatcher.forward(request, response);
        }

    }

    private void checkUserName(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("name");
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        try {
            int userCount = userDAO.existingUser(username);
            if (userCount > 0) {
                response.getWriter().write("exists");
            } else {
                response.getWriter().write("available");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("error");
        }
    }


    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        try {
            User existingUser = userDAO.selectUserById(id);
            RequestDispatcher dispatcher = request.getRequestDispatcher("edit-user.jsp");
            request.setAttribute("user", existingUser);
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private void UpdateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String password = request.getParameter("password");
            String email = request.getParameter("email");
            Part image = request.getPart("image_path");
            boolean deleteImage = Boolean.parseBoolean(request.getParameter("deleteImage"));
            InputStream image_stream;

            if (password != null && password.trim().isEmpty()) {
                password = null;
            }
            System.out.println("password: " + password);

            if (password != null) {
                password = userDAO.hashPassword(password);
            } else {
                password = userDAO.getExistingPassword(id);
            }

            if (deleteImage) {
                image_stream = null;
            } else if (image != null && image.getSize() > 0) {
                image_stream = image.getInputStream();
            } else {
                image_stream = userDAO.getExistingImage_stream(id);
            }
            User newUser = new User(id, name, password, email, image_stream, "");
            userDAO.updateUser(newUser);
            response.sendRedirect(request.getContextPath() + "/list");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private void DeleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        try {
            boolean isDeleted = userDAO.deleteUser(id);
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(isDeleted ? "success" : "failure");
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/plain");
        }

    }

    private void LoginUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        String name = request.getParameter("name");
        String password = request.getParameter("password");
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        try {
            boolean isValidUser = userDAO.loginUser(name, password);

            if (isValidUser) {
                session.setAttribute("user", name);
                response.getWriter().write("success");

            } else {
                response.getWriter().write("Invalid username or password");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private void LogoutUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute("user");
            session.invalidate();
        }
        response.sendRedirect("login.jsp");
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
                response.sendRedirect("list-users.jsp");
            } else {
                request.setAttribute("errorMessage", "Invalid login");
                RequestDispatcher dispatcher = request.getRequestDispatcher("forget-password.jsp");
                dispatcher.forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    private void ListUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        try {
            List<User> listUser = userDAO.selectAllUser();
            request.setAttribute("listUser", listUser);
            RequestDispatcher dispatcher = request.getRequestDispatcher("list-users.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}