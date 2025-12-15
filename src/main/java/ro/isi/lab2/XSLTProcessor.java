package ro.isi.lab2;

import javax.xml.transform.*;
import javax.xml.transform.stream.*;
import java.io.*;
import java.nio.file.*;

public class XSLTProcessor {
    
    // Transformă XML în HTML folosind XSLT
    public static String transformXMLtoHTML(String xmlFilePath, String xslFilePath) {
        try {
            // Creează transformator
            TransformerFactory factory = TransformerFactory.newInstance();
            Source xsl = new StreamSource(new File(xslFilePath));
            Transformer transformer = factory.newTransformer(xsl);
            
            // Sursa XML
            Source xml = new StreamSource(new File(xmlFilePath));
            
            // Destinație (StringWriter pentru a obține rezultatul ca String)
            StringWriter writer = new StringWriter();
            Result result = new StreamResult(writer);
            
            // Aplică transformarea
            transformer.transform(xml, result);
            
            return writer.toString();
            
        } catch (TransformerException e) {
            System.err.println("❌ XSLT Transformation error: " + e.getMessage());
            e.printStackTrace();
            return "<div class='error'>XSLT Transformation failed: " + e.getMessage() + "</div>";
        }
    }
    
    // Transformă și salvează în fișier HTML
    public static boolean transformAndSave(String xmlFilePath, String xslFilePath, String outputHtmlPath) {
        try {
            String htmlContent = transformXMLtoHTML(xmlFilePath, xslFilePath);
            
            // Salvează în fișier
            Files.write(Paths.get(outputHtmlPath), htmlContent.getBytes());
            
            System.out.println("✅ HTML generated: " + outputHtmlPath);
            return true;
            
        } catch (Exception e) {
            System.err.println("❌ Error saving HTML: " + e.getMessage());
            return false;
        }
    }
}