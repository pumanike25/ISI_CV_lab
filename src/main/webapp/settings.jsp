<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Settings - Europass CV System</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f5f5f5; margin: 0; padding: 20px; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .success { background: #dff0d8; color: #3c763d; padding: 10px; border-radius: 4px; margin-bottom: 15px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        select { padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
        .btn { background: #003366; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; margin-right: 10px; }
        .nav { margin-bottom: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="nav">
            <a href="user-dashboard.jsp" class="btn">Dashboard</a>
            <a href="cv" class="btn">Create CV</a>
            <a href="logout" class="btn" style="background: #dc3545;">Logout</a>
        </div>
        
        <h2>Settings</h2>
        
        <% if (request.getAttribute("success") != null) { %>
            <div class="success">${success}</div>
        <% } %>
        
        <form method="post" action="settings">
            <div class="form-group">
                <label for="language">Select Language:</label>
                <select id="language" name="language">
                    <option value="en" ${currentLanguage == 'en' ? 'selected' : ''}>English</option>
                    <option value="ro" ${currentLanguage == 'ro' ? 'selected' : ''}>Romanian</option>
                    <option value="fr" ${currentLanguage == 'fr' ? 'selected' : ''}>French</option>
                    <option value="de" ${currentLanguage == 'de' ? 'selected' : ''}>German</option>
                </select>
            </div>
            
            <button type="submit" class="btn">Save Settings</button>
        </form>
        
        <div style="margin-top: 20px; padding: 15px; background: #f8f9fa; border-radius: 4px;">
            <strong>Current language:</strong> 
            <span id="currentLang">
                ${currentLanguage == 'en' ? 'English' : 
                  currentLanguage == 'ro' ? 'Romanian' : 
                  currentLanguage == 'fr' ? 'French' : 
                  currentLanguage == 'de' ? 'German' : currentLanguage}
            </span>
        </div>
    </div>
</body>
</html>