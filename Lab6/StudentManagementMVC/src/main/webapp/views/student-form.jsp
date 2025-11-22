<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${student != null && student.id > 0}">Edit Student</c:when>
            <c:otherwise>Add New Student</c:otherwise>
        </c:choose>
    </title>
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
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .container {
            background: white;
            border-radius: 10px;
            padding: 40px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 600px;
        }
        
        h1 {
            color: #333;
            margin-bottom: 30px;
            font-size: 28px;
            text-align: center;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
            font-size: 14px;
        }
        
        input[type="text"],
        input[type="email"],
        select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        input:focus,
        select:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .required {
            color: #dc3545;
        }
        
        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        
        .btn {
            flex: 1;
            padding: 14px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            text-align: center;
            display: inline-block;
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
        
        .btn-secondary:hover {
            background-color: #5a6268;
        }
        
        .info-text {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
        
        /* error msg styling */
        .error {
            color: #dc3545;
            font-size: 14px;
            display: block;
            margin-top: 5px;
            font-weight: 500;
        }
        
        input.error-input,
        select.error-input {
            border-color: #dc3545;
        }
        
        /* loading spinner */
        .loading-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 9999;
            justify-content: center;
            align-items: center;
        }
        
        .loading-overlay.active {
            display: flex;
        }
        
        .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #667eea;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
    <script>
        // stop double click
        let isSubmitting = false;
        
        function handleFormSubmit(event) {
            if (isSubmitting) {
                event.preventDefault();
                console.log("Form already submitting, blocked duplicate submission");
                return false;
            }
            
            isSubmitting = true;
            console.log("Form submitted, blocking further submissions");
            
            // show loading
            document.getElementById('loadingOverlay').classList.add('active');
            
            // disable submit button
            const submitBtn = event.target.querySelector('button[type="submit"]');
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.style.opacity = '0.6';
            }
            
            return true;
        }
    </script>
</head>
<body>
    <!-- spinner overlay -->
    <div id="loadingOverlay" class="loading-overlay">
        <div class="spinner"></div>
    </div>
    
    <div class="container">
        <h1>
            <c:choose>
                <c:when test="${student != null && student.id > 0}">
                    ✏️ Edit Student
                </c:when>
                <c:otherwise>
                    ➕ Add New Student
                </c:otherwise>
            </c:choose>
        </h1>
        
        <form action="student" method="POST" onsubmit="return handleFormSubmit(event)">
            <!-- action type -->
            <input type="hidden" name="action" 
                   value="${student != null && student.id > 0 ? 'update' : 'insert'}">
            
            <!-- id for update -->
            <c:if test="${student != null && student.id > 0}">
                <input type="hidden" name="id" value="${student.id}">
            </c:if>
            
            <!-- code input -->
            <div class="form-group">
                <label for="studentCode">
                    Student Code <span class="required">*</span>
                </label>
                <input type="text" 
                       id="studentCode" 
                       name="studentCode" 
                       value="${student.studentCode}"
                       class="${not empty errorCode ? 'error-input' : ''}"
                       ${student != null && student.id > 0 ? 'readonly' : 'required'}
                       placeholder="e.g., SV001, IT123">
                <p class="info-text">Format: 2 letters + 3+ digits</p>
                <c:if test="${not empty errorCode}">
                    <span class="error">${errorCode}</span>
                </c:if>
            </div>
            
            <!-- name input -->
            <div class="form-group">
                <label for="fullName">
                    Full Name <span class="required">*</span>
                </label>
                <input type="text" 
                       id="fullName" 
                       name="fullName" 
                       value="${student.fullName}"
                       class="${not empty errorName ? 'error-input' : ''}"
                       required
                       placeholder="Enter full name">
                <c:if test="${not empty errorName}">
                    <span class="error">${errorName}</span>
                </c:if>
            </div>
            
            <!-- email input -->
            <div class="form-group">
                <label for="email">
                    Email <span class="required">*</span>
                </label>
                <input type="email" 
                       id="email" 
                       name="email" 
                       value="${student.email}"
                       class="${not empty errorEmail ? 'error-input' : ''}"
                       required
                       placeholder="student@example.com">
                <c:if test="${not empty errorEmail}">
                    <span class="error">${errorEmail}</span>
                </c:if>
            </div>
            
            <!-- major dropdown -->
            <div class="form-group">
                <label for="major">
                    Major <span class="required">*</span>
                </label>
                <select id="major" name="major" class="${not empty errorMajor ? 'error-input' : ''}" required>
                    <option value="">-- Select Major --</option>
                    <option value="Computer Science" 
                            ${student.major == 'Computer Science' ? 'selected' : ''}>
                        Computer Science
                    </option>
                    <option value="Information Technology" 
                            ${student.major == 'Information Technology' ? 'selected' : ''}>
                        Information Technology
                    </option>
                    <option value="Software Engineering" 
                            ${student.major == 'Software Engineering' ? 'selected' : ''}>
                        Software Engineering
                    </option>
                    <option value="Business Administration" 
                            ${student.major == 'Business Administration' ? 'selected' : ''}>
                        Business Administration
                    </option>
                </select>
            </div>
            
            <!-- submit & cancel buttons -->
            <div class="button-group">
                <button type="submit" class="btn btn-primary">
                    <c:choose>
                        <c:when test="${student != null && student.id > 0}">
                            💾 Update Student
                        </c:when>
                        <c:otherwise>
                            ➕ Add Student
                        </c:otherwise>
                    </c:choose>
                </button>
                <a href="student?action=list" class="btn btn-secondary">
                    ❌ Cancel
                </a>
            </div>
        </form>
    </div>
</body>
</html>
