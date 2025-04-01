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
<% response.setHeader("Cache-Control", "private, no-cache, no-store, must-revalidate, max-age=0");%>
<nav class="navbar navbar-dark bg-dark">
    <a class="navbar-brand" href="<c:url value='/index.jsp' />">
        <h3>CRUD Application</h3>
    </a>
</nav>

<div class="container col-md-5">
    <div class="card" style="top: 100px">
        <div class="card-body">

            <form id="loginForm" action="<%=request.getContextPath()%>/login" method="post">
                <div class="d-flex justify-content-between">
                    <h2>Login</h2>
                    <a href="index.jsp">
                        <h3>Home</h3>
                    </a>
                </div>

                <label>Name</label>
                <fieldset class="form-group">
                    <input id="name" type="text" class="form-control" name="name" maxlength="20"
                           oninput="this.value = this.value.replace(/\s/g, '')">
                    <small id="nameError" class="text-danger"></small>
                    <c:if test="${not empty errorMessage}">
                        <div class="text-danger">
                            Invalid username
                        </div>
                    </c:if>
                </fieldset>

                <label>Password</label>
                <fieldset class="form-group">
                    <input id="password" type="password" class="form-control" name="password"
                           oninput="this.value = this.value.replace(/\s/g, '')">
                    <small id="passwordError" class="text-danger"></small>
                    <c:if test="${not empty errorMessage}">
                        <div class="text-danger">
                            Invalid password
                        </div>
                    </c:if>
                </fieldset>

                <button id="loginBtn" type="submit" class="btn btn-success btn-custom">Login</button>
                <%--          <a href="forget-password.jsp">Forget Password?</a>--%>

            </form>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        $("#loginForm").on("submit", function (event) {
            event.preventDefault();

            let name = $("#name").val().trim();
            let password = $("#password").val().trim();


            let valid = true;
            if (name.length < 1) {
                $("#nameError").text("Enter Name");
                valid = false;
            } else {
                $("#nameError").text("");
            }

            if (password.length < 1) {
                $("#passwordError").text("Enter password");
                valid = false;
            } else {
                $("#passwordError").text("");
            }

            if (!valid) {
                return;
            }

            $.ajax({
                url: "login",
                type: "POST",
                data: {name: name, password: password},
                dataType: "text",
                success: function (response) {
                    if (response.trim() === "success") {
                        sessionStorage.setItem("user", "true");
                        window.location.href = "list";
                    } else {
                        $("#nameError").text("Invalid username");
                        $("#passwordError").text("Invalid password");
                    }
                },
                error: function () {
                    console.log("AJAX request failed");
                }
            });
        });
    });


</script>


</body>
</html>
