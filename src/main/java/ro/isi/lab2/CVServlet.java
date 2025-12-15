package ro.isi.lab2;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/cv")
public class CVServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CVValidator validator;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        validator = new CVValidator();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Verifică autentificare
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Verifică autentificare
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Preluare parametri din formular
        Map<String, String> formData = new HashMap<>();
        formData.put("firstName", request.getParameter("firstName"));
        formData.put("lastName", request.getParameter("lastName"));
        formData.put("email", request.getParameter("email"));
        formData.put("phone", request.getParameter("phone"));
        formData.put("birthDate", request.getParameter("birthDate"));
        formData.put("address", request.getParameter("address"));
        formData.put("education", request.getParameter("education"));
        formData.put("experience", request.getParameter("experience"));
        formData.put("skills", request.getParameter("skills"));
        formData.put("languages", request.getParameter("languages"));
        
        // Validare date
        Map<String, String> errors = validator.validateCV(formData);
        
        if (errors.isEmpty()) {
            // Salvează în baza de date
            boolean saved = userDAO.saveCVData(user.getId(), formData);
            
            if (saved) {
                request.setAttribute("formData", formData);
                request.setAttribute("success", "CV submitted and saved successfully!");
                request.getRequestDispatcher("/cv-result.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Error saving CV to database");
                request.setAttribute("formData", formData);
                request.getRequestDispatcher("/index.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("errors", errors);
            request.setAttribute("formData", formData);
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}