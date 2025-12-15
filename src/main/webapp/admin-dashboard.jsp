<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="ro.isi.lab2.UserDAO, java.util.List, java.util.Map" %>
<%
    // Verifică autentificare
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    ro.isi.lab2.User user = (ro.isi.lab2.User) session.getAttribute("user");
    UserDAO userDAO = new UserDAO();
    List<Map<String, String>> userCVs = userDAO.getUserCVs(user.getId());
    int cvCount = userCVs.size();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Dashboard - Europass CV System</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <div class="container">
        <div class="welcome-section">
            <h1>Welcome, <%= user.getUsername() %>!</h1>
            <p>Role: <span class="role-badge"><%= user.getRole() %></span></p>
            <p>Email: <%= user.getEmail() %></p>
        </div>

        <!-- CV Statistics -->
        <div class="stats-container">
            <div class="stat-card">
                <div class="stat-icon">📊</div>
                <div class="stat-number"><%= cvCount %></div>
                <div class="stat-label">Total CVs</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">⏰</div>
                <div class="stat-number">
                    <% if (cvCount > 0) { %>
                        <%= userCVs.get(0).get("createdAt").substring(0, 10) %>
                    <% } else { %>
                        N/A
                    <% } %>
                </div>
                <div class="stat-label">Last Created</div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="quick-actions">
            <h2>Quick Actions</h2>
            <div class="action-grid">
                <a href="cv-form.jsp" class="action-card">
                    <div class="action-icon">➕</div>
                    <h3>Create New CV</h3>
                    <p>Create a new Europass CV</p>
                </a>
                
                <a href="cv-list.jsp" class="action-card">
                    <div class="action-icon">📋</div>
                    <h3>View My CVs</h3>
                    <p>Browse all your created CVs</p>
                </a>
                
                <a href="cv-list.jsp?style=cards" class="action-card">
                    <div class="action-icon">🎴</div>
                    <h3>Cards View</h3>
                    <p>View CVs in card layout</p>
                </a>
                
                <a href="cv-list.jsp?style=table" class="action-card">
                    <div class="action-icon">📊</div>
                    <h3>Table View</h3>
                    <p>View CVs in table format</p>
                </a>
                
                <a href="cv-list.jsp?style=modern" class="action-card">
                    <div class="action-icon">🎨</div>
                    <h3>Modern View</h3>
                    <p>View CVs with modern design</p>
                </a>
                
                <a href="cv-list.jsp?style=classic" class="action-card">
                    <div class="action-icon">📄</div>
                    <h3>Classic View</h3>
                    <p>View CVs in classic style</p>
                </a>
            </div>
        </div>

        <!-- Recent CVs Preview -->
        <% if (cvCount > 0) { %>
        <div class="recent-cvs">
            <h2>Recent CVs</h2>
            <div class="cv-preview-grid">
                <% 
                int displayCount = Math.min(cvCount, 3);
                for (int i = 0; i < displayCount; i++) { 
                    Map<String, String> cv = userCVs.get(i);
                %>
                <div class="cv-preview-card">
                    <h4><%= cv.get("firstName") %> <%= cv.get("lastName") %></h4>
                    <p class="cv-preview-email">📧 <%= cv.get("email") %></p>
                    <p class="cv-preview-education">
                        <%= cv.get("education").length() > 60 ? 
                            cv.get("education").substring(0, 60) + "..." : cv.get("education") %>
                    </p>
                    <div class="cv-preview-footer">
                        <span class="cv-date"><%= cv.get("createdAt").substring(0, 10) %></span>
                        <a href="cv-list.jsp" class="view-details">View Details →</a>
                    </div>
                </div>
                <% } %>
            </div>
            <% if (cvCount > 3) { %>
            <div class="view-all-container">
                <a href="cv-list.jsp" class="btn-secondary">View All <%= cvCount %> CVs</a>
            </div>
            <% } %>
        </div>
        <% } else { %>
        <div class="no-cvs-dashboard">
            <div class="empty-state">
                <h3>📝 No CVs Yet</h3>
                <p>You haven't created any CVs. Start by creating your first Europass CV!</p>
                <a href="cv-form.jsp" class="btn-primary">Create Your First CV</a>
            </div>
        </div>
        <% } %>
    </div>
    
    <%@ include file="footer.jsp" %>
    
    <style>
        /* CSS-ul tău existent rămâne la fel */
        .welcome-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
        }
        
        .role-badge {
            background: rgba(255,255,255,0.2);
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.9em;
        }
        
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            border-left: 4px solid #003366;
        }
        
        .stat-icon {
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        
        .stat-number {
            font-size: 2em;
            font-weight: bold;
            color: #003366;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #666;
            font-size: 0.9em;
        }
        
        .quick-actions {
            margin-bottom: 40px;
        }
        
        .action-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .action-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            text-decoration: none;
            color: inherit;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border: 2px solid transparent;
        }
        
        .action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
            border-color: #003366;
        }
        
        .action-icon {
            font-size: 2.5em;
            margin-bottom: 15px;
        }
        
        .action-card h3 {
            color: #003366;
            margin-bottom: 10px;
        }
        
        .action-card p {
            color: #666;
            font-size: 0.9em;
        }
        
        .recent-cvs {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        
        .cv-preview-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .cv-preview-card {
            border: 1px solid #eee;
            padding: 20px;
            border-radius: 8px;
            transition: border-color 0.3s ease;
        }
        
        .cv-preview-card:hover {
            border-color: #003366;
        }
        
        .cv-preview-card h4 {
            color: #003366;
            margin-bottom: 10px;
        }
        
        .cv-preview-email {
            color: #666;
            font-size: 0.9em;
            margin-bottom: 10px;
        }
        
        .cv-preview-education {
            color: #555;
            font-size: 0.9em;
            line-height: 1.4;
        }
        
        .cv-preview-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }
        
        .cv-date {
            font-size: 0.8em;
            color: #999;
        }
        
        .view-details {
            font-size: 0.9em;
            color: #003366;
            text-decoration: none;
        }
        
        .view-all-container {
            text-align: center;
            margin-top: 20px;
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
        }
        
        .btn-secondary:hover {
            background: #545b62;
        }
        
        .empty-state {
            text-align: center;
            padding: 50px 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        
        .empty-state h3 {
            color: #003366;
            margin-bottom: 15px;
        }
    </style>
</body>
</html>