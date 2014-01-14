<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:output method="xml" indent="yes"/>
  <xsl:attribute-set name="test">
      <xsl:attribute name="font-family">Helvetica, Arial</xsl:attribute>
      <xsl:attribute name="color">black</xsl:attribute>
      <xsl:attribute name="font-size">14</xsl:attribute>
  </xsl:attribute-set>
  <xsl:template match="/">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="A4-portrait"
              page-height="29.7cm" page-width="21.0cm" margin="1cm">
          <fo:region-body/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      <fo:page-sequence master-reference="A4-portrait">
        <fo:flow flow-name="xsl-region-body">
          <fo:block-container position="absolute" top="0" left="0">
            <fo:block font-size="16" xsl:use-attribute-sets="test">
              <xsl:value-of select="resume/header/name/firstname"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="resume/header/name/surname"/>
            </fo:block>
            <fo:block>
              <xsl:value-of select="resume/header/address/street"/>
            </fo:block>
            <fo:block>
              <xsl:value-of select="resume/header/address/postalCode"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="resume/header/address/city"/>
              <xsl:text>, </xsl:text>
              <xsl:value-of select="resume/header/address/country"/>
            </fo:block>
            <fo:block>
              <xsl:value-of select="resume/header/contact/email"/>
            </fo:block>
            <fo:block>
              <xsl:value-of select="resume/header/contact/phone"/>
            </fo:block>
            <xsl:for-each select="resume/header/contact/url">
              <fo:block>
                <xsl:value-of select="." />
              </fo:block>
            </xsl:for-each>
          </fo:block-container><!--address-->

          <fo:block-container position="absolute" top="0" left="8cm">
            <fo:block text-align="center">
              <xsl:for-each select="resume/keywords/keyword">
                <xsl:choose>
                  <xsl:when test="position() = 1">
                    <fo:block font-size="22">
                      <xsl:value-of select="." />
                    </fo:block>
                  </xsl:when>
                  <xsl:otherwise>
                    <fo:block>
                      <xsl:value-of select="." />
                    </fo:block>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </fo:block>
          </fo:block-container><!--keywords-->  

          <fo:block-container position="absolute" top="5cm" left="0cm" width="3cm">
            <fo:block>      
              <xsl:for-each select="resume/skillarea">
                <fo:block font-size="14">
                  <xsl:value-of select="title"/>
                </fo:block>
                <xsl:for-each select="skillset">
                  <fo:block font-size="12">
                    <xsl:value-of select="title"/>
                  </fo:block>
                  <xsl:for-each select="skill">
                    <fo:block font-size="10">
                      <xsl:value-of select="."/>
                    </fo:block>
                  </xsl:for-each>
                </xsl:for-each>
              </xsl:for-each>
            </fo:block><!--skills-->
            <fo:block>      
              <xsl:for-each select="resume/interests/interest">
                <fo:block font-size="10">
                  <xsl:value-of select="title"/>
                </fo:block>
              </xsl:for-each>
            </fo:block><!--interest-->  
          </fo:block-container>  
          
          <fo:block-container position="absolute" top="5cm" left="4cm">
            <fo:block>
              <fo:block font-size="18">
                <xsl:text>
                  Expériences
                </xsl:text>  
              </fo:block>     
              <xsl:for-each select="resume/history/job">
                <fo:block margin-bottom="5">
                  <fo:block font-size="16">
                    <xsl:value-of select="jobtitle"/>
                  </fo:block>
                  <fo:block font-size="14" color="#999999">
                    <xsl:value-of select="period/from/date/year"/>
                    <xsl:if test="period/from/date/year != period/to/date/year">
                      <xsl:text>-</xsl:text>
                      <xsl:value-of select="period/to/date/year"/>
                    </xsl:if>
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="employer"/>
                  </fo:block>

                  <xsl:for-each select="achievements/achievement">
                    <fo:list-block>
                      <fo:list-item>
                        <fo:list-item-label end-indent="label-end()">
                          <fo:block>°</fo:block>
                        </fo:list-item-label>
                        <fo:list-item-body start-indent="body-start()">
                          <fo:block font-size="12">
                            <xsl:value-of select="."/>
                          </fo:block>
                        </fo:list-item-body>
                      </fo:list-item>
                    </fo:list-block>
                  </xsl:for-each>

                  <xsl:for-each select="projects/project">
                    <fo:list-block>
                      <fo:list-item>
                        <fo:list-item-label end-indent="label-end()">
                          <fo:block>*</fo:block>
                        </fo:list-item-label>
                        <fo:list-item-body start-indent="body-start()">
                          <fo:block font-size="10">
                            <xsl:value-of select="."/>
                          </fo:block>
                        </fo:list-item-body>
                      </fo:list-item>
                    </fo:list-block>
                  </xsl:for-each>
                </fo:block>
              </xsl:for-each>
            </fo:block><!--experience-->
            <fo:block font-size="18">
              <xsl:text>
                Formation
              </xsl:text> 
            </fo:block>
            <fo:block>       
              <xsl:for-each select="resume/academics/degrees/degree"> 
                <fo:block font-size="16">
                  <xsl:value-of select="level"/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="major"/>
                </fo:block>
                <fo:block font-size="14" color="#999999">
                  <xsl:value-of select="date/year"/>
                  <xsl:text>: </xsl:text>
                  <xsl:value-of select="institution"/>
                </fo:block>
                <fo:block font-size="12">
                  <xsl:value-of select="minor"/>
                </fo:block>
                <fo:block font-size="10">
                  <xsl:value-of select="annotation"/>
                </fo:block>
              </xsl:for-each>
            </fo:block><!--degree-->
          </fo:block-container>

        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>
</xsl:stylesheet>