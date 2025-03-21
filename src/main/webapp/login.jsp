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

      <form action="<%=request.getContextPath()%>/login" method="post">
          <div class="d-flex justify-content-between">
              <h2>Login</h2>
              <a href="index.jsp">
                  <h3>Home</h3>
              </a>
          </div>

          <label>Name</label>
          <fieldset class="form-group">
          <input type="text"  class="form-control" name="name" required="required">
          </fieldset>

          <label>Password</label>
          <fieldset class="form-group">
          <input type="text"  class="form-control" name="password">
          </fieldset>

        <button id="loginBtn" type="submit" class="btn btn-primary btn-custom">Login</button>
          <a href="forget-password.jsp">Forget Password?</a>

      </form>
    </div>
  </div>
</div>



</body>
</html>
