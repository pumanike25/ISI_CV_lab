package ro.isi.lab2;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;

@WebServlet("/export-cv")
public class CVExportServlet extends HttpServlet {
    
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
        
        // Obține datele CV din request
        Map<String, String> cvData = new HashMap<>();
        cvData.put("firstName", request.getParameter("firstName"));
        cvData.put("lastName", request.getParameter("lastName"));
        cvData.put("email", request.getParameter("email"));
        cvData.put("phone", request.getParameter("phone"));
        cvData.put("birthDate", request.getParameter("birthDate"));
        cvData.put("address", request.getParameter("address"));
        cvData.put("education", request.getParameter("education"));
        cvData.put("experience", request.getParameter("experience"));
        cvData.put("skills", request.getParameter("skills"));
        cvData.put("languages", request.getParameter("languages"));
        
        // Creează director pentru XML-uri
        String xmlDir = getServletContext().getRealPath("/xml/cvs/");
        File directory = new File(xmlDir);
        if (!directory.exists()) {
            directory.mkdirs();
        }
        
        // Generează nume de fișier unic
        String timestamp = new java.text.SimpleDateFormat("yyyyMMdd_HHmmss").format(new java.util.Date());
        String fileName = "cv_" + user.getUsername() + "_" + timestamp + ".xml";
        String filePath = xmlDir + File.separator + fileName;
        
        // Salvează în XML folosind DOM
        boolean saved = XMLUtil.saveCVToXML(cvData, filePath);
        
        if (saved) {
            session.setAttribute("lastXMLFile", fileName);
            session.setAttribute("xmlContent", XMLUtil.readXMLFile(filePath));
            response.sendRedirect("xml-export.jsp?success=true&file=" + fileName);
        } else {
            response.sendRedirect("xml-export.jsp?error=true");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        request.getRequestDispatcher("/xml-export.jsp").forward(request, response);
    }
}