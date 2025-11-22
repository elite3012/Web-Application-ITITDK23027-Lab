-- Student Management MVC - Database Setup Script
-- Run this script in MySQL to create the database and tables

-- Create database
CREATE DATABASE IF NOT EXISTS student_management;

-- Use the database
USE student_management;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'USER',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    INDEX idx_username (username),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert sample users
-- Password for both users is: password123
-- BCrypt hash generated with: BCrypt.hashpw("password123", BCrypt.gensalt())
INSERT INTO users (username, password, full_name, role, is_active) VALUES
('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JqhLQYhKHKEH0MK/K2nfJPhNnZTC', 'Administrator', 'ADMIN', TRUE),
('john', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JqhLQYhKHKEH0MK/K2nfJPhNnZTC', 'John Doe', 'USER', TRUE);

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

-- Insert sample student data
INSERT INTO students (student_code, full_name, email, major) VALUES
('SV001', 'Nguyen Van A', 'nguyenvana@example.com', 'Computer Science'),
('SV002', 'Tran Thi B', 'tranthib@example.com', 'Information Technology'),
('SV003', 'Le Van C', 'levanc@example.com', 'Software Engineering'),
('SV004', 'Pham Thi D', 'phamthid@example.com', 'Data Science'),
('SV005', 'Hoang Van E', 'hoangvane@example.com', 'Computer Science'),
('SV006', 'Vo Thi F', 'vothif@example.com', 'Business Administration'),
('SV007', 'Dang Van G', 'dangvang@example.com', 'Information Technology'),
('SV008', 'Bui Thi H', 'buithih@example.com', 'Software Engineering');

-- Display the data
SELECT '=== USERS TABLE ===' AS '';
SELECT id, username, full_name, role, is_active, created_at FROM users;

SELECT '=== STUDENTS TABLE ===' AS '';
SELECT * FROM students;
