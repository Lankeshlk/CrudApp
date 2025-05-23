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
<% response.setHeader("Cache-Control", "private, no-cache, no-store, must-revalidate, max-age=0"); %>
<nav class="navbar navbar-dark bg-dark">
    <a class="navbar-brand" href="<c:url value='/index.jsp' />">
        <h3>CRUD Application</h3>
    </a>
</nav>

<div class="container col-md-5">
    <div class="card" style="top: 100px">
        <div class="card-body">

            <form action="insert" method="post" enctype="multipart/form-data">
                <caption>
                    <h2>
                        Add New User
                    </h2>
                </caption>

                <input type="hidden" name="id"/>
                <fieldset class="form-group">
                    <label>Name</label>
                    <input id="name" type="text" class="form-control" name="name" maxlength="20"
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
                    <input id="email" type="text" class="form-control" name="email" maxlength="30"
                           oninput="this.value = this.value.replace(/\s/g, '')">
                    <small id="emailError" class="text-danger"></small>
                </fieldset>

                <fieldset class="form-group">
                    <label>Password</label>
                    <input id="password" type="password" class="form-control" name="password" maxlength="10"
                           oninput="this.value = this.value.replace(/\s/g, '')">
                    <small id="passwordError" class="text-danger"></small>
                </fieldset>

                <fieldset class="form-group">
                    <label>Confirm Password</label>
                    <input id="password_B" type="password" class="form-control" name="password_B" maxlength="10"
                           oninput="this.value = this.value.replace(/\s/g, '')">

                    <small id="confirmPasswordError" class="text-danger"></small>
                </fieldset>

                <fieldset class="form-group">
                    <label>Profile</label>
                    <input type="file" id="profile" name="image_path" accept="image/*">
                </fieldset>

                <button type="submit" class="btn btn-success btn-custom">Save</button>
            </form>
        </div>
    </div>
</div>


<script>
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

    document.getElementById("password_B").addEventListener("input", function () {
        let password = this.value;
        let errorPassword = document.getElementById("confirmPasswordError");

        if (password.length < 1) {
            errorPassword.textContent = "Confirm password";
        } else {
            errorPassword.textContent = "";
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
        let errorPassword = document.getElementById("passwordError");

        let password_B = document.getElementById("password_B").value.trim();
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


        if (!password) {
            errorPassword.textContent = "Enter Password";
            valid = false;
        } else if (password.length < 3) {
            errorPassword.textContent = "Password must be at least 3 characters.";
            valid = false;
        } else {
            errorPassword.textContent = "";
        }


        if (!password_B) {
            errorPassword_B.textContent = "Confirm password";
            valid = false;
        } else if (password_B !== password) {
            errorPassword_B.textContent = "Password do not match";
            valid = false;
        } else {
            errorPassword_B.textContent = "";
        }


        if (!valid) {
            event.preventDefault();
        }
    });

    $(document).ready(function () {
        let nameValid = false;
        let name = null;
        $("#name").on("input", function () {
            name = $(this).val().trim();
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
                            sessionStorage.setItem("user", "true");
                        }
                    },
                    error: function () {
                        console.log("AJAX request failed");
                    }
                });
            } else {
                $("#nameError").text("Enter Name");
            }
        });
        $("form").on("submit", function (event) {
            if (!nameValid) {
                event.preventDefault();
                if (name === null) {
                    $("#nameError").text("Enter name");
                } else {
                    $("#nameError").text("Name already taken");

                }
            } else {
                sessionStorage.setItem("user", "true");
            }
        });
    });


</script>

</body>
</html>
