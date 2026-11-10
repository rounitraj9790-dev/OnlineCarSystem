package com.carsystem.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.carsystem.util.DBConnection;

@WebServlet("/AdminUpdateStatusServlet")
public class AdminUpdateStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String serviceIdStr = request.getParameter("service_id");
        String newStatus = request.getParameter("status");

        if (serviceIdStr != null && newStatus != null) {
            try (Connection conn = DBConnection.getConnection()) {
                String sql = "UPDATE maintenance_requests SET status = ? WHERE service_id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, newStatus);
                stmt.setInt(2, Integer.parseInt(serviceIdStr));
                stmt.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect("adminServices.jsp?msg=updated");
    }
}