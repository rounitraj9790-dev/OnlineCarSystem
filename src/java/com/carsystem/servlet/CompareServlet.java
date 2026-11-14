package com.carsystem.servlet;

import com.carsystem.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/CompareServlet")
public class CompareServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List allCars = new ArrayList<>();
        Map<String, Object> car1 = null;
        Map<String, Object> car2 = null;

        String car1IdParam = request.getParameter("car1");
        String car2IdParam = request.getParameter("car2");

        try (Connection conn = DBConnection.getConnection()) {

            String listSql = "SELECT c.car_id, c.name, c.brand, cat.category_name "
                           + "FROM cars c LEFT JOIN categories cat ON c.category_id = cat.category_id "
                           + "ORDER BY c.brand, c.name";
            try (PreparedStatement ps = conn.prepareStatement(listSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("car_id", rs.getInt("car_id"));
                    row.put("name", rs.getString("name"));
                    row.put("brand", rs.getString("brand"));
                    row.put("category_name", rs.getString("category_name"));
                    allCars.add(row);
                }
            }

            if (car1IdParam != null && !car1IdParam.isEmpty()
                    && car2IdParam != null && !car2IdParam.isEmpty()) {
                int id1 = Integer.parseInt(car1IdParam);
                int id2 = Integer.parseInt(car2IdParam);

                car1 = getCarDetailsById(conn, id1);
                car2 = getCarDetailsById(conn, id2);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "Database error: " + e.getMessage());
        }

        request.setAttribute("allCars", allCars);
        request.setAttribute("car1", car1);
        request.setAttribute("car2", car2);
        request.getRequestDispatcher("compare.jsp").forward(request, response);
    }

    private Map<String, Object> getCarDetailsById(Connection conn, int carId) throws Exception {
        String sql = "SELECT c.*, cat.category_name FROM cars c "
                   + "LEFT JOIN categories cat ON c.category_id = cat.category_id "
                   + "WHERE c.car_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, carId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> car = new HashMap<>();
                    car.put("car_id", rs.getInt("car_id"));
                    car.put("name", rs.getString("name"));
                    car.put("brand", rs.getString("brand"));
                    car.put("category_name", rs.getString("category_name"));
                    car.put("price", rs.getDouble("price"));
                    car.put("engine_cc", rs.getInt("engine_cc"));
                    car.put("mileage", rs.getDouble("mileage"));
                    car.put("fuel_type", rs.getString("fuel_type"));
                    car.put("transmission", rs.getString("transmission"));
                    car.put("image_url", rs.getString("image_url"));
                    return car;
                }
            }
        }
        return null;
    }
}