<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Folosește un nume diferit pentru variabilă
    ro.isi.lab2.User currentUser = (ro.isi.lab2.User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Europass CV System</title>
    <style>
        .main-header {
            background: #003366;
            color: white;
            padding: 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .navbar {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
        }
        
        .nav-brand h2 {
            margin: 0;
            padding: 15px 0;
            font-size: 1.5em;
        }
        
        .nav-links {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .nav-link {
            color: white;
            text-decoration: none;
            padding: 8px 15px;
            border-radius: 5px;
            transition: background-color 0.3s;
            font-weight: 500;
        }
        
        .nav-link:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }
        
        .nav-link.logout {
            background-color: #dc3545;
        }
        
        .nav-link.logout:hover {
            background-color: #c82333;
        }
        
        .user-info {
            margin-right: 10px;
            font-weight: bold;
            color: #e9ecef;
        }
        
        @media (max-width: 768px) {
            .navbar {
                flex-direction: column;
                padding: 10px;
            }
            
            .nav-links {
                margin-top: 10px;
                flex-wrap: wrap;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <header class="main-header">
        <nav class="navbar">
            <div class="nav-brand">
                <h2>📊 Europass CV System</h2>
            </div>
            <div class="nav-links">
                <% if (currentUser != null) { %>
                    <span class="user-info">Welcome, <%= currentUser.getUsername() %> (<%= currentUser.getRole() %>)</span>
                    <a href="<%= "admin".equals(currentUser.getRole()) ? "admin-dashboard.jsp" : "user-dashboard.jsp" %>" 
                       class="nav-link">🏠 Dashboard</a>
                    <a href="cv-form.jsp" class="nav-link">➕ Create CV</a>
                    <a href="cv-list.jsp" class="nav-link">📋 My CVs</a>
                    <a href="xml-export.jsp" class="nav-link">📄 XML Tools</a> 
                    <a href="settings.jsp" class="nav-link">⚙️ Settings</a>
                    <a href="logout.jsp" class="nav-link logout">🚪 Logout</a>
                <% } else { %>
                    <a href="login.jsp" class="nav-link">🔐 Login</a>
                <% } %>
            </div>
        </nav>
    </header>