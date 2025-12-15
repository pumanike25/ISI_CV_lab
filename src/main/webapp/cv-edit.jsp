<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%
    // Verifică autentificare
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Map<String, String> cv = (Map<String, String>) request.getAttribute("cv");
    Map<String, String> errors = (Map<String, String>) request.getAttribute("errors");
    String action = (String) request.getAttribute("action");
    
    if (cv == null) {
        response.sendRedirect("cv-list.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit CV - Europass System</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .edit-container {
            max-width: 800px;
            margin: 0 auto;
        }
        
        .edit-header {
            background: linear-gradient(135deg, #003366, #0056b3);
            color: white;
            padding: 25px;
            border-radius: 10px;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .edit-header h1 {
            margin: 0;
            font-size: 2em;
        }
        
        .edit-subtitle {
            opacity: 0.9;
            margin-top: 5px;
        }
        
        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        
        .btn-update {
            background: #28a745;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-update:hover {
            background: #218838;
        }
        
        .btn-cancel {
            background: #6c757d;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-cancel:hover {
            background: #545b62;
        }
        
        .delete-section {
            margin-top: 30px;
            padding: 20px;
            background: #f8d7da;
            border-radius: 8px;
            border-left: 4px solid #dc3545;
        }
        
        .btn-delete {
            background: #dc3545;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-delete:hover {
            background: #c82333;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <div class="container edit-container">
        <div class="edit-header">
            <h1>✏️ Edit CV</h1>
            <p class="edit-subtitle">Update your Europass CV information</p>
        </div>
        
        <form method="post" action="cv-management">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="cvId" value="<%= cv.get("id") %>">
            
            <!-- Personal Information -->
            <div class="form-section">
                <h3>Personal Information</h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="firstName" class="required">First Name</label>
                        <input type="text" id="firstName" name="firstName" 
                               value="<%= cv.get("firstName") != null ? cv.get("firstName") : "" %>"
                               class="form-control" required>
                        <% if (errors != null && errors.containsKey("firstName")) { %>
                            <div class="error"><%= errors.get("firstName") %></div>
                        <% } %>
                    </div>
                    
                    <div class="form-group">
                        <label for="lastName" class="required">Last Name</label>
                        <input type="text" id="lastName" name="lastName"
                               value="<%= cv.get("lastName") != null ? cv.get("lastName") : "" %>"
                               class="form-control" required>
                        <% if (errors != null && errors.containsKey("lastName")) { %>
                            <div class="error"><%= errors.get("lastName") %></div>
                        <% } %>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="email" class="required">Email Address</label>
                        <input type="email" id="email" name="email"
                               value="<%= cv.get("email") != null ? cv.get("email") : "" %>"
                               class="form-control" required>
                        <% if (errors != null && errors.containsKey("email")) { %>
                            <div class="error"><%= errors.get("email") %></div>
                        <% } %>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="tel" id="phone" name="phone"
                               value="<%= cv.get("phone") != null ? cv.get("phone") : "" %>"
                               class="form-control">
                        <% if (errors != null && errors.containsKey("phone")) { %>
                            <div class="error"><%= errors.get("phone") %></div>
                        <% } %>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="birthDate" class="required">Date of Birth</label>
                    <input type="date" id="birthDate" name="birthDate"
                           value="<%= cv.get("birthDate") != null ? cv.get("birthDate") : "" %>"
                           class="form-control" required>
                    <% if (errors != null && errors.containsKey("birthDate")) { %>
                        <div class="error"><%= errors.get("birthDate") %></div>
                    <% } %>
                </div>
                
                <div class="form-group">
                    <label for="address">Address</label>
                    <textarea id="address" name="address" class="form-control" 
                              rows="3"><%= cv.get("address") != null ? cv.get("address") : "" %></textarea>
                </div>
            </div>
            
            <!-- Education Section -->
            <div class="form-section">
                <h3>Education and Training</h3>
                <div class="form-group">
                    <label for="education" class="required">Education Details</label>
                    <textarea id="education" name="education" class="form-control" 
                              rows="4" required><%= cv.get("education") != null ? cv.get("education") : "" %></textarea>
                    <% if (errors != null && errors.containsKey("education")) { %>
                        <div class="error"><%= errors.get("education") %></div>
                    <% } %>
                </div>
            </div>
            
            <!-- Work Experience Section -->
            <div class="form-section">
                <h3>Work Experience</h3>
                <div class="form-group">
                    <label for="experience" class="required">Professional Experience</label>
                    <textarea id="experience" name="experience" class="form-control" 
                              rows="4" required><%= cv.get("experience") != null ? cv.get("experience") : "" %></textarea>
                    <% if (errors != null && errors.containsKey("experience")) { %>
                        <div class="error"><%= errors.get("experience") %></div>
                    <% } %>
                </div>
            </div>
            
            <!-- Skills Section -->
            <div class="form-section">
                <h3>Personal Skills and Competences</h3>
                
                <div class="form-group">
                    <label for="skills">Technical Skills</label>
                    <textarea id="skills" name="skills" class="form-control" 
                              rows="3"><%= cv.get("skills") != null ? cv.get("skills") : "" %></textarea>
                </div>
                
                <div class="form-group">
                    <label for="languages">Languages</label>
                    <textarea id="languages" name="languages" class="form-control" 
                              rows="2"><%= cv.get("languages") != null ? cv.get("languages") : "" %></textarea>
                </div>
            </div>
            
            <div class="form-actions">
                <button type="submit" class="btn-update">
                    💾 Update CV
                </button>
                <a href="cv-list.jsp" class="btn-cancel">
                    ↩️ Cancel
                </a>
            </div>
        </form>
        
        <div class="delete-section">
            <h3 style="color: #721c24;">⚠️ Danger Zone</h3>
            <p>Once you delete a CV, there is no going back. Please be certain.</p>
            <a href="cv-management?action=delete&id=<%= cv.get("id") %>" 
               class="btn-delete"
               onclick="return confirm('Are you sure you want to delete this CV? This action cannot be undone.')">
                🗑️ Delete This CV
            </a>
        </div>
    </div>
    
    <%@ include file="footer.jsp" %>
</body>
</html>