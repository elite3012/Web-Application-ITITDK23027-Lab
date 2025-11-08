<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Student - Student Management System</title>
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
        
        input[type="text"]:required:invalid,
        input[type="email"]:required:invalid {
            border-color: #e0e0e0;
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        button[type="submit"]:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
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
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            font-size: 14px;
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
        <h1>➕ Add New Student</h1>
        <p class="subtitle">Fill in the student information</p>
        
        <div class="info-box">
            <strong>ℹ️ Note:</strong> Fields marked with <span class="required">*</span> are required.
        </div>
        
        <form action="process_add.jsp" method="POST">
            <div class="form-group">
                <label for="studentCode">
                    Student Code <span class="required">*</span>
                </label>
                <input 
                    type="text" 
                    id="studentCode" 
                    name="studentCode" 
                    placeholder="e.g., ST006"
                    required
                    maxlength="20">
                <div class="help-text">Unique identifier for the student (max 20 characters)</div>
            </div>
            
            <div class="form-group">
                <label for="fullName">
                    Full Name <span class="required">*</span>
                </label>
                <input 
                    type="text" 
                    id="fullName" 
                    name="fullName" 
                    placeholder="e.g., John Doe"
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
                    placeholder="e.g., john.doe@university.edu"
                    maxlength="100">
                <div class="help-text">Optional - Student's email address</div>
            </div>
            
            <div class="form-group">
                <label for="major">Major</label>
                <input 
                    type="text" 
                    id="major" 
                    name="major" 
                    placeholder="e.g., Computer Science"
                    maxlength="50">
                <div class="help-text">Optional - Student's field of study</div>
            </div>
            
            <div class="button-group">
                <button type="submit">💾 Add Student</button>
                <a href="list_students.jsp" class="btn-cancel">✖ Cancel</a>
            </div>
        </form>
    </div>
</body>
</html>
