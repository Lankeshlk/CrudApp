<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>JSP - CRUD</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .container {
            margin-top: 50px;
            text-align: center;
        }
        .btn-custom {
            margin: 10px;
            width: 150px;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-dark bg-dark">
    <a class="navbar-brand" href="#">CRUD Application</a>
</nav>

<div class="container">
    <h1 class="display-4 text-primary">CRUD Operations</h1>
    <a id="login" href="login.jsp" class="btn btn-primary btn-custom">Login</a>
    <a id="register" href="new-form.jsp" class="btn btn-success btn-custom">Register</a>
</div>
</body>
</html>
