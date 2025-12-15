<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, java.util.List" %>
<%
    List<Map<String, String>> cvs = (List<Map<String, String>>) request.getAttribute("cvs");
    if (cvs == null) {
        cvs = (List<Map<String, String>>) session.getAttribute("userCVs");
    }
%>

<% if (cvs != null && !cvs.isEmpty()) { %>
<div class="cv-compact-container">
    <% for (Map<String, String> cv : cvs) { %>
        <div class="cv-compact-item">
            <div class="cv-compact-header">
                <h4 class="cv-compact-name">
                    <%= cv.get("firstName") != null ? cv.get("firstName") : "" %> 
                    <%= cv.get("lastName") != null ? cv.get("lastName") : "" %>
                </h4>
                <span class="cv-compact-date">
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
            <div class="cv-compact-preview">
                <strong>Education:</strong> 
                <%
                String education = cv.get("education");
                if (education != null) {
                    if (education.length() > 60) {
                        out.print(education.substring(0, 60) + "...");
                    } else {
                        out.print(education);
                    }
                } else {
                    out.print("No education");
                }
                %>
                | 
                <strong>Experience:</strong> 
                <%
                String experience = cv.get("experience");
                if (experience != null) {
                    if (experience.length() > 60) {
                        out.print(experience.substring(0, 60) + "...");
                    } else {
                        out.print(experience);
                    }
                } else {
                    out.print("No experience");
                }
                %>
            </div>
        </div>
    <% } %>
</div>
<% } else { %>
    <div class="no-data">No CVs found to display.</div>
<% } %>