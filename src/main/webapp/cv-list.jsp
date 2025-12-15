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
    List<Map<String, String>> cvs = userDAO.getUserCVs(user.getId());
    
    // Salvează CV-urile în request pentru fișierele incluse
    request.setAttribute("cvs", cvs);
    session.setAttribute("userCVs", cvs);
    
    String style = request.getParameter("style");
    if (style == null) style = "cards";
    
    String exportSuccess = request.getParameter("exportSuccess");
    String exportError = request.getParameter("exportError");
    String exportCount = request.getParameter("count");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My CVs - Europass System</title>
    <style>
        <%@ include file="cv-styles.css" %>
        
        .no-data {
            text-align: center;
            padding: 40px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            color: #666;
        }
        
        /* --- STILURI PENTRU ACȚIUNI ȘI BUTOANE --- */
        
        /* Container pentru butoanele de pe fiecare card */
        .cv-management-actions {
            margin-top: 15px;
            padding-top: 10px;
            border-top: 1px solid #eee;
            display: flex;
            gap: 8px;
            align-items: center;
            flex-wrap: wrap;
        }

        .cv-actions {
            margin-top: 15px;
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        
        /* Butoane Generale */
        .btn-export, .btn-xml-tools, .btn-edit, .btn-delete {
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.2s ease;
            cursor: pointer;
            border: none;
        }
        
        /* Buton Export (Albastru) */
        .btn-export {
            background: #17a2b8;
            color: white;
        }
        .btn-export:hover {
            background: #138496;
            transform: translateY(-2px);
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }
        
        /* Buton XML Tools (Mov) */
        .btn-xml-tools {
            background: #6f42c1;
            color: white;
        }
        .btn-xml-tools:hover {
            background: #5a32a3;
            transform: translateY(-2px);
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }

        /* Buton Edit (Cyan închis) */
        .btn-edit {
            background: #17a2b8;
            color: white;
        }
        .btn-edit:hover {
            background: #138496;
            transform: translateY(-1px);
        }

        /* Buton Delete (Roșu) */
        .btn-delete {
            background: #dc3545;
            color: white;
        }
        .btn-delete:hover {
            background: #c82333;
            transform: translateY(-1px);
        }

        /* Formular Export Inline */
        .export-form {
            display: inline;
            margin: 0;
        }
        
        /* --- MESAJE ȘI ALERTE --- */
        .export-message {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            animation: fadeIn 0.5s ease;
        }
        
        .export-success {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }
        
        .export-error {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        /* --- HEADER ȘI LAYOUT --- */
        .page-header-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .bulk-export-section {
            background: #e7f3ff;
            padding: 15px;
            border-radius: 8px;
            margin-top: 20px;
            border-left: 4px solid #003366;
        }
        
        .bulk-actions {
            display: flex;
            gap: 10px;
            align-items: center;
            margin-top: 10px;
        }
        
        .cv-checkbox {
            margin-right: 5px;
        }
        
        .select-all-container {
            display: flex;
            align-items: center;
            gap: 5px;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <div class="container">
        <div class="page-header-actions">
            <div>
                <h1>My Curriculum Vitae</h1>
                <% if (!cvs.isEmpty()) { %>
                <p class="page-subtitle">Manage and export your CVs</p>
                <% } %>
            </div>
            
            <% if (!cvs.isEmpty()) { %>
            <div>
                <a href="xml-export.jsp" class="btn-primary" style="display: inline-flex; align-items: center; gap: 8px;">
                    📄 XML Export Tools
                </a>
            </div>
            <% } %>
        </div>
        
        <% if ("true".equals(exportSuccess)) { %>
            <div class="export-message export-success">
                <strong>✅ Export Successful!</strong> 
                <% if (exportCount != null) { %>
                    <%= exportCount %> CV(s) have been exported to XML format.
                <% } else { %>
                    CV has been exported to XML format.
                <% } %>
                <a href="xml-export.jsp" style="margin-left: 10px; color: #155724; text-decoration: underline;">
                    View in XML Tools
                </a>
            </div>
        <% } %>
        
        <% if ("true".equals(exportError)) { %>
            <div class="export-message export-error">
                <strong>❌ Export Failed!</strong> There was an error exporting the CV to XML.
            </div>
        <% } %>
        
        <div class="style-selector">
            <h3>Choose Display Style:</h3>
            <div class="style-buttons">
                <a href="?style=cards" class="style-btn <%= "cards".equals(style) ? "active" : "" %>">📋 Cards View</a>
                <a href="?style=table" class="style-btn <%= "table".equals(style) ? "active" : "" %>">📊 Table View</a>
                <a href="?style=modern" class="style-btn <%= "modern".equals(style) ? "active" : "" %>">🎨 Modern View</a>
                <a href="?style=classic" class="style-btn <%= "classic".equals(style) ? "active" : "" %>">📄 Classic View</a>
                <a href="?style=compact" class="style-btn <%= "compact".equals(style) ? "active" : "" %>">📱 Compact View</a>
            </div>
        </div>

        <% if (cvs.isEmpty()) { %>
            <div class="no-cvs">
                <div style="font-size: 4em; margin-bottom: 20px;">📝</div>
                <h3>No CVs Yet</h3>
                <p>You haven't created any CVs. Start by creating your first Europass CV!</p>
                <div style="margin-top: 20px;">
                    <a href="cv-form.jsp" class="btn-primary">Create Your First CV</a>
                    <a href="user-dashboard.jsp" class="btn-secondary" style="margin-left: 10px;">Back to Dashboard</a>
                </div>
            </div>
        <% } else { %>
            <div class="cv-count">
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <strong>Found <%= cvs.size() %> CV<%= cvs.size() > 1 ? "s" : "" %></strong>
                        <span style="font-size: 0.9em; color: #666; margin-left: 10px;">
                            Last updated: <%= new java.util.Date().toString() %>
                        </span>
                    </div>
                    <div>
                        <a href="#bulkExport" class="btn-secondary">📦 Bulk Export</a>
                    </div>
                </div>
            </div>

            <% if ("table".equals(style)) { %>
                <jsp:include page="cv-style-table.jsp" />
            <% } else if ("modern".equals(style)) { %>
                <jsp:include page="cv-style-modern.jsp" />
            <% } else if ("classic".equals(style)) { %>
                <jsp:include page="cv-style-classic.jsp" />
            <% } else if ("compact".equals(style)) { %>
                <jsp:include page="cv-style-compact.jsp" />
            <% } else { %>
                <jsp:include page="cv-style-cards.jsp" />
            <% } %>
            
            <div id="bulkExport" class="bulk-export-section">
                <h3>📦 Bulk Export to XML</h3>
                <p>Export multiple CVs to XML format at once:</p>
                
                <form method="post" action="export-existing-cv" id="bulkExportForm">
                    <div class="bulk-actions">
                        <button type="submit" class="btn-primary" onclick="return confirm('Export selected CVs to XML?')">
                            📤 Export Selected CVs
                        </button>
                        <div class="select-all-container" style="margin-left: auto;">
                            <input type="checkbox" id="selectAllCVs" onchange="toggleAllCVs(this)" class="cv-checkbox">
                            <label for="selectAllCVs" style="font-weight: bold;">Select All CVs</label>
                        </div>
                    </div>
                    
                    <% int index = 0; %>
                    <% for (Map<String, String> cv : cvs) { 
                        String cvId = cv.get("id") != null ? cv.get("id") : String.valueOf(index);
                    %>
                    <input type="hidden" name="cvIds" value="<%= cvId %>">
                    <input type="hidden" name="cvData_<%= cvId %>_firstName" value="<%= cv.get("firstName") != null ? cv.get("firstName") : "" %>">
                    <input type="hidden" name="cvData_<%= cvId %>_lastName" value="<%= cv.get("lastName") != null ? cv.get("lastName") : "" %>">
                    <input type="hidden" name="cvData_<%= cvId %>_email" value="<%= cv.get("email") != null ? cv.get("email") : "" %>">
                    <input type="hidden" name="cvData_<%= cvId %>_phone" value="<%= cv.get("phone") != null ? cv.get("phone") : "" %>">
                    <input type="hidden" name="cvData_<%= cvId %>_birthDate" value="<%= cv.get("birthDate") != null ? cv.get("birthDate") : "" %>">
                    <input type="hidden" name="cvData_<%= cvId %>_address" value="<%= cv.get("address") != null ? cv.get("address") : "" %>">
                    <input type="hidden" name="cvData_<%= cvId %>_education" value="<%= cv.get("education") != null ? cv.get("education") : "" %>">
                    <input type="hidden" name="cvData_<%= cvId %>_experience" value="<%= cv.get("experience") != null ? cv.get("experience") : "" %>">
                    <input type="hidden" name="cvData_<%= cvId %>_skills" value="<%= cv.get("skills") != null ? cv.get("skills") : "" %>">
                    <input type="hidden" name="cvData_<%= cvId %>_languages" value="<%= cv.get("languages") != null ? cv.get("languages") : "" %>">
                    <% index++; %>
                    <% } %>
                </form>
                
                <div style="margin-top: 15px; font-size: 0.9em; color: #666;">
                    <p><strong>Note:</strong> Selected CVs will be exported as separate XML files in the XML Tools section.</p>
                </div>
            </div>
            
            <div style="text-align: center; margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee;">
                <a href="xml-export.jsp" class="btn-primary">🚀 Go to Advanced XML Tools</a>
                <a href="user-dashboard.jsp" class="btn-secondary" style="margin-left: 10px;">← Back to Dashboard</a>
            </div>
        <% } %>
    </div>
    
    <%@ include file="footer.jsp" %>
    
    <script>
        // Funcție pentru selectarea tuturor CV-urilor
        function toggleAllCVs(checkbox) {
            const cvCheckboxes = document.querySelectorAll('input[name="cvIds"]');
            cvCheckboxes.forEach(cb => {
                cb.checked = checkbox.checked;
            });
            console.log('Selected all CVs: ' + checkbox.checked);
        }
        
        // Initializează checkboxes ca ne-selectate
        document.addEventListener('DOMContentLoaded', function() {
            const cvCheckboxes = document.querySelectorAll('input[name="cvIds"]');
            cvCheckboxes.forEach(cb => {
                cb.checked = false;
            });
        });
        
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
        
        // Animație pentru mesaje
        const messages = document.querySelectorAll('.export-message');
        messages.forEach((msg, index) => {
            msg.style.animationDelay = (index * 0.1) + 's';
        });
        
        // Verifică dacă există CV-uri selectate înainte de submit
        document.getElementById('bulkExportForm').addEventListener('submit', function(e) {
            const selectedCVs = document.querySelectorAll('input[name="cvIds"]:checked');
            if (selectedCVs.length === 0) {
                e.preventDefault();
                alert('Please select at least one CV to export.');
                return false;
            }
            return true;
        });
    </script>
</body>
</html>