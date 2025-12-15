package ro.isi.lab2;

import org.w3c.dom.*;
import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.xml.sax.*;
import org.xml.sax.helpers.DefaultHandler;
import java.io.*;
import java.util.*;

public class XMLUtil {
    
    // 1. Creare XML folosind DOM (Document Object Model)
    public static boolean saveCVToXML(Map<String, String> cvData, String filePath) {
        try {
            // Creare DocumentBuilder
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document doc = builder.newDocument();
            
            // Element rădăcină
            Element rootElement = doc.createElement("CurriculumVitae");
            doc.appendChild(rootElement);
            
            // Adaugă metadate
            Element meta = doc.createElement("metadata");
            rootElement.appendChild(meta);
            
            Element timestamp = doc.createElement("generated");
            timestamp.setTextContent(new java.util.Date().toString());
            meta.appendChild(timestamp);
            
            Element format = doc.createElement("format");
            format.setTextContent("Europass CV");
            meta.appendChild(format);
            
            // Secțiunea de informații personale
            Element personalInfo = doc.createElement("personalInformation");
            rootElement.appendChild(personalInfo);
            
            addElement(doc, personalInfo, "firstName", cvData.get("firstName"));
            addElement(doc, personalInfo, "lastName", cvData.get("lastName"));
            addElement(doc, personalInfo, "email", cvData.get("email"));
            addElement(doc, personalInfo, "phone", cvData.get("phone"));
            addElement(doc, personalInfo, "birthDate", cvData.get("birthDate"));
            addElement(doc, personalInfo, "address", cvData.get("address"));
            
            // Educație
            Element education = doc.createElement("education");
            rootElement.appendChild(education);
            
            Element eduItem = doc.createElement("item");
            eduItem.setTextContent(cvData.get("education"));
            education.appendChild(eduItem);
            
            // Experiență
            Element experience = doc.createElement("workExperience");
            rootElement.appendChild(experience);
            
            Element expItem = doc.createElement("item");
            expItem.setTextContent(cvData.get("experience"));
            experience.appendChild(expItem);
            
            // Competențe
            if (cvData.get("skills") != null && !cvData.get("skills").isEmpty()) {
                Element skills = doc.createElement("skills");
                rootElement.appendChild(skills);
                
                Element skillItem = doc.createElement("item");
                skillItem.setTextContent(cvData.get("skills"));
                skills.appendChild(skillItem);
            }
            
            // Limbi
            if (cvData.get("languages") != null && !cvData.get("languages").isEmpty()) {
                Element languages = doc.createElement("languages");
                rootElement.appendChild(languages);
                
                Element langItem = doc.createElement("item");
                langItem.setTextContent(cvData.get("languages"));
                languages.appendChild(langItem);
            }
            
            // Scrie XML în fișier
            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            Transformer transformer = transformerFactory.newTransformer();
            transformer.setOutputProperty(OutputKeys.INDENT, "yes");
            transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4");
            
            DOMSource source = new DOMSource(doc);
            StreamResult result = new StreamResult(new File(filePath));
            transformer.transform(source, result);
            
            System.out.println("✅ XML saved to: " + filePath);
            return true;
            
        } catch (Exception e) {
            System.err.println("❌ Error saving XML: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    private static void addElement(Document doc, Element parent, String tagName, String textContent) {
        if (textContent != null && !textContent.trim().isEmpty()) {
            Element element = doc.createElement(tagName);
            element.setTextContent(textContent);
            parent.appendChild(element);
        }
    }
    
    // 2. Parsare XML folosind SAX (Simple API for XML)
    public static Map<String, List<String>> parseXMLWithSAX(String filePath) throws Exception {
        SAXParserFactory factory = SAXParserFactory.newInstance();
        SAXParser saxParser = factory.newSAXParser();
        
        XMLHandler handler = new XMLHandler();
        saxParser.parse(new File(filePath), handler);
        
        return handler.getParsedData();
    }
    
    // SAX Handler pentru parsare
    private static class XMLHandler extends DefaultHandler {
        private Map<String, List<String>> data = new HashMap<>();
        private String currentElement;
        private StringBuilder currentText = new StringBuilder();
        
        @Override
        public void startElement(String uri, String localName, String qName, Attributes attributes) {
            currentElement = qName;
            currentText.setLength(0);
        }
        
        @Override
        public void characters(char[] ch, int start, int length) {
            currentText.append(ch, start, length);
        }
        
        @Override
        public void endElement(String uri, String localName, String qName) {
            String text = currentText.toString().trim();
            if (!text.isEmpty() && !qName.equals("CurriculumVitae")) {
                data.computeIfAbsent(qName, k -> new ArrayList<>()).add(text);
            }
            currentElement = null;
        }
        
        public Map<String, List<String>> getParsedData() {
            return data;
        }
    }
    
    // 3. Citire simplă XML pentru verificare
    public static String readXMLFile(String filePath) {
        StringBuilder content = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                content.append(line).append("\n");
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return content.toString();
    }
    
    // 4. Listare toate fișierele XML din folder
    public static List<String> listXMLFiles(String directoryPath) {
        List<String> xmlFiles = new ArrayList<>();
        File directory = new File(directoryPath);
        
        if (directory.exists() && directory.isDirectory()) {
            File[] files = directory.listFiles((dir, name) -> name.toLowerCase().endsWith(".xml"));
            if (files != null) {
                for (File file : files) {
                    xmlFiles.add(file.getName());
                }
            }
        } else {
            // Creează directorul dacă nu există
            directory.mkdirs();
        }
        
        return xmlFiles;
    }
}