<%@page import="java.sql.*, com.carsystem.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
/*
String role = (String) session.getAttribute("role");
if (role == null || !"admin".equalsIgnoreCase(role)) {
    response.sendRedirect("login.jsp");
    return;
}*/

    int totalCars = 0;
    int pendingServices = 0;
    int totalOrders = 0;
    int totalUsers = 0;
    double totalRevenue = 0.0;

    try (Connection conn = DBConnection.getConnection()) {
        ResultSet rsCars = conn.createStatement().executeQuery("SELECT COUNT(*) FROM cars");
        if (rsCars.next()) totalCars = rsCars.getInt(1);

        ResultSet rsServices = conn.createStatement().executeQuery("SELECT COUNT(*) FROM maintenance_requests WHERE status='Pending'");
        if (rsServices.next()) pendingServices = rsServices.getInt(1);

        ResultSet rsPurchases = conn.createStatement().executeQuery("SELECT COUNT(*), COALESCE(SUM(amount), 0) FROM purchases");
        if (rsPurchases.next()) {
            totalOrders = rsPurchases.getInt(1);
            totalRevenue = rsPurchases.getDouble(2);
        }

        ResultSet rsUsers = conn.createStatement().executeQuery("SELECT COUNT(*) FROM users WHERE role='customer'");
        if (rsUsers.next()) totalUsers = rsUsers.getInt(1);

    } catch(Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Admin Dashboard - Cars Mania</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <style>
        .dashboard-container { max-width: 1100px; margin: 40px auto; padding: 30px; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; color: #ffffff; }
        .header-section { display: flex; justify-content: space-between; align-items: center; margin-bottom: 35px; background: rgba(255, 255, 255, 0.06); backdrop-filter: blur(12px); padding: 20px 30px; border-radius: 16px; border: 1px solid rgba(255, 255, 255, 0.15); }
        .header-title { font-size: 28px; font-weight: 800; color: #e0d4fd; letter-spacing: 1.5px; text-transform: uppercase; }
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 35px; }
        .stat-card { background: rgba(255, 255, 255, 0.08); backdrop-filter: blur(12px); border: 1px solid rgba(255, 255, 255, 0.2); border-radius: 16px; padding: 25px 20px; text-align: center; box-shadow: 0 10px 25px rgba(0,0,0,0.4); }
        .stat-value { font-size: 32px; font-weight: 800; margin-top: 10px; color: #bb86fc; }
        .stat-label { font-size: 14px; text-transform: uppercase; color: #b39ddb; letter-spacing: 1px; }
        .nav-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 25px; }
        .action-card { background: rgba(0, 0, 0, 0.4); border: 1px solid rgba(255, 255, 255, 0.2); border-radius: 16px; padding: 30px 20px; text-align: center; text-decoration: none; color: #ffffff; transition: 0.3s; }
        .action-card:hover { background: linear-gradient(135deg, #7b1fa2, #4a148c); border-color: #bb86fc; transform: translateY(-4px); }
        .action-title { font-size: 20px; font-weight: bold; margin-bottom: 10px; color: #f3e5f5; }
        .action-desc { font-size: 13px; color: #d1c4e9; }
    </style>
</head>
<body style="background: radial-gradient(circle at center, #2e1065, #0f051d); min-height: 100vh; margin: 0;">

    <div class="dashboard-container">
        <div class="header-section">
            <div class="header-title">Cars Mania - Control Center</div>
            <a href="index.jsp" style="color: #bb86fc; text-decoration: none; font-weight: bold;">&larr; View Customer Showroom</a>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-label">Total Revenue</div>
                <div class="stat-value" style="color: #69f0ae;">&#8377; <%= String.format("%,.0f", totalRevenue) %></div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Showroom Fleet</div>
                <div class="stat-value"><%= totalCars %></div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Pending Services</div>
                <div class="stat-value" style="color: #ffb74d;"><%= pendingServices %></div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Registered Users</div>
                <div class="stat-value"><%= totalUsers %></div>
            </div>
        </div>

        <div class="nav-grid">
            <a href="manageCars.jsp" class="action-card">
                <div class="action-title">&#128663; Manage Fleet</div>
                <div class="action-desc">Add new vehicle models or delete cars from showroom catalog.</div>
            </a>
            <a href="adminServices.jsp" class="action-card">
                <div class="action-title">&#128295; Service Requests</div>
                <div class="action-desc">Review maintenance bookings and approve or mark services complete.</div>
            </a>
            <a href="adminOrders.jsp" class="action-card">
                <div class="action-title">&#128179; Orders & Ledger</div>
                <div class="action-desc">View customer car purchases, card info, and transaction receipts.</div>
            </a>
        </div>
    </div>

</body>
</html>