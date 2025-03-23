<%--
  Created by IntelliJ IDEA.
  User: lanke
  Date: 10/03/2025
  Time: 4:41 pm
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>JSP - CRUD</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .container {
            margin-top: 50px;
        }
        .btn-custom {
            margin: 10px;
            width: 150px;
        }
    </style>
</head>

<body>


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

                        <input type="hidden" name="id" />
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
                        <input id="email" type="text"  class="form-control" name="email" maxlength="30"
                               oninput="this.value = this.value.replace(/\s/g, '')">
                        <small id="emailError" class="text-danger"></small>
                    </fieldset>

                    <fieldset class="form-group">
                        <label>Password</label>
                        <input id="password" type="password"  class="form-control" name="password"
                               oninput="this.value = this.value.replace(/\s/g, '')">
                        <small id="passwordError" class="text-danger"></small>
                    </fieldset>

                    <fieldset class="form-group">
                        <label>Confirm Password</label>
                        <input id="password_B" type="password"  class="form-control" name="password_B"
                               oninput="this.value = this.value.replace(/\s/g, '')">

                        <small id="confirmPasswordError" class="text-danger"></small>
                    </fieldset>

                    <fieldset class="form-group">
                        <label>Profile</label>
                        <input type="file" id="profile" name="image_path"  accept="image/*">
                    </fieldset>

                    <button type="submit" class="btn btn-success btn-custom">Save</button>
                </form>
        </div>
    </div>
</div>


<script>

    document.getElementById("password").addEventListener("input", function() {
        let password = this.value;
        let errorPassword = document.getElementById("passwordError");

        if (password.length < 3) {
            errorPassword.textContent = "Password must be at least 8 characters.";
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



        if (!name) {
            errorName.textContent = "Enter Name";
            valid = false;
        } else {
            errorName.textContent = "";
        }


        if (!email) {
            errorMail.textContent = "Enter email address";
            valid = false;
        }else if (!emailPattern.test(email)) {
            errorMail.textContent = "Please enter a valid email address.";
            valid = false;
        }else {
            errorMail.textContent = "";
        }


        if (!password) {
            errorPassword.textContent = "Enter Password";
            valid = false;
        }else if (password.length < 3) {
            errorPassword.textContent = "Password must be at least 8 characters.";
            valid = false;
        } else {
            errorPassword.textContent = "";
        }


        if (!password_B) {
            errorPassword_B.textContent = "Confirm password";
            valid = false;
        } else if (password_B !== password) {
            errorPassword_B.textContent = "Incorrect passwords";
            valid = false;
        } else {
            errorPassword_B.textContent = "";
        }


        if (!valid) {
            event.preventDefault();
        }
    });


</script>

</body>
</html>
