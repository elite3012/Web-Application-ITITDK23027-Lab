package com.student.controller;

import java.io.IOException;
import java.util.List;

import com.student.dao.StudentDAO;
import com.student.model.Student;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/student")
public class StudentController extends HttpServlet {
    
    private StudentDAO studentDAO;
    
    @Override
    public void init() {
        studentDAO = new StudentDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteStudent(request, response);
                break;
            case "search":  // search stuff
                searchStudents(request, response);
                break;
            case "sort":    // sort stuff
                sortStudents(request, response);
                break;
            case "filter":  // filter stuff
                filterStudents(request, response);
                break;
            default:
                listStudents(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        System.out.println("=== doPost called, action: " + action + " ===");
        
        if (action == null || action.isEmpty()) {
            System.err.println("ERROR: action parameter is null or empty!");
            response.sendRedirect("student?action=list&error=Invalid action");
            return;
        }
        
        switch (action) {
            case "insert":
                insertStudent(request, response);
                break;
            case "update":
                updateStudent(request, response);
                break;
            default:
                System.err.println("ERROR: Unknown action: " + action);
                response.sendRedirect("student?action=list&error=Unknown action");
                break;
        }
    }
    
    // list students with pages
    private void listStudents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // page stuff
        int page = 1;
        int recordsPerPage = 10;
        
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        // calc offset
        int offset = (page - 1) * recordsPerPage;
        
        // get page data
        List<Student> students = studentDAO.getStudentsPaginated(offset, recordsPerPage);
        int totalRecords = studentDAO.getTotalStudents();
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
        
        // set attributes
        request.setAttribute("students", students);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-list.jsp");
        dispatcher.forward(request, response);
    }
    
    // show add form
    private void showNewForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
        dispatcher.forward(request, response);
    }
    
    // show edit form
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        Student existingStudent = studentDAO.getStudentById(id);
        
        request.setAttribute("student", existingStudent);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
        dispatcher.forward(request, response);
    }
    
    // add student
    private void insertStudent(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        
        System.out.println("=== StudentController.insertStudent() called ===");
        
        String studentCode = request.getParameter("studentCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");
        
        System.out.println("Received parameters:");
        System.out.println("  studentCode: " + studentCode);
        System.out.println("  fullName: " + fullName);
        System.out.println("  email: " + email);
        System.out.println("  major: " + major);
        
        Student newStudent = new Student(studentCode, fullName, email, major);
        
        // check if valid first
        if (!validateStudent(newStudent, request)) {
            // failed - go back to form
            request.setAttribute("student", newStudent);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
            dispatcher.forward(request, response);
            return; // stop here
        }
        
        // validation passed
        System.out.println("Calling studentDAO.addStudent()...");
        boolean success = studentDAO.addStudent(newStudent);
        System.out.println("addStudent() returned: " + success);
        
        if (success) {
            System.out.println("SUCCESS: Student added successfully");
            response.sendRedirect("student?action=list&message=Student added successfully");
        } else {
            System.err.println("FAILED: Could not add student");
            response.sendRedirect("student?action=list&error=Failed to add student. Check console for details.");
        }
    }
    
    // update student
    private void updateStudent(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        String studentCode = request.getParameter("studentCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");
        
        Student student = new Student(studentCode, fullName, email, major);
        student.setId(id);
        
        // check if valid first
        if (!validateStudent(student, request)) {
            // failed - go back to form
            request.setAttribute("student", student);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
            dispatcher.forward(request, response);
            return; // stop here
        }
        
        // validation passed
        if (studentDAO.updateStudent(student)) {
            response.sendRedirect("student?action=list&message=Student updated successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to update student");
        }
    }
    
    // delete student
    private void deleteStudent(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        
        if (studentDAO.deleteStudent(id)) {
            response.sendRedirect("student?action=list&message=Student deleted successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to delete student");
        }
    }
    
    // search students
    private void searchStudents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // get keyword
        String keyword = request.getParameter("keyword");
        
        // search (DAO handles null)
        List<Student> students = studentDAO.searchStudents(keyword);
        
        // set results
        request.setAttribute("students", students);
        request.setAttribute("keyword", keyword);  // keep keyword in form
        
        // forward to view
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-list.jsp");
        dispatcher.forward(request, response);
    }
    
    // check student data
    private boolean validateStudent(Student student, HttpServletRequest request) {
        boolean isValid = true;
        
        // check student code
        if (student.getStudentCode() == null || student.getStudentCode().trim().isEmpty()) {
            request.setAttribute("errorCode", "Student code is required");
            isValid = false;
        } else if (!student.getStudentCode().matches("[A-Z]{2}[0-9]{3,}")) {
            request.setAttribute("errorCode", "Invalid format. Use 2 letters + 3+ digits (e.g., SV001)");
            isValid = false;
        }
        
        // check name
        if (student.getFullName() == null || student.getFullName().trim().isEmpty()) {
            request.setAttribute("errorName", "Full name is required");
            isValid = false;
        } else if (student.getFullName().trim().length() < 2) {
            request.setAttribute("errorName", "Full name must be at least 2 characters");
            isValid = false;
        }
        
        // check email if provided
        if (student.getEmail() != null && !student.getEmail().trim().isEmpty()) {
            if (!student.getEmail().matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                request.setAttribute("errorEmail", "Invalid email format");
                isValid = false;
            }
        }
        
        // check major
        if (student.getMajor() == null || student.getMajor().trim().isEmpty()) {
            request.setAttribute("errorMajor", "Major is required");
            isValid = false;
        }
        
        return isValid;
    }
    
    // sort students
    private void sortStudents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String sortBy = request.getParameter("sortBy");
        String order = request.getParameter("order");
        
        // get sorted data
        List<Student> students = studentDAO.getStudentsSorted(sortBy, order);
        
        // set data
        request.setAttribute("students", students);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("order", order);
        
        // Forward to view
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-list.jsp");
        dispatcher.forward(request, response);
    }
    
    // filter by major
    private void filterStudents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String major = request.getParameter("major");
        
        List<Student> students;
        
        // if no major selected, show all
        if (major == null || major.trim().isEmpty()) {
            students = studentDAO.getAllStudents();
        } else {
            students = studentDAO.getStudentsByMajor(major);
        }
        
        // set data
        request.setAttribute("students", students);
        request.setAttribute("selectedMajor", major);
        
        // forward
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-list.jsp");
        dispatcher.forward(request, response);
    }
}
