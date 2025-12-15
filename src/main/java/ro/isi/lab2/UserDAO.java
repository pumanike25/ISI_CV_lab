package ro.isi.lab2;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserDAO {
    
    // ✅ METODĂ DE AUTENTIFICARE
    public User authenticate(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        
        System.out.println("🔍 Autentificare user: " + username);
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            stmt.setString(2, password);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                user.setEmail(rs.getString("email"));
                System.out.println("✅ User găsit: " + user.getUsername() + " (" + user.getRole() + ")");
                return user;
            } else {
                System.out.println("❌ User NOT found: " + username);
            }
        } catch (SQLException e) {
            System.err.println("❌ Eroare la autentificare:");
            e.printStackTrace();
        }
        return null;
    }
    
    // ✅ METODĂ PENTRU SALVARE CV
    public boolean saveCVData(int userId, Map<String, String> cvData) {
        String sql = "INSERT INTO cv_data (user_id, first_name, last_name, email, phone, " +
                    "birth_date, address, education, experience, skills, languages) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        System.out.println("💾 Salvare CV pentru user_id: " + userId);
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, cvData.get("firstName"));
            stmt.setString(3, cvData.get("lastName"));
            stmt.setString(4, cvData.get("email"));
            stmt.setString(5, cvData.get("phone"));
            stmt.setString(6, cvData.get("birthDate"));
            stmt.setString(7, cvData.get("address"));
            stmt.setString(8, cvData.get("education"));
            stmt.setString(9, cvData.get("experience"));
            stmt.setString(10, cvData.get("skills"));
            stmt.setString(11, cvData.get("languages"));
            
            int rowsAffected = stmt.executeUpdate();
            boolean success = rowsAffected > 0;
            
            if (success) {
                System.out.println("✅ CV salvat cu succes pentru user_id: " + userId);
            } else {
                System.out.println("❌ Eroare la salvarea CV pentru user_id: " + userId);
            }
            
            return success;
            
        } catch (SQLException e) {
            System.err.println("❌ Eroare SQL la salvarea CV:");
            e.printStackTrace();
        }
        return false;
    }
    
    // ✅ METODĂ PENTRU ÎNREGISTRARE USER NOU
    public boolean registerUser(String username, String password, String email, String role) {
        String sql = "INSERT INTO users (username, password, email, role) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            stmt.setString(2, password);
            stmt.setString(3, email);
            stmt.setString(4, role != null ? role : "user");
            
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("✅ User registered: " + username);
                return true;
            }
        } catch (SQLException e) {
            System.err.println("❌ Error registering user: " + e.getMessage());
            // Verifică dacă este eroare de duplicate username
            if (e.getMessage().contains("Duplicate") || e.getMessage().contains("unique")) {
                throw new RuntimeException("Username already exists!");
            }
        }
        return false;
    }
    
    // ✅ METODĂ PENTRU VERIFICARE USERNAME EXISTENT
    public boolean usernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // ✅ METODĂ PENTRU PRELUARE TOATE CV-URILE UNUI USER
    public List<Map<String, String>> getUserCVs(int userId) {
        List<Map<String, String>> cvs = new ArrayList<>();
        String sql = "SELECT * FROM cv_data WHERE user_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, String> cv = new HashMap<>();
                cv.put("id", String.valueOf(rs.getInt("id")));
                cv.put("firstName", rs.getString("first_name"));
                cv.put("lastName", rs.getString("last_name"));
                cv.put("email", rs.getString("email"));
                cv.put("phone", rs.getString("phone"));
                cv.put("birthDate", rs.getString("birth_date"));
                cv.put("address", rs.getString("address"));
                cv.put("education", rs.getString("education"));
                cv.put("experience", rs.getString("experience"));
                cv.put("skills", rs.getString("skills"));
                cv.put("languages", rs.getString("languages"));
                cv.put("createdAt", rs.getString("created_at"));
                cvs.add(cv);
            }
        } catch (SQLException e) {
            System.err.println("❌ Eroare la preluarea CV-urilor:");
            e.printStackTrace();
        }
        return cvs;
    }
    
    // ✅ METODĂ PENTRU PRELUARE UN SINGUR CV
    public Map<String, String> getCVById(int cvId, int userId) {
        String sql = "SELECT * FROM cv_data WHERE id = ? AND user_id = ?";
        Map<String, String> cv = null;
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, cvId);
            stmt.setInt(2, userId);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                cv = new HashMap<>();
                cv.put("id", String.valueOf(rs.getInt("id")));
                cv.put("firstName", rs.getString("first_name"));
                cv.put("lastName", rs.getString("last_name"));
                cv.put("email", rs.getString("email"));
                cv.put("phone", rs.getString("phone"));
                cv.put("birthDate", rs.getString("birth_date"));
                cv.put("address", rs.getString("address"));
                cv.put("education", rs.getString("education"));
                cv.put("experience", rs.getString("experience"));
                cv.put("skills", rs.getString("skills"));
                cv.put("languages", rs.getString("languages"));
                cv.put("createdAt", rs.getString("created_at"));
                System.out.println("✅ CV found: " + cvId);
            }
        } catch (SQLException e) {
            System.err.println("❌ Error getting CV by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return cv;
    }
    
    // ✅ METODĂ PENTRU ACTUALIZARE CV
    public boolean updateCVData(int cvId, Map<String, String> cvData) {
        String sql = "UPDATE cv_data SET first_name = ?, last_name = ?, email = ?, phone = ?, " +
                    "birth_date = ?, address = ?, education = ?, experience = ?, " +
                    "skills = ?, languages = ? WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, cvData.get("firstName"));
            stmt.setString(2, cvData.get("lastName"));
            stmt.setString(3, cvData.get("email"));
            stmt.setString(4, cvData.get("phone"));
            stmt.setString(5, cvData.get("birthDate"));
            stmt.setString(6, cvData.get("address"));
            stmt.setString(7, cvData.get("education"));
            stmt.setString(8, cvData.get("experience"));
            stmt.setString(9, cvData.get("skills"));
            stmt.setString(10, cvData.get("languages"));
            stmt.setInt(11, cvId);
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("✅ CV updated: " + cvId + " (" + rowsAffected + " rows affected)");
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("❌ Error updating CV: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // ✅ METODĂ PENTRU ȘTERGERE CV
    public boolean deleteCV(int cvId, int userId) {
        String sql = "DELETE FROM cv_data WHERE id = ? AND user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, cvId);
            stmt.setInt(2, userId);
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("✅ CV deleted: " + cvId + " (" + rowsAffected + " rows affected)");
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("❌ Error deleting CV: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}