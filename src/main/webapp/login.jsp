<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="${language}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Europass CV System</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f5f5f5; margin: 0; padding: 0; }
        .login-container { max-width: 400px; margin: 100px auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input[type="text"], input[type="password"] { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
        .btn { background: #003366; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; }
        .error { color: red; margin-bottom: 15px; }
        .language-info { background: #e7f3ff; padding: 10px; border-radius: 4px; margin-bottom: 15px; }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Login to Europass CV System</h2>
        
        <div class="language-info">
            <strong>Current language:</strong> 
            ${language == 'en' ? 'English' : language == 'ro' ? 'Romanian' : language}
            <br><small>Change language in Settings after login</small>
        </div>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="error">${error}</div>
        <% } %>
        
        <form method="post" action="login">
            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" required>
            </div>
            
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
            </div>
            
            <button type="submit" class="btn">Login</button>
        </form>
        
		<div class="register-link" style="text-align: center; margin-top: 25px; padding-top: 20px; border-top: 1px solid #eee;">
		    <p style="color: #666; margin-bottom: 10px;">Don't have an account?</p>
		    <a href="register.jsp" class="btn-secondary" style="display: inline-block; padding: 10px 25px;">
		        📝 Create New Account
		    </a>
		</div>
		
		<!-- SAU o variantă mai simplă: -->
		<div style="text-align: center; margin-top: 20px;">
		    <p style="color: #666;">New user? 
		        <a href="register.jsp" style="color: #003366; text-decoration: none; font-weight: bold;">
		            Sign up here
		        </a>
		    </p>
		</div>
		        
        <div style="margin-top: 20px; font-size: 12px; color: #666;">
            <strong>Demo accounts:</strong><br>
            Admin: admin / admin123<br>
            User: user / user123
        </div>
    </div>
</body>
</html>