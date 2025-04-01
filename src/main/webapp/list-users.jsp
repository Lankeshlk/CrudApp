<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>JSP - CRUD</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
<%@ page import="jakarta.servlet.http.HttpSession" %>


<%
    response.setHeader("Cache-Control", "private, no-cache, no-store, must-revalidate, max-age=0");

    HttpSession sessionUser = request.getSession(false);
    if (sessionUser == null || sessionUser.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<nav class="navbar navbar-dark bg-dark">
    <a class="navbar-brand" href="<c:url value='/index.jsp' />">
        <h3>CRUD Application</h3>
    </a>
</nav>

<div class="container">
    <h3 class="text-center">List of Users</h3>
    <hr>
    <div class="container text-left d-flex justify-content-between">
        <div class="d-flex align-items-center">
            <a href="<%=request.getContextPath()%>/new" class="btn btn-success btn-custom">Add New User</a>
            <a href="<%=request.getContextPath()%>/logout"  class="btn btn-primary btn-custom">Log
                out</a>
        </div>
        <div class="d-flex align-items-center">
            <h3>Welcome, <c:out value="${sessionScope.user}"/></h3>
        </div>
    </div>
    <br>
    <table class="table table-borderless table-striped">
        <thead class="thead-dark">
        <tr>
            <th class="text-center" style="width: 5%">ID</th>
            <th class="text-center" style="width: 25%">Name</th>
            <th class="text-center" style="width: 25%">Email</th>
            <th class="text-center" style="width: 20%">Profile</th>
            <th class="text-center" style="width: 25%">Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="user" items="${listUser}">

            <tr>
                <td class="text-center">
                    <c:out value="${user.id}"/>
                </td>
                <td class="text-center">
                    <c:out value="${user.name}"/>
                </td>
                <td class="d-flex justify-content-center">
                    <c:out value="${user.email}"/>
                </td>
                <td>
                    <div class="d-flex justify-content-center">
                        <c:if test="${user.image != null}">
                            <img src="data:image/jpeg;base64,${user.image}" class="rounded-circle " alt="Image"
                                 width="100" height="100"/>

                        </c:if>
                        <c:if test="${user.image == null}">
                            <img src="https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg"
                                 class="rounded-circle img-fluid"
                                 alt="Default Profile"
                                 width="100" height="100"/>
                        </c:if>

                    </div>
                </td>

                <td class="justify-content-center text-center ">
                    <button onclick="location.href='edit?id=${user.id}'" class="btn btn-outline-primary">Edit</button>
                    <button class="btn btn-outline-danger deleteUser" data-id="${user.id}">Delete</button>

                </td>

            </tr>
        </c:forEach>

        </tbody>

    </table>
</div>

<script>
    if (sessionStorage.getItem("user") !== "true") {
        window.location.href = "login.jsp"
    }



$(document).ready(function () {
        $(".deleteUser").click(function () {
            var id = $(this).data("id");
            var row = $(this).closest("tr");

            Swal.fire({
                title: "Are you sure?",
                text: "You won't be able to revert this!",
                icon: "warning",
                showCancelButton: true,
                confirmButtonColor: "#d33",
                cancelButtonColor: "#3085d6",
                confirmButtonText: "Yes, delete it!"
            }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        type: "POST",
                        url: "delete",
                        data: {action: "deleteUser", id: id},
                        success: function (response) {
                            if (response === "success") {
                                row.fadeOut(function () {
                                    $(this).remove();
                                });
                            } else {
                                Swal.fire("Error!", "Failed to delete user!", "error");
                            }
                        },
                        error: function () {
                            Swal.fire("Error!", "An error occurred while deleting user!", "error");
                        }
                    });
                }
            });

        });
    });
</script>
</body>

</html>
