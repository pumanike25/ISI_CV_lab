<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 1. Obține sesiunea curentă (false înseamnă că nu creăm una nouă dacă nu există)
    HttpSession currentSession = request.getSession(false);
    
    // 2. Dacă există o sesiune activă, o invalidăm (ștergem datele utilizatorului)
    if (currentSession != null) {
        currentSession.invalidate();
    }

    // 3. Redirecționăm utilizatorul înapoi la pagina de login
    response.sendRedirect("login.jsp");
%>