package com.student.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.student.model.Student;

public class StudentDAO {

    // db stuff
    private static final String DB_URL = "jdbc:mysql://localhost:3306/student_management";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    // connect db
    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("Connecting to database: " + DB_URL);
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            System.out.println("Database connection successful!");
            return conn;
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL Driver not found!");
            throw new SQLException("MySQL Driver not found", e);
        } catch (SQLException e) {
            System.err.println("Database connection failed: " + e.getMessage());
            throw e;
        }
    }

    // get all
    public List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM students ORDER BY id DESC";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setStudentCode(rs.getString("student_code"));
                student.setFullName(rs.getString("full_name"));
                student.setEmail(rs.getString("email"));
                student.setMajor(rs.getString("major"));
                student.setCreatedAt(rs.getTimestamp("created_at"));
                students.add(student);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return students;
    }

    // get one student
    public Student getStudentById(int id) {
        String sql = "SELECT * FROM students WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setStudentCode(rs.getString("student_code"));
                student.setFullName(rs.getString("full_name"));
                student.setEmail(rs.getString("email"));
                student.setMajor(rs.getString("major"));
                student.setCreatedAt(rs.getTimestamp("created_at"));
                return student;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // add new student
    public boolean addStudent(Student student) {
        String sql = "INSERT INTO students (student_code, full_name, email, major) VALUES (?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            System.out.println("=== Adding Student ===");
            System.out.println("Student Code: " + student.getStudentCode());
            System.out.println("Full Name: " + student.getFullName());
            System.out.println("Email: " + student.getEmail());
            System.out.println("Major: " + student.getMajor());

            System.out.println("Getting database connection...");
            conn = getConnection();
            System.out.println("Connection obtained!");

            System.out.println("Preparing SQL statement...");
            pstmt = conn.prepareStatement(sql);

            // Set query timeout to 10 seconds
            pstmt.setQueryTimeout(10);
            System.out.println("Query timeout set to 10 seconds");

            System.out.println("Setting parameters...");
            pstmt.setString(1, student.getStudentCode());
            pstmt.setString(2, student.getFullName());
            pstmt.setString(3, student.getEmail());
            pstmt.setString(4, student.getMajor());
            System.out.println("Parameters set successfully");

            System.out.println("Executing INSERT query...");
            System.out.println("SQL: " + sql);

            int rowsAffected = pstmt.executeUpdate();

            System.out.println("Query executed! Rows affected: " + rowsAffected);
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("=== SQL ERROR when adding student ===");
            System.err.println("Error Code: " + e.getErrorCode());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Message: " + e.getMessage());

            // Check for duplicate entry (error code 1062)
            if (e.getErrorCode() == 1062) {
                System.err.println("DUPLICATE KEY ERROR: Student code already exists!");
            }

            e.printStackTrace();
            return false;
        } finally {
            // Clean up resources
            try {
                if (pstmt != null) {
                    System.out.println("Closing PreparedStatement...");
                    pstmt.close();
                }
                if (conn != null) {
                    System.out.println("Closing Connection...");
                    conn.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
    }

    // update student info
    public boolean updateStudent(Student student) {
        String sql = "UPDATE students SET student_code = ?, full_name = ?, email = ?, major = ? WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, student.getStudentCode());
            pstmt.setString(2, student.getFullName());
            pstmt.setString(3, student.getEmail());
            pstmt.setString(4, student.getMajor());
            pstmt.setInt(5, student.getId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // delete student
    public boolean deleteStudent(int id) {
        String sql = "DELETE FROM students WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Ex5: search by keyword
    public List<Student> searchStudents(String keyword) {
        List<Student> students = new ArrayList<>();

        // if empty, get all
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllStudents();
        }

        String sql = "SELECT * FROM students WHERE student_code LIKE ? OR full_name LIKE ? OR email LIKE ? ORDER BY id DESC";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            // add wildcards for LIKE
            String searchPattern = "%" + keyword.trim() + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Student student = createStudentFromResultSet(rs);
                students.add(student);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return students;
    }

    // Ex7: sort students
    public List<Student> getStudentsSorted(String sortBy, String order) {
        List<Student> students = new ArrayList<>();

        // validate column name
        String validatedSortBy = validateSortBy(sortBy);
        String validatedOrder = validateOrder(order);

        String sql = "SELECT * FROM students ORDER BY " + validatedSortBy + " " + validatedOrder;

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Student student = createStudentFromResultSet(rs);
                students.add(student);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return students;
    }

    // filter by major
    public List<Student> getStudentsByMajor(String major) {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM students WHERE major = ? ORDER BY id DESC";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, major);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Student student = createStudentFromResultSet(rs);
                students.add(student);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return students;
    }

    // filter + sort combo
    public List<Student> getStudentsFiltered(String major, String sortBy, String order) {
        List<Student> students = new ArrayList<>();

        String validatedSortBy = validateSortBy(sortBy);
        String validatedOrder = validateOrder(order);

        String sql;
        boolean hasMajorFilter = (major != null && !major.trim().isEmpty());

        if (hasMajorFilter) {
            sql = "SELECT * FROM students WHERE major = ? ORDER BY " + validatedSortBy + " " + validatedOrder;
        } else {
            sql = "SELECT * FROM students ORDER BY " + validatedSortBy + " " + validatedOrder;
        }

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            if (hasMajorFilter) {
                pstmt.setString(1, major);
            }

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Student student = createStudentFromResultSet(rs);
                students.add(student);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return students;
    }

    // Ex8: count total
    public int getTotalStudents() {
        String sql = "SELECT COUNT(*) FROM students";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    // get students with pages
    public List<Student> getStudentsPaginated(int offset, int limit) {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM students ORDER BY id DESC LIMIT ? OFFSET ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, limit);
            pstmt.setInt(2, offset);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Student student = createStudentFromResultSet(rs);
                students.add(student);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return students;
    }

    // helper: make Student from db row
    private Student createStudentFromResultSet(ResultSet rs) throws SQLException {
        Student student = new Student();
        student.setId(rs.getInt("id"));
        student.setStudentCode(rs.getString("student_code"));
        student.setFullName(rs.getString("full_name"));
        student.setEmail(rs.getString("email"));
        student.setMajor(rs.getString("major"));
        student.setCreatedAt(rs.getTimestamp("created_at"));
        return student;
    }

    // check if sort column is safe
    private String validateSortBy(String sortBy) {
        String[] validColumns = {"id", "student_code", "full_name", "email", "major"};

        if (sortBy != null) {
            for (String validColumn : validColumns) {
                if (validColumn.equalsIgnoreCase(sortBy)) {
                    return validColumn;
                }
            }
        }

        return "id"; // default
    }

    // check asc or desc
    private String validateOrder(String order) {
        if ("desc".equalsIgnoreCase(order)) {
            return "DESC";
        }
        return "ASC"; // default
    }
}
