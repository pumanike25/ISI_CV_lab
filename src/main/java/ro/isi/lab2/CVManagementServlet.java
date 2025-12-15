package ro.isi.lab2;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/cv-management")
public class CVManagementServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Verifică autentificare
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        UserDAO userDAO = new UserDAO();
        
        String action = request.getParameter("action");
        String cvIdParam = request.getParameter("id");
        
        if ("edit".equals(action) && cvIdParam != null) {
            // Editare CV - afișează formularul cu datele existente
            try {
                int cvId = Integer.parseInt(cvIdParam);
                Map<String, String> cv = userDAO.getCVById(cvId, user.getId());
                
                if (cv != null) {
                    request.setAttribute("cv", cv);
                    request.setAttribute("action", "edit");
                    request.getRequestDispatcher("/cv-edit.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "CV not found or you don't have permission!");
                    request.getRequestDispatcher("/cv-list.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid CV ID!");
                request.getRequestDispatcher("/cv-list.jsp").forward(request, response);
            }
            
        } else if ("delete".equals(action) && cvIdParam != null) {
            // Ștergere CV - afișează pagina de confirmare
            try {
                int cvId = Integer.parseInt(cvIdParam);
                Map<String, String> cv = userDAO.getCVById(cvId, user.getId());
                
                if (cv != null) {
                    request.setAttribute("cv", cv);
                    request.getRequestDispatcher("/cv-delete.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "CV not found or you don't have permission!");
                    request.getRequestDispatcher("/cv-list.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid CV ID!");
                request.getRequestDispatcher("/cv-list.jsp").forward(request, response);
            }
            
        } else {
            // Listare CV-uri (default)
            response.sendRedirect("cv-list.jsp");
        }
    }
    
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
        UserDAO userDAO = new UserDAO();
        CVValidator validator = new CVValidator();
        
        String action = request.getParameter("action");
        String cvIdParam = request.getParameter("cvId");
        
        if ("update".equals(action) && cvIdParam != null) {
            // Actualizare CV existent
            try {
                int cvId = Integer.parseInt(cvIdParam);
                
                // Verifică dacă CV-ul aparține utilizatorului
                Map<String, String> existingCV = userDAO.getCVById(cvId, user.getId());
                if (existingCV == null) {
                    request.setAttribute("error", "CV not found or you don't have permission!");
                    request.getRequestDispatcher("/cv-list.jsp").forward(request, response);
                    return;
                }
                
                // Preluare date actualizate
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
                
                // Validare date
                Map<String, String> errors = validator.validateCV(cvData);
                
                if (errors.isEmpty()) {
                    // Actualizează în baza de date
                    boolean success = userDAO.updateCVData(cvId, cvData);
                    
                    if (success) {
                        session.setAttribute("success", "CV updated successfully!");
                        response.sendRedirect("cv-list.jsp?success=updated");
                    } else {
                        request.setAttribute("error", "Error updating CV!");
                        request.setAttribute("cv", cvData);
                        request.setAttribute("action", "edit");
                        request.getRequestDispatcher("/cv-edit.jsp").forward(request, response);
                    }
                } else {
                    // Dacă sunt erori, revenire la formular
                    request.setAttribute("errors", errors);
                    request.setAttribute("cv", cvData);
                    request.setAttribute("action", "edit");
                    request.getRequestDispatcher("/cv-edit.jsp").forward(request, response);
                }
                
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid CV ID!");
                request.getRequestDispatcher("/cv-list.jsp").forward(request, response);
            }
            
        } else if ("delete".equals(action) && cvIdParam != null) {
            // Ștergere CV confirmată
            try {
                int cvId = Integer.parseInt(cvIdParam);
                
                // Verifică dacă CV-ul aparține utilizatorului
                Map<String, String> existingCV = userDAO.getCVById(cvId, user.getId());
                if (existingCV == null) {
                    request.setAttribute("error", "CV not found or you don't have permission!");
                    request.getRequestDispatcher("/cv-list.jsp").forward(request, response);
                    return;
                }
                
                // Șterge CV
                boolean success = userDAO.deleteCV(cvId, user.getId());
                
                if (success) {
                    session.setAttribute("success", "CV deleted successfully!");
                    response.sendRedirect("cv-list.jsp?success=deleted");
                } else {
                    request.setAttribute("error", "Error deleting CV!");
                    request.getRequestDispatcher("/cv-list.jsp").forward(request, response);
                }
                
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid CV ID!");
                request.getRequestDispatcher("/cv-list.jsp").forward(request, response);
            }
        } else {
            // Acțiune necunoscută
            response.sendRedirect("cv-list.jsp");
        }
    }
}