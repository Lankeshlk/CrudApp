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
<div class="container col-md-5">
    <div class="card" style="top: 100px">
        <div class="card-body">
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">
                        ${errorMessage}
                </div>
            </c:if>
                <form action="insert" method="post" enctype="multipart/form-data">
                    <caption>
                        <h2>
                            Add New User
                        </h2>
                    </caption>

                        <input type="hidden" name="id" />
                    <fieldset class="form-group">
                        <label>Name</label>
                        <input id="name" type="text" class="form-control" name="name" required="required">
                        <small id="nameError" class="text-danger"></small>
                    </fieldset>

                    <fieldset class="form-group">
                        <label>Email</label>
                        <input id="email" type="email"  class="form-control" name="email" required="required">
                        <small id="emailError" class="text-danger"></small>
                    </fieldset>

                    <fieldset class="form-group">
                        <label>Password</label>
                        <input id="password" type="password"  class="form-control" name="password_A" required="required"
                               oninput="this.value = this.value.replace(/\s/g, '')">
                        <small id="passwordError" class="text-danger"></small>
                    </fieldset>

                    <fieldset class="form-group">
                        <label>Confirm Password</label>
                        <input id="password_B" type="password"  class="form-control" name="password_B" required="required"
                               oninput="this.value = this.value.replace(/\s/g, '')">

                        <small id="confirmPasswordError" class="text-danger"></small>
                    </fieldset>

                    <fieldset class="form-group">
                        <label>Profile</label>
                        <input type="file" id="profile" name="image_path"  accept="image/*">
                    </fieldset>

                    <button type="submit" class="btn btn-primary btn-custom">Save</button>
                </form>
        </div>
    </div>
</div>


<script>
    document.getElementById("name").addEventListener("input", function() {
        let password = this.value;
        let errorMessage = document.getElementById("nameError");

        if (password.length < 1) {
            errorMessage.textContent = "Enter Name";
        } else if (password.length > 20) {
            errorMessage.textContent = "Name must not exceed 50 characters.";
        } else {
            errorMessage.textContent = "";
        }
    });

    document.getElementById("email").addEventListener("input", function() {
        let password = this.value;
        let errorMessage = document.getElementById("emailError");

        if (password.length < 1) {
            errorMessage.textContent = "Enter Email ID";
        } else if (password.length > 20) {
            errorMessage.textContent = "Email id must not exceed 50 characters.";
        } else {
            errorMessage.textContent = "";
        }
    });

    document.getElementById("password").addEventListener("input", function() {
        let password = this.value;
        let errorMessage = document.getElementById("passwordError");

        if (password.length < 1) {
            errorMessage.textContent = "Password must be at least 8 characters.";
        } else if (password.length > 20) {
            errorMessage.textContent = "Password must not exceed 20 characters.";
        } else {
            errorMessage.textContent = "";
        }
    });

    document.getElementById("password_B").addEventListener("input", function() {
        let password = document.getElementById("password").value;
        let confirmPassword = this.value;
        let confirmPasswordError = document.getElementById("confirmPasswordError");

        if (password !== confirmPassword) {
            confirmPasswordError.textContent = "Wrong password";
        } else {
            confirmPasswordError.textContent = "";
        }
    });

</script>

</body>
</html>
