package ro.isi.lab2;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/settings")
public class SettingsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Preia limba curentă din cookie
        String currentLanguage = "en";
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("language".equals(cookie.getName())) {
                    currentLanguage = cookie.getValue();
                    break;
                }
            }
        }
        request.setAttribute("currentLanguage", currentLanguage);
        request.getRequestDispatcher("/settings.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        
        String language = request.getParameter("language");
        
        // Salvează în cookie
        Cookie languageCookie = new Cookie("language", language);
        languageCookie.setMaxAge(30 * 24 * 60 * 60); // 30 zile
        languageCookie.setPath("/");
        response.addCookie(languageCookie);
        
        request.setAttribute("success", "Language settings saved successfully!");
        request.setAttribute("currentLanguage", language);
        request.getRequestDispatcher("/settings.jsp").forward(request, response);
    }
}