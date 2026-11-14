package com.travel.service;

import com.travel.dao.PackageDAO;
import com.travel.model.Package;
import java.util.List;

public class PackageService {
    private PackageDAO packageDAO;

    public PackageService() {
        packageDAO = new PackageDAO();
    }

    // Get package by ID
    public Package getPackageById(int packageId) {
        return packageDAO.getPackageById(packageId);
    }

    // Get all packages
    public List<Package> getAllPackages() {
        return packageDAO.getAllPackages();
    }

    // Add new package
    public boolean addPackage(Package pkg) {
        return packageDAO.addPackage(pkg);
    }

    // Update package
    public boolean updatePackage(Package pkg) {
        return packageDAO.updatePackage(pkg);
    }

    public boolean deletePackage(int packageId) {
        return packageDAO.deletePackage(packageId);
    }

    // Image-related methods
    public boolean addPackageImage(int packageId, String imagePath) {
        return packageDAO.addPackageImage(packageId, imagePath);
    }

    public List<String> getPackageImages(int packageId) {
        return packageDAO.getPackageImages(packageId);
    }

    public boolean deletePackageImages(int packageId) {
        return packageDAO.deletePackageImages(packageId);
    }
}