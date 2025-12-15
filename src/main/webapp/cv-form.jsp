<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="ro.isi.lab2.CVValidator, java.util.Map, java.util.HashMap" %>
<%
    // Verifică autentificare
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    ro.isi.lab2.User user = (ro.isi.lab2.User) session.getAttribute("user");
    Map<String, String> formData = new HashMap<>();
    Map<String, String> errors = new HashMap<>();
    String success = null;
    
    // Procesare formular
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // Preluare date
        formData.put("firstName", request.getParameter("firstName"));
        formData.put("lastName", request.getParameter("lastName"));
        formData.put("email", request.getParameter("email"));
        formData.put("phone", request.getParameter("phone"));
        formData.put("birthDate", request.getParameter("birthDate"));
        formData.put("address", request.getParameter("address"));
        formData.put("education", request.getParameter("education"));
        formData.put("experience", request.getParameter("experience"));
        formData.put("skills", request.getParameter("skills"));
        formData.put("languages", request.getParameter("languages"));
        
        // Validare
        CVValidator validator = new CVValidator();
        errors = validator.validateCV(formData);
        
        if (errors.isEmpty()) {
            // Salvare în baza de date
            ro.isi.lab2.UserDAO userDAO = new ro.isi.lab2.UserDAO();
            boolean saved = userDAO.saveCVData(user.getId(), formData);
            
            if (saved) {
                session.setAttribute("cvData", formData);
                response.sendRedirect("cv-result.jsp");
                return;
            } else {
                errors.put("database", "Error saving CV to database");
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Europass CV</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <div class="container">
        <h1>Europass Curriculum Vitae</h1>
        
        <% if (errors.containsKey("database")) { %>
            <div class="error-message"><%= errors.get("database") %></div>
        <% } %>
        
        <form method="post" action="cv-form.jsp">
            <!-- Personal Information -->
            <div class="form-section">
                <h3>Personal Information</h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="firstName" class="required">First Name</label>
                        <input type="text" id="firstName" name="firstName" 
                               value="<%= formData.get("firstName") != null ? formData.get("firstName") : "" %>"
                               class="form-control">
                        <% if (errors.containsKey("firstName")) { %>
                            <div class="error"><%= errors.get("firstName") %></div>
                        <% } %>
                    </div>
                    
                    <div class="form-group">
                        <label for="lastName" class="required">Last Name</label>
                        <input type="text" id="lastName" name="lastName"
                               value="<%= formData.get("lastName") != null ? formData.get("lastName") : "" %>"
                               class="form-control">
                        <% if (errors.containsKey("lastName")) { %>
                            <div class="error"><%= errors.get("lastName") %></div>
                        <% } %>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="email" class="required">Email Address</label>
                        <input type="email" id="email" name="email"
                               value="<%= formData.get("email") != null ? formData.get("email") : "" %>"
                               class="form-control">
                        <% if (errors.containsKey("email")) { %>
                            <div class="error"><%= errors.get("email") %></div>
                        <% } %>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="tel" id="phone" name="phone"
                               value="<%= formData.get("phone") != null ? formData.get("phone") : "" %>"
                               class="form-control">
                        <% if (errors.containsKey("phone")) { %>
                            <div class="error"><%= errors.get("phone") %></div>
                        <% } %>
                        <div class="field-hint">Format: +40 123 456 789</div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="birthDate" class="required">Date of Birth</label>
                    <input type="date" id="birthDate" name="birthDate"
                           value="<%= formData.get("birthDate") != null ? formData.get("birthDate") : "" %>"
                           class="form-control">
                    <% if (errors.containsKey("birthDate")) { %>
                        <div class="error"><%= errors.get("birthDate") %></div>
                    <% } %>
                </div>
                
                <div class="form-group">
                    <label for="address">Address</label>
                    <textarea id="address" name="address" class="form-control"><%= formData.get("address") != null ? formData.get("address") : "" %></textarea>
                </div>
            </div>
            
            <!-- Education Section -->
            <div class="form-section">
                <h3>Education and Training</h3>
                <div class="form-group">
                    <label for="education" class="required">Education Details</label>
                    <textarea id="education" name="education" class="form-control" 
                              placeholder="Include: Institution name, Degree, Dates, etc."><%= formData.get("education") != null ? formData.get("education") : "" %></textarea>
                    <% if (errors.containsKey("education")) { %>
                        <div class="error"><%= errors.get("education") %></div>
                    <% } %>
                    <div class="field-hint">List your educational background in chronological order</div>
                </div>
            </div>
            
            <!-- Work Experience Section -->
            <div class="form-section">
                <h3>Work Experience</h3>
                <div class="form-group">
                    <label for="experience" class="required">Professional Experience</label>
                    <textarea id="experience" name="experience" class="form-control" 
                              placeholder="Include: Company name, Position, Responsibilities, Dates"><%= formData.get("experience") != null ? formData.get("experience") : "" %></textarea>
                    <% if (errors.containsKey("experience")) { %>
                        <div class="error"><%= errors.get("experience") %></div>
                    <% } %>
                    <div class="field-hint">List your work experience starting with the most recent</div>
                </div>
            </div>
            
            <!-- Skills Section -->
            <div class="form-section">
                <h3>Personal Skills and Competences</h3>
                
                <div class="form-group">
                    <label for="skills">Technical Skills</label>
                    <textarea id="skills" name="skills" class="form-control" 
                              placeholder="Computer skills, technical competencies, etc."><%= formData.get("skills") != null ? formData.get("skills") : "" %></textarea>
                </div>
                
                <div class="form-group">
                    <label for="languages">Languages</label>
                    <textarea id="languages" name="languages" class="form-control" 
                              placeholder="Language, Level (e.g., English - Proficient)"><%= formData.get("languages") != null ? formData.get("languages") : "" %></textarea>
                    <div class="field-hint">Specify language and proficiency level</div>
                </div>
            </div>
            
            <button type="submit" class="btn-primary">Submit Europass CV</button>
            <a href="user-dashboard.jsp" class="btn-secondary" style="margin-left: 10px;">Cancel</a>
        </form>
    </div>
    
    <%@ include file="footer.jsp" %>
    
    <style>
        .form-section {
            background: white;
            padding: 25px;
            margin-bottom: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .form-section h3 {
            color: #003366;
            border-bottom: 2px solid #003366;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }
        
        label.required::after {
            content: " *";
            color: red;
        }
        
        .form-control {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        .form-control:focus {
            border-color: #003366;
            outline: none;
            box-shadow: 0 0 5px rgba(0, 51, 102, 0.2);
        }
        
        textarea.form-control {
            height: 120px;
            resize: vertical;
        }
        
        .field-hint {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
            font-style: italic;
        }
        
        .error {
            color: #dc3545;
            font-size: 12px;
            margin-top: 5px;
        }
        
        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 12px;
            border-radius: 4px;
            margin-bottom: 20px;
            border-left: 4px solid #dc3545;
        }
        
        .btn-primary {
            background: #003366;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-primary:hover {
            background: #002244;
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-secondary:hover {
            background: #545b62;
        }
        
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }
    </style>
</body>
</html>