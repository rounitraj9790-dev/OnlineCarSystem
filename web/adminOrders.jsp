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
    <title>Customer Orders Ledger - Cars Mania</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <style>
        .order-box {
            max-width: 1100px;
            margin: 40px auto;
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 16px;
            padding: 30px;
            color: #ffffff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.5);
        }
        .header-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { padding: 12px 14px; border: 1px solid rgba(255,255,255,0.15); text-align: center; }
        th { background: rgba(0, 0, 0, 0.5); color: #bb86fc; font-size: 14px; }
        .badge-card { background: rgba(187, 134, 252, 0.2); color: #d1c4e9; border: 1px solid #bb86fc; padding: 4px 8px; border-radius: 6px; font-family: monospace; }
    </style>
</head>
<body style="background: radial-gradient(circle at center, #2e1065, #0f051d); min-height: 100vh; margin: 0; padding-top: 20px;">

    <div class="order-box">
        <div class="header-row">
            <h2>Customer Orders & Revenue Ledger</h2>
            <a href="adminDashboard.jsp" style="color: #bb86fc; text-decoration: none; font-weight: bold;">&larr; Back to Dashboard</a>
        </div>

        <table>
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>User ID</th>
                    <th>Car Purchased</th>
                    <th>Payment Method</th>
                    <th>Amount Paid</th>
                    <th>Purchase Date</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try (Connection conn = DBConnection.getConnection();
                         Statement stmt = conn.createStatement();
                         ResultSet rs = stmt.executeQuery(
                             "SELECT p.purchase_id, p.user_id, p.card_number, p.amount, p.purchase_date, " +
                             "c.name AS car_name, c.brand " +
                             "FROM purchases p " +
                             "LEFT JOIN cars c ON p.car_id = c.car_id " +
                             "ORDER BY p.purchase_id DESC")) {
                        
                        boolean hasData = false;
                        while(rs.next()) {
                            hasData = true;
                            String card = rs.getString("card_number");
                            String maskedCard = (card != null && card.length() >= 4) ? "**** **** **** " + card.substring(card.length() - 4) : "Card";
                %>
                <tr>
                    <td>#ORD-<%= rs.getInt("purchase_id") %></td>
                    <td>User #<%= rs.getInt("user_id") %></td>
                    <td><%= rs.getString("brand") != null ? rs.getString("brand") + " " + rs.getString("car_name") : "Car #" + rs.getInt("car_id") %></td>
                    <td><span class="badge-card"><%= maskedCard %></span></td>
                    <td style="color: #69f0ae; font-weight: bold;">&#8377; <%= String.format("%,.0f", rs.getDouble("amount")) %></td>
                    <td><%= rs.getTimestamp("purchase_date") %></td>
                </tr>
                <%
                        }
                        if (!hasData) {
                %>
                <tr>
                    <td colspan="6" style="padding: 25px; color: #b39ddb;">No car purchase records found in purchases table yet.</td>
                </tr>
                <%
                        }
                    } catch(Exception e) { 
                        e.printStackTrace(); 
                    }
                %>
            </tbody>
        </table>
    </div>

</body>
</html>