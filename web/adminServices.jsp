<%@page import="java.sql.*, com.carsystem.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
/*

    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

*/
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Admin - Service Management</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <style>
        .admin-box {
            max-width: 1050px;
            margin: 40px auto;
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.5);
            color: #ffffff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .header-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .title { font-size: 26px; font-weight: 800; color: #e0d4fd; letter-spacing: 1px; }
        .alert-success { background: rgba(76, 175, 80, 0.2); border: 1px solid #4caf50; color: #a5d6a7; padding: 10px; border-radius: 8px; text-align: center; margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { padding: 12px 14px; border: 1px solid rgba(255,255,255,0.15); text-align: center; }
        th { background: rgba(0, 0, 0, 0.4); color: #bb86fc; font-size: 14px; text-transform: uppercase; }
        .badge { padding: 5px 10px; border-radius: 12px; font-size: 12px; font-weight: bold; }
        .badge-pending { background: rgba(255, 152, 0, 0.2); color: #ffb74d; border: 1px solid #ff9800; }
        .badge-approved { background: rgba(33, 150, 243, 0.2); color: #64b5f6; border: 1px solid #2196f3; }
        .badge-completed { background: rgba(76, 175, 80, 0.2); color: #81c784; border: 1px solid #4caf50; }
        .status-select { background: rgba(0,0,0,0.5); color: #fff; border: 1px solid rgba(255,255,255,0.3); border-radius: 6px; padding: 6px; outline: none; }
        .btn-update { background: #7b1fa2; border: none; color: white; padding: 6px 14px; border-radius: 6px; cursor: pointer; font-weight: bold; }
        .btn-update:hover { background: #9c27b0; }
    </style>
</head>
<body style="background: radial-gradient(circle at center, #2e1065, #0f051d); min-height: 100vh; margin: 0; padding-top: 20px;">

    <div class="admin-box">
        <div class="header-row">
            <div class="title">Admin Control Panel: Service Bookings</div>
            <a href="adminDashboard.jsp" style="color: #bb86fc; text-decoration: none;">&larr; Back to Dashboard</a>
        </div>

        <% if ("updated".equals(request.getParameter("msg"))) { %>
            <div class="alert-success">Status successfully updated in database!</div>
        <% } %>

        <table>
            <thead>
                <tr>
                    <th>Service ID</th>
                    <th>Car Model</th>
                    <th>Service Type</th>
                    <th>Booking Date</th>
                    <th>Current Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try (Connection conn = DBConnection.getConnection();
                         Statement stmt = conn.createStatement();
                         ResultSet rs = stmt.executeQuery("SELECT * FROM maintenance_requests ORDER BY service_id DESC")) {
                        
                        while(rs.next()) {
                            int sId = rs.getInt("service_id");
                            String status = rs.getString("status");
                            String badgeClass = "badge-pending";
                            if ("Approved".equalsIgnoreCase(status)) badgeClass = "badge-approved";
                            else if ("Completed".equalsIgnoreCase(status)) badgeClass = "badge-completed";
                %>
                <tr>
                    <td>#SRV-<%= sId %></td>
                    <td><%= rs.getString("car_name") %></td>
                    <td><%= rs.getString("service_type") %></td>
                    <td><%= rs.getString("service_date") %></td>
                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                    <td>
                        <form action="AdminUpdateStatusServlet" method="POST" style="display: flex; gap: 8px; justify-content: center;">
                            <input type="hidden" name="service_id" value="<%= sId %>">
                            <select name="status" class="status-select">
                                <option value="Pending" <%= "Pending".equalsIgnoreCase(status) ? "selected" : "" %>>Pending</option>
                                <option value="Approved" <%= "Approved".equalsIgnoreCase(status) ? "selected" : "" %>>Approved</option>
                                <option value="Completed" <%= "Completed".equalsIgnoreCase(status) ? "selected" : "" %>>Completed</option>
                            </select>
                            <button type="submit" class="btn-update">Update</button>
                        </form>
                    </td>
                </tr>
                <%
                        }
                    } catch(Exception e) { e.printStackTrace(); }
                %>
            </tbody>
        </table>
    </div>

</body>
</html>