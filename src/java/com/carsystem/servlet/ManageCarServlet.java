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

@WebServlet("/ManageCarServlet")
public class ManageCarServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        try (Connection conn = DBConnection.getConnection()) {
            if ("add".equalsIgnoreCase(action)) {
                String sql = "INSERT INTO cars (name, brand, category_id, price, engine_cc, mileage, fuel_type, transmission, image_url) "
                           + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, request.getParameter("name"));
                ps.setString(2, request.getParameter("brand"));
                ps.setInt(3, Integer.parseInt(request.getParameter("category_id")));
                ps.setDouble(4, Double.parseDouble(request.getParameter("price")));
                ps.setInt(5, Integer.parseInt(request.getParameter("engine_cc")));
                ps.setDouble(6, Double.parseDouble(request.getParameter("mileage")));
                ps.setString(7, request.getParameter("fuel_type"));
                ps.setString(8, request.getParameter("transmission"));
                ps.setString(9, request.getParameter("image_url"));
                ps.executeUpdate();
                response.sendRedirect("manageCars.jsp?msg=added");
                return;
            } else if ("delete".equalsIgnoreCase(action)) {
                String sql = "DELETE FROM cars WHERE car_id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(request.getParameter("car_id")));
                ps.executeUpdate();
                response.sendRedirect("manageCars.jsp?msg=deleted");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("manageCars.jsp?err=failed");
    }
}