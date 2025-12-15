package ro.isi.lab2;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;

@WebServlet("/export-existing-cv")
public class ExportExistingCVServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Verifică autentificare
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String[] cvIds = request.getParameterValues("cvIds");
        
        System.out.println("🔍 Export request received from user: " + user.getUsername());
        System.out.println("📦 CV IDs to export: " + (cvIds != null ? Arrays.toString(cvIds) : "null"));
        
        if (cvIds == null || cvIds.length == 0) {
            System.out.println("❌ No CVs selected for export");
            response.sendRedirect("cv-list.jsp?exportError=true&message=No CVs selected");
            return;
        }
        
        List<String> exportedFiles = new ArrayList<>();
        int successCount = 0;
        
        for (String cvId : cvIds) {
            try {
                System.out.println("🔄 Processing CV ID: " + cvId);
                
                // Colectează datele din hidden fields
                Map<String, String> cvData = new HashMap<>();
                cvData.put("firstName", request.getParameter("cvData_" + cvId + "_firstName"));
                cvData.put("lastName", request.getParameter("cvData_" + cvId + "_lastName"));
                cvData.put("email", request.getParameter("cvData_" + cvId + "_email"));
                cvData.put("phone", request.getParameter("cvData_" + cvId + "_phone"));
                cvData.put("birthDate", request.getParameter("cvData_" + cvId + "_birthDate"));
                cvData.put("address", request.getParameter("cvData_" + cvId + "_address"));
                cvData.put("education", request.getParameter("cvData_" + cvId + "_education"));
                cvData.put("experience", request.getParameter("cvData_" + cvId + "_experience"));
                cvData.put("skills", request.getParameter("cvData_" + cvId + "_skills"));
                cvData.put("languages", request.getParameter("cvData_" + cvId + "_languages"));
                
                System.out.println("📝 CV Data collected: " + cvData.get("firstName") + " " + cvData.get("lastName"));
                
                // Creează director pentru XML-uri
                String xmlDir = getServletContext().getRealPath("/xml/cvs/");
                File directory = new File(xmlDir);
                if (!directory.exists()) {
                    boolean dirCreated = directory.mkdirs();
                    System.out.println("📁 XML directory created: " + dirCreated + " at " + xmlDir);
                }
                
                // Generează nume de fișier unic
                String timestamp = new java.text.SimpleDateFormat("yyyyMMdd_HHmmss").format(new java.util.Date());
                String fileName = "cv_" + user.getUsername() + "_id" + cvId + "_" + timestamp + ".xml";
                String filePath = xmlDir + File.separator + fileName;
                
                // Salvează în XML folosind DOM
                boolean saved = XMLUtil.saveCVToXML(cvData, filePath);
                
                if (saved) {
                    exportedFiles.add(fileName);
                    successCount++;
                    System.out.println("✅ XML saved: " + fileName);
                } else {
                    System.out.println("❌ Failed to save XML for CV ID: " + cvId);
                }
                
            } catch (Exception e) {
                System.err.println("❌ Error exporting CV ID " + cvId + ": " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        if (successCount > 0) {
            System.out.println("🎉 Export completed: " + successCount + "/" + cvIds.length + " CVs exported");
            session.setAttribute("lastExportFiles", exportedFiles);
            session.setAttribute("exportCount", successCount);
            response.sendRedirect("cv-list.jsp?exportSuccess=true&count=" + successCount);
        } else {
            System.out.println("❌ All exports failed");
            response.sendRedirect("cv-list.jsp?exportError=true&message=Export failed");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirect către formular
        response.sendRedirect("cv-list.jsp");
    }
}