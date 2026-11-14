package com.travel.controller.managers;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Enumeration;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import com.travel.model.PackageManager;
import com.travel.model.Package;
import com.travel.service.PackageService;

public class PackageManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PackageService packageService;
    private static final String UPLOAD_DIR = "images" + File.separator + "packages";

    public void init() {
        packageService = new PackageService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null ||
                !"packageManager".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/tour-login");
            return;
        }

        // Get package manager from session
        PackageManager manager = (PackageManager) session.getAttribute("user");
        request.setAttribute("manager", manager);

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "add":
                request.getRequestDispatcher("/views/package-manager/packages/add.jsp").forward(request, response);
                break;
            case "list":
                // Get all packages
                List<Package> packages = packageService.getAllPackages();
                request.setAttribute("packages", packages);

                // Forward to list packages page
                request.getRequestDispatcher("/views/package-manager/packages/list.jsp").forward(request, response);
                break;
            case "edit":
                // Get package ID
                String packageId = request.getParameter("id");

                // Get package details
                Package pkg = packageService.getPackageById(Integer.parseInt(packageId));
                request.setAttribute("package", pkg);

                // Forward to edit package page
                request.getRequestDispatcher("/views/package-manager/packages/edit.jsp").forward(request, response);
                break;
            case "remove":
                // Get package ID
                String removeId = request.getParameter("id");

                // Get package details
                Package removePkg = packageService.getPackageById(Integer.parseInt(removeId));
                request.setAttribute("package", removePkg);

                // Forward to remove package page
                request.getRequestDispatcher("/views/package-manager/packages/remove.jsp").forward(request, response);
                break;
            case "viewImages":
                // Get package ID
                String viewId = request.getParameter("id");

                // Get package details
                Package viewPkg = packageService.getPackageById(Integer.parseInt(viewId));
                request.setAttribute("package", viewPkg);

                // Forward to view images page
                request.getRequestDispatcher("/views/package-manager/packages/view-images.jsp").forward(request, response);
                break;
            default:
                // Forward to list packages page by default
                List<Package> defaultPackages = packageService.getAllPackages();
                request.setAttribute("packages", defaultPackages);
                request.getRequestDispatcher("/views/package-manager/packages/list.jsp").forward(request, response);
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Check if user is logged in as package manager
        if (session == null || session.getAttribute("user") == null ||
                !"packageManager".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/tour-login");
            return;
        }

        // Extract parameters and file parts
        Map<String, String> parameters = new HashMap<>();
        List<Part> fileParts = new ArrayList<>();

        // Check if the request is multipart
        if (request.getContentType() != null && request.getContentType().toLowerCase().contains("multipart/form-data")) {
            for (Part part : request.getParts()) {
                String name = part.getName();
                if (part.getSubmittedFileName() == null) {
                    // Form field
                    try (InputStream is = part.getInputStream()) {
                        String value = new String(is.readAllBytes(), StandardCharsets.UTF_8);
                        parameters.put(name, value);
                    }
                } else {
                    // File part - only interested in packageImages
                    if ("packageImages".equals(name)) {
                        fileParts.add(part);
                    }
                }
            }
        } else {
            Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String name = paramNames.nextElement();
                parameters.put(name, request.getParameter(name));
            }
        }

        String action = parameters.get("action");

        // Handle different actions
        switch (action) {
            case "add":
                // Get form parameters
                String packageName = parameters.get("packageName");
                double price = Double.parseDouble(parameters.get("price"));
                String startDate = parameters.get("startDate");
                String endDate = parameters.get("endDate");
                String duration = parameters.get("duration");
                String destinations = parameters.get("destinations");
                String description = parameters.get("description");

                // Create package object
                Package pkg = new Package();
                pkg.setPackageName(packageName);
                pkg.setPrice(price);
                pkg.setStartDate(java.sql.Date.valueOf(startDate));
                pkg.setEndDate(java.sql.Date.valueOf(endDate));
                pkg.setDuration(duration);
                pkg.setDestinations(destinations);
                pkg.setDescription(description);

                // Handle file uploads
                List<String> imagePaths = handleFileUpload(fileParts);
                pkg.setImages(imagePaths);

                // Add package
                boolean success = packageService.addPackage(pkg);

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/tour-package-manager-packages?action=list&success=1");
                } else {
                    response.sendRedirect(request.getContextPath() + "/tour-package-manager-packages?action=add&error=1");
                }
                break;

            case "update":
                // Get form parameters
                int updateId = Integer.parseInt(parameters.get("packageId"));
                String updatePackageName = parameters.get("packageName");
                double updatePrice = Double.parseDouble(parameters.get("price"));
                String updateStartDate = parameters.get("startDate");
                String updateEndDate = parameters.get("endDate");
                String updateDuration = parameters.get("duration");
                String updateDestinations = parameters.get("destinations");
                String updateDescription = parameters.get("description");

                // Create package object
                Package updatePkg = new Package();
                updatePkg.setPackageId(updateId);
                updatePkg.setPackageName(updatePackageName);
                updatePkg.setPrice(updatePrice);
                updatePkg.setStartDate(java.sql.Date.valueOf(updateStartDate));
                updatePkg.setEndDate(java.sql.Date.valueOf(updateEndDate));
                updatePkg.setDuration(updateDuration);
                updatePkg.setDestinations(updateDestinations);
                updatePkg.setDescription(updateDescription);

                // Handle file uploads
                List<String> updateImagePaths = handleFileUpload(fileParts);
                updatePkg.setImages(updateImagePaths);

                // Update package
                boolean updateSuccess = packageService.updatePackage(updatePkg);

                if (updateSuccess) {
                    response.sendRedirect(request.getContextPath() + "/tour-package-manager-packages?action=list&success=2");
                } else {
                    response.sendRedirect(request.getContextPath() + "/tour-package-manager-packages?action=edit&id=" + updateId + "&error=1");
                }
                break;

            case "delete":
                // Get package ID
                int deleteId = Integer.parseInt(parameters.get("packageId"));

                // Delete package
                boolean deleteSuccess = packageService.deletePackage(deleteId);

                if (deleteSuccess) {
                    response.sendRedirect(request.getContextPath() + "/tour-package-manager-packages?action=list&success=3");
                } else {
                    response.sendRedirect(request.getContextPath() + "/tour-package-manager-packages?action=list&error=2");
                }
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/tour-package-manager-packages");
                break;
        }
    }

    private List<String> handleFileUpload(List<Part> fileParts) throws IOException {
        List<String> imagePaths = new ArrayList<>();

        // Get the upload path
        String applicationPath = getServletContext().getRealPath("");
        String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;

        // Create the upload directory if it doesn't exist
        File uploadDir = new File(uploadFilePath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        for (Part part : fileParts) {
            if (part != null && part.getSize() > 0) {
                // Generate a unique file name to prevent overwriting
                String fileName = UUID.randomUUID().toString() + "_" + part.getSubmittedFileName();
                String filePath = uploadFilePath + File.separator + fileName;

                // Save the file
                part.write(filePath);

                // Add the file path to the list (relative path for database storage)
                imagePaths.add(UPLOAD_DIR + File.separator + fileName);
            }
        }

        return imagePaths;
    }
}