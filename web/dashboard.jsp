<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Dashboard - Cars Mania</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <style>
        .hub-container {
            max-width: 580px;
            margin: 70px auto;
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 20px;
            padding: 40px;
            text-align: center;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.5);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #ffffff;
        }
        .hub-title {
            font-size: 34px;
            letter-spacing: 2px;
            font-weight: 800;
            margin-bottom: 35px;
            color: #e0d4fd;
            text-transform: uppercase;
        }
        .top-row-buttons {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        .btn-card {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 22px 15px;
            font-size: 17px;
            font-weight: bold;
            color: #ffffff;
            text-decoration: none;
            background: rgba(0, 0, 0, 0.4);
            border: 2px solid rgba(255, 255, 255, 0.25);
            border-radius: 14px;
            transition: all 0.3s ease;
            letter-spacing: 1px;
            text-transform: uppercase;
        }
        .btn-card:hover {
            background: linear-gradient(135deg, #7b1fa2, #4a148c);
            border-color: #bb86fc;
            box-shadow: 0 0 16px rgba(187, 134, 252, 0.5);
            transform: translateY(-2px);
        }
        .btn-full {
            width: 100%;
            box-sizing: border-box;
            padding: 22px 15px;
        }
        .nav-footer {
            margin-top: 30px;
            border-top: 1px solid rgba(255, 255, 255, 0.15);
            padding-top: 15px;
        }
        .nav-footer a {
            color: #ff5252;
            text-decoration: none;
            font-size: 14px;
        }
    </style>
</head>
<body style="background: radial-gradient(circle at center, #2e1065, #0f051d); min-height: 100vh; margin: 0; padding-top: 10px;">

    <div class="hub-container">
        <!-- Title matching sketch -->
        <div class="hub-title">CARS MANIA</div>

        <!-- Row 1: Categories & Comparison -->
        <div class="top-row-buttons">
            <a href="categories.jsp" class="btn-card">Categories</a>
            <a href="compare.jsp" class="btn-card">Comparison</a>
        </div>

        <!-- Row 2: Maintenance Module -->
        <div>
            <a href="serviceBooking.jsp" class="btn-card btn-full">Maintenance</a>
        </div>

        <div class="nav-footer">
            <a href="index.jsp">Back to Home</a>
        </div>
    </div>

</body>
</html>