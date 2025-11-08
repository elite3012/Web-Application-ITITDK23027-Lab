<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Student - Student Management System</title>
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
        }
        
        .container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }
        
        h1 {
            color: #333;
            margin-bottom: 10px;
            text-align: center;
        }
        
        .subtitle {
            text-align: center;
            color: #666;
            margin-bottom: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            color: #333;
            font-weight: 600;
            margin-bottom: 8px;
        }
        
        .required {
            color: #dc3545;
        }
        
        input[type="text"],
        input[type="email"] {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            font-size: 16px;
            transition: border-color 0.3s;
        }
        
        input[type="text"]:focus,
        input[type="email"]:focus {
            outline: none;
            border-color: #667eea;
        }
        
        input[readonly] {
            background-color: #f5f5f5;
            cursor: not-allowed;
            color: #666;
        }
        
        .button-group {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }
        
        button,
        .btn-cancel {
            flex: 1;
            padding: 12px 30px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            transition: all 0.3s;
        }
        
        button[type="submit"] {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
        
        button[type="submit"]:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
        }
        
        .btn-cancel {
            background: #6c757d;
            color: white;
        }
        
        .btn-cancel:hover {
            background: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(108, 117, 125, 0.4);
        }
        
        .info-box {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .error-message {
            background: #f8d7da;
            border: 2px solid #dc3545;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            color: #721c24;
        }
        
        .help-text {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>✏️ Edit Student</h1>
        <p class="subtitle">Update student information</p>
        
        <%
            String idParam = request.getParameter("id");
            
            if (idParam == null || idParam.trim().isEmpty()) {
        %>
                <div class="error-message">
                    <strong>❌ Error:</strong> Student ID is required.
                </div>
                <div style="text-align: center; margin-top: 20px;">
                    <a href="list_students.jsp" class="btn-cancel">← Back to List</a>
                </div>
        <%
            } else {
                int studentId = 0;
                try {
                    studentId = Integer.parseInt(idParam);
                } catch (NumberFormatException e) {
        %>
                    <div class="error-message">
                        <strong>❌ Error:</strong> Invalid student ID format.
                    </div>
                    <div style="text-align: center; margin-top: 20px;">
                        <a href="list_students.jsp" class="btn-cancel">← Back to List</a>
                    </div>
        <%
                    return;
                }
                
                String dbURL = "jdbc:mysql://localhost:3306/student_management";
                String dbUser = "root";
                String dbPassword = "";
                
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    
                    conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                    
                    String sql = "SELECT * FROM students WHERE id = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, studentId);
                    
                    rs = pstmt.executeQuery();
                    
                    if (rs.next()) {
                        int id = rs.getInt("id");
                        String studentCode = rs.getString("student_code");
                        String fullName = rs.getString("full_name");
                        String email = rs.getString("email");
                        String major = rs.getString("major");
        %>
        
        <div class="info-box">
            <strong>ℹ️ Note:</strong> Student Code cannot be changed. Fields marked with <span class="required">*</span> are required.
        </div>
        
        <form action="process_edit.jsp" method="POST">
            <!-- Hidden field for student ID -->
            <input type="hidden" name="id" value="<%= id %>">
            
            <div class="form-group">
                <label for="studentCode">Student Code</label>
                <input 
                    type="text" 
                    id="studentCode" 
                    name="studentCode" 
                    value="<%= studentCode %>"
                    readonly>
                <div class="help-text">Student code cannot be modified</div>
            </div>
            
            <div class="form-group">
                <label for="fullName">
                    Full Name <span class="required">*</span>
                </label>
                <input 
                    type="text" 
                    id="fullName" 
                    name="fullName" 
                    value="<%= fullName %>"
                    required
                    maxlength="100">
                <div class="help-text">Student's full name (max 100 characters)</div>
            </div>
            
            <div class="form-group">
                <label for="email">Email Address</label>
                <input 
                    type="email" 
                    id="email" 
                    name="email" 
                    value="<%= email != null ? email : "" %>"
                    maxlength="100">
                <div class="help-text">Optional - Student's email address</div>
            </div>
            
            <div class="form-group">
                <label for="major">Major</label>
                <input 
                    type="text" 
                    id="major" 
                    name="major" 
                    value="<%= major != null ? major : "" %>"
                    maxlength="50">
                <div class="help-text">Optional - Student's field of study</div>
            </div>
            
            <div class="button-group">
                <button type="submit">💾 Update Student</button>
                <a href="list_students.jsp" class="btn-cancel">✖ Cancel</a>
            </div>
        </form>
        
        <%
                    } else {
        %>
                        <div class="error-message">
                            <strong>❌ Error:</strong> Student not found with ID: <%= studentId %>
                        </div>
                        <div style="text-align: center; margin-top: 20px;">
                            <a href="list_students.jsp" class="btn-cancel">← Back to List</a>
                        </div>
        <%
                    }
                    
                } catch (ClassNotFoundException e) {
        %>
                    <div class="error-message">
                        <strong>❌ Driver Error:</strong> MySQL JDBC Driver not found.<br>
                        <%= e.getMessage() %>
                    </div>
                    <div style="text-align: center; margin-top: 20px;">
                        <a href="list_students.jsp" class="btn-cancel">← Back to List</a>
                    </div>
        <%
                } catch (SQLException e) {
        %>
                    <div class="error-message">
                        <strong>❌ Database Error:</strong> <%= e.getMessage() %>
                    </div>
                    <div style="text-align: center; margin-top: 20px;">
                        <a href="list_students.jsp" class="btn-cancel">← Back to List</a>
                    </div>
        <%
                } finally {
                    try {
                        if (rs != null) rs.close();
                    } catch (SQLException e) {
                    }
                    
                    try {
                        if (pstmt != null) pstmt.close();
                    } catch (SQLException e) {
                    }
                    
                    try {
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                    }
                }
            }
        %>
    </div>
</body>
</html>
