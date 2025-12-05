package com.example.product_management.repository;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.product_management.entity.Product;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    
    // Spring Data JPA generates implementation automatically!
    
    // Custom query methods (derived from method names)
    List<Product> findByCategory(String category);
    List<Product> findByCategory(String category, Sort sort);
    
    List<Product> findByNameContaining(String keyword);
    Page<Product> findByNameContaining(String keyword, Pageable pageable);
    
    List<Product> findByPriceBetween(BigDecimal minPrice, BigDecimal maxPrice);
    
    List<Product> findByCategoryOrderByPriceAsc(String category);
    
    boolean existsByProductCode(String productCode);
    
    // Exercise 5: Advanced Search with multiple criteria
    @Query("SELECT p FROM Product p WHERE " +
           "(:name IS NULL OR LOWER(p.name) LIKE LOWER(CONCAT('%', :name, '%'))) AND " +
           "(:category IS NULL OR p.category = :category) AND " +
           "(:minPrice IS NULL OR p.price >= :minPrice) AND " +
           "(:maxPrice IS NULL OR p.price <= :maxPrice)")
    Page<Product> advancedSearch(
        @Param("name") String name,
        @Param("category") String category,
        @Param("minPrice") BigDecimal minPrice,
        @Param("maxPrice") BigDecimal maxPrice,
        Pageable pageable
    );
    
    // Exercise 5: Get all distinct categories
    @Query("SELECT DISTINCT p.category FROM Product p ORDER BY p.category")
    List<String> findAllCategories();
    
    // Exercise 8: Statistics - Total products
    @Query("SELECT COUNT(p) FROM Product p")
    Long getTotalProducts();
    
    // Exercise 8: Statistics - Total value
    @Query("SELECT SUM(p.price * p.quantity) FROM Product p")
    BigDecimal getTotalValue();
    
    // Exercise 8: Statistics - Average price
    @Query("SELECT AVG(p.price) FROM Product p")
    BigDecimal getAveragePrice();
    
    // Exercise 8: Statistics - Products by category
    @Query("SELECT p.category, COUNT(p) FROM Product p GROUP BY p.category")
    List<Object[]> countByCategory();
    
    // All basic CRUD methods inherited from JpaRepository:
    // - findAll()
    // - findById(Long id)
    // - save(Product product)
    // - deleteById(Long id)
    // - count()
    // - existsById(Long id)
}