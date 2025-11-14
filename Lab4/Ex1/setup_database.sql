students-- Lab 4 Exercise 1: Student Management Database Setup
-- Create database and table with sample data

-- Create database
CREATE DATABASE IF NOT EXISTS student_management
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE student_management;

-- Drop table if exists
DROP TABLE IF EXISTS students;

-- Create students table
CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_code VARCHAR(20) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    major VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_student_code (student_code),
    INDEX idx_full_name (full_name),
    INDEX idx_major (major)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert 15 sample students for pagination testing (10 per page)
INSERT INTO students (student_code, full_name, email, major) VALUES
('ST001', 'Nguyen Van A', 'nguyenvana@university.edu', 'Computer Science'),
('ST002', 'Tran Thi B', 'tranthib@university.edu', 'Information Technology'),
('ST003', 'Le Van C', 'levanc@university.edu', 'Software Engineering'),
('ST004', 'Pham Thi D', 'phamthid@university.edu', 'Data Science'),
('ST005', 'Hoang Van E', 'hoangvane@university.edu', 'Computer Science'),
('ST006', 'Vo Thi F', 'vothif@university.edu', 'Information Technology'),
('ST007', 'Bui Van G', 'buivang@university.edu', 'Computer Science'),
('ST008', 'Dang Thi H', 'dangthih@university.edu', 'Data Science'),
('ST009', 'Do Van I', 'dovani@university.edu', 'Software Engineering'),
('ST010', 'Ngo Thi K', 'ngothik@university.edu', 'Computer Science'),
('ST011', 'Phan Van L', 'phanvanl@university.edu', 'Information Technology'),
('ST012', 'Trinh Thi M', 'trinhthim@university.edu', 'Data Science'),
('ST013', 'Duong Van N', 'duongvann@university.edu', 'Computer Science'),
('ST014', 'Ha Thi O', 'hathio@university.edu', 'Software Engineering'),
('ST015', 'Ly Van P', 'lyvanp@university.edu', 'Information Technology');

-- Verify data
SELECT * FROM students;
SELECT COUNT(*) as total_students FROM students;

-- Show table structure
DESCRIBE students;
