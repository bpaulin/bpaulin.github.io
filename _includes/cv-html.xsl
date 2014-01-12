<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" omit-xml-declaration="yes" encoding="utf-8" indent="yes" media-type="text/html" />
<xsl:template match="/">
  <xsl:value-of select="resume/header/name/firstname"/>
  <h2>
    Parcours professionnel
  </h2>
  <xsl:for-each select="resume/history/job"> 
    <article>
      <header>
        <h3>
          <span class="label label-info">
            <xsl:value-of select="period/from/date/year"/>
            -
            <xsl:value-of select="period/to/date/year"/> 
          </span> 
          <span>
            <xsl:value-of select="jobtitle"/> 
          </span>
          <span class="small">
            <xsl:value-of select="employer"/>
          </span>
        </h3>
      </header>
      <ul class="list-unstyled">
        <xsl:for-each select="projects/project">
          <li>
              <xsl:value-of select="."/>
          </li> 
        </xsl:for-each>
      </ul>
    </article>
  </xsl:for-each>
  <h2>
    Formation
  </h2>
  <xsl:for-each select="resume/academics/degrees/degree"> 
    <article>
      <header>
        <h3>
          <xsl:value-of select="level"/>
          <xsl:value-of select="major"/>
          <xsl:value-of select="minor"/>
          <xsl:value-of select="date/year"/>
        </h3>
        <p>
          <xsl:value-of select="institution"/>
          <xsl:value-of select="annotation"/>
        </p>
      </header>
    </article>
  </xsl:for-each>
</xsl:template>
</xsl:stylesheet>