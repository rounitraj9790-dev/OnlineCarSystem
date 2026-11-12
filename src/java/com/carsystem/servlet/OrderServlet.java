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

@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        if (userId == null) {
            userId = 2; // Fallback to default Customer User (user_id = 2) if not logged in
        }

        String carIdStr = request.getParameter("carId");
        String amountStr = request.getParameter("amount");
        String cardNumber = request.getParameter("cardNumber");

        if (cardNumber != null && cardNumber.length() > 20) {
            cardNumber = cardNumber.substring(0, 20);
        }

        try (Connection con = DBConnection.getConnection()) {
            if (con != null) {
                String sql = "INSERT INTO purchases (user_id, car_id, card_number, amount) VALUES (?, ?, ?, ?)";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, userId);
                ps.setInt(2, Integer.parseInt(carIdStr));
                ps.setString(3, cardNumber);
                ps.setDouble(4, Double.parseDouble(amountStr));

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    response.sendRedirect("CarCatalogServlet?msg=purchased");
                    return;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("checkout.jsp?carId=" + carIdStr + "&price=" + amountStr + "&err=failed");
    }
}