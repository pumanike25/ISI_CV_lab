package ro.isi.lab2;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;

@WebServlet("/delete-xml")
public class DeleteXMLServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Verifică autentificare
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String fileName = request.getParameter("file");
        if (fileName != null && !fileName.isEmpty()) {
            String xmlDir = getServletContext().getRealPath("/xml/cvs/");
            File file = new File(xmlDir + File.separator + fileName);
            
            if (file.exists() && file.delete()) {
                response.sendRedirect("xml-export.jsp?success=deleted&file=" + fileName);
            } else {
                response.sendRedirect("xml-export.jsp?error=deleteFailed&file=" + fileName);
            }
        } else {
            response.sendRedirect("xml-export.jsp?error=noFile");
        }
    }
}