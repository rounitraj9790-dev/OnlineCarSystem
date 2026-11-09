<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Car Maintenance Booking - Car Mania</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <style>
        .service-container {
            max-width: 550px;
            margin: 50px auto;
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 16px;
            padding: 35px 40px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.5);
            color: #ffffff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .service-container h2 {
            text-align: center;
            margin-bottom: 25px;
            font-size: 26px;
            color: #e0d4fd;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            color: #d1c4e9;
        }
        .form-control {
            width: 100%;
            padding: 12px 14px;
            border-radius: 8px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            background: rgba(0, 0, 0, 0.4);
            color: #ffffff;
            font-size: 14px;
            box-sizing: border-box;
            outline: none;
        }
        .form-control option {
            background: #1e1035;
            color: #ffffff;
        }
        .btn-submit {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #7b1fa2, #4a148c);
            border: none;
            border-radius: 8px;
            color: white;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 10px;
        }
        .btn-submit:hover {
            background: linear-gradient(135deg, #9c27b0, #6a1b9a);
        }
        .alert-msg {
            text-align: center;
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 6px;
            font-size: 14px;
        }
        .success { background: rgba(76, 175, 80, 0.2); border: 1px solid #4caf50; color: #81c784; }
        .error { background: rgba(244, 67, 54, 0.2); border: 1px solid #f44336; color: #e57373; }
        .nav-links {
            text-align: center;
            margin-top: 20px;
        }
        .nav-links a {
            color: #b39ddb;
            text-decoration: none;
            font-size: 14px;
            margin: 0 10px;
        }
    </style>
</head>
<body style="background: radial-gradient(circle at center, #2e1065, #0f051d); min-height: 100vh; margin: 0; padding-top: 20px;">

    <div class="service-container">
        <h2>Schedule Car Service</h2>

        <% 
            String msg = request.getParameter("msg");
            if ("success".equals(msg)) {
        %>
            <div class="alert-msg success">Service request booked successfully!</div>
        <% 
            } else if ("error".equals(msg)) {
        %>
            <div class="alert-msg error">Failed to schedule service. Please try again.</div>
        <% 
            }
        %>

        <form action="MaintenanceServlet" method="POST">
            <div class="form-group">
                <label for="carName">Select Car Model</label>
                <select name="carName" id="carName" class="form-control" required>
                    <option value="" disabled selected>-- Choose Car --</option>
                    <optgroup label="SUV">
                        <option value="Mahindra Scorpio-N">Mahindra Scorpio-N</option>
                        <option value="Hyundai Creta">Hyundai Creta</option>
                        <option value="Toyota Fortuner">Toyota Fortuner</option>
                    </optgroup>
                    <optgroup label="Sedan">
                        <option value="Honda City">Honda City</option>
                        <option value="Hyundai Verna">Hyundai Verna</option>
                        <option value="Skoda Slavia">Skoda Slavia</option>
                    </optgroup>
                    <optgroup label="Electric">
                        <option value="Tata Nexon EV">Tata Nexon EV</option>
                        <option value="MG ZS EV">MG ZS EV</option>
                        <option value="Hyundai Ioniq 5">Hyundai Ioniq 5</option>
                    </optgroup>
                    <optgroup label="Sports">
                        <option value="Ford Mustang GT">Ford Mustang GT</option>
                        <option value="Porsche 911">Porsche 911</option>
                        <option value="Lamborghini Huracan">Lamborghini Huracan</option>
                    </optgroup>
                </select>
            </div>

            <div class="form-group">
                <label for="serviceType">Service Type</label>
                <select name="serviceType" id="serviceType" class="form-control" required>
                    <option value="" disabled selected>-- Select Service Type --</option>
                    <option value="General Periodic Maintenance">General Periodic Maintenance</option>
                    <option value="Engine Oil & Filter Replacement">Engine Oil & Filter Replacement</option>
                    <option value="Brake Inspection & Pad Replacement">Brake Inspection & Pad Replacement</option>
                    <option value="Battery Health & Electrical Diagnosis">Battery Health & Electrical Diagnosis</option>
                    <option value="Wheel Alignment & Tire Balancing">Wheel Alignment & Tire Balancing</option>
                    <option value="AC Servicing & Cabin Filter Change">AC Servicing & Cabin Filter Change</option>
                </select>
            </div>

            <div class="form-group">
                <label for="serviceDate">Preferred Service Date</label>
                <input type="date" name="serviceDate" id="serviceDate" class="form-control" required>
            </div>

            <button type="submit" class="btn-submit">Confirm Service Booking</button>
        </form>

        <div class="nav-links">
            <a href="serviceStatus.jsp">View Booking Status</a> | 
            <a href="index.jsp">Back to Home</a>
        </div>
    </div>

    <script>
        const datePicker = document.getElementById('serviceDate');
        const today = new Date().toISOString().split('T')[0];
        datePicker.setAttribute('min', today);
    </script>
</body>
</html>