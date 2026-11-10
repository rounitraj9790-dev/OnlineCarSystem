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
    <title>Manage Fleet - Cars Mania</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <style>
        .fleet-box {
            max-width: 1100px;
            margin: 30px auto;
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
        .alert-success { background: rgba(76, 175, 80, 0.2); border: 1px solid #4caf50; color: #a5d6a7; padding: 10px; border-radius: 8px; text-align: center; margin-bottom: 20px; }
        .form-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px; margin-bottom: 20px; }
        .input-group label { display: block; font-size: 13px; margin-bottom: 5px; color: #d1c4e9; }
        .input-field { width: 100%; padding: 10px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.2); background: rgba(0,0,0,0.4); color: #fff; box-sizing: border-box; }
        .btn-add { background: linear-gradient(135deg, #7b1fa2, #4a148c); color: #fff; border: none; padding: 12px 24px; border-radius: 8px; font-weight: bold; cursor: pointer; text-transform: uppercase; }
        table { width: 100%; border-collapse: collapse; margin-top: 25px; }
        th, td { padding: 10px 12px; border: 1px solid rgba(255,255,255,0.15); text-align: center; font-size: 14px; }
        th { background: rgba(0,0,0,0.5); color: #bb86fc; }
        .btn-del { background: #d32f2f; color: #fff; border: none; padding: 6px 12px; border-radius: 6px; cursor: pointer; font-size: 12px; }
    </style>
</head>
<body style="background: radial-gradient(circle at center, #2e1065, #0f051d); min-height: 100vh; margin: 0; padding-top: 10px;">

    <div class="fleet-box">
        <div class="header-row">
            <h2>Manage Showroom Fleet</h2>
            <a href="adminDashboard.jsp" style="color: #bb86fc; text-decoration: none;">&larr; Back to Dashboard</a>
        </div>

        <% if ("added".equals(request.getParameter("msg"))) { %>
            <div class="alert-success">Car added successfully to showroom!</div>
        <% } else if ("deleted".equals(request.getParameter("msg"))) { %>
            <div class="alert-success">Car deleted successfully from database!</div>
        <% } %>

        <form action="ManageCarServlet" method="POST">
            <input type="hidden" name="action" value="add">
            <div class="form-grid">
                <div class="input-group">
                    <label>Car Model Name</label>
                    <input type="text" name="name" class="input-field" placeholder="e.g. Thar Roxx" required>
                </div>
                <div class="input-group">
                    <label>Brand</label>
                    <input type="text" name="brand" class="input-field" placeholder="e.g. Mahindra" required>
                </div>
                <div class="input-group">
                    <label>Category</label>
                    <select name="category_id" class="input-field" required>
                        <option value="1">SUV</option>
                        <option value="2">Sedan</option>
                        <option value="3">Electric</option>
                        <option value="4">Sports</option>
                    </select>
                </div>
                <div class="input-group">
                    <label>Price (INR)</label>
                    <input type="number" step="0.01" name="price" class="input-field" placeholder="e.g. 1500000" required>
                </div>
                <div class="input-group">
                    <label>Engine (CC)</label>
                    <input type="number" name="engine_cc" class="input-field" placeholder="0 for Electric" required>
                </div>
                <div class="input-group">
                    <label>Mileage / Range (kmpl or km)</label>
                    <input type="number" step="0.1" name="mileage" class="input-field" placeholder="e.g. 15.5" required>
                </div>
                <div class="input-group">
                    <label>Fuel Type</label>
                    <select name="fuel_type" class="input-field">
                        <option value="Petrol">Petrol</option>
                        <option value="Diesel">Diesel</option>
                        <option value="Electric">Electric</option>
                    </select>
                </div>
                <div class="input-group">
                    <label>Transmission</label>
                    <select name="transmission" class="input-field">
                        <option value="Manual">Manual</option>
                        <option value="Automatic">Automatic</option>
                    </select>
                </div>
                <div class="input-group">
                    <label>Image File Name</label>
                    <input type="text" name="image_url" class="input-field" placeholder="e.g. default.jpg" value="default.jpg">
                </div>
            </div>
            <button type="submit" class="btn-add">+ Insert Car to Database</button>
        </form>

        <h2 style="margin-top: 40px;">Current Showroom Cars</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Model</th>
                    <th>Brand</th>
                    <th>Price</th>
                    <th>Engine</th>
                    <th>Fuel</th>
                    <th>Transmission</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try (Connection conn = DBConnection.getConnection();
                         ResultSet rs = conn.createStatement().executeQuery("SELECT * FROM cars ORDER BY car_id DESC")) {
                        while(rs.next()) {
                %>
                <tr>
                    <td>#<%= rs.getInt("car_id") %></td>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getString("brand") %></td>
                    <td style="color: #69f0ae;">&#8377; <%= String.format("%,.0f", rs.getDouble("price")) %></td>
                    <td><%= rs.getInt("engine_cc") %> CC</td>
                    <td><%= rs.getString("fuel_type") %></td>
                    <td><%= rs.getString("transmission") %></td>
                    <td>
                        <form action="ManageCarServlet" method="POST" onsubmit="return confirm('Delete this car?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="car_id" value="<%= rs.getInt("car_id") %>">
                            <button type="submit" class="btn-del">Delete</button>
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