package ro.isi.lab2;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DatabaseUtil {
    // Configurația ta pentru baza de date
    private static final String HOST = "";
    private static final String DB_NAME = "";
    private static final String USERNAME = "";
    private static final String PASSWORD = "";
    private static final String URL = "jdbc:mysql://" + HOST + ":3306/" + DB_NAME;
    
    static {
        try {
            // Încarcă driver-ul MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✅ MySQL JDBC Driver loaded successfully");
            
            // Testează conexiunea la inițializare
            testConnection();
            
            // Initializează baza de date
            initializeDatabase();
            
        } catch (ClassNotFoundException e) {
            System.err.println("❌ MySQL JDBC Driver not found!");
            e.printStackTrace();
        }
    }
    
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
    
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            System.out.println("✅ Conexiune la baza de date REUSITĂ!");
            System.out.println("📊 Database: " + DB_NAME + " pe " + HOST);
            return true;
        } catch (SQLException e) {
            System.err.println("❌ Eroare conexiune MySQL:");
            System.err.println("   URL: " + URL);
            System.err.println("   User: " + USERNAME);
            System.err.println("   Error: " + e.getMessage());
            return false;
        }
    }
    
    private static void initializeDatabase() {
        try (Connection conn = getConnection(); Statement stmt = conn.createStatement()) {
            
            System.out.println("🔄 Initializare structură baza de date...");
            
            // Create users table
            String createUsersTable = "CREATE TABLE IF NOT EXISTS users (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "username VARCHAR(50) UNIQUE NOT NULL, " +
                    "password VARCHAR(100) NOT NULL, " +
                    "role ENUM('admin', 'user') DEFAULT 'user', " +
                    "email VARCHAR(100) NOT NULL, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)";
            stmt.execute(createUsersTable);
            System.out.println("✅ Tabela 'users' creată/verificată");
            
            // Create cv_data table
            String createCVTable = "CREATE TABLE IF NOT EXISTS cv_data (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT, " +
                    "first_name VARCHAR(100) NOT NULL, " +
                    "last_name VARCHAR(100) NOT NULL, " +
                    "email VARCHAR(100) NOT NULL, " +
                    "phone VARCHAR(20), " +
                    "birth_date DATE NOT NULL, " +
                    "address TEXT, " +
                    "education TEXT NOT NULL, " +
                    "experience TEXT NOT NULL, " +
                    "skills TEXT, " +
                    "languages TEXT, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "FOREIGN KEY (user_id) REFERENCES users(id))";
            stmt.execute(createCVTable);
            System.out.println("✅ Tabela 'cv_data' creată/verificată");
            
            // Insert default users (doar dacă nu există deja)
            String checkUsers = "SELECT COUNT(*) FROM users";
            ResultSet rs = stmt.executeQuery(checkUsers); // SCHIMBAT de la 'var' la 'ResultSet'
            rs.next();
            int userCount = rs.getInt(1);
            
            if (userCount == 0) {
                String insertAdmin = "INSERT INTO users (username, password, role, email) VALUES " +
                        "('admin', 'admin123', 'admin', 'admin@cvsystem.com'), " +
                        "('user', 'user123', 'user', 'user@cvsystem.com')";
                stmt.execute(insertAdmin);
                System.out.println("✅ Utilizatori demo adăugați");
            } else {
                System.out.println("ℹ️  Utilizatori existenți deja în baza de date");
            }
            
            System.out.println("🎉 Initializare baza de date completă!");
            
        } catch (SQLException e) {
            System.err.println("❌ Eroare la initializarea bazei de date:");
            e.printStackTrace();
        }
    }
}