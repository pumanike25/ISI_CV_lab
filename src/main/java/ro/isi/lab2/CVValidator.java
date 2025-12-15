package ro.isi.lab2;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

public class CVValidator {
    
    public Map<String, String> validateCV(Map<String, String> formData) {
        Map<String, String> errors = new HashMap<>();
        
        // Validare nume
        String firstName = formData.get("firstName");
        if (firstName == null || firstName.trim().isEmpty()) {
            errors.put("firstName", "First name is required");
        } else if (firstName.length() < 2) {
            errors.put("firstName", "First name must be at least 2 characters");
        } else if (!isValidName(firstName)) {
            errors.put("firstName", "First name can only contain letters and spaces");
        }
        
        // Validare nume de familie
        String lastName = formData.get("lastName");
        if (lastName == null || lastName.trim().isEmpty()) {
            errors.put("lastName", "Last name is required");
        } else if (lastName.length() < 2) {
            errors.put("lastName", "Last name must be at least 2 characters");
        } else if (!isValidName(lastName)) {
            errors.put("lastName", "Last name can only contain letters and spaces");
        }
        
        // Validare email
        String email = formData.get("email");
        if (email == null || email.trim().isEmpty()) {
            errors.put("email", "Email is required");
        } else if (!isValidEmail(email)) {
            errors.put("email", "Invalid email format (example: name@domain.com)");
        }
        
        // Validare telefon
        String phone = formData.get("phone");
        if (phone != null && !phone.trim().isEmpty() && !isValidPhone(phone)) {
            errors.put("phone", "Invalid phone number format (example: +40 123 456 789)");
        }
        
        // Validare data nașterii
        String birthDate = formData.get("birthDate");
        if (birthDate == null || birthDate.trim().isEmpty()) {
            errors.put("birthDate", "Birth date is required");
        } else if (!isValidDate(birthDate)) {
            errors.put("birthDate", "Invalid date format");
        }
        
        // Validare educație
        String education = formData.get("education");
        if (education == null || education.trim().isEmpty()) {
            errors.put("education", "Education information is required");
        } else if (education.trim().length() < 10) {
            errors.put("education", "Please provide more detailed education information");
        }
        
        // Validare experiență
        String experience = formData.get("experience");
        if (experience == null || experience.trim().isEmpty()) {
            errors.put("experience", "Work experience is required");
        } else if (experience.trim().length() < 10) {
            errors.put("experience", "Please provide more detailed work experience");
        }
        
        return errors;
    }
    
    private boolean isValidName(String name) {
        String nameRegex = "^[a-zA-Z\\s-]+$";
        return Pattern.compile(nameRegex).matcher(name).matches();
    }
    
    private boolean isValidEmail(String email) {
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
        return Pattern.compile(emailRegex).matcher(email).matches();
    }
    
    private boolean isValidPhone(String phone) {
        // Acceptă: +40 123 456 789, 0123 456 789, 0712-345-678, etc.
        String phoneRegex = "^[+]?[0-9\\s-()]{10,}$";
        return Pattern.compile(phoneRegex).matcher(phone).matches();
    }
    
    private boolean isValidDate(String date) {
        // Validare simplă pentru format data
        String dateRegex = "^\\d{4}-\\d{2}-\\d{2}$";
        return Pattern.compile(dateRegex).matcher(date).matches();
    }
}