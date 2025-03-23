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

                <input type="hidden" name="id" value="<c:out value='${user.id}' />" />

                <fieldset class="form-group">
                    <label>Name</label>
                    <input id="name" type="text" value="<c:out value='${user.name}' />"
                           class="form-control" name="name" maxlength="20"
                           oninput="this.value = this.value.replace(/\s/g, '')">
                    <small id="nameError" class="text-danger"></small>
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
<%--                           value="<c:out value='${user.password}' />"--%>
                           class="form-control" name="password"
                           oninput="this.value = this.value.replace(/\s/g, '')">
                    <small id="passwordError" class="text-danger"></small>
                </fieldset>

                <fieldset class="form-group">
                    <label>Confirm Password</label>
                    <input id="confirmPassword" type="password"
                           class="form-control" name="confirmPassword"
                           oninput="this.value = this.value.replace(/\s/g, '')">
                    <small id="confirmPasswordError" class="text-danger"></small>
                </fieldset>

                <div>
                    <c:if test="${user.image != null}">
                        <img src="data:image/jpeg;base64,${user.image}"
                             class="rounded-circle " alt="Image" width="100" height="100" />
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

    document.getElementById("password").addEventListener("input", function() {
        let password = this.value;
        let errorMessage = document.getElementById("passwordError");
        if (password.length < 8) {
            errorMessage.textContent = "Password must be at least 8 characters.";
        }else {
            errorMessage.textContent = "";
        }
    });


    document.querySelector("form").addEventListener("submit", function (event) {
        let valid = true;

        let name = document.getElementById("name").value.trim();
        let errorName = document.getElementById("nameError");
        if (!name) {
            errorName.textContent = "Enter Name";
            valid = false;
        } else {
            errorName.textContent = "";
        }

        let email = document.getElementById("email").value.trim();
        let errorMail = document.getElementById("emailError");
        let emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
        if (!email) {
            errorMail.textContent = "Enter email address";
            valid = false;
        } else if (!emailPattern.test(email)) {
            errorMail.textContent = "Please enter a valid email address.";
            valid = false;
        } else {
            errorMail.textContent = "";
        }

        let password = document.getElementById("password").value.trim();
        let password_B = document.getElementById("confirmPassword").value.trim();
        let errorPassword_B = document.getElementById("confirmPasswordError");

        if (password !== password_B) {
            errorPassword_B.textContent = "Incorrect password";
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
