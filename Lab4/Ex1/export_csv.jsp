<%@ page language="java" contentType="text/csv; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    response.setContentType("text/csv");
    response.setHeader("Content-Disposition", "attachment; filename=\"students_export.csv\"");
    
    String dbURL = "jdbc:mysql://localhost:3306/student_management";
    String dbUser = "root";
    String dbPassword = "";
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        
        out.println("ID,Student Code,Full Name,Email,Major,Created At");
        
        String sql = "SELECT * FROM students ORDER BY id ASC";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
        
        while (rs.next()) {
            int id = rs.getInt("id");
            String studentCode = rs.getString("student_code");
            String fullName = rs.getString("full_name");
            String email = rs.getString("email");
            String major = rs.getString("major");
            Timestamp createdAt = rs.getTimestamp("created_at");
            
            out.println(id + "," + 
                       "\"" + studentCode + "\"," + 
                       "\"" + fullName + "\"," + 
                       "\"" + (email != null ? email : "") + "\"," + 
                       "\"" + (major != null ? major : "") + "\"," + 
                       "\"" + createdAt + "\"");
        }
        
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        try {
            if (rs != null) rs.close();
        } catch (SQLException e) {}
        
        try {
            if (pstmt != null) pstmt.close();
        } catch (SQLException e) {}
        
        try {
            if (conn != null) conn.close();
        } catch (SQLException e) {}
    }
%>
