package ro.isi.lab2;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Afișează pagina de register
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Preluare date din formular
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String role = "user"; // Default role pentru utilizatori noi
        
        // Validare basic
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            email == null || email.trim().isEmpty()) {
            
            request.setAttribute("error", "All fields are required!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Verifică dacă parolele coincid
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Verifică lungimea parolei
        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters!");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        UserDAO userDAO = new UserDAO();
        
        try {
            // Încearcă înregistrarea
            boolean success = userDAO.registerUser(username, password, email, role);
            
            if (success) {
                // Autentifică automat utilizatorul după înregistrare
                User user = userDAO.authenticate(username, password);
                if (user != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                    session.setMaxInactiveInterval(30 * 60); // 30 minute
                    
                    // Redirect către dashboard
                    response.sendRedirect("user-dashboard.jsp");
                } else {
                    // Dacă autentificarea automată nu funcționează, redirect la login
                    request.setAttribute("success", "Registration successful! Please login.");
                    response.sendRedirect("login.jsp?success=registered");
                }
            } else {
                request.setAttribute("error", "Registration failed. Please try again.");
                request.setAttribute("username", username);
                request.setAttribute("email", email);
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }
            
        } catch (RuntimeException e) {
            // Dacă username-ul există deja
            request.setAttribute("error", e.getMessage());
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}