<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
</div> <!-- Închide container-ul din body dacă există -->

<footer class="main-footer">
    <div class="footer-content">
        <div class="footer-section">
            <h3>Europass CV System</h3>
            <p>Create professional European-standard CVs with multiple display styles.</p>
        </div>
        
        <div class="footer-section">
            <h4>Quick Links</h4>
            <ul>
                <li><a href="login.jsp">Login</a></li>
                <li><a href="cv-form.jsp">Create CV</a></li>
                <li><a href="settings.jsp">Settings</a></li>
            </ul>
        </div>
        
        <div class="footer-section">
            <h4>Display Styles</h4>
            <ul>
                <li><a href="cv-list.jsp?style=cards">Cards View</a></li>
                <li><a href="cv-list.jsp?style=table">Table View</a></li>
                <li><a href="cv-list.jsp?style=modern">Modern View</a></li>
                <li><a href="cv-list.jsp?style=classic">Classic View</a></li>
            </ul>
        </div>
        
        <div class="footer-section">
            <h4>Support</h4>
            <ul>
                <li><a href="#">Help Center</a></li>
                <li><a href="#">Contact Us</a></li>
                <li><a href="#">Privacy Policy</a></li>
            </ul>
        </div>
    </div>
    
    <div class="footer-bottom">
        <p>&copy; 2024 Europass CV System. All rights reserved.</p>
    </div>
</footer>

<style>
    .main-footer {
        background: #2c3e50;
        color: white;
        margin-top: 50px;
        padding: 40px 0 20px;
    }
    
    .footer-content {
        max-width: 1200px;
        margin: 0 auto;
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 30px;
        padding: 0 20px;
    }
    
    .footer-section h3,
    .footer-section h4 {
        color: #3498db;
        margin-bottom: 15px;
    }
    
    .footer-section ul {
        list-style: none;
        padding: 0;
    }
    
    .footer-section ul li {
        margin-bottom: 8px;
    }
    
    .footer-section a {
        color: #bdc3c7;
        text-decoration: none;
        transition: color 0.3s;
    }
    
    .footer-section a:hover {
        color: #3498db;
    }
    
    .footer-bottom {
        max-width: 1200px;
        margin: 0 auto;
        text-align: center;
        padding: 20px;
        border-top: 1px solid #34495e;
        margin-top: 30px;
        color: #95a5a6;
    }
    
    @media (max-width: 768px) {
        .footer-content {
            grid-template-columns: 1fr;
            text-align: center;
        }
    }
</style>

</body>
</html>