<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="ro.isi.lab2.XSLTProcessor" %>
<%
    // Verifică autentificare
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String xmlFile = request.getParameter("file");
    String htmlResult = null;
    
    if (xmlFile != null && !xmlFile.isEmpty()) {
        String xmlPath = application.getRealPath("/xml/cvs/" + xmlFile);
        String xslPath = application.getRealPath("/xml/cv-template.xsl");
        
        // Aplică transformarea XSLT
        htmlResult = XSLTProcessor.transformXMLtoHTML(xmlPath, xslPath);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>XSLT Transformation - Europass CV System</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <div class="container">
        <h1>XSLT Transformation</h1>
        <p>This page demonstrates transforming XML to HTML using XSLT (Extensible Stylesheet Language Transformations).</p>
        
        <% if (xmlFile == null) { %>
            <div class="error-message">
                <p>No XML file specified. Please select a file from the 
                <a href="xml-export.jsp">XML Export</a> page.</p>
            </div>
        <% } else if (htmlResult == null) { %>
            <div class="error-message">
                <p>Error transforming XML file: <%= xmlFile %></p>
            </div>
        <% } else { %>
            <div class="info-message">
                <p>Transforming file: <strong><%= xmlFile %></strong> using XSLT</p>
                <p>XSL Template: <code>cv-template.xsl</code></p>
            </div>
            
            <!-- Rezultatul transformării XSLT -->
            <div class="xslt-result">
                <%= htmlResult %>
            </div>
            
            <div class="action-buttons" style="margin-top: 30px; text-align: center;">
                <a href="xml-view.jsp?file=<%= xmlFile %>" class="btn-primary">Back to SAX View</a>
                <a href="xml-export.jsp" class="btn-secondary">Back to XML Export</a>
                <button onclick="window.print()" class="btn-secondary">Print CV</button>
            </div>
        <% } %>
    </div>
    
    <%@ include file="footer.jsp" %>
</body>
</html>