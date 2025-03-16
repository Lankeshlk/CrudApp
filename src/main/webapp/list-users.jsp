<%--
  Created by IntelliJ IDEA.
  User: lanke
  Date: 10/03/2025
  Time: 4:43 pm
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
<div class="container">
    <h3 class="text-center">List of Users</h3>
    <hr>
    <div class="container text-left">
        <a href="<%=request.getContextPath()%>/new" class="btn btn-success btn-custom">Add New User</a>
        <a href="login.jsp" class="btn btn-success btn-custom">Log out</a>
    </div>
    <br>
    <table class="table table-borderless table-striped">
        <thead class="thead-dark">
        <tr>
            <th class="text-center">ID</th>
            <th class="text-center">Name</th>
            <th class="text-center">Email</th>
<%--            <th>Password</th>--%>
            <th class="text-center">Profile</th>
            <th class="text-center">Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="user" items="${listUser}">

            <tr>
                <td class="text-center">
                    <c:out value="${user.id}" />
                </td>
                <td class="text-center">
                    <c:out value="${user.name}" />
                </td>
                <td class="d-flex justify-content-center">
                    <c:out value="${user.email}" />
                </td>
<%--                <td>--%>
<%--                    <c:out value="${user.password}" />--%>
<%--                </td>--%>
                <td>
                    <div class="d-flex justify-content-center">
                        <c:if test="${user.image != null}">
<%--                            <img src="${user.image}" class="img-fluid" alt="Image" width="300" />--%>
                            <img src="data:image/jpeg;base64,${user.image}" class="rounded-circle " alt="Image" width="100" height="100" />

                        </c:if>
                        <c:if test="${user.image == null}">
                            <img src="https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg"
                                 class="rounded-circle img-fluid"
                                 alt="Default Profile"
                                 width="100" height="100" />
                        </c:if>

                    </div>
                </td>

                <td class="justify-content-center">
                    <button onclick="location.href='edit?id=${user.id}'" class="btn btn-outline-primary">Edit</button>
                    <button onclick="location.href='delete?id=${user.id}'"  class="btn btn-outline-danger">Delete</button>
                </td>

            </tr>
        </c:forEach>

        </tbody>

    </table>
</div>

</body>

</html>
