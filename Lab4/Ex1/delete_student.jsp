<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String idParam = request.getParameter("id");
    
    String errorMessage = null;
    boolean hasError = false;
    
    if (idParam == null || idParam.trim().isEmpty()) {
        errorMessage = "Student ID is required for deletion.";
        hasError = true;
    }
    
    int studentId = 0;
    if (!hasError) {
        try {
            studentId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            errorMessage = "Invalid student ID format.";
            hasError = true;
        }
    }
    
    if (!hasError) {
        String dbURL = "jdbc:mysql://localhost:3306/student_management";
        String dbUser = "root";
        String dbPassword = "";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
            
            String sql = "DELETE FROM students WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setInt(1, studentId);
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                response.sendRedirect("list_students.jsp?success=Student deleted successfully");
            } else {
                errorMessage = "Student not found. No records were deleted.";
                hasError = true;
            }
            
        } catch (ClassNotFoundException e) {
            errorMessage = "MySQL JDBC Driver not found: " + e.getMessage();
            hasError = true;
        } catch (SQLException e) {
            if (e.getErrorCode() == 1451) {
                errorMessage = "Cannot delete student. This student is referenced by other records.";
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
    <title>Error - Delete Student</title>
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
    </style>
</head>
<body>
    <div class="container">
        <h1>⚠️ Error Deleting Student</h1>
        
        <div class="error-box">
            <div class="error-message">
                <%= errorMessage %>
            </div>
        </div>
        
        <div class="button-group">
            <a href="list_students.jsp" class="btn btn-primary">← Back to Student List</a>
        </div>
    </div>
</body>
</html>
<%
    }
%>
