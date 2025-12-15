<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, java.util.List" %>
<%
    List<Map<String, String>> cvs = (List<Map<String, String>>) request.getAttribute("cvs");
    if (cvs == null) {
        cvs = (List<Map<String, String>>) session.getAttribute("userCVs");
    }
%>

<% if (cvs != null && !cvs.isEmpty()) { %>
<div class="cv-classic-container">
    <% for (Map<String, String> cv : cvs) { %>
        <div class="cv-classic-item">
            <div class="cv-classic-header">
                <h1 class="cv-classic-name">
                    <%= cv.get("firstName") != null ? cv.get("firstName") : "" %> 
                    <%= cv.get("lastName") != null ? cv.get("lastName") : "" %>
                </h1>
                <div class="cv-classic-contact">
                    <span>Email: <%= cv.get("email") != null ? cv.get("email") : "N/A" %></span>
                    <% if (cv.get("phone") != null && !cv.get("phone").isEmpty()) { %>
                        <span>Phone: <%= cv.get("phone") %></span>
                    <% } %>
                    <% if (cv.get("birthDate") != null) { %>
                        <span>Born: <%= cv.get("birthDate") %></span>
                    <% } %>
                </div>
            </div>
            
            <div class="cv-classic-section">
                <h3>EDUCATION AND TRAINING</h3>
                <div class="cv-classic-content">
                    <%
                    String education = cv.get("education");
                    if (education != null) {
                        out.print(education.replace("\n", "<br>"));
                    } else {
                        out.print("No education information available");
                    }
                    %>
                </div>
            </div>
            
            <div class="cv-classic-section">
                <h3>WORK EXPERIENCE</h3>
                <div class="cv-classic-content">
                    <%
                    String experience = cv.get("experience");
                    if (experience != null) {
                        out.print(experience.replace("\n", "<br>"));
                    } else {
                        out.print("No work experience available");
                    }
                    %>
                </div>
            </div>
            
            <% if (cv.get("skills") != null && !cv.get("skills").isEmpty()) { %>
            <div class="cv-classic-section">
                <h3>PERSONAL SKILLS</h3>
                <div class="cv-classic-content">
                    <%
                    String skills = cv.get("skills");
                    out.print(skills.replace("\n", "<br>"));
                    %>
                </div>
            </div>
            <% } %>
            
            <% if (cv.get("languages") != null && !cv.get("languages").isEmpty()) { %>
            <div class="cv-classic-section">
                <h3>LANGUAGES</h3>
                <div class="cv-classic-content">
                    <%
                    String languages = cv.get("languages");
                    out.print(languages.replace("\n", "<br>"));
                    %>
                </div>
            </div>
            <% } %>
            
            <div class="cv-classic-footer">
                <hr style="border-top: 1px solid #003366; margin-top: 30px;">
                <small>
                    Created: 
                    <% 
                    String createdAt = cv.get("createdAt");
                    if (createdAt != null) {
                        out.print(createdAt);
                    } else {
                        out.print("Unknown date");
                    }
                    %>
                </small>
            </div>
        </div>
        <hr style="margin: 40px 0; border: none; border-top: 2px dashed #003366;">
    <% } %>
</div>
<% } else { %>
    <div class="no-data">No CVs found to display.</div>
<% } %>