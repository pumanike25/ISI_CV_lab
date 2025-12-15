<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, java.util.List" %>
<%
    List<Map<String, String>> cvs = (List<Map<String, String>>) request.getAttribute("cvs");
    if (cvs == null) {
        cvs = (List<Map<String, String>>) session.getAttribute("userCVs");
    }
%>

<% if (cvs != null && !cvs.isEmpty()) { %>
<div class="cv-modern-container">
    <% 
    String[] colors = {"linear-gradient(135deg, #667eea 0%, #764ba2 100%)", 
                      "linear-gradient(135deg, #f093fb 0%, #f5576c 100%)",
                      "linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)",
                      "linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)",
                      "linear-gradient(135deg, #fa709a 0%, #fee140 100%)"};
    int colorIndex = 0;
    %>
    
    <% for (Map<String, String> cv : cvs) { %>
        <div class="cv-modern-item" style="background: <%= colors[colorIndex % colors.length] %>">
            <div class="cv-modern-header">
                <h2 class="cv-modern-name">
                    <%= cv.get("firstName") != null ? cv.get("firstName") : "" %> 
                    <%= cv.get("lastName") != null ? cv.get("lastName") : "" %>
                </h2>
                <span class="cv-modern-date">
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
            
            <div class="cv-modern-content">
                <div class="cv-modern-section">
                    <h4>📧 Contact</h4>
                    <div><%= cv.get("email") != null ? cv.get("email") : "N/A" %></div>
                    <% if (cv.get("phone") != null && !cv.get("phone").isEmpty()) { %>
                        <div>📞 <%= cv.get("phone") %></div>
                    <% } %>
                </div>
                
                <div class="cv-modern-section">
                    <h4>🎓 Education</h4>
                    <div>
                        <%
                        String education = cv.get("education");
                        if (education != null) {
                            out.print(education);
                        } else {
                            out.print("No education information");
                        }
                        %>
                    </div>
                </div>
                
                <div class="cv-modern-section">
                    <h4>💼 Experience</h4>
                    <div>
                        <%
                        String experience = cv.get("experience");
                        if (experience != null) {
                            out.print(experience);
                        } else {
                            out.print("No experience information");
                        }
                        %>
                    </div>
                </div>
                
                <% if (cv.get("skills") != null && !cv.get("skills").isEmpty()) { %>
                <div class="cv-modern-section">
                    <h4>🛠️ Skills</h4>
                    <div><%= cv.get("skills") %></div>
                </div>
                <% } %>
            </div>
        </div>
        <% colorIndex++; %>
    <% } %>
</div>
<% } else { %>
    <div class="no-data">No CVs found to display.</div>
<% } %>