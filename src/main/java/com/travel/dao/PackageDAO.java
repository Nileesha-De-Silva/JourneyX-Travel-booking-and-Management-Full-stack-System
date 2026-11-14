package com.travel.dao;

import com.travel.model.Package;
import com.travel.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PackageDAO {

    // Get package by ID with images
    public Package getPackageById(int packageId) {
        Package pkg = null;
        String sql = "SELECT * FROM Package WHERE PackageId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, packageId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                pkg = new Package();
                pkg.setPackageId(rs.getInt("PackageId"));
                pkg.setPackageName(rs.getString("PackageName"));
                pkg.setPrice(rs.getDouble("Price"));
                pkg.setStartDate(rs.getDate("StartDate"));
                pkg.setEndDate(rs.getDate("EndDate"));
                pkg.setDuration(rs.getString("Duration"));
                pkg.setDestinations(rs.getString("Destinations"));
                pkg.setDescription(rs.getString("Description"));

                // Get images for this package
                pkg.setImages(getPackageImages(packageId));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return pkg;
    }

    // Get all packages with images
    public List<Package> getAllPackages() {
        List<Package> packages = new ArrayList<>();
        String sql = "SELECT * FROM Package ORDER BY PackageId";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Package pkg = new Package();
                pkg.setPackageId(rs.getInt("PackageId"));
                pkg.setPackageName(rs.getString("PackageName"));
                pkg.setPrice(rs.getDouble("Price"));
                pkg.setStartDate(rs.getDate("StartDate"));
                pkg.setEndDate(rs.getDate("EndDate"));
                pkg.setDuration(rs.getString("Duration"));
                pkg.setDestinations(rs.getString("Destinations"));
                pkg.setDescription(rs.getString("Description"));

                // Get images for this package
                pkg.setImages(getPackageImages(pkg.getPackageId()));

                packages.add(pkg);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return packages;
    }

    // Add new package
    public boolean addPackage(Package pkg) {
        String sql = "INSERT INTO Package (PackageName, Price, StartDate, EndDate, Duration, Destinations, Description) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, pkg.getPackageName());
            stmt.setDouble(2, pkg.getPrice());
            stmt.setDate(3, pkg.getStartDate());
            stmt.setDate(4, pkg.getEndDate());
            stmt.setString(5, pkg.getDuration());
            stmt.setString(6, pkg.getDestinations());
            stmt.setString(7, pkg.getDescription());

            int result = stmt.executeUpdate();

            if (result > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    int packageId = rs.getInt(1);

                    // Add images if any
                    if (pkg.getImages() != null && !pkg.getImages().isEmpty()) {
                        for (String imagePath : pkg.getImages()) {
                            addPackageImage(packageId, imagePath);
                        }
                    }
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Update package
    public boolean updatePackage(Package pkg) {
        String sql = "UPDATE Package SET PackageName = ?, Price = ?, StartDate = ?, EndDate = ?, Duration = ?, Destinations = ?, Description = ? WHERE PackageId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, pkg.getPackageName());
            stmt.setDouble(2, pkg.getPrice());
            stmt.setDate(3, pkg.getStartDate());
            stmt.setDate(4, pkg.getEndDate());
            stmt.setString(5, pkg.getDuration());
            stmt.setString(6, pkg.getDestinations());
            stmt.setString(7, pkg.getDescription());
            stmt.setInt(8, pkg.getPackageId());

            int result = stmt.executeUpdate();

            if (result > 0) {
                // Update images if needed
                // First delete existing images
                deletePackageImages(pkg.getPackageId());

                // Add new images
                if (pkg.getImages() != null && !pkg.getImages().isEmpty()) {
                    for (String imagePath : pkg.getImages()) {
                        addPackageImage(pkg.getPackageId(), imagePath);
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Delete package
    public boolean deletePackage(int packageId) {
        // First delete all images for the package
        deletePackageImages(packageId);

        String sql = "DELETE FROM Package WHERE PackageId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, packageId);
            int result = stmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Image-related methods
    public boolean addPackageImage(int packageId, String imagePath) {
        String sql = "INSERT INTO PackageImages (PackageId, ImagePath) VALUES (?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, packageId);
            stmt.setString(2, imagePath);

            int result = stmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<String> getPackageImages(int packageId) {
        List<String> images = new ArrayList<>();
        String sql = "SELECT ImagePath FROM PackageImages WHERE PackageId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, packageId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                images.add(rs.getString("ImagePath"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return images;
    }

    public boolean deletePackageImages(int packageId) {
        String sql = "DELETE FROM PackageImages WHERE PackageId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, packageId);
            int result = stmt.executeUpdate();
            return true; // Even if no images, it's successful
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

}