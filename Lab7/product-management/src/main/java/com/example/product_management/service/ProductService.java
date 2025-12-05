package com.example.product_management.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

import com.example.product_management.entity.Product;

public interface ProductService {
    
    List<Product> getAllProducts();
    List<Product> getAllProducts(Sort sort);
    
    Optional<Product> getProductById(Long id);
    
    Product saveProduct(Product product);
    
    void deleteProduct(Long id);
    
    List<Product> searchProducts(String keyword);
    Page<Product> searchProducts(String keyword, Pageable pageable);
    
    List<Product> getProductsByCategory(String category);
    List<Product> getProductsByCategory(String category, Sort sort);
    
    // Exercise 5: Advanced search
    Page<Product> advancedSearch(String name, String category, BigDecimal minPrice, BigDecimal maxPrice, Pageable pageable);
    List<String> getAllCategories();
    
    // Exercise 8: Statistics
    Map<String, Object> getStatistics();
}
