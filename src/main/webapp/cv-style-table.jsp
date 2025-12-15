<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, java.util.List" %>
<%
    List<Map<String, String>> cvs = (List<Map<String, String>>) request.getAttribute("cvs");
    if (cvs == null) {
        cvs = (List<Map<String, String>>) session.getAttribute("userCVs");
    }
%>

<% if (cvs != null && !cvs.isEmpty()) { %>
<div class="cv-table-container">
    <table class="cv-table">
        <thead>
            <tr>
                <th>Name</th>
                <th>Contact</th>
                <th>Education</th>
                <th>Experience</th>
                <th>Created</th>
            </tr>
        </thead>
        <tbody>
            <% for (Map<String, String> cv : cvs) { %>
            <tr>
                <td>
                    <strong>
                        <%= cv.get("firstName") != null ? cv.get("firstName") : "" %> 
                        <%= cv.get("lastName") != null ? cv.get("lastName") : "" %>
                    </strong>
                    <% if (cv.get("birthDate") != null) { %>
                        <br><small>Born: <%= cv.get("birthDate") %></small>
                    <% } %>
                </td>
                <td>
                    <div>📧 <%= cv.get("email") != null ? cv.get("email") : "N/A" %></div>
                    <% if (cv.get("phone") != null && !cv.get("phone").isEmpty()) { %>
                        <div>📞 <%= cv.get("phone") %></div>
                    <% } %>
                </td>
                <td>
                    <div class="table-section">
                        <%
                        String education = cv.get("education");
                        if (education != null) {
                            if (education.length() > 80) {
                                out.print(education.substring(0, 80) + "...");
                            } else {
                                out.print(education);
                            }
                        } else {
                            out.print("No education");
                        }
                        %>
                    </div>
                </td>
                <td>
                    <div class="table-section">
                        <%
                        String experience = cv.get("experience");
                        if (experience != null) {
                            if (experience.length() > 80) {
                                out.print(experience.substring(0, 80) + "...");
                            } else {
                                out.print(experience);
                            }
                        } else {
                            out.print("No experience");
                        }
                        %>
                    </div>
                </td>
                <td>
                    <small>
                        <% 
                        String createdAt = cv.get("createdAt");
                        if (createdAt != null && createdAt.length() >= 10) {
                            out.print(createdAt.substring(0, 10));
                        } else {
                            out.print("N/A");
                        }
                        %>
                    </small>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</div>
<% } else { %>
    <div class="no-data">No CVs found to display.</div>
<% } %>