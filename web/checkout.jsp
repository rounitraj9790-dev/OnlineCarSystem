<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String carId = request.getParameter("carId");
    String carName = request.getParameter("name");
    String priceStr = request.getParameter("price");

    if (carId == null || priceStr == null) {
        response.sendRedirect("CarCatalogServlet");
        return;
    }
    double amount = Double.parseDouble(priceStr);
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Checkout & Payment - Cars Mania</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <style>
        body {
            background: radial-gradient(circle at center, #2e1065, #0f051d);
            min-height: 100vh;
            margin: 0;
            padding-top: 30px;
            color: #ffffff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .checkout-box {
            max-width: 500px;
            margin: 20px auto;
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 16px;
            padding: 35px 40px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.5);
        }
        .checkout-box h2 {
            text-align: center;
            margin-top: 0;
            color: #e0d4fd;
        }
        .summary-card {
            background: rgba(0, 0, 0, 0.4);
            border: 1px solid rgba(187, 134, 252, 0.4);
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 22px;
        }
        .summary-card p {
            margin: 6px 0;
            font-size: 15px;
            color: #d1c4e9;
        }
        .amount-highlight {
            font-size: 22px;
            font-weight: 700;
            color: #69f0ae;
        }
        .form-group {
            margin-bottom: 16px;
        }
        .form-group label {
            display: block;
            font-size: 13px;
            margin-bottom: 6px;
            color: #d1c4e9;
        }
        .form-control {
            width: 100%;
            padding: 12px;
            border-radius: 8px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            background: rgba(0, 0, 0, 0.4);
            color: #ffffff;
            font-size: 14px;
            box-sizing: border-box;
        }
        .row-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }
        .btn-pay {
            width: 100%;
            padding: 13px;
            background: linear-gradient(135deg, #7b1fa2, #4a148c);
            border: none;
            border-radius: 8px;
            color: #ffffff;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            margin-top: 10px;
        }
        .btn-pay:hover {
            background: linear-gradient(135deg, #9c27b0, #6a1b9a);
        }
        .alert-error {
            background: rgba(244, 67, 54, 0.2);
            border: 1px solid #f44336;
            color: #e57373;
            padding: 10px;
            border-radius: 8px;
            text-align: center;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>

    <div class="checkout-box">
        <h2>Secure Car Booking Payment</h2>

        <% if ("failed".equals(request.getParameter("err"))) { %>
            <div class="alert-error">Transaction failed. Please try again.</div>
        <% } %>

        <div class="summary-card">
            <p><strong>Selected Vehicle:</strong> <%= carName %></p>
            <p><strong>Total Payable:</strong> <span class="amount-highlight">&#8377; <%= String.format("%,.0f", amount) %></span></p>
        </div>

        <form action="OrderServlet" method="POST">
            <input type="hidden" name="carId" value="<%= carId %>">
            <input type="hidden" name="amount" value="<%= amount %>">

            <div class="form-group">
                <label>Cardholder Name</label>
                <input type="text" name="cardHolder" class="form-control" placeholder="e.g. Rounit Raj" required>
            </div>

            <div class="form-group">
                <label>Card Number (16 Digits)</label>
                <input type="text" name="cardNumber" class="form-control" maxlength="19" placeholder="4532 1100 8899 4412" required>
            </div>

            <div class="row-2">
                <div class="form-group">
                    <label>Expiry Date</label>
                    <input type="text" name="expiry" class="form-control" placeholder="MM/YY" maxlength="5" required>
                </div>
                <div class="form-group">
                    <label>CVV</label>
                    <input type="password" name="cvv" class="form-control" placeholder="123" maxlength="3" required>
                </div>
            </div>

            <button type="submit" class="btn-pay">Pay & Confirm Booking</button>
        </form>

        <div style="text-align: center; margin-top: 18px;">
            <a href="CarCatalogServlet" style="color: #bb86fc; text-decoration: none; font-size: 14px;">&larr; Cancel & Back to Showroom</a>
        </div>
    </div>

</body>
</html>