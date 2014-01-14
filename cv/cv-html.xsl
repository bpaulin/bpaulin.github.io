<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" omit-xml-declaration="yes" encoding="utf-8" indent="yes" media-type="text/html" />
<xsl:template match="/">
<div class="hresume row">
  <div class="col-sm-4">  
    <address class="vcard">
      <strong class="fn">
        <xsl:value-of select="resume/header/name/firstname"/>&#160;<xsl:value-of select="resume/header/name/surname"/>
      </strong>
      <ul class="adr list-unstyled">
        <li>
          <span class="street-address"><xsl:value-of select="resume/header/address/street"/></span>
        </li>
        <li>
          <span class="postal-code"><xsl:value-of select="resume/header/address/postalCode"/></span>&#160;<span class="locality"><xsl:value-of select="resume/header/address/city"/></span>,&#160;<span class="country-name"><xsl:value-of select="resume/header/address/country"/></span>
        </li>
      </ul>
      <ul class="list-unstyled">
        <li>
          <a class="email">
              <xsl:attribute name="href">
                mailto:<xsl:value-of select="resume/header/contact/email" />
              </xsl:attribute>
            <xsl:value-of select="resume/header/contact/email"/>
          </a>
        </li>
        <li>
          <span class="tel"><xsl:value-of select="resume/header/contact/phone"/></span>
        </li>
        <xsl:for-each select="resume/header/contact/url">
          <li>
            <a class="url">
                <xsl:attribute name="href">
                  <xsl:value-of select="." />
                </xsl:attribute>
              <xsl:value-of select="."/>
            </a>
          </li>
        </xsl:for-each>
      </ul>
    </address>
  </div>
  <div class="col-sm-8 text-center keywords">
    <xsl:for-each select="resume/keywords/keyword">
      <div class="keyword">
        <xsl:value-of select="." />
      </div>
    </xsl:for-each>
  </div>  
</div>
<div class="hresume row">
  <aside class="col-sm-3">  
    <h2>
      Compétences
    </h2>
    <section class="skills">
      <xsl:for-each select="resume/skillarea">
        <h3><xsl:value-of select="title"/></h3>
        <xsl:for-each select="skillset">
          <h4><xsl:value-of select="title"/></h4>
          <xsl:for-each select="skill">
            <div class="row">
              <div class="col-xs-4">
                <div class="progress">
                  <div class="progress-bar" role="progressbar" aria-valuemin="0" aria-valuemax="10">
                    <xsl:attribute name="aria-valuenow">
                      <xsl:value-of select="@level" />
                    </xsl:attribute>
                    <xsl:attribute name="style">
                      width: <xsl:value-of select="@level" />0%
                    </xsl:attribute>
                    <span class="sr-only"><xsl:value-of select="@level" />/10</span>
                  </div>
                </div>
              </div>
              <div class="col-xs-8">
                <span class="skill" rel="tag" >
                  <xsl:value-of select="."/>
                </span>
              </div>
            </div>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:for-each>
    </section>
    <h2>
      Centres d'intérêt
    </h2>
    <ul class="list-unstyled">
      <xsl:for-each select="resume/interests/interest">
        <li>
          <xsl:value-of select="title"/>
        </li>
      </xsl:for-each>
    </ul>
  </aside>
  <div class="col-sm-9">
    <h2>
      Expériences
    </h2>
    <div class="vcalendar">
      <xsl:for-each select="resume/history/job"> 
        <article class="experience vevent">
          <header>
            <h3>
              <span>
                <xsl:value-of select="jobtitle"/> 
              </span>
            </h3>
            <div>
              <strong>
                <xsl:value-of select="period/from/date/year"/>
                <xsl:if test="period/from/date/year != period/to/date/year">
                  /
                  <xsl:value-of select="period/to/date/year"/>
                </xsl:if>
              </strong>
              : 
              <xsl:value-of select="employer"/>
            </div>
          </header>
          <ul class="fa-ul">
            <xsl:for-each select="achievements/achievement">
              <li>
                <i class="fa-li fa fa-check-circle"></i>
                <xsl:value-of select="."/>
              </li> 
            </xsl:for-each>
          </ul>
          <ul class="fa-ul projects">
            <xsl:for-each select="projects/project">
              <li>
                <i class="fa-li fa fa-chevron-circle-right"></i>
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
      <article class="education">
        <header>
          <h3>
            <xsl:value-of select="level"/>&#160;
            <xsl:value-of select="major"/>
          </h3>
          <div>
            <strong>
              <xsl:value-of select="date/year"/>
              :
              <xsl:value-of select="institution"/>
            </strong>
          </div>
          <ul class="list-unstyled">
            <li><xsl:value-of select="minor"/></li>
            <li><em><xsl:value-of select="annotation"/></em></li>
          </ul>
        </header>
      </article>
    </xsl:for-each>
  </div>
</div>
</xsl:template>
</xsl:stylesheet>