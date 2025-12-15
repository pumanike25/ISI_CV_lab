<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Europass CV Form</title>
    <style>
        /* Stiluri Europass */
        body { 
            font-family: 'Arial', sans-serif; 
            margin: 0; 
            padding: 0; 
            background-color: #f5f5f5; 
            color: #333;
        }
        
        .europass-container {
            max-width: 800px;
            margin: 20px auto;
            background: white;
            padding: 30px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        
        .europass-header {
            background: #003366;
            color: white;
            padding: 20px;
            text-align: center;
            margin-bottom: 30px;
        }
        
        .europass-header h1 {
            margin: 0;
            font-size: 24px;
        }
        
        .form-section {
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .section-title {
            color: #003366;
            font-size: 18px;
            margin-bottom: 15px;
            font-weight: bold;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        
        input[type="text"],
        input[type="email"],
        input[type="tel"],
        input[type="date"],
        textarea,
        select {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }
        
        textarea {
            height: 80px;
            resize: vertical;
        }
        
        .required::after {
            content: " *";
            color: red;
        }
        
        .error {
            color: #d9534f;
            font-size: 12px;
            margin-top: 5px;
        }
        
        .success {
            background: #dff0d8;
            color: #3c763d;
            padding: 12px;
            border-radius: 4px;
            margin-bottom: 20px;
            border-left: 4px solid #3c763d;
        }
        
        .submit-btn {
            background: #003366;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 20px;
        }
        
        .submit-btn:hover {
            background: #002244;
        }
        
        .field-hint {
            font-size: 11px;
            color: #666;
            margin-top: 3px;
        }
    </style>
</head>
<body>
    <div class="europass-container">
        <div class="europass-header">
            <h1>Europass Curriculum Vitae</h1>
        </div>
        
        <% if (request.getAttribute("success") != null) { %>
            <div class="success">
                <strong>Success!</strong> ${success}
            </div>
        <% } %>
        
        <form method="post" action="cv">
            <!-- Personal Information Section -->
            <div class="form-section">
                <div class="section-title">Personal Information</div>
                
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                    <div class="form-group">
                        <label for="firstName" class="required">First Name</label>
                        <input type="text" id="firstName" name="firstName" 
                               value="${formData != null ? formData.firstName : ''}">
                        <% 
                            Map<String, String> errors = (Map<String, String>) request.getAttribute("errors");
                            if (errors != null && errors.containsKey("firstName")) { 
                        %>
                            <div class="error">${errors.firstName}</div>
                        <% } %>
                    </div>
                    
                    <div class="form-group">
                        <label for="lastName" class="required">Last Name</label>
                        <input type="text" id="lastName" name="lastName"
                               value="${formData != null ? formData.lastName : ''}">
                        <% if (errors != null && errors.containsKey("lastName")) { %>
                            <div class="error">${errors.lastName}</div>
                        <% } %>
                    </div>
                </div>
                
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                    <div class="form-group">
                        <label for="email" class="required">Email Address</label>
                        <input type="email" id="email" name="email"
                               value="${formData != null ? formData.email : ''}">
                        <% if (errors != null && errors.containsKey("email")) { %>
                            <div class="error">${errors.email}</div>
                        <% } %>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="tel" id="phone" name="phone"
                               value="${formData != null ? formData.phone : ''}">
                        <% if (errors != null && errors.containsKey("phone")) { %>
                            <div class="error">${errors.phone}</div>
                        <% } %>
                        <div class="field-hint">Format: +40 123 456 789</div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="birthDate" class="required">Date of Birth</label>
                    <input type="date" id="birthDate" name="birthDate"
                           value="${formData != null ? formData.birthDate : ''}">
                    <% if (errors != null && errors.containsKey("birthDate")) { %>
                        <div class="error">${errors.birthDate}</div>
                    <% } %>
                </div>
                
                <div class="form-group">
                    <label for="address">Address</label>
                    <textarea id="address" name="address">${formData != null ? formData.address : ''}</textarea>
                </div>
            </div>
            
            <!-- Education Section -->
            <div class="form-section">
                <div class="section-title">Education and Training</div>
                <div class="form-group">
                    <label for="education" class="required">Education Details</label>
                    <textarea id="education" name="education" placeholder="Include: Institution name, Degree, Dates, etc.">${formData != null ? formData.education : ''}</textarea>
                    <% if (errors != null && errors.containsKey("education")) { %>
                        <div class="error">${errors.education}</div>
                    <% } %>
                    <div class="field-hint">List your educational background in chronological order</div>
                </div>
            </div>
            
            <!-- Work Experience Section -->
            <div class="form-section">
                <div class="section-title">Work Experience</div>
                <div class="form-group">
                    <label for="experience" class="required">Professional Experience</label>
                    <textarea id="experience" name="experience" placeholder="Include: Company name, Position, Responsibilities, Dates">${formData != null ? formData.experience : ''}</textarea>
                    <% if (errors != null && errors.containsKey("experience")) { %>
                        <div class="error">${errors.experience}</div>
                    <% } %>
                    <div class="field-hint">List your work experience starting with the most recent</div>
                </div>
            </div>
            
            <!-- Skills Section -->
            <div class="form-section">
                <div class="section-title">Personal Skills and Competences</div>
                
                <div class="form-group">
                    <label for="skills">Technical Skills</label>
                    <textarea id="skills" name="skills" placeholder="Computer skills, technical competencies, etc.">${formData != null ? formData.skills : ''}</textarea>
                </div>
                
                <div class="form-group">
                    <label for="languages">Languages</label>
                    <textarea id="languages" name="languages" placeholder="Language, Level (e.g., English - Proficient)">${formData != null ? formData.languages : ''}</textarea>
                    <div class="field-hint">Specify language and proficiency level</div>
                </div>
            </div>
            
            <button type="submit" class="submit-btn">Submit Europass CV</button>
        </form>
    </div>
</body>
</html>