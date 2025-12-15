<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Redirect dacă utilizatorul este deja autentificat
    if (session.getAttribute("user") != null) {
        response.sendRedirect("user-dashboard.jsp");
        return;
    }
    
    String error = (String) request.getAttribute("error");
    String username = (String) request.getAttribute("username");
    String email = (String) request.getAttribute("email");
    
    // Verifică dacă există cookie pentru limbă
    String language = "en";
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("language".equals(cookie.getName())) {
                language = cookie.getValue();
                break;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="<%= language %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Europass CV System</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .register-container {
            max-width: 500px;
            margin: 50px auto;
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .register-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .register-header h1 {
            color: #003366;
            margin-bottom: 10px;
        }
        
        .register-header p {
            color: #666;
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
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: #003366;
            outline: none;
            box-shadow: 0 0 0 3px rgba(0, 51, 102, 0.1);
        }
        
        .password-strength {
            margin-top: 5px;
            font-size: 12px;
            color: #666;
        }
        
        .strength-bar {
            height: 4px;
            background: #eee;
            border-radius: 2px;
            margin-top: 5px;
            overflow: hidden;
        }
        
        .strength-fill {
            height: 100%;
            width: 0%;
            background: #dc3545;
            transition: width 0.3s ease, background 0.3s ease;
        }
        
        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #dc3545;
            animation: fadeIn 0.5s ease;
        }
        
        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #28a745;
            animation: fadeIn 0.5s ease;
        }
        
        .login-link {
            text-align: center;
            margin-top: 25px;
            color: #666;
        }
        
        .login-link a {
            color: #003366;
            text-decoration: none;
            font-weight: bold;
        }
        
        .login-link a:hover {
            text-decoration: underline;
        }
        
        .terms {
            font-size: 12px;
            color: #666;
            margin-top: 20px;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .btn-primary {
            width: 100%;
            padding: 14px;
            font-size: 16px;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <h1>Create Account</h1>
            <p>Join Europass CV System and create professional CVs</p>
        </div>
        
        <% if (error != null) { %>
            <div class="error-message">
                <strong>❌ Error:</strong> <%= error %>
            </div>
        <% } %>
        
        <% if ("true".equals(request.getParameter("success"))) { %>
            <div class="success-message">
                <strong>✅ Success!</strong> Registration completed. You can now login.
            </div>
        <% } %>
        
        <form method="post" action="register" id="registerForm">
            <div class="form-group">
                <label for="username" class="required">Username</label>
                <input type="text" id="username" name="username" class="form-control" 
                       value="<%= username != null ? username : "" %>" 
                       required autofocus
                       placeholder="Choose a username">
                <div class="field-hint">3-20 characters, letters and numbers only</div>
            </div>
            
            <div class="form-group">
                <label for="email" class="required">Email Address</label>
                <input type="email" id="email" name="email" class="form-control" 
                       value="<%= email != null ? email : "" %>" 
                       required
                       placeholder="your.email@example.com">
            </div>
            
            <div class="form-group">
                <label for="password" class="required">Password</label>
                <input type="password" id="password" name="password" class="form-control" 
                       required
                       placeholder="At least 6 characters">
                <div class="password-strength">
                    Password strength: <span id="strengthText">None</span>
                </div>
                <div class="strength-bar">
                    <div class="strength-fill" id="strengthBar"></div>
                </div>
            </div>
            
            <div class="form-group">
                <label for="confirmPassword" class="required">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" 
                       required
                       placeholder="Repeat your password">
                <div id="passwordMatch" class="field-hint"></div>
            </div>
            
            <div class="form-group">
                <div class="terms">
                    <input type="checkbox" id="terms" name="terms" required>
                    <label for="terms">
                        I agree to the <a href="#" style="color: #003366;">Terms of Service</a> 
                        and <a href="#" style="color: #003366;">Privacy Policy</a>
                    </label>
                </div>
            </div>
            
            <button type="submit" class="btn-primary" id="submitBtn">Create Account</button>
        </form>
        
        <div class="login-link">
            Already have an account? <a href="login.jsp">Sign in here</a>
        </div>
    </div>
    
    <script>
        // Password strength checker
        const passwordInput = document.getElementById('password');
        const strengthBar = document.getElementById('strengthBar');
        const strengthText = document.getElementById('strengthText');
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const passwordMatch = document.getElementById('passwordMatch');
        const submitBtn = document.getElementById('submitBtn');
        
        passwordInput.addEventListener('input', function() {
            const password = this.value;
            let strength = 0;
            
            // Length check
            if (password.length >= 6) strength++;
            if (password.length >= 8) strength++;
            
            // Character variety checks
            if (/[A-Z]/.test(password)) strength++; // Uppercase
            if (/[0-9]/.test(password)) strength++; // Numbers
            if (/[^A-Za-z0-9]/.test(password)) strength++; // Special chars
            
            // Update strength bar and text
            const width = strength * 20;
            strengthBar.style.width = width + '%';
            
            // Update colors and text
            if (strength <= 1) {
                strengthBar.style.backgroundColor = '#dc3545';
                strengthText.textContent = 'Weak';
                strengthText.style.color = '#dc3545';
            } else if (strength <= 3) {
                strengthBar.style.backgroundColor = '#ffc107';
                strengthText.textContent = 'Medium';
                strengthText.style.color = '#ffc107';
            } else {
                strengthBar.style.backgroundColor = '#28a745';
                strengthText.textContent = 'Strong';
                strengthText.style.color = '#28a745';
            }
            
            checkPasswordMatch();
        });
        
        // Password match checker
        confirmPasswordInput.addEventListener('input', checkPasswordMatch);
        
        function checkPasswordMatch() {
            const password = passwordInput.value;
            const confirmPassword = confirmPasswordInput.value;
            
            if (confirmPassword === '') {
                passwordMatch.textContent = '';
                passwordMatch.style.color = '';
                submitBtn.disabled = false;
                return;
            }
            
            if (password === confirmPassword) {
                passwordMatch.textContent = '✓ Passwords match';
                passwordMatch.style.color = '#28a745';
                submitBtn.disabled = false;
            } else {
                passwordMatch.textContent = '✗ Passwords do not match';
                passwordMatch.style.color = '#dc3545';
                submitBtn.disabled = true;
            }
        }
        
        // Username availability check (simplified)
        document.getElementById('username').addEventListener('blur', function() {
            const username = this.value;
            if (username.length >= 3) {
                // Într-o aplicație reală, aici ai face un AJAX call către server
                console.log('Checking username availability:', username);
            }
        });
        
        // Form validation before submit
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const password = passwordInput.value;
            const confirmPassword = confirmPasswordInput.value;
            const terms = document.getElementById('terms').checked;
            
            if (!terms) {
                e.preventDefault();
                alert('Please accept the Terms of Service and Privacy Policy');
                return false;
            }
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match!');
                return false;
            }
            
            if (password.length < 6) {
                e.preventDefault();
                alert('Password must be at least 6 characters long!');
                return false;
            }
            
            return true;
        });
        
        // Animație la încărcare
        document.addEventListener('DOMContentLoaded', function() {
            const container = document.querySelector('.register-container');
            container.style.opacity = '0';
            container.style.transform = 'translateY(20px)';
            
            setTimeout(() => {
                container.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                container.style.opacity = '1';
                container.style.transform = 'translateY(0)';
            }, 100);
        });
    </script>
</body>
</html>