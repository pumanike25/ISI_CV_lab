<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="ro.isi.lab2.XMLUtil, java.util.*" %>
<%
    // Verifică autentificare
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String xmlFile = request.getParameter("file");
    Map<String, List<String>> parsedData = null;
    String xmlContent = null;
    
    if (xmlFile != null && !xmlFile.isEmpty()) {
        String xmlPath = application.getRealPath("/xml/cvs/" + xmlFile);
        try {
            // Parsare cu SAX
            parsedData = XMLUtil.parseXMLWithSAX(xmlPath);
            xmlContent = XMLUtil.readXMLFile(xmlPath);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>XML SAX Parser - Europass CV System</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .parser-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
        }
        
        .sax-results, .xml-source {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .sax-item {
            margin-bottom: 15px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 5px;
            border-left: 4px solid #003366;
        }
        
        .sax-tag {
            color: #003366;
            font-weight: bold;
            display: block;
            margin-bottom: 5px;
        }
        
        .sax-content {
            color: #333;
        }
        
        .xml-preview {
            background: #2d2d2d;
            color: #f8f8f2;
            padding: 20px;
            border-radius: 5px;
            font-family: 'Courier New', monospace;
            font-size: 14px;
            overflow-x: auto;
            max-height: 500px;
            overflow-y: auto;
        }
        
        @media (max-width: 992px) {
            .parser-container {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <div class="container">
        <h1>XML SAX Parser</h1>
        <p>This page demonstrates parsing XML files using SAX (Simple API for XML).</p>
        
        <% if (xmlFile == null) { %>
            <div class="error-message">
                <p>No XML file specified. Please select a file from the 
                <a href="xml-export.jsp">XML Export</a> page.</p>
            </div>
        <% } else if (parsedData == null) { %>
            <div class="error-message">
                <p>Error parsing XML file: <%= xmlFile %></p>
            </div>
        <% } else { %>
            <div class="info-message">
                <p>Parsing file: <strong><%= xmlFile %></strong> using SAX Parser</p>
            </div>
            
            <div class="parser-container">
                <!-- Rezultate parsare SAX -->
                <div class="sax-results">
                    <h2>SAX Parsed Data</h2>
                    <p>The following data was extracted using the SAX parser:</p>
                    
                    <% for (Map.Entry<String, List<String>> entry : parsedData.entrySet()) { %>
                    <div class="sax-item">
                        <span class="sax-tag">&lt;<%= entry.getKey() %>&gt;</span>
                        <% for (String value : entry.getValue()) { %>
                        <div class="sax-content"><%= value %></div>
                        <% } %>
                    </div>
                    <% } %>
                    
                    <div class="sax-stats">
                        <h3>Parser Statistics</h3>
                        <p>Total elements parsed: <%= parsedData.size() %></p>
                        <p>Total data items: 
                            <% 
                            int totalItems = 0;
                            for (List<String> list : parsedData.values()) {
                                totalItems += list.size();
                            }
                            out.print(totalItems);
                            %>
                        </p>
                    </div>
                </div>
                
                <!-- Sursa XML originală -->
                <div class="xml-source">
                    <h2>Original XML Source</h2>
                    <div class="xml-preview">
                        <pre><%= xmlContent != null ? 
                            xmlContent.replace("<", "&lt;").replace(">", "&gt;") : 
                            "Unable to load XML content" %></pre>
                    </div>
                </div>
            </div>
            
            <div class="action-buttons" style="margin-top: 30px; text-align: center;">
                <a href="xslt-transform.jsp?file=<%= xmlFile %>" class="btn-primary">Transform with XSLT</a>
                <a href="xml-export.jsp" class="btn-secondary">Back to XML Export</a>
            </div>
        <% } %>
    </div>
    
    <%@ include file="footer.jsp" %>
</body>
</html>