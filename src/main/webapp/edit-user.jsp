<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>JSP - CRUD</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>

<body>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    response.setHeader("Cache-Control", "private, no-cache, no-store, must-revalidate, max-age=0");

    HttpSession sessionUser = request.getSession(false);
    if (sessionUser == null || sessionUser.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<nav class="navbar navbar-dark bg-dark">
    <a class="navbar-brand" href="<c:url value='/index.jsp' />">
        <h3>CRUD Application</h3>
    </a>
</nav>

<div class="container col-md-5">
    <div class="card">
        <div class="card-body">

            <div class="d-flex justify-content-between">
                <div>
                    <h2>Edit User</h2>
                </div>
                <div>
                    <a href="javascript:void(0);" onclick="window.history.back();">
                        <h4>CANCEL</h4>
                    </a>
                </div>
            </div>

            <form action="update" method="post" enctype="multipart/form-data">

                <input type="hidden" name="id" value="<c:out value='${user.id}' />"/>

                <fieldset class="form-group">
                    <label>Name</label>
                    <input id="name" type="text" value="<c:out value='${user.name}' />"
                           class="form-control" name="name" maxlength="20"
                           oninput="this.value = this.value.replace(/\s/g, '')">
                    <small id="nameError" class="text-danger"></small>
                    <c:if test="${not empty errorMessage}">
                        <div class="text-danger">
                                ${errorMessage}
                        </div>
                    </c:if>
                </fieldset>

                <fieldset class="form-group">
                    <label>Email</label>
                    <input id="email" type="text" value="<c:out value='${user.email}' />"
                           class="form-control" name="email" maxlength="30"
                           oninput="this.value = this.value.replace(/\s/g, '')">
                    <small id="emailError" class="text-danger"></small>
                </fieldset>

                <fieldset class="form-group">
                    <label>Password</label>
                    <input id="password" type="password"
                           class="form-control" name="password" maxlength="10"
                           oninput="this.value = this.value.replace(/\s/g, '')">
                    <small id="passwordError" class="text-danger"></small>
                </fieldset>

                <fieldset class="form-group">
                    <label>Confirm Password</label>
                    <input id="confirmPassword" type="password"
                           class="form-control" name="confirmPassword" maxlength="10"
                           oninput="this.value = this.value.replace(/\s/g, '')">
                    <small id="confirmPasswordError" class="text-danger"></small>
                </fieldset>

                <div>
                    <c:if test="${user.image != null}">
                        <img src="data:image/jpeg;base64,${user.image}"
                             class="rounded-circle " alt="Image" width="100" height="100"/>
                        <fieldset class="form-group">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" value="" id="flexCheckDefault">
                                <label class="form-check-label" for="flexCheckDefault">
                                    Delete
                                </label>
                            </div>
                        </fieldset>
                    </c:if>
                </div>


                <input type="hidden" name="deleteImage" id="deleteImageInput" value="false">

                <fieldset class="form-group">
                    <label>Profile</label>
                    <input id="image" type="file" value="<c:out value='${user.image}' />"
                           class="form-control" name="image_path" accept="image/*">
                </fieldset>

                <button type="submit" class="btn btn-primary btn-custom">Update</button>
                <button type="reset" value="reset" class="btn btn-success btn-custom">Reset</button>
            </form>
        </div>
    </div>
</div>
<script>

    if (sessionStorage.getItem("user") !== "true") {
        window.location.href = "login.jsp"
    }

    $(document).ready(function () {
        let nameValid = true;
        let oldName = $("#name").val().trim();
        console.log(oldName + "----------------")
        $("#name").on("input", function () {
            let name = $(this).val().trim();
            console.log(name)

            if (name !== oldName) {
                if (name.length > 0) {
                    $.ajax({
                        url: "checkUsername",
                        type: "POST",
                        data: {name: name},
                        dataType: "text",
                        success: function (response) {
                            if (response.trim() === "exists") {
                                $("#nameError").text("Name already taken");
                                nameValid = false;
                            } else {
                                $("#nameError").text("");
                                nameValid = true;
                            }
                        },
                        error: function () {
                            console.log("AJAX request failed");
                        }
                    });
                } else {
                    $("#nameError").text("");
                    nameValid = true;
                }
            } else {
                $("#nameError").text("");
                console.log(name)
                console.log(oldName)
                nameValid = true;
            }
        });

        $("form").on("submit", function (event) {
            if (!nameValid) {
                event.preventDefault();
                $("#nameError").text("Name already taken");
            }
        });
    });

    document.getElementById("name").addEventListener("input", function () {
        let name = this.value;
        let errorName = document.getElementById("nameError");

        if (name.length < 1) {
            errorName.textContent = "Enter name";
        } else {
            errorName.textContent = "";
        }
    });

    document.getElementById("email").addEventListener("input", function () {
        let email = this.value;
        let errorEmail = document.getElementById("emailError");

        if (email.length < 1) {
            errorEmail.textContent = "Enter email address";
        } else {
            errorEmail.textContent = "";
        }
    });


    document.getElementById("password").addEventListener("input", function () {
        let password = this.value;
        let errorPassword = document.getElementById("passwordError");

        if (password.length < 1) {
            errorPassword.textContent = "Password must be at least 8 characters.";
        } else {
            errorPassword.textContent = "";
        }
    });

    document.getElementById("confirmPassword").addEventListener("input", function () {
        let confirmPassword = this.value;
        let errorConfirmPassword = document.getElementById("confirmPasswordError");

        if (confirmPassword.length < 1) {
            errorConfirmPassword.textContent = "Confirm password";
        } else {
            errorConfirmPassword.textContent = "";
        }
    });


    document.querySelector("form").addEventListener("submit", function (event) {
        let valid = true;

        let name = document.getElementById("name").value.trim();
        let errorName = document.getElementById("nameError");

        let email = document.getElementById("email").value.trim();
        let errorMail = document.getElementById("emailError");
        let emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;

        let password = document.getElementById("password").value.trim();
        let password_B = document.getElementById("confirmPassword").value.trim();
        let errorPassword_B = document.getElementById("confirmPasswordError");


        if (!name || name.length < 1) {
            errorName.textContent = "Enter Name";
            valid = false;
        } else {
            errorName.textContent = "";
        }


        if (!email || email.length < 1) {
            errorMail.textContent = "Enter email address";
            valid = false;
        } else if (!emailPattern.test(email)) {
            errorMail.textContent = "Please enter a valid email address.";
            valid = false;
        } else {
            errorMail.textContent = "";
        }


        if (password !== password_B) {
            errorPassword_B.textContent = "Password do not match";
            valid = false;
        } else {
            errorPassword_B.textContent = "";
        }

        if (!valid) {
            event.preventDefault();
        }
    });

    document.getElementById("flexCheckDefault").addEventListener("change", function () {
        let deleteImageInput = document.getElementById("deleteImageInput");
        deleteImageInput.value = this.checked ? "true" : "false";
    });


</script>
</body>
</html>
