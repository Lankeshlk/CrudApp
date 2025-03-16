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
                        <input type="text" class="form-control" name="name" required="required">
                    </fieldset>

                    <fieldset class="form-group">
                        <label>Email</label>
                        <input type="email"  class="form-control" name="email" required="required">
                    </fieldset>

                    <fieldset class="form-group">
                        <label>Password</label>
                        <input type="text"  class="form-control" name="password_A" required="required">
                    </fieldset>

                    <fieldset class="form-group">
                        <label>Confirm Password</label>
                        <input type="text"  class="form-control" name="password_B" required="required">
                    </fieldset>

                    <fieldset class="form-group">
                        <label>Profile</label>
                        <input type="file" id="profile" name="image_path" accept="/image">
                    </fieldset>

                    <button type="submit" class="btn btn-primary btn-custom">Save</button>
                </form>
        </div>
    </div>
</div>

</body>
</html>
