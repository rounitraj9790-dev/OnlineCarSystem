<%@page import="java.sql.*, com.carsystem.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>My Service Appointments - Car Mania</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <style>
        .status-container {
            max-width: 900px;
            margin: 50px auto;
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 16px;
            padding: 30px 40px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.5);
            color: #ffffff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .header-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            padding-bottom: 15px;
            margin-bottom: 25px;
        }
        .header-bar h2 {
            margin: 0;
            color: #e0d4fd;
            font-size: 24px;
        }
        .btn-new {
            background: linear-gradient(135deg, #7b1fa2, #4a148c);
            color: #ffffff;
            padding: 9px 18px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            transition: 0.3s;
        }
        .btn-new:hover {
            background: linear-gradient(135deg, #9c27b0, #6a1b9a);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        th, td {
            padding: 14px 16px;
            text-align: left;
            border-bottom: 1px solid rgba(255, 255, 255, 0.12);
            font-size: 14px;
        }
        th {
            background: rgba(0, 0, 0, 0.4);
            color: #d1c4e9;
            text-transform: uppercase;
            font-size: 12px;
            letter-spacing: 0.5px;
        }
        .badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .badge-pending {
            background: rgba(255, 171, 0, 0.15);
            color: #ffab00;
            border: 1px solid #ffab00;
        }
        .badge-approved {
            background: rgba(100, 181, 246, 0.15);
            color: #64b5f6;
            border: 1px solid #64b5f6;
        }
        .badge-completed {
            background: rgba(105, 240, 174, 0.15);
            color: #69f0ae;
            border: 1px solid #69f0ae;
        }
        .alert-success {
            background: rgba(76, 175, 80, 0.2);
            border: 1px solid #4caf50;
            color: #81c784;
            padding: 10px;
            border-radius: 8px;
            text-align: center;
            margin-bottom: 20px;
            font-size: 14px;
        }
    </style>
</head>
<body style="background: radial-gradient(circle at center, #2e1065, #0f051d); min-height: 100vh; margin: 0; padding-top: 20px;">

    <div class="status-container">
        <div class="header-bar">
            <h2>My Car Service Requests</h2>
            <div>
                <a href="serviceBooking.jsp" class="btn-new">+ Book New Service</a>
                <a href="index.jsp" style="color: #b39ddb; text-decoration: none; margin-left: 15px; font-size: 14px;">Home</a>
            </div>
        </div>

        <% if ("booked".equals(request.getParameter("msg"))) { %>
            <div class="alert-success">Service appointment successfully booked! Details updated below.</div>
        <% } %>

        <table>
            <thead>
                <tr>
                    <th>Request ID</th>
                    <th>Vehicle</th>
                    <th>Service Package</th>
                    <th>Scheduled Date</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    int currentUserId = (session.getAttribute("user_id") != null) 
                                        ? (Integer) session.getAttribute("user_id") 
                                        : 1;

                    try (Connection con = DBConnection.getConnection()) {
                        if (con != null) {
                            String sql = "SELECT * FROM maintenance_requests WHERE user_id = ? ORDER BY service_id DESC";
                            PreparedStatement ps = con.prepareStatement(sql);
                            ps.setInt(1, currentUserId);
                            ResultSet rs = ps.executeQuery();
                            boolean hasRecords = false;

                            while (rs.next()) {
                                hasRecords = true;
                                String st = rs.getString("status");
                                String badgeClass = "badge-pending";
                                if ("Approved".equalsIgnoreCase(st) || "In Progress".equalsIgnoreCase(st)) {
                                    badgeClass = "badge-approved";
                                } else if ("Completed".equalsIgnoreCase(st)) {
                                    badgeClass = "badge-completed";
                                }
                %>
                    <tr>
                        <td>#SRV-<%= rs.getInt("service_id") %></td>
                        <td><strong><%= rs.getString("car_name") %></strong></td>
                        <td><%= rs.getString("service_type") %></td>
                        <td><%= rs.getDate("service_date") %></td>
                        <td><span class="badge <%= badgeClass %>"><%= st %></span></td>
                    </tr>
                <%
                            }
                            if (!hasRecords) {
                %>
                    <tr>
                        <td colspan="5" style="text-align: center; color: #b39ddb; padding: 30px;">
                            No maintenance requests found. Click "+ Book New Service" to schedule.
                        </td>
                    </tr>
                <%
                            }
                        } else {
                %>
                    <tr>
                        <td colspan="5" style="text-align: center; color: #ff5252; padding: 20px;">
                            Unable to connect to database.
                        </td>
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