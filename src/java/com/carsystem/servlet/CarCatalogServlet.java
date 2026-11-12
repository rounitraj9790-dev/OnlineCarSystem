package com.carsystem.servlet;

import com.carsystem.bean.Car;
import com.carsystem.util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/CarCatalogServlet")
public class CarCatalogServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Car> carList = new ArrayList<>();
        String catIdParam = request.getParameter("categoryId");

        try (Connection con = DBConnection.getConnection()) {
            if (con != null) {
                String sql;
                boolean filterByCategory = (catIdParam != null && !catIdParam.trim().isEmpty() && !"0".equals(catIdParam.trim()));

                if (filterByCategory) {
                    sql = "SELECT * FROM cars WHERE category_id = ? ORDER BY car_id ASC";
                } else {
                    sql = "SELECT * FROM cars ORDER BY car_id ASC";
                }

                PreparedStatement ps = con.prepareStatement(sql);
                if (filterByCategory) {
                    ps.setInt(1, Integer.parseInt(catIdParam.trim()));
                }

                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Car c = new Car();
                    c.setCarId(rs.getInt("car_id"));
                    c.setName(rs.getString("name"));
                    c.setBrand(rs.getString("brand"));
                    c.setCategoryId(rs.getInt("category_id"));
                    c.setPrice(rs.getDouble("price"));
                    c.setEngineCc(rs.getInt("engine_cc"));
                    c.setMileage(rs.getDouble("mileage"));
                    c.setFuelType(rs.getString("fuel_type"));
                    c.setTransmission(rs.getString("transmission"));
                    c.setImageUrl(rs.getString("image_url"));
                    carList.add(c);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("carList", carList);
        request.setAttribute("activeCategory", (catIdParam != null && !catIdParam.trim().isEmpty()) ? catIdParam.trim() : "0");
        request.getRequestDispatcher("categories.jsp").forward(request, response);
    }
}