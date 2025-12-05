# Product Management System

## Student Information
- **Name:** Trần Phúc Quý
- **Student ID:** ITITDK23027

## Technologies Used
- Spring Boot 4.0.0
- Spring Data JPA
- MySQL 8.0
- Thymeleaf
- Maven

## Setup Instructions
1. Import project into VS Code
2. Create database: `product_management`
3. Update `application.properties` with your MySQL credentials
4. Run: `mvn spring-boot:run`
5. Open browser: http://localhost:8089/products

## Completed Features
- [x] CRUD operations (Create, Read, Update, Delete)
- [x] Search functionality (by name)
- [x] Advanced search with filters (Exercise 5)
- [x] Validation (Exercise 6)
- [x] Sorting (Exercise 7)
- [x] Statistics Dashboard (Exercise 8)

## Project Structure
```
product-management/
├── src/main/java/com/example/product_management/
│   ├── controller/
│   │   ├── ProductController.java       # CRUD, Search, Advanced Search, Sorting
│   │   └── DashboardController.java     # Statistics Dashboard
│   ├── entity/
│   │   └── Product.java                 # Entity with validation annotations
│   ├── repository/
│   │   └── ProductRepository.java       # Custom queries, pagination, statistics
│   ├── service/
│   │   ├── ProductService.java          # Service interface
│   │   └── ProductServiceImpl.java      # Service implementation
│   └── ProductManagementApplication.java
├── src/main/resources/
│   ├── templates/
│   │   ├── product-list.html           # List view with search, filters, sorting
│   │   ├── product-form.html           # Form with validation errors
│   │   └── dashboard.html              # Statistics dashboard
│   └── application.properties          # Database configuration
└── pom.xml                             # Maven dependencies