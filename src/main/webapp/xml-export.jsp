<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="ro.isi.lab2.XMLUtil, ro.isi.lab2.UserDAO, java.util.*" %>
<%@ page import="java.io.File" %>
<%
    // Verifică autentificare
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    ro.isi.lab2.User user = (ro.isi.lab2.User) session.getAttribute("user");
    UserDAO userDAO = new UserDAO();
    List<Map<String, String>> userCVs = userDAO.getUserCVs(user.getId());
    
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    String xmlFile = request.getParameter("file");
    String xmlContent = (String) session.getAttribute("xmlContent");
    
    // Listă fișiere XML existente
    String xmlDir = application.getRealPath("/xml/cvs/");
    List<String> xmlFiles = XMLUtil.listXMLFiles(xmlDir);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>XML Tools - Europass CV System</title>
    <link rel="stylesheet" href="style.css">
    <style>
        /* Stiluri noi și îmbunătățite */
        .xml-tools-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-top: 20px;
        }
        
        .tool-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            border-top: 5px solid #003366;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .tool-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }
        
        .tool-icon {
            font-size: 2.5em;
            margin-bottom: 20px;
            text-align: center;
        }
        
        .tool-card h2 {
            color: #003366;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .xml-preview {
            background: #1e1e1e;
            color: #d4d4d4;
            padding: 20px;
            border-radius: 8px;
            font-family: 'Consolas', 'Monaco', monospace;
            font-size: 13px;
            line-height: 1.5;
            overflow-x: auto;
            max-height: 400px;
            overflow-y: auto;
            margin-top: 15px;
        }
        
        .xml-tag { color: #569cd6; }
        .xml-attr { color: #9cdcfe; }
        .xml-text { color: #ce9178; }
        .xml-comment { color: #6a9955; }
        
        .quick-export-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }
        
        .cv-export-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #28a745;
            transition: background-color 0.2s;
        }
        
        .cv-export-item:hover {
            background: #e9ecef;
        }
        
        .cv-export-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .cv-name {
            font-weight: bold;
            color: #003366;
        }
        
        .cv-date {
            font-size: 0.8em;
            color: #6c757d;
        }
        
        .xml-file-list {
            margin-top: 20px;
        }
        
        .xml-file-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 15px;
            margin-bottom: 10px;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #17a2b8;
        }
        
        .file-info {
            flex: 1;
        }
        
        .file-name {
            font-weight: bold;
            color: #003366;
        }
        
        .file-size {
            font-size: 0.8em;
            color: #6c757d;
        }
        
        .file-actions {
            display: flex;
            gap: 8px;
        }
        
        .btn-icon {
            padding: 6px 12px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 0.9em;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        
        .btn-view { background: #17a2b8; color: white; }
        .btn-transform { background: #6f42c1; color: white; }
        .btn-download { background: #28a745; color: white; }
        .btn-delete { background: #dc3545; color: white; }
        
        .btn-icon:hover {
            opacity: 0.9;
        }
        
        .no-data {
            text-align: center;
            padding: 40px;
            color: #6c757d;
            background: #f8f9fa;
            border-radius: 8px;
            border: 2px dashed #dee2e6;
        }
        
        @media (max-width: 992px) {
            .xml-tools-container {
                grid-template-columns: 1fr;
            }
        }
        
        /* Animatie pentru mesaje */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .success-message, .error-message {
            animation: fadeIn 0.5s ease;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <div class="container">
        <div class="page-header">
            <h1>📄 XML Tools</h1>
            <p class="page-subtitle">Manage XML exports, transformations and parsing</p>
        </div>
        
        <% if ("true".equals(success)) { %>
            <div class="success-message" style="animation: fadeIn 0.5s ease;">
                <h3>✅ XML Export Successful!</h3>
                <p>CV has been saved to XML file: <strong><%= xmlFile %></strong></p>
                <div class="action-buttons" style="margin-top: 15px;">
                    <a href="xml-view.jsp?file=<%= xmlFile %>" class="btn-icon btn-view">🔍 View with SAX</a>
                    <a href="xslt-transform.jsp?file=<%= xmlFile %>" class="btn-icon btn-transform">🔄 Transform with XSLT</a>
                    <a href="xml/cvs/<%= xmlFile %>" class="btn-icon btn-download" download>📥 Download XML</a>
                </div>
            </div>
        <% } %>
        
        <% if ("true".equals(error)) { %>
            <div class="error-message" style="animation: fadeIn 0.5s ease;">
                <h3>❌ XML Export Failed</h3>
                <p>There was an error saving the CV to XML format.</p>
            </div>
        <% } %>
        
        <div class="xml-tools-container">
            <!-- Card 1: Export Existing CVs -->
            <div class="tool-card">
                <div class="tool-icon">📤</div>
                <h2>Export Existing CVs</h2>
                <p>Select and export your saved CVs to XML format:</p>
                
                <% if (userCVs.isEmpty()) { %>
                    <div class="no-data">
                        <p>No CVs found in database.</p>
                        <a href="cv-form.jsp" class="btn-primary" style="margin-top: 10px;">Create Your First CV</a>
                    </div>
                <% } else { %>
                    <form method="post" action="export-existing-cv" id="exportForm">
                        <div class="quick-export-grid">
                            <% for (Map<String, String> cv : userCVs) { %>
                            <div class="cv-export-item">
                                <div class="cv-export-header">
                                    <span class="cv-name">
                                        <%= cv.get("firstName") %> <%= cv.get("lastName") %>
                                    </span>
                                    <span class="cv-date">
                                        <%= cv.get("createdAt") != null && cv.get("createdAt").length() >= 10 ? 
                                            cv.get("createdAt").substring(0, 10) : "N/A" %>
                                    </span>
                                </div>
                                <div class="cv-preview">
                                    <small>
                                        <%= cv.get("education") != null && cv.get("education").length() > 60 ? 
                                            cv.get("education").substring(0, 60) + "..." : 
                                            (cv.get("education") != null ? cv.get("education") : "No education") %>
                                    </small>
                                </div>
                                <div style="margin-top: 10px;">
                                    <input type="checkbox" name="cvIds" value="<%= cv.get("id") %>" 
                                           id="cv_<%= cv.get("id") %>">
                                    <label for="cv_<%= cv.get("id") %>">Export this CV</label>
                                </div>
                                <input type="hidden" name="cvData_<%= cv.get("id") %>_firstName" value="<%= cv.get("firstName") %>">
                                <input type="hidden" name="cvData_<%= cv.get("id") %>_lastName" value="<%= cv.get("lastName") %>">
                                <input type="hidden" name="cvData_<%= cv.get("id") %>_email" value="<%= cv.get("email") %>">
                                <input type="hidden" name="cvData_<%= cv.get("id") %>_phone" value="<%= cv.get("phone") != null ? cv.get("phone") : "" %>">
                                <input type="hidden" name="cvData_<%= cv.get("id") %>_birthDate" value="<%= cv.get("birthDate") %>">
                                <input type="hidden" name="cvData_<%= cv.get("id") %>_address" value="<%= cv.get("address") != null ? cv.get("address") : "" %>">
                                <input type="hidden" name="cvData_<%= cv.get("id") %>_education" value="<%= cv.get("education") %>">
                                <input type="hidden" name="cvData_<%= cv.get("id") %>_experience" value="<%= cv.get("experience") %>">
                                <input type="hidden" name="cvData_<%= cv.get("id") %>_skills" value="<%= cv.get("skills") != null ? cv.get("skills") : "" %>">
                                <input type="hidden" name="cvData_<%= cv.get("id") %>_languages" value="<%= cv.get("languages") != null ? cv.get("languages") : "" %>">
                            </div>
                            <% } %>
                        </div>
                        
                        <div style="margin-top: 20px; display: flex; gap: 10px; align-items: center;">
                            <button type="submit" class="btn-primary">
                                📤 Export Selected CVs
                            </button>
                            <div style="margin-left: auto;">
                                <input type="checkbox" id="selectAll" onchange="toggleSelectAll(this)">
                                <label for="selectAll">Select All</label>
                            </div>
                        </div>
                    </form>
                    
                    <script>
                        function toggleSelectAll(checkbox) {
                            var checkboxes = document.querySelectorAll('input[name="cvIds"]');
                            checkboxes.forEach(function(cb) {
                                cb.checked = checkbox.checked;
                            });
                        }
                    </script>
                <% } %>
            </div>
            
            <!-- Card 2: Create New XML -->
            <div class="tool-card">
                <div class="tool-icon">➕</div>
                <h2>Create New XML</h2>
                <p>Generate XML from new CV data:</p>
                
                <form method="post" action="export-cv">
                    <div class="form-group">
                        <label for="firstName" class="required">First Name</label>
                        <input type="text" id="firstName" name="firstName" class="form-control" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="lastName" class="required">Last Name</label>
                        <input type="text" id="lastName" name="lastName" class="form-control" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="email" class="required">Email</label>
                        <input type="email" id="email" name="email" class="form-control" required>
                    </div>
                    
                    <button type="submit" class="btn-primary" style="width: 100%; margin-top: 15px;">
                        🚀 Generate XML
                    </button>
                </form>
                
                <div style="margin-top: 20px; font-size: 0.9em; color: #6c757d;">
                    <p><strong>Tip:</strong> Use the full form for complete CV export.</p>
                </div>
            </div>
            
            <!-- Card 3: XML Files Manager -->
            <div class="tool-card" style="grid-column: span 2;">
                <div class="tool-icon">📁</div>
                <h2>XML Files Manager</h2>
                <p>Manage your existing XML files:</p>
                
                <% if (xmlFiles.isEmpty()) { %>
                    <div class="no-data">
                        <p>No XML files found. Export a CV to get started.</p>
                    </div>
                <% } else { %>
                    <div class="xml-file-list">
                        <% for (String file : xmlFiles) { 
                            File f = new File(xmlDir + file);
                        %>
                        <div class="xml-file-item">
                            <div class="file-info">
                                <div class="file-name">📄 <%= file %></div>
                                <div class="file-size">
                                    Size: <%= f.length() %> bytes | 
                                    Modified: <%= new java.util.Date(f.lastModified()).toString() %>
                                </div>
                            </div>
                            <div class="file-actions">
                                <a href="xml-view.jsp?file=<%= file %>" class="btn-icon btn-view" title="View with SAX">
                                    🔍 SAX
                                </a>
                                <a href="xslt-transform.jsp?file=<%= file %>" class="btn-icon btn-transform" title="Transform with XSLT">
                                    🔄 XSLT
                                </a>
                                <a href="xml/cvs/<%= file %>" class="btn-icon btn-download" download title="Download XML">
                                    📥 Download
                                </a>
                                <a href="delete-xml?file=<%= file %>" class="btn-icon btn-delete" 
                                   title="Delete" 
                                   onclick="return confirm('Are you sure you want to delete <%= file %>?')">
                                    🗑️ Delete
                                </a>
                            </div>
                        </div>
                        <% } %>
                    </div>
                    
                    <div style="margin-top: 20px; text-align: center;">
                        <p><strong><%= xmlFiles.size() %></strong> XML file(s) found</p>
                    </div>
                <% } %>
            </div>
        </div>
        
        <!-- XML Preview Section -->
        <% if (xmlContent != null && !xmlContent.isEmpty()) { %>
        <div class="tool-card" style="margin-top: 30px;">
            <div class="tool-icon">👁️</div>
            <h2>Latest XML Preview</h2>
            <div class="xml-preview">
                <pre><%= xmlContent.replace("<", "&lt;").replace(">", "&gt;") %></pre>
            </div>
        </div>
        <% } %>
    </div>
    
    <%@ include file="footer.jsp" %>
    
    <script>
        // Smooth scroll pentru anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const targetId = this.getAttribute('href');
                if(targetId !== '#') {
                    const targetElement = document.querySelector(targetId);
                    if(targetElement) {
                        targetElement.scrollIntoView({ behavior: 'smooth' });
                    }
                }
            });
        });
        
        // Animație pentru card-uri la încărcare
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.tool-card');
            cards.forEach((card, index) => {
                card.style.animationDelay = (index * 0.1) + 's';
                card.style.animation = 'fadeIn 0.5s ease forwards';
                card.style.opacity = '0';
            });
        });
    </script>
</body>
</html>