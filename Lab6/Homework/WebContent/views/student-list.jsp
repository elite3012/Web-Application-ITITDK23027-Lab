<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student List - MVC</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }
        
        h1 {
            color: #333;
            margin-bottom: 10px;
            font-size: 32px;
        }
        
        .subtitle {
            color: #666;
            margin-bottom: 30px;
            font-style: italic;
        }
        
        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-weight: 500;
        }
        
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 500;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            font-size: 14px;
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
            background-color: #6c757d;
            color: white;
        }
        
        .btn-danger {
            background-color: #dc3545;
            color: white;
            padding: 8px 16px;
            font-size: 13px;
        }
        
        .btn-danger:hover {
            background-color: #c82333;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        th {
            font-weight: 600;
            text-transform: uppercase;
            font-size: 13px;
            letter-spacing: 0.5px;
        }
        
        tbody tr {
            transition: background-color 0.2s;
        }
        
        tbody tr:hover {
            background-color: #f8f9fa;
        }
        
        .actions {
            display: flex;
            gap: 10px;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        
        .empty-state-icon {
            font-size: 64px;
            margin-bottom: 20px;
        }
        
        /* search box css */
        .search-box {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 2px solid #e9ecef;
        }
        
        .search-box form {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .search-box input[type="text"] {
            flex: 1;
            padding: 10px 15px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        
        .search-box input[type="text"]:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .search-box button {
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 500;
        }
        
        .search-box button:hover {
            background-color: #0056b3;
        }
        
        .search-box .clear-btn {
            background-color: #6c757d;
        }
        
        .search-box .clear-btn:hover {
            background-color: #5a6268;
        }
        
        .search-result {
            background-color: #d1ecf1;
            border: 1px solid #bee5eb;
            color: #0c5460;
            padding: 12px 20px;
            border-radius: 5px;
            margin-bottom: 15px;
            font-weight: 500;
        }
        
        /* filter & sort css */
        .filter-box {
            background-color: #fff3cd;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 2px solid #ffc107;
        }
        
        .filter-box form {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .filter-box label {
            font-weight: 500;
            color: #333;
        }
        
        .filter-box select {
            padding: 8px 12px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        
        .filter-box select:focus {
            outline: none;
            border-color: #ffc107;
        }
        
        .sortable-header {
            cursor: pointer;
            user-select: none;
            position: relative;
            padding-right: 20px;
        }
        
        .sortable-header:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }
        
        .sort-indicator {
            position: absolute;
            right: 5px;
            top: 50%;
            transform: translateY(-50%);
        }
        
        /* page buttons css */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 30px;
            padding: 20px;
        }
        
        .page-link {
            padding: 8px 16px;
            border: 2px solid #667eea;
            border-radius: 5px;
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s;
            background: white;
        }
        
        .page-link:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
        }
        
        .page-link.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            cursor: default;
            border-color: transparent;
        }
        
        /* navbar css */
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 30px;
            border-radius: 10px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        .navbar h2 {
            margin: 0;
            font-size: 24px;
            color: white;
        }
        
        .navbar-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 8px 15px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 5px;
        }
        
        .role-badge {
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .role-admin {
            background: #ffc107;
            color: #333;
        }
        
        .role-user {
            background: #28a745;
            color: white;
        }
        
        .navbar a {
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 5px;
            transition: background 0.3s;
        }
        
        .navbar a:hover {
            background: rgba(255,255,255,0.1);
        }
        
        .btn-change-password {
            background: #f39c12;
        }
        
        .btn-change-password:hover {
            background: #e67e22 !important;
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-weight: 500;
        }
        
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- navbar with user info -->
        <div class="navbar">
            <h2>📚 Student Management System</h2>
            <div class="navbar-right">
                <div class="user-info">
                    <span>Welcome, ${sessionScope.fullName}</span>
                    <span class="role-badge role-${sessionScope.role}">
                        ${sessionScope.role}
                    </span>
                </div>
                <c:if test="${sessionScope.role eq 'admin'}">
                    <a href="dashboard">Dashboard</a>
                </c:if>
                <a href="change-password" class="btn-change-password">🔒 Change Password</a>
                <a href="logout">Logout</a>
            </div>
        </div>
        
        <h1>📚 Student Management System</h1>
        <p class="subtitle">MVC Pattern with Jakarta EE & JSTL</p>
        
        <!-- green success msg -->
        <c:if test="${not empty param.message}">
            <div class="message success">
                ✅ ${param.message}
            </div>
        </c:if>
        
        <!-- red error msg -->
        <c:if test="${not empty param.error}">
            <div class="message error">
                ❌ ${param.error}
            </div>
        </c:if>
        
        <!-- search stuff -->
        <div class="search-box">
            <form action="student" method="get">
                <input type="hidden" name="action" value="search">
                <input type="text" 
                       name="keyword" 
                       value="${keyword}" 
                       placeholder="🔍 Search by name, code, or email...">
                <button type="submit">Search</button>
                <c:if test="${not empty keyword}">
                    <a href="student?action=list" class="btn clear-btn" style="text-decoration: none; display: inline-block; padding: 10px 20px;">
                        Clear
                    </a>
                </c:if>
            </form>
        </div>
        
        <!-- show what we searched -->
        <c:if test="${not empty keyword}">
            <div class="search-result">
                📌 Search results for: "<strong>${keyword}</strong>" - Found ${students.size()} student(s)
            </div>
        </c:if>
        
        <!-- filter dropdown -->
        <div class="filter-box">
            <form action="student" method="get">
                <input type="hidden" name="action" value="filter">
                <label>Filter by Major:</label>
                <select name="major">
                    <option value="">All Majors</option>
                    <option value="Computer Science" ${selectedMajor == 'Computer Science' ? 'selected' : ''}>
                        Computer Science
                    </option>
                    <option value="Information Technology" ${selectedMajor == 'Information Technology' ? 'selected' : ''}>
                        Information Technology
                    </option>
                    <option value="Software Engineering" ${selectedMajor == 'Software Engineering' ? 'selected' : ''}>
                        Software Engineering
                    </option>
                    <option value="Data Science" ${selectedMajor == 'Data Science' ? 'selected' : ''}>
                        Data Science
                    </option>
                    <option value="Business Administration" ${selectedMajor == 'Business Administration' ? 'selected' : ''}>
                        Business Administration
                    </option>
                </select>
                <button type="submit">Apply Filter</button>
                <c:if test="${not empty selectedMajor}">
                    <a href="student?action=list" class="btn clear-btn" style="text-decoration: none; display: inline-block; padding: 8px 16px; margin-left: 5px;">
                        Clear Filter
                    </a>
                </c:if>
            </form>
        </div>
        
        <!-- add button - admin only -->
        <c:if test="${sessionScope.role eq 'admin'}">
            <div style="margin-bottom: 20px;">
                <a href="student?action=new" class="btn btn-primary">
                    ➕ Add New Student
                </a>
            </div>
        </c:if>
        
        <!-- table to show students -->
        <c:choose>
            <c:when test="${not empty students}">
                <table>
                    <thead>
                        <tr>
                            <th>
                                <a href="student?action=sort&sortBy=id&order=${order == 'asc' ? 'desc' : 'asc'}" 
                                   class="sortable-header" style="color: white; text-decoration: none; display: block;">
                                    ID
                                    <c:if test="${sortBy == 'id'}">
                                        <span class="sort-indicator">${order == 'asc' ? '▲' : '▼'}</span>
                                    </c:if>
                                </a>
                            </th>
                            <th>
                                <a href="student?action=sort&sortBy=student_code&order=${order == 'asc' ? 'desc' : 'asc'}" 
                                   class="sortable-header" style="color: white; text-decoration: none; display: block;">
                                    Student Code
                                    <c:if test="${sortBy == 'student_code'}">
                                        <span class="sort-indicator">${order == 'asc' ? '▲' : '▼'}</span>
                                    </c:if>
                                </a>
                            </th>
                            <th>
                                <a href="student?action=sort&sortBy=full_name&order=${order == 'asc' ? 'desc' : 'asc'}" 
                                   class="sortable-header" style="color: white; text-decoration: none; display: block;">
                                    Full Name
                                    <c:if test="${sortBy == 'full_name'}">
                                        <span class="sort-indicator">${order == 'asc' ? '▲' : '▼'}</span>
                                    </c:if>
                                </a>
                            </th>
                            <th>
                                <a href="student?action=sort&sortBy=email&order=${order == 'asc' ? 'desc' : 'asc'}" 
                                   class="sortable-header" style="color: white; text-decoration: none; display: block;">
                                    Email
                                    <c:if test="${sortBy == 'email'}">
                                        <span class="sort-indicator">${order == 'asc' ? '▲' : '▼'}</span>
                                    </c:if>
                                </a>
                            </th>
                            <th>
                                <a href="student?action=sort&sortBy=major&order=${order == 'asc' ? 'desc' : 'asc'}" 
                                   class="sortable-header" style="color: white; text-decoration: none; display: block;">
                                    Major
                                    <c:if test="${sortBy == 'major'}">
                                        <span class="sort-indicator">${order == 'asc' ? '▲' : '▼'}</span>
                                    </c:if>
                                </a>
                            </th>
                            <c:if test="${sessionScope.role eq 'admin'}">
                                <th>Actions</th>
                            </c:if>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="student" items="${students}">
                            <tr>
                                <td>${student.id}</td>
                                <td><strong>${student.studentCode}</strong></td>
                                <td>${student.fullName}</td>
                                <td>${student.email}</td>
                                <td>${student.major}</td>
                                <c:if test="${sessionScope.role eq 'admin'}">
                                    <td>
                                        <div class="actions">
                                            <a href="student?action=edit&id=${student.id}" class="btn btn-secondary">
                                                ✏️ Edit
                                            </a>
                                            <a href="student?action=delete&id=${student.id}" 
                                               class="btn btn-danger"
                                               onclick="return confirm('Are you sure you want to delete this student?')">
                                                🗑️ Delete
                                            </a>
                                        </div>
                                    </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                
                <!-- page numbers -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination">
                        <!-- back button -->
                        <c:if test="${currentPage > 1}">
                            <a href="student?action=list&page=${currentPage - 1}" class="page-link">
                                ← Previous
                            </a>
                        </c:if>
                        
                        <!-- numbers -->
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <c:choose>
                                <c:when test="${currentPage eq i}">
                                    <span class="page-link active">${i}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="student?action=list&page=${i}" class="page-link">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        
                        <!-- next button -->
                        <c:if test="${currentPage < totalPages}">
                            <a href="student?action=list&page=${currentPage + 1}" class="page-link">
                                Next →
                            </a>
                        </c:if>
                    </div>
                </c:if>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-state-icon">📭</div>
                    <h3>No students found</h3>
                    <p>Start by adding a new student</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
