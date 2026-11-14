<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map, java.text.NumberFormat, java.util.Locale" %>
<%
    if (request.getAttribute("allCars") == null) {
        response.sendRedirect("CompareServlet");
        return;
    }
    List allCars = (List) request.getAttribute("allCars");
    Map<String, Object> car1 = (Map<String, Object>) request.getAttribute("car1");
    Map<String, Object> car2 = (Map<String, Object>) request.getAttribute("car2");

    String selected1 = request.getParameter("car1") != null ? request.getParameter("car1") : "";
    String selected2 = request.getParameter("car2") != null ? request.getParameter("car2") : "";

    NumberFormat inrFormat = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
    inrFormat.setMaximumFractionDigits(0);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Compare Cars - Cars Mania</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body {
            background: radial-gradient(circle at center, #2e1065, #0f051d);
            min-height: 100vh;
            color: #ffffff;
            padding-bottom: 50px;
        }
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 18px 40px;
            background: rgba(15, 5, 29, 0.75);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.12);
        }
        .navbar h1 { font-size: 22px; letter-spacing: 0.5px; }
        .nav-links a {
            color: #d8b4fe;
            text-decoration: none;
            margin-left: 22px;
            font-size: 14px;
            font-weight: 500;
        }
        .nav-links a:hover { color: #ffffff; }
        .container { max-width: 1000px; margin: 35px auto; padding: 0 20px; }
        .selector-card {
            background: rgba(255, 255, 255, 0.07);
            backdrop-filter: blur(14px);
            border: 1px solid rgba(255, 255, 255, 0.18);
            border-radius: 16px;
            padding: 25px;
            margin-bottom: 30px;
        }
        .selector-grid {
            display: grid;
            grid-template-columns: 1fr auto 1fr auto;
            gap: 16px;
            align-items: end;
        }
        .form-group label {
            display: block;
            font-size: 13px;
            color: #d8b4fe;
            margin-bottom: 8px;
            font-weight: 600;
        }
        select {
            width: 100%;
            padding: 12px 14px;
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.25);
            background: #1e0b3b;
            color: #ffffff;
            font-size: 14px;
            outline: none;
        }
        .vs-badge {
            background: linear-gradient(135deg, #9333ea, #ec4899);
            padding: 10px 14px;
            border-radius: 50%;
            font-weight: 700;
            font-size: 13px;
            text-align: center;
        }
        .btn-compare {
            padding: 12px 26px;
            border: none;
            border-radius: 10px;
            background: linear-gradient(135deg, #7c3aed, #db2777);
            color: #ffffff;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
        }
        .btn-compare:hover { opacity: 0.92; }
        .compare-table-wrap {
            background: rgba(255, 255, 255, 0.06);
            backdrop-filter: blur(14px);
            border: 1px solid rgba(255, 255, 255, 0.16);
            border-radius: 16px;
            overflow: hidden;
        }
        table { width: 100%; border-collapse: collapse; }
        th, td {
            padding: 16px 20px;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            font-size: 15px;
        }
        th:first-child, td:first-child {
            text-align: left;
            font-weight: 600;
            color: #c4b5fd;
            width: 24%;
            background: rgba(0, 0, 0, 0.2);
        }
        .car-header img {
            width: 220px;
            height: 130px;
            object-fit: cover;
            border-radius: 10px;
            margin-top: 10px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            background: #16082c;
        }
        .car-title { font-size: 19px; font-weight: 700; color: #ffffff; }
        .btn-buy {
            display: inline-block;
            padding: 10px 22px;
            background: linear-gradient(135deg, #10b981, #059669);
            color: #ffffff;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 13px;
        }
        .btn-buy:hover { opacity: 0.92; }
        .empty-state {
            text-align: center;
            padding: 45px 20px;
            color: #c4b5fd;
            font-size: 15px;
        }
        @media (max-width: 768px) {
            .selector-grid { grid-template-columns: 1fr; }
            .vs-badge { width: 44px; margin: 0 auto; }
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>Cars Mania Comparison</h1>
        <div class="nav-links">
            <a href="CarCatalogServlet">Showroom</a>
            <a href="serviceBooking.jsp">Book Service</a>
            <a href="dashboard.jsp">Dashboard</a>
        </div>
    </div>

    <div class="container">
        <div class="selector-card">
            <form action="CompareServlet" method="get" class="selector-grid">
                <div class="form-group">
                    <label for="car1">Select First Car</label>
                    <select name="car1" id="car1" required>
                        <option value="">-- Choose Car 1 --</option>
                        <% for (Object obj : allCars) {
    Map<String, Object> c = (Map<String, Object>) obj;
    String idStr = String.valueOf(c.get("car_id"));
%>
<option value="<%= idStr %>" <%= idStr.equals(selected1) ? "selected" : "" %>>
                                <%= c.get("brand") %> <%= c.get("name") %>
                            </option>
                        <% } %>
                    </select>
                </div>

                <div class="vs-badge">VS</div>

                <div class="form-group">
                    <label for="car2">Select Second Car</label>
                    <select name="car2" id="car2" required>
                        <option value="">-- Choose Car 2 --</option>
<% for (Object obj : allCars) {
    Map<String, Object> c = (Map<String, Object>) obj;
    String idStr = String.valueOf(c.get("car_id"));
%>
<option value="<%= idStr %>" <%= idStr.equals(selected2) ? "selected" : "" %>>
                                <%= c.get("brand") %> <%= c.get("name") %>
                            </option>
                        <% } %>
                    </select>
                </div>

                <button type="submit" class="btn-compare">Compare</button>
            </form>
        </div>

        <% if (car1 != null && car2 != null) {
            double p1 = (Double) car1.get("price");
            double p2 = (Double) car2.get("price");
            int cc1 = (Integer) car1.get("engine_cc");
            int cc2 = (Integer) car2.get("engine_cc");
            double m1 = (Double) car1.get("mileage");
            double m2 = (Double) car2.get("mileage");
            String f1 = String.valueOf(car1.get("fuel_type"));
            String f2 = String.valueOf(car2.get("fuel_type"));
        %>
        <div class="compare-table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>Specification</th>
                        <th class="car-header">
                            <div class="car-title"><%= car1.get("brand") %> <%= car1.get("name") %></div>
                            <img src="images/<%= car1.get("image_url") %>" alt="<%= car1.get("name") %>">
                        </th>
                        <th class="car-header">
                            <div class="car-title"><%= car2.get("brand") %> <%= car2.get("name") %></div>
                            <img src="images/<%= car2.get("image_url") %>" alt="<%= car2.get("name") %>">
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Brand</td>
                        <td><%= car1.get("brand") %></td>
                        <td><%= car2.get("brand") %></td>
                    </tr>
                    <tr>
                        <td>Category</td>
                        <td><%= car1.get("category_name") %></td>
                        <td><%= car2.get("category_name") %></td>
                    </tr>
                    <tr>
                        <td>Price</td>
                        <td><%= inrFormat.format(p1) %></td>
                        <td><%= inrFormat.format(p2) %></td>
                    </tr>
                    <tr>
                        <td>Engine</td>
                        <td><%= cc1 == 0 ? "Electric Motor" : cc1 + " cc" %></td>
                        <td><%= cc2 == 0 ? "Electric Motor" : cc2 + " cc" %></td>
                    </tr>
                    <tr>
                        <td>Mileage / Range</td>
                        <td><%= m1 %> <%= "Electric".equalsIgnoreCase(f1) ? "km/charge" : "km/l" %></td>
                        <td><%= m2 %> <%= "Electric".equalsIgnoreCase(f2) ? "km/charge" : "km/l" %></td>
                    </tr>
                    <tr>
                        <td>Fuel Type</td>
                        <td><%= f1 %></td>
                        <td><%= f2 %></td>
                    </tr>
                    <tr>
                        <td>Transmission</td>
                        <td><%= car1.get("transmission") %></td>
                        <td><%= car2.get("transmission") %></td>
                    </tr>
                    <tr>
                        <td>Action</td>
                        <td>
                            <a class="btn-buy" href="checkout.jsp?carId=<%= car1.get("car_id") %>&name=<%= car1.get("brand") %>%20<%= car1.get("name") %>&price=<%= p1 %>">
                                Buy <%= car1.get("name") %>
                            </a>
                        </td>
                        <td>
                            <a class="btn-buy" href="checkout.jsp?carId=<%= car2.get("car_id") %>&name=<%= car2.get("brand") %>%20<%= car2.get("name") %>&price=<%= p2 %>">
                                Buy <%= car2.get("name") %>
                            </a>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <% } else { %>
            <div class="compare-table-wrap empty-state">
                Select any two cars above and click <strong>Compare</strong> to view side-by-side details.
            </div>
        <% } %>
    </div>
</body>
</html>