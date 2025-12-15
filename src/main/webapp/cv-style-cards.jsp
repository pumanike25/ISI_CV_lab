<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, java.util.List" %>
<%
    // Obține lista de CV-uri din request
    List<Map<String, String>> cvs = (List<Map<String, String>>) request.getAttribute("cvs");
    if (cvs == null) {
        // Dacă nu este în request, încerci din session sau altă sursă
        cvs = (List<Map<String, String>>) session.getAttribute("userCVs");
    }
%>

<% if (cvs != null && !cvs.isEmpty()) { %>
<div class="cv-cards-container">
    <% 
    int index = 0;
    for (Map<String, String> cv : cvs) { 
        String cvId = cv.get("id") != null ? cv.get("id") : String.valueOf(index);
    %>
        <div class="cv-card">
            <!-- Checkbox pentru bulk export -->
            <div style="position: absolute; top: 15px; right: 15px;">
                <input type="checkbox" 
                       name="cvIds" 
                       value="<%= cvId %>" 
                       class="cv-checkbox"
                       form="bulkExportForm"
                       style="transform: scale(1.2);">
            </div>
            
            <div class="cv-card-header">
                <h3 class="cv-card-name">
                    <%= cv.get("firstName") != null ? cv.get("firstName") : "" %> 
                    <%= cv.get("lastName") != null ? cv.get("lastName") : "" %>
                </h3>
                <span class="cv-card-date">
                    <% 
                    String createdAt = cv.get("createdAt");
                    if (createdAt != null && createdAt.length() >= 10) {
                        out.print(createdAt.substring(0, 10));
                    } else {
                        out.print("N/A");
                    }
                    %>
                </span>
            </div>
            
            <div class="cv-card-contact">
                <div>📧 <%= cv.get("email") != null ? cv.get("email") : "N/A" %></div>
                <% if (cv.get("phone") != null && !cv.get("phone").isEmpty()) { %>
                    <div>📞 <%= cv.get("phone") %></div>
                <% } %>
                <% if (cv.get("birthDate") != null) { %>
                    <div>🎂 <%= cv.get("birthDate") %></div>
                <% } %>
            </div>
            
            <div class="cv-card-section">
                <h4>Education</h4>
                <p>
                    <%
                    String education = cv.get("education");
                    if (education != null) {
                        if (education.length() > 100) {
                            out.print(education.substring(0, 100) + "...");
                        } else {
                            out.print(education);
                        }
                    } else {
                        out.print("No education information");
                    }
                    %>
                </p>
            </div>
            
            <div class="cv-card-section">
                <h4>Experience</h4>
                <p>
                    <%
                    String experience = cv.get("experience");
                    if (experience != null) {
                        if (experience.length() > 100) {
                            out.print(experience.substring(0, 100) + "...");
                        } else {
                            out.print(experience);
                        }
                    } else {
                        out.print("No experience information");
                    }
                    %>
                </p>
            </div>
            
            <% if (cv.get("skills") != null && !cv.get("skills").isEmpty()) { %>
            <div class="cv-card-section">
                <h4>Skills</h4>
                <p>
                    <%
                    String skills = cv.get("skills");
                    if (skills.length() > 80) {
                        out.print(skills.substring(0, 80) + "...");
                    } else {
                        out.print(skills);
                    }
                    %>
                </p>
            </div>
            <% } %>
            
            <!-- BUTOANE CRUD + EXPORT -->
            <div class="cv-management-actions">
                <a href="cv-management?action=edit&id=<%= cvId %>" 
                   class="btn-edit" 
                   title="Edit CV">
                    ✏️ Edit
                </a>
                <a href="cv-management?action=delete&id=<%= cvId %>" 
                   class="btn-delete" 
                   title="Delete CV"
                   onclick="return confirm('Are you sure you want to delete this CV?')">
                    🗑️ Delete
                </a>
                <form method="post" action="export-existing-cv" class="export-form" style="display: inline;">
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
                    <button type="submit" class="btn-export" onclick="return confirm('Export this CV to XML?')">
                        📄 Export XML
                    </button>
                </form>
            </div>
        </div>
    <% 
        index++;
    } %>
</div>
<% } else { %>
    <div class="no-data">
        <div style="font-size: 3em; margin-bottom: 15px;">📭</div>
        <h3>No CVs Found</h3>
        <p>There are no CVs to display in this view.</p>
    </div>
<% } %>