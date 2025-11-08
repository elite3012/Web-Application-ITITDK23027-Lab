<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student List - Student Management System</title>
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
            max-width: 1200px;
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
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
        }
        
        td {
            padding: 12px 15px;
            border-bottom: 1px solid #e0e0e0;
        }
        
        tr:hover {
            background-color: #f5f5f5;
        }
        
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        
        tr:nth-child(even):hover {
            background-color: #f0f0f0;
        }
        
        .error-message {
            background: #f44336;
            color: white;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        
        .success-message {
            background: #4caf50;
            color: white;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        
        .info-box {
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        
        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .badge-cs {
            background: #e3f2fd;
            color: #1976d2;
        }
        
        .badge-it {
            background: #f3e5f5;
            color: #7b1fa2;
        }
        
        .badge-se {
            background: #e8f5e9;
            color: #388e3c;
        }
        
        .badge-ds {
            background: #fff3e0;
            color: #f57c00;
        }
        
        .header-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .btn-add {
            padding: 10px 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-add:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .action-links {
            display: flex;
            gap: 10px;
        }
        
        .edit-link {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s;
        }
        
        .edit-link:hover {
            color: #4c5fd5;
            text-decoration: underline;
        }
        
        .delete-link {
            color: #dc3545;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s;
        }
        
        .delete-link:hover {
            color: #c82333;
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎓 Student Management System</h1>
        <p class="subtitle">List of All Students</p>
        
        <%
            String successMsg = request.getParameter("success");
            if (successMsg != null && !successMsg.isEmpty()) {
        %>
        <div class="success-message">
            ✅ <%= successMsg %>
        </div>
        <%
            }
        %>
        
        <div class="header-actions">
            <div></div>
            <a href="add_student.jsp" class="btn-add">➕ Add New Student</a>
        </div>
        
        <%
            String dbURL = "jdbc:mysql://localhost:3306/student_management";
            String dbUser = "root";
            String dbPassword = "";
            
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                
                stmt = conn.createStatement();
                
                String sql = "SELECT * FROM students ORDER BY id ASC";
                rs = stmt.executeQuery(sql);
                
                int rowCount = 0;
                if (rs.last()) {
                    rowCount = rs.getRow();
                    rs.beforeFirst();
                }
        %>
        
        <div class="info-box">
            <strong>ℹ️ Database Status:</strong> Connected successfully | 
            <strong>Total Students:</strong> <%= rowCount %>
        </div>
        
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Student Code</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Major</th>
                    <th>Created At</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
        <%
                while (rs.next()) {
                    int id = rs.getInt("id");
                    String studentCode = rs.getString("student_code");
                    String fullName = rs.getString("full_name");
                    String email = rs.getString("email");
                    String major = rs.getString("major");
                    Timestamp createdAt = rs.getTimestamp("created_at");
                    
                    String badgeClass = "badge ";
                    if (major.contains("Computer Science")) {
                        badgeClass += "badge-cs";
                    } else if (major.contains("Information Technology")) {
                        badgeClass += "badge-it";
                    } else if (major.contains("Software Engineering")) {
                        badgeClass += "badge-se";
                    } else if (major.contains("Data Science")) {
                        badgeClass += "badge-ds";
                    }
        %>
                <tr>
                    <td><strong><%= id %></strong></td>
                    <td><%= studentCode %></td>
                    <td><%= fullName %></td>
                    <td><%= email %></td>
                    <td><span class="<%= badgeClass %>"><%= major %></span></td>
                    <td><%= createdAt %></td>
                    <td>
                        <div class="action-links">
                            <a href="edit_student.jsp?id=<%= id %>" class="edit-link">
                                ✏️ Edit
                            </a>
                            <a href="delete_student.jsp?id=<%= id %>" 
                               class="delete-link"
                               onclick="return confirm('Are you sure you want to delete this student? This action cannot be undone.');">
                                🗑️ Delete
                            </a>
                        </div>
                    </td>
                </tr>
        <%
                }
        %>
            </tbody>
        </table>
        
        <%
            } catch (ClassNotFoundException e) {
        %>
                <div class="error-message">
                    <strong>❌ Driver Error:</strong> MySQL JDBC Driver not found.<br>
                    Please add MySQL Connector/J library to your project.<br>
                    Error: <%= e.getMessage() %>
                </div>
        <%
            } catch (SQLException e) {
        %>
                <div class="error-message">
                    <strong>Database Error:</strong> <%= e.getMessage() %><br>
                    <strong>Error Code:</strong> <%= e.getErrorCode() %><br>
                    <strong>SQL State:</strong> <%= e.getSQLState() %>
                </div>
        <%
            } finally {
                try {
                    if (rs != null) rs.close();
                } catch (SQLException e) {}
                
                try {
                    if (stmt != null) stmt.close();
                } catch (SQLException e) {}
                
                try {
                    if (conn != null) conn.close();
                } catch (SQLException e) {}
            }
        %>
    </div>
</body>
</html>
