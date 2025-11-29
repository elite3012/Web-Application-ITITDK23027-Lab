package com.student.controller;

import java.io.IOException;

import org.mindrot.jbcrypt.BCrypt;

import com.student.dao.UserDAO;
import com.student.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Controller for changing user password
 */
@WebServlet("/change-password")
public class ChangePasswordController extends HttpServlet {
    
    private UserDAO userDAO;
    
    @Override
    public void init() {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Show change password form
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/change-password.jsp");
        dispatcher.forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get current user from session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        
        // Get form parameters
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate inputs
        boolean hasErrors = false;
        
        // Check if all fields are provided
        if (currentPassword == null || currentPassword.trim().isEmpty()) {
            request.setAttribute("errorCurrent", "Current password is required");
            hasErrors = true;
        }
        
        if (newPassword == null || newPassword.trim().isEmpty()) {
            request.setAttribute("errorNew", "New password is required");
            hasErrors = true;
        }
        
        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("errorConfirm", "Please confirm new password");
            hasErrors = true;
        }
        
        // Validate new password length
        if (!hasErrors && newPassword.length() < 8) {
            request.setAttribute("errorNew", "Password must be at least 8 characters");
            hasErrors = true;
        }
        
        // Check if new passwords match
        if (!hasErrors && !newPassword.equals(confirmPassword)) {
            request.setAttribute("errorConfirm", "Passwords do not match");
            hasErrors = true;
        }
        
        // Verify current password
        if (!hasErrors && !userDAO.verifyPassword(currentUser.getId(), currentPassword)) {
            request.setAttribute("errorCurrent", "Current password is incorrect");
            hasErrors = true;
        }
        
        // If there are errors, go back to form
        if (hasErrors) {
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/change-password.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        // Hash new password
        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        
        // Update password in database
        boolean success = userDAO.updatePassword(currentUser.getId(), hashedPassword);
        
        if (success) {
            // Success - redirect to student list
            response.sendRedirect("student?action=list&message=Password changed successfully");
        } else {
            // Failed - show error
            request.setAttribute("error", "Failed to update password. Please try again.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/change-password.jsp");
            dispatcher.forward(request, response);
        }
    }
}
