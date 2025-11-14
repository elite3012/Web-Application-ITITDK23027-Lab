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
        
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 5px;
            margin-top: 20px;
            padding: 20px 0;
        }
        
        .pagination a, .pagination strong {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            text-decoration: none;
            color: #667eea;
            transition: all 0.3s;
        }
        
        .pagination a:hover {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }
        
        .pagination strong {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }
        
        .table-responsive {
            overflow-x: auto;
        }
        
        @media (max-width: 768px) {
            table {
                font-size: 12px;
            }
            th, td {
                padding: 8px 5px;
            }
            .container {
                padding: 15px;
            }
        }
    </style>
    <script>
        setTimeout(function() {
            var messages = document.querySelectorAll('.success-message, .error-message');
            messages.forEach(function(msg) {
                msg.style.transition = 'opacity 0.5s';
                msg.style.opacity = '0';
                setTimeout(function() {
                    msg.style.display = 'none';
                }, 500);
            });
        }, 3000);
    </script>
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
            <form action="list_students.jsp" method="GET" style="display: flex; gap: 10px; align-items: center;">
                <input type="text" name="keyword" placeholder="🔍 Search by name or code..." 
                       value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>"
                       style="padding: 10px; border: 2px solid #ddd; border-radius: 6px; flex: 1; font-size: 14px;">
                <button type="submit" style="padding: 10px 20px; background: #007bff; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: 600;">Search</button>
                <a href="list_students.jsp" style="padding: 10px 20px; background: #6c757d; color: white; text-decoration: none; border-radius: 6px; font-weight: 600;">Clear</a>
            </form>
            <div style="display: flex; gap: 10px;">
                <a href="export_csv.jsp" style="padding: 10px 20px; background: #28a745; color: white; text-decoration: none; border-radius: 6px; font-weight: 600;">📥 Export CSV</a>
                <a href="add_student.jsp" class="btn-add">➕ Add New Student</a>
            </div>
        </div>
        
        <%
            String keyword = request.getParameter("keyword");
            String pageParam = request.getParameter("page");
            int currentPage = (pageParam != null) ? Integer.parseInt(pageParam) : 1;
            int recordsPerPage = 10;
            int offset = (currentPage - 1) * recordsPerPage;
            
            String dbURL = "jdbc:mysql://localhost:3306/student_management";
            String dbUser = "root";
            String dbPassword = "";
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            PreparedStatement countStmt = null;
            ResultSet rs = null;
            ResultSet countRs = null;
            int totalRecords = 0;
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                
                String countSql;
                String dataSql;
                
                if (keyword != null && !keyword.trim().isEmpty()) {
                    countSql = "SELECT COUNT(*) as total FROM students WHERE full_name LIKE ? OR student_code LIKE ?";
                    countStmt = conn.prepareStatement(countSql);
                    countStmt.setString(1, "%" + keyword.trim() + "%");
                    countStmt.setString(2, "%" + keyword.trim() + "%");
                    countRs = countStmt.executeQuery();
                    if (countRs.next()) {
                        totalRecords = countRs.getInt("total");
                    }
                    
                    dataSql = "SELECT * FROM students WHERE full_name LIKE ? OR student_code LIKE ? ORDER BY id ASC LIMIT ? OFFSET ?";
                    pstmt = conn.prepareStatement(dataSql);
                    pstmt.setString(1, "%" + keyword.trim() + "%");
                    pstmt.setString(2, "%" + keyword.trim() + "%");
                    pstmt.setInt(3, recordsPerPage);
                    pstmt.setInt(4, offset);
                } else {
                    countSql = "SELECT COUNT(*) as total FROM students";
                    countStmt = conn.prepareStatement(countSql);
                    countRs = countStmt.executeQuery();
                    if (countRs.next()) {
                        totalRecords = countRs.getInt("total");
                    }
                    
                    dataSql = "SELECT * FROM students ORDER BY id ASC LIMIT ? OFFSET ?";
                    pstmt = conn.prepareStatement(dataSql);
                    pstmt.setInt(1, recordsPerPage);
                    pstmt.setInt(2, offset);
                }
                
                rs = pstmt.executeQuery();
                int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
        %>
        
        <div class="info-box">
            <strong>ℹ️ Database Status:</strong> Connected successfully | 
            <strong>Total Students:</strong> <%= totalRecords %> | 
            <strong>Page:</strong> <%= currentPage %> of <%= totalPages %>
        </div>
        
        <div class="table-responsive">
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
        </div>
        
        <div class="pagination">
            <% if (currentPage > 1) { 
                String prevLink = "list_students.jsp?page=" + (currentPage - 1);
                if (keyword != null && !keyword.trim().isEmpty()) {
                    prevLink += "&keyword=" + keyword.trim();
                }
            %>
                <a href="<%= prevLink %>">« Previous</a>
            <% } %>
            
            <% 
                int startPage = Math.max(1, currentPage - 2);
                int endPage = Math.min(totalPages, currentPage + 2);
                
                for (int i = startPage; i <= endPage; i++) { 
                    String pageLink = "list_students.jsp?page=" + i;
                    if (keyword != null && !keyword.trim().isEmpty()) {
                        pageLink += "&keyword=" + keyword.trim();
                    }
                    
                    if (i == currentPage) { 
            %>
                        <strong><%= i %></strong>
            <%      } else { %>
                        <a href="<%= pageLink %>"><%= i %></a>
            <%      } 
                } 
            %>
            
            <% if (currentPage < totalPages) { 
                String nextLink = "list_students.jsp?page=" + (currentPage + 1);
                if (keyword != null && !keyword.trim().isEmpty()) {
                    nextLink += "&keyword=" + keyword.trim();
                }
            %>
                <a href="<%= nextLink %>">Next »</a>
            <% } %>
        </div>
        
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
                    if (countRs != null) countRs.close();
                } catch (SQLException e) {}
                
                try {
                    if (pstmt != null) pstmt.close();
                } catch (SQLException e) {}
                
                try {
                    if (countStmt != null) countStmt.close();
                } catch (SQLException e) {}
                
                try {
                    if (conn != null) conn.close();
                } catch (SQLException e) {}
            }
        %>
    </div>
</body>
</html>
