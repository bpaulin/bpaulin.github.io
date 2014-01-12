<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" omit-xml-declaration="yes" encoding="utf-8" indent="yes" media-type="text/html" />
<xsl:template match="/">
<div class="hresume">
  <address class="vcard">
    <span class="fn">
      <xsl:value-of select="resume/header/name/firstname"/>
      <xsl:value-of select="resume/header/name/surname"/>
    </span>
    <span class="adr">
      <span class="street-address"><xsl:value-of select="resume/header/address/street"/></span>
      <span class="locality"><xsl:value-of select="resume/header/address/city"/></span>, 
      <span class="postal-code"><xsl:value-of select="resume/header/address/postalCode"/></span>
      <span class="country-name"><xsl:value-of select="resume/header/address/country"/></span>
    </span>
    Email: <span class="email"><xsl:value-of select="resume/header/contact/email"/></span>
    Homepage: <span class="url"><xsl:value-of select="resume/header/contact/url"/></span>
    Phone: <span class="tel"><xsl:value-of select="resume/header/contact/phone"/></span>
  </address>
  <h2>
    Parcours professionnel
  </h2>
  <div class="vcalendar">
    <xsl:for-each select="resume/history/job"> 
      <article class="experience vevent">
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
  </div>
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
  <h2>
    Compétences
  </h2>
  <xsl:for-each select="resume/skillarea">
    <h3><xsl:value-of select="title"/></h3>
    <xsl:for-each select="skillset">
      <h4><xsl:value-of select="title"/></h4>
      <xsl:for-each select="skill">
        <xsl:value-of select="."/>
        <div class="progress">
          <div class="progress-bar" role="progressbar" aria-valuemin="0" aria-valuemax="10">
            <xsl:attribute name="aria-valuenow">
              <xsl:value-of select="@level" />
            </xsl:attribute>
            <xsl:attribute name="style">
              width: <xsl:value-of select="@level" />0%
            </xsl:attribute>
            <span class="sr-only">40% Complete (success)</span>
          </div>
        </div>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:for-each>
  <h2>
    Centre d'interet
  </h2>
  <ul>
    <xsl:for-each select="resume/interests/interest">
      <li>
        <xsl:value-of select="title"/>
      </li>
    </xsl:for-each>
  </ul>
</div>
</xsl:template>
</xsl:stylesheet>