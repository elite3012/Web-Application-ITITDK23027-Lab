-- Student Management MVC - Database Setup Script
-- Run this script in MySQL to create the database and table

-- Create database
CREATE DATABASE IF NOT EXISTS student_management;

-- Use the database
USE student_management;

-- Create students table
CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_code VARCHAR(50) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    major VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_student_code (student_code),
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert sample data
INSERT INTO students (student_code, full_name, email, major) VALUES
('ST001', 'John Doe', 'john.doe@example.com', 'Computer Science'),
('ST002', 'Jane Smith', 'jane.smith@example.com', 'Information Technology'),
('ST003', 'Mike Johnson', 'mike.johnson@example.com', 'Software Engineering'),
('ST004', 'Sarah Williams', 'sarah.williams@example.com', 'Data Science'),
('ST005', 'David Brown', 'david.brown@example.com', 'Computer Science');

-- Display the data
SELECT * FROM students;
