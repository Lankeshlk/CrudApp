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
    <div class="card">
        <div class="card-body">
            <form action="update" method="post" enctype="multipart/form-data">
                <h2>Edit User</h2>
                <input type="hidden" name="id" value="<c:out value='${user.id}' />" />

                <fieldset class="form-group">
                    <label>Name</label> <input type="text" value="<c:out value='${user.name}' />" class="form-control" name="name" required="required">
                </fieldset>

                <fieldset class="form-group">
                    <label>Email</label> <input type="text" value="<c:out value='${user.email}' />" class="form-control" name="email" required="required">
                </fieldset>

                <fieldset class="form-group">
                    <label>Password</label> <input type="text" value="<c:out value='${user.password}' />" class="form-control" name="password">
                </fieldset>

                <fieldset class="form-group">
                    <label>Profile</label> <input type="file" value="<c:out value='${user.image}' />" class="form-control" name="image_path">
                </fieldset>

                <button type="submit" class="btn btn-primary btn-custom">Update</button>
                <button type="reset" value="reset" class="btn btn-success btn-custom">Reset</button>
            </form>
        </div>
    </div>
</div>

</body>
</html>
