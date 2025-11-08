<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String studentCode = request.getParameter("studentCode");
    String fullName = request.getParameter("fullName");
    String email = request.getParameter("email");
    String major = request.getParameter("major");
    
    String errorMessage = null;
    boolean hasError = false;
    
    if (studentCode == null || studentCode.trim().isEmpty() || 
        fullName == null || fullName.trim().isEmpty()) {
        errorMessage = "Required fields missing. Student Code and Full Name are required.";
        hasError = true;
    }
    
    if (!hasError) {
        studentCode = studentCode.trim();
        fullName = fullName.trim();
        
        if (email != null) {
            email = email.trim();
            if (email.isEmpty()) email = null;
        }
        if (major != null) {
            major = major.trim();
            if (major.isEmpty()) major = null;
        }
        
        String dbURL = "jdbc:mysql://localhost:3306/student_management";
        String dbUser = "root";
        String dbPassword = "";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
            
            String sql = "INSERT INTO students (student_code, full_name, email, major) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, studentCode);
            pstmt.setString(2, fullName);
            pstmt.setString(3, email);
            pstmt.setString(4, major);
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                response.sendRedirect("list_students.jsp?success=Student added successfully");
            } else {
                errorMessage = "Failed to add student. No rows affected.";
                hasError = true;
            }
            
        } catch (ClassNotFoundException e) {
            errorMessage = "MySQL JDBC Driver not found: " + e.getMessage();
            hasError = true;
        } catch (SQLException e) {
            if (e.getErrorCode() == 1062 || e.getMessage().contains("Duplicate entry")) {
                errorMessage = "Student code already exists. Please use a different student code.";
            } else {
                errorMessage = "Database error: " + e.getMessage();
            }
            hasError = true;
        } finally {
            try {
                if (pstmt != null) pstmt.close();
            } catch (SQLException e) {}
            
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {}
        }
    }
    
    if (hasError) {
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Add Student</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .container {
            max-width: 600px;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }
        
        h1 {
            color: #dc3545;
            margin-bottom: 20px;
            text-align: center;
        }
        
        .error-box {
            background: #f8d7da;
            border: 2px solid #dc3545;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .error-message {
            color: #721c24;
            font-size: 16px;
            line-height: 1.5;
        }
        
        .button-group {
            display: flex;
            gap: 10px;
            justify-content: center;
        }
        
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>⚠️ Error Adding Student</h1>
        
        <div class="error-box">
            <div class="error-message">
                <%= errorMessage %>
            </div>
        </div>
        
        <div class="button-group">
            <a href="add_student.jsp" class="btn btn-primary">← Go Back</a>
            <a href="list_students.jsp" class="btn btn-secondary">View Student List</a>
        </div>
    </div>
</body>
</html>
<%
    }
%>
