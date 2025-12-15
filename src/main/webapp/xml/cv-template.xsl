<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="/">
        <html lang="en">
        <head>
            <meta charset="UTF-8"/>
            <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
            <title>Europass CV - XSLT Generated</title>
            <style>
                body {
                    font-family: 'Arial', sans-serif;
                    line-height: 1.6;
                    color: #333;
                    max-width: 1000px;
                    margin: 0 auto;
                    padding: 20px;
                    background-color: #f9f9f9;
                }
                
                .cv-container {
                    background: white;
                    padding: 40px;
                    border-radius: 10px;
                    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                }
                
                .cv-header {
                    background: #003366;
                    color: white;
                    padding: 30px;
                    border-radius: 8px;
                    margin-bottom: 30px;
                    text-align: center;
                }
                
                .cv-header h1 {
                    margin: 0;
                    font-size: 2.5em;
                }
                
                .cv-section {
                    margin-bottom: 30px;
                    padding-bottom: 20px;
                    border-bottom: 2px solid #eee;
                }
                
                .cv-section:last-child {
                    border-bottom: none;
                }
                
                .section-title {
                    color: #003366;
                    font-size: 1.5em;
                    margin-bottom: 15px;
                    padding-bottom: 5px;
                    border-bottom: 2px solid #003366;
                }
                
                .personal-info-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                    gap: 15px;
                }
                
                .info-item {
                    margin-bottom: 10px;
                }
                
                .info-label {
                    font-weight: bold;
                    color: #555;
                }
                
                .content-box {
                    background: #f8f9fa;
                    padding: 15px;
                    border-radius: 5px;
                    border-left: 4px solid #003366;
                    margin-top: 10px;
                }
                
                .metadata {
                    font-size: 0.9em;
                    color: #666;
                    text-align: right;
                    margin-top: 30px;
                    padding-top: 15px;
                    border-top: 1px dashed #ccc;
                }
                
                @media print {
                    .cv-container {
                        box-shadow: none;
                        padding: 0;
                    }
                    
                    body {
                        background: white;
                    }
                }
            </style>
        </head>
        <body>
            <div class="cv-container">
                <div class="cv-header">
                    <h1>Europass Curriculum Vitae</h1>
                    <p>Generated from XML using XSLT</p>
                </div>
                
                <xsl:apply-templates select="CurriculumVitae"/>
                
                <div class="metadata">
                    <p>Document generated: 
                        <xsl:value-of select="CurriculumVitae/metadata/generated"/>
                    </p>
                    <p>Format: <xsl:value-of select="CurriculumVitae/metadata/format"/></p>
                </div>
            </div>
        </body>
        </html>
    </xsl:template>
    
    <xsl:template match="CurriculumVitae">
        <!-- Personal Information -->
        <div class="cv-section">
            <h2 class="section-title">Personal Information</h2>
            <div class="personal-info-grid">
                <div class="info-item">
                    <span class="info-label">Name:</span>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="personalInformation/firstName"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="personalInformation/lastName"/>
                </div>
                
                <div class="info-item">
                    <span class="info-label">Email:</span>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="personalInformation/email"/>
                </div>
                
                <div class="info-item">
                    <span class="info-label">Phone:</span>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="personalInformation/phone"/>
                </div>
                
                <div class="info-item">
                    <span class="info-label">Date of Birth:</span>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="personalInformation/birthDate"/>
                </div>
                
                <div class="info-item" style="grid-column: 1 / -1;">
                    <span class="info-label">Address:</span>
                    <div class="content-box">
                        <xsl:value-of select="personalInformation/address"/>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Education -->
        <div class="cv-section">
            <h2 class="section-title">Education and Training</h2>
            <div class="content-box">
                <xsl:value-of select="education/item"/>
            </div>
        </div>
        
        <!-- Work Experience -->
        <div class="cv-section">
            <h2 class="section-title">Work Experience</h2>
            <div class="content-box">
                <xsl:value-of select="workExperience/item"/>
            </div>
        </div>
        
        <!-- Skills -->
        <xsl:if test="skills">
            <div class="cv-section">
                <h2 class="section-title">Personal Skills</h2>
                <div class="content-box">
                    <xsl:value-of select="skills/item"/>
                </div>
            </div>
        </xsl:if>
        
        <!-- Languages -->
        <xsl:if test="languages">
            <div class="cv-section">
                <h2 class="section-title">Languages</h2>
                <div class="content-box">
                    <xsl:value-of select="languages/item"/>
                </div>
            </div>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>