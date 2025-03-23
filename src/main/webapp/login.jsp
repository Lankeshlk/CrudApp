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
<%  response.setHeader("Cache-Control","private, no-cache, no-store, must-revalidate, max-age=0");%>
<nav class="navbar navbar-dark bg-dark">
    <a class="navbar-brand" href="<c:url value='/index.jsp' />">
        <h3>CRUD Application</h3>
    </a>
</nav>

<div class="container col-md-5">
  <div class="card" style="top: 100px">
    <div class="card-body">

      <form action="<%=request.getContextPath()%>/login" method="post">
          <div class="d-flex justify-content-between">
              <h2>Login</h2>
              <a href="index.jsp">
                  <h3>Home</h3>
              </a>
          </div>

          <label>Name</label>
          <fieldset class="form-group">
          <input id="name" type="text"  class="form-control" name="name" maxlength="20"
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
          <input id="password" type="password"  class="form-control" name="password"
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

        let password = document.getElementById("password").value.trim();
        let errorPassword = document.getElementById("passwordError");
        if (!password) {
            errorPassword.textContent = "Enter Password";
            valid = false;
        } else {
            errorPassword.textContent = "";
        }

        if (!valid) {
            event.preventDefault();
        }
    });

</script>



</body>
</html>
