-- Lab 4 Exercise 1: Student Management Database Setup
-- Create database and table with sample data

-- Create database
CREATE DATABASE IF NOT EXISTS student_management;
USE student_management;

-- Drop table if exists
DROP TABLE IF EXISTS students;

-- Create students table
CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_code VARCHAR(20) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    major VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert 5 sample students
INSERT INTO students (student_code, full_name, email, major) VALUES
('ST001', 'John Doe', 'john.doe@university.edu', 'Computer Science'),
('ST002', 'Jane Smith', 'jane.smith@university.edu', 'Information Technology'),
('ST003', 'Michael Brown', 'michael.brown@university.edu', 'Software Engineering'),
('ST004', 'Emily Davis', 'emily.davis@university.edu', 'Data Science'),
('ST005', 'David Wilson', 'david.wilson@university.edu', 'Computer Science');

-- Verify data
SELECT * FROM students;
