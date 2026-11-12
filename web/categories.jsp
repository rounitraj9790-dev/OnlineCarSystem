<%@page import="java.util.List, com.carsystem.bean.Car"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (request.getAttribute("carList") == null) {
        response.sendRedirect("CarCatalogServlet");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Showroom Catalog - Cars Mania</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <style>
        body {
            background: radial-gradient(circle at center, #2e1065, #0f051d);
            min-height: 100vh;
            margin: 0;
            color: #ffffff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .catalog-wrapper {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px 50px 20px;
        }
        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            border-bottom: 1px solid rgba(255,255,255,0.15);
            padding-bottom: 15px;
        }
        .top-bar h1 {
            margin: 0;
            font-size: 28px;
            color: #e0d4fd;
        }
        .nav-home {
            color: #bb86fc;
            text-decoration: none;
            font-weight: 600;
            font-size: 15px;
        }
        .category-tabs {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 30px;
        }
        .tab-btn {
            padding: 10px 22px;
            border-radius: 25px;
            text-decoration: none;
            color: #d1c4e9;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.2);
            font-weight: 600;
            font-size: 14px;
            transition: 0.3s;
        }
        .tab-btn:hover, .tab-btn.active {
            background: linear-gradient(135deg, #7b1fa2, #4a148c);
            color: #ffffff;
            border-color: #bb86fc;
            box-shadow: 0 4px 15px rgba(187, 134, 252, 0.35);
        }
        .cars-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 25px;
        }
        .car-card {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.18);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.45);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: transform 0.25s;
        }
        .car-card:hover {
            transform: translateY(-5px);
            border-color: #bb86fc;
        }
        .car-img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            background: rgba(0,0,0,0.4);
        }
        .car-body {
            padding: 20px;
        }
        .car-brand {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #bb86fc;
            font-weight: 700;
        }
        .car-title {
            font-size: 22px;
            margin: 4px 0 12px 0;
            color: #ffffff;
        }
        .specs-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px;
            font-size: 13px;
            color: #d1c4e9;
            background: rgba(0,0,0,0.3);
            padding: 10px 12px;
            border-radius: 8px;
            margin-bottom: 16px;
        }
        .price-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 10px;
        }
        .car-price {
            font-size: 20px;
            font-weight: 700;
            color: #69f0ae;
        }
        .btn-buy {
            background: linear-gradient(135deg, #7b1fa2, #4a148c);
            color: #ffffff;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            transition: 0.3s;
        }
        .btn-buy:hover {
            background: linear-gradient(135deg, #9c27b0, #6a1b9a);
        }
        .alert-success {
            background: rgba(76, 175, 80, 0.2);
            border: 1px solid #4caf50;
            color: #a5d6a7;
            padding: 12px;
            border-radius: 8px;
            text-align: center;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

    <div class="catalog-wrapper">
        <div class="top-bar">
            <h1>Cars Mania Showroom</h1>
            <div>
                <a href="serviceBooking.jsp" class="nav-home" style="margin-right: 18px;">Book Service</a>
                <a href="index.jsp" class="nav-home">&larr; Home</a>
            </div>
        </div>

        <% if ("purchased".equals(request.getParameter("msg"))) { %>
            <div class="alert-success">Congratulations! Your car booking & payment is confirmed.</div>
        <% } %>

        <%
            String activeCat = (String) request.getAttribute("activeCategory");
            if (activeCat == null) activeCat = "0";
        %>

        <div class="category-tabs">
            <a href="CarCatalogServlet?categoryId=0" class="tab-btn <%= "0".equals(activeCat) ? "active" : "" %>">All Cars</a>
            <a href="CarCatalogServlet?categoryId=1" class="tab-btn <%= "1".equals(activeCat) ? "active" : "" %>">SUV</a>
            <a href="CarCatalogServlet?categoryId=2" class="tab-btn <%= "2".equals(activeCat) ? "active" : "" %>">Sedan</a>
            <a href="CarCatalogServlet?categoryId=3" class="tab-btn <%= "3".equals(activeCat) ? "active" : "" %>">Electric</a>
            <a href="CarCatalogServlet?categoryId=4" class="tab-btn <%= "4".equals(activeCat) ? "active" : "" %>">Sports</a>
        </div>

        <div class="cars-grid">
            <%
                List<Car> carList = (List<Car>) request.getAttribute("carList");
                if (carList != null && !carList.isEmpty()) {
                    for (Car c : carList) {
                        boolean isElectric = "Electric".equalsIgnoreCase(c.getFuelType()) || c.getEngineCc() == 0;
            %>
            <div class="car-card">
                <img src="images/<%= c.getImageUrl() %>" alt="<%= c.getName() %>" class="car-img" onerror="this.src='images/default.jpg';">
                <div class="car-body">
                    <div class="car-brand"><%= c.getBrand() %></div>
                    <h3 class="car-title"><%= c.getName() %></h3>

                    <div class="specs-grid">
                        <div><strong>Engine:</strong> <%= isElectric ? "Electric Motor" : c.getEngineCc() + " CC" %></div>
                        <div><strong><%= isElectric ? "Range:" : "Mileage:" %></strong> <%= c.getMileage() %> <%= isElectric ? "km" : "kmpl" %></div>
                        <div><strong>Fuel:</strong> <%= c.getFuelType() %></div>
                        <div><strong>Gearbox:</strong> <%= c.getTransmission() %></div>
                    </div>

                    <div class="price-row">
                        <div class="car-price">&#8377; <%= String.format("%,.0f", c.getPrice()) %></div>
                        <a href="checkout.jsp?carId=<%= c.getCarId() %>&name=<%= java.net.URLEncoder.encode(c.getBrand() + " " + c.getName(), "UTF-8") %>&price=<%= c.getPrice() %>" class="btn-buy">Buy Now</a>
                    </div>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <div style="grid-column: 1 / -1; text-align: center; padding: 40px; color: #d1c4e9;">
                No cars found in this category. (Open via <strong>CarCatalogServlet</strong> to load cars from database.)
            </div>
            <%
                }
            %>
        </div>
    </div>

</body>
</html>