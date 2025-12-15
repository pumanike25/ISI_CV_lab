<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Verifică autentificare
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Obține datele CV din sesiune
    java.util.Map<String, String> cvData = (java.util.Map<String, String>) session.getAttribute("cvData");
    if (cvData == null) {
        response.sendRedirect("cv-form.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CV Submitted Successfully - Europass System</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <div class="container">
        <div class="success-header">
            <h1>✅ CV Submitted Successfully!</h1>
            <p>Your Europass CV has been created and saved to the database.</p>
        </div>
        
        <div class="cv-preview">
            <h2>CV Preview</h2>
            
            <div class="cv-preview-section">
                <h3>Personal Information</h3>
                <div class="preview-grid">
                    <div class="preview-item">
                        <strong>Name:</strong> 
                        <%= cvData.get("firstName") %> <%= cvData.get("lastName") %>
                    </div>
                    <div class="preview-item">
                        <strong>Email:</strong> 
                        <%= cvData.get("email") %>
                    </div>
                    <div class="preview-item">
                        <strong>Phone:</strong> 
                        <%= cvData.get("phone") != null && !cvData.get("phone").isEmpty() ? cvData.get("phone") : "Not specified" %>
                    </div>
                    <div class="preview-item">
                        <strong>Date of Birth:</strong> 
                        <%= cvData.get("birthDate") %>
                    </div>
                    <div class="preview-item full-width">
                        <strong>Address:</strong> 
                        <%= cvData.get("address") != null && !cvData.get("address").isEmpty() ? cvData.get("address") : "Not specified" %>
                    </div>
                </div>
            </div>
            
            <div class="cv-preview-section">
                <h3>Education and Training</h3>
                <div class="preview-content">
                    <%= cvData.get("education").replace("\n", "<br>") %>
                </div>
            </div>
            
            <div class="cv-preview-section">
                <h3>Work Experience</h3>
                <div class="preview-content">
                    <%= cvData.get("experience").replace("\n", "<br>") %>
                </div>
            </div>
            
            <% if (cvData.get("skills") != null && !cvData.get("skills").isEmpty()) { %>
            <div class="cv-preview-section">
                <h3>Personal Skills</h3>
                <div class="preview-content">
                    <%= cvData.get("skills").replace("\n", "<br>") %>
                </div>
            </div>
            <% } %>
            
            <% if (cvData.get("languages") != null && !cvData.get("languages").isEmpty()) { %>
            <div class="cv-preview-section">
                <h3>Languages</h3>
                <div class="preview-content">
                    <%= cvData.get("languages").replace("\n", "<br>") %>
                </div>
            </div>
            <% } %>
        </div>
        
        <div class="action-buttons">
            <a href="cv-form.jsp" class="btn-primary">Create Another CV</a>
            <a href="cv-list.jsp" class="btn-secondary">View All My CVs</a>
            <a href="user-dashboard.jsp" class="btn-secondary">Back to Dashboard</a>
        </div>
    </div>
    
    <%@ include file="footer.jsp" %>
    
    <style>
        .success-header {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            padding: 30px;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 30px;
        }
        
        .success-header h1 {
            margin: 0 0 10px 0;
            font-size: 2.5em;
        }
        
        .cv-preview {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .cv-preview h2 {
            color: #003366;
            border-bottom: 2px solid #003366;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        
        .cv-preview-section {
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }
        
        .cv-preview-section:last-child {
            border-bottom: none;
        }
        
        .cv-preview-section h3 {
            color: #003366;
            margin-bottom: 15px;
        }
        
        .preview-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
        }
        
        .preview-item {
            padding: 10px;
        }
        
        .preview-item.full-width {
            grid-column: 1 / -1;
        }
        
        .preview-item strong {
            color: #555;
            display: block;
            margin-bottom: 5px;
        }
        
        .preview-content {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            border-left: 4px solid #003366;
            line-height: 1.6;
        }
        
        .action-buttons {
            text-align: center;
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        @media (max-width: 768px) {
            .preview-grid {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .action-buttons a {
                width: 100%;
                max-width: 300px;
                text-align: center;
            }
        }
    </style>
</body>
</html>