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
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
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
    <a class="navbar-brand" href="<c:url value='/index.jsp' />">CRUD Application</a>
</nav>

<div class="container col-md-5">
    <div class="card" style="top: 100px">
        <div class="card-body">

            <form action="<%=request.getContextPath()%>/forget" method="post">
                <h2>Forget Password</h2>
                <label>Name</label>
                <fieldset class="form-group">
                    <input type="text" class="form-control" name="name">
                </fieldset>
                <label>Email</label>
                <fieldset class="form-group">
                    <input type="email" class="form-control" name="email">
                </fieldset>
                <c:if test="${not empty errorMessage}">
                    <div class="text-danger">
                            ${errorMessage}
                    </div>
                </c:if>
                <button type="submit" class="btn btn-success btn-custom">Login</button>
            </form>
        </div>
    </div>
</div>

</body>
</html>
