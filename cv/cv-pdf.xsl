<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:output method="xml" indent="yes"/>
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
            <fo:block font-size="22" font-weight="bold">
              <xsl:value-of select="resume/header/name/firstname"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="resume/header/name/surname"/>
            </fo:block>
              
            <fo:block margin-bottom="0.2cm">
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
            </fo:block>
            <fo:block margin-bottom="0.2cm">
              <fo:block>
                <xsl:value-of select="resume/header/contact/email"/>
              </fo:block>
              <fo:block>
                <xsl:value-of select="resume/header/contact/phone"/>
              </fo:block>
            </fo:block>
            <fo:block>
              <xsl:for-each select="resume/header/contact/url">
                <fo:block>
                  <xsl:value-of select="." />
                </fo:block>
              </xsl:for-each>
            </fo:block>
          </fo:block-container><!--address-->

          <fo:block-container position="absolute" top="0" left="8cm" padding="5px">
            <fo:block text-align="center">
              <xsl:for-each select="resume/keywords/keyword">
                <xsl:choose>
                  <xsl:when test="position() = 1">
                    <fo:block font-size="22" margin-bottom="10px" font-weight="bold">
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

          <fo:block-container  position="absolute" top="5cm">
            <fo:block-container position="absolute" left="0cm" width="4cm" >
              <fo:block background-color="#DDDDDD" padding="5px"><!--skills-->      
                <xsl:for-each select="resume/skillarea">
                  <fo:block margin-bottom="0.5cm">
                    <fo:block font-size="14">
                      <xsl:value-of select="title"/>
                    </fo:block>
                    <xsl:for-each select="skillset">
                      <fo:block margin-bottom="0.2cm">
                        <fo:block font-size="12" text-decoration="underline" font-weight="bold">
                          <xsl:value-of select="title"/>
                        </fo:block>
                        <xsl:for-each select="skill">
                          <fo:block font-size="10" margin-left="0.2cm">
                            <xsl:value-of select="."/>
                          </fo:block>
                        </xsl:for-each>
                      </fo:block>
                    </xsl:for-each>
                  </fo:block>
                </xsl:for-each>
              </fo:block><!--/skills-->
              <fo:block font-size="14" margin-top="15px" font-weight="bold">
                <xsl:text>Centres d'intérêt</xsl:text>
              </fo:block>
              <fo:block>      
                <xsl:for-each select="resume/interests/interest">
                  <fo:block font-size="10">
                    <xsl:value-of select="title"/>
                  </fo:block>
                </xsl:for-each>
              </fo:block><!--interest-->  
            </fo:block-container>  
          
            <fo:block-container position="absolute" left="5cm">
              <fo:block margin-bottom="0.5cm">
                <fo:block font-size="18" font-weight="bold" margin-left="10px">
                  <xsl:text>Expériences</xsl:text>  
                </fo:block>     
                <xsl:for-each select="resume/history/job">
                  <fo:block margin-bottom="0.2cm">
                    <fo:block font-size="16">
                      <xsl:value-of select="jobtitle"/>
                    </fo:block>
                    <fo:block font-size="14" color="#999999">
                      <fo:inline font-weight="bold">
                        <xsl:value-of select="period/from/date/year"/>
                        <xsl:if test="period/from/date/year != period/to/date/year">
                          <xsl:text>-</xsl:text>
                          <xsl:value-of select="period/to/date/year"/>
                        </xsl:if>
                      </fo:inline>
                      <xsl:text>: </xsl:text>
                      <xsl:value-of select="employer"/>
                    </fo:block>

                    <xsl:for-each select="achievements/achievement">
                      <fo:list-block>
                        <fo:list-item>
                          <fo:list-item-label start-indent="0.4cm">
                            <fo:block>&#x2022;</fo:block>
                          </fo:list-item-label>
                          <fo:list-item-body start-indent="0.7cm">
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
                          <fo:list-item-label start-indent="0.2cm">
                            <fo:block>-</fo:block>
                          </fo:list-item-label>
                          <fo:list-item-body start-indent="0.5cm">
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

              <fo:block font-size="18" font-weight="bold" margin-left="10px" margin-bottom="5px">
                <xsl:text>Formation</xsl:text> 
              </fo:block>
              <fo:block-container>       
                <xsl:for-each select="resume/academics/degrees/degree">
                  <fo:block-container position="absolute" background-color="#EEEEEE" padding="5px">
                    <xsl:attribute name="left">
                      <xsl:value-of select="(position()-1)*7"/>
                      <xsl:text>cm</xsl:text>
                    </xsl:attribute>
                    <fo:block font-size="15">
                      <xsl:value-of select="level"/>
                      <xsl:text> </xsl:text>
                      <xsl:value-of select="major"/>
                    </fo:block>
                    <fo:block font-size="12" color="#999999">
                      <fo:inline font-weight="bold">
                        <xsl:value-of select="date/year"/>
                      </fo:inline>
                      <xsl:text>: </xsl:text>
                      <xsl:value-of select="institution"/>
                    </fo:block>
                    <fo:block font-size="12">
                      <xsl:value-of select="minor"/>
                    </fo:block>
                    <fo:block font-size="10">
                      <xsl:value-of select="annotation"/>
                    </fo:block>
                  </fo:block-container>
                </xsl:for-each>
              </fo:block-container><!--degree-->

            </fo:block-container>
          </fo:block-container>

        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>
</xsl:stylesheet>