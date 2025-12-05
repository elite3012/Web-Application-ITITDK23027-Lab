package com.example.product_management.service;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.product_management.entity.Product;
import com.example.product_management.repository.ProductRepository;

@Service
@Transactional
public class ProductServiceImpl implements ProductService {
    
    private final ProductRepository productRepository;
    
    public ProductServiceImpl(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }
    
    @Override
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }
    
    @Override
    public List<Product> getAllProducts(Sort sort) {
        return productRepository.findAll(sort);
    }
    
    @Override
    public Optional<Product> getProductById(Long id) {
        return productRepository.findById(id);
    }
    
    @Override
    public Product saveProduct(Product product) {
        // Validation logic can go here
        return productRepository.save(product);
    }
    
    @Override
    public void deleteProduct(Long id) {
        productRepository.deleteById(id);
    }
    
    @Override
    public List<Product> searchProducts(String keyword) {
        return productRepository.findByNameContaining(keyword);
    }
    
    @Override
    public Page<Product> searchProducts(String keyword, Pageable pageable) {
        return productRepository.findByNameContaining(keyword, pageable);
    }
    
    @Override
    public List<Product> getProductsByCategory(String category) {
        return productRepository.findByCategory(category);
    }
    
    @Override
    public List<Product> getProductsByCategory(String category, Sort sort) {
        return productRepository.findByCategory(category, sort);
    }
    
    // Exercise 5: Advanced search
    @Override
    public Page<Product> advancedSearch(String name, String category, BigDecimal minPrice, BigDecimal maxPrice, Pageable pageable) {
        return productRepository.advancedSearch(name, category, minPrice, maxPrice, pageable);
    }
    
    @Override
    public List<String> getAllCategories() {
        return productRepository.findAllCategories();
    }
    
    // Exercise 8: Statistics
    @Override
    public Map<String, Object> getStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        Long totalProducts = productRepository.getTotalProducts();
        BigDecimal totalValue = productRepository.getTotalValue();
        BigDecimal avgPrice = productRepository.getAveragePrice();
        List<Object[]> categoryStats = productRepository.countByCategory();
        
        stats.put("totalProducts", totalProducts != null ? totalProducts : 0L);
        stats.put("totalValue", totalValue != null ? totalValue : BigDecimal.ZERO);
        stats.put("averagePrice", avgPrice != null ? avgPrice : BigDecimal.ZERO);
        stats.put("categoryStats", categoryStats);
        
        return stats;
    }
}
