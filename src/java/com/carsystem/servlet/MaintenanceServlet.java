package com.carsystem.servlet;

import com.carsystem.util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/MaintenanceServlet")
public class MaintenanceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Session check: User login na ho to testing fallback user_id = 1 (Admin/Test User)
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        if (userId == null) {
            userId = 1; 
        }

        // 2. Form fields retrieve karna
        String carName = request.getParameter("carName");
        String serviceType = request.getParameter("serviceType");
        String serviceDate = request.getParameter("serviceDate");

        // 3. Database me insert karna
        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                System.out.println("DB Connection null mila!");
                response.sendRedirect("serviceBooking.jsp?msg=error");
                return;
            }

            String sql = "INSERT INTO maintenance_requests (user_id, car_name, service_type, service_date, status) VALUES (?, ?, ?, ?, 'Pending')";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, carName);
            ps.setString(3, serviceType);
            ps.setDate(4, java.sql.Date.valueOf(serviceDate));

            int rows = ps.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("serviceStatus.jsp?msg=booked");
            } else {
                response.sendRedirect("serviceBooking.jsp?msg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("serviceBooking.jsp?msg=error");
        }
    }
}