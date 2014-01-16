<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" omit-xml-declaration="yes" encoding="utf-8" indent="no" media-type="text/vcard" />
<xsl:template match="/">BEGIN:VCARD
VERSION:3.0
N:<xsl:value-of select="resume/header/name/surname"/>;<xsl:value-of select="resume/header/name/firstname"/>;
FN:<xsl:value-of select="resume/header/name/firstname"/>&#160;<xsl:value-of select="resume/header/name/surname"/>
ADR;TYPE=HOME:;;<xsl:value-of select="resume/header/address/street"/>;<xsl:value-of select="resume/header/address/city"/>;;<xsl:value-of select="resume/header/address/postalCode"/>;<xsl:value-of select="resume/header/address/country"/>;
LABEL;TYPE=HOME:<xsl:value-of select="resume/header/address/street"/>\n<xsl:value-of select="resume/header/address/postalCode"/>&#160;<xsl:value-of select="resume/header/address/city"/>\n<xsl:value-of select="resume/header/address/country"/>
TEL;TYPE=CELL:<xsl:value-of select="resume/header/contact/phone"/>
EMAIL;TYPE=HOME:<xsl:value-of select="resume/header/contact/email"/>
URL:<xsl:value-of select="resume/header/contact/url"/>
BDAY:<xsl:value-of select="resume/header/birth/date/year"/>-<xsl:value-of select="resume/header/birth/date/month"/>-<xsl:value-of select="resume/header/birth/date/dayOfMonth"/>
PHOTO;VALUE=uri:http://www.gravatar.com/avatar/c84405cfcdcb4b95e229a6ae640b621d
END:VCARD
</xsl:template>
</xsl:stylesheet>