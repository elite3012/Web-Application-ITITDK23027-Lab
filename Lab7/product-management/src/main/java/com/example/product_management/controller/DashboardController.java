package com.example.product_management.controller;

import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.product_management.service.ProductService;

@Controller
@RequestMapping("/dashboard")
public class DashboardController {
    
    private final ProductService productService;
    
    public DashboardController(ProductService productService) {
        this.productService = productService;
    }
    
    // Exercise 8: Statistics Dashboard
    @GetMapping
    public String showDashboard(Model model) {
        Map<String, Object> statistics = productService.getStatistics();
        model.addAttribute("statistics", statistics);
        return "dashboard";
    }
}
