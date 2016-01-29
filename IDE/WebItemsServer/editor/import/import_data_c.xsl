<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://ns.bransom.nl/vanace/webitems/v20110101"
	xmlns:out="http://ns.bransom.nl/vanace/webitems/v20110101"
	exclude-result-prefixes="out"
	version="1.0">

	<xsl:template match="/News">
		<xsl:choose>
			<xsl:when test="$site-id">
				<xsl:call-template name="itemset_type_C" />
			</xsl:when>
			<xsl:otherwise>
				<site>
					<name><xsl:value-of select="$site-name" /></name>
					<xsl:call-template name="itemset_type_C" />
				</site>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="itemset_type_C">
		<itemset>
			<xsl:if test="$site-id">
				<xsl:attribute name="ownerId"><xsl:value-of select="$site-id" /></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="settings" />
			<xsl:apply-templates select="content" />
		</itemset>
	</xsl:template>

	<xsl:template match="/News/settings">
		<type>C</type>
		<settings_c>
			<xsl:apply-templates select="*" />
		</settings_c>
	</xsl:template>

	<xsl:template match="/News/content">
		<name>
			<xsl:choose>
				<xsl:when test="$itemset-name != ''"><xsl:value-of select="$itemset-name" /></xsl:when>
				<xsl:otherwise><xsl:value-of select="@title" /></xsl:otherwise>
			</xsl:choose>
		</name>
		<xsl:apply-templates select="item" />
	</xsl:template>

	<xsl:template match="/News/content/item">
		<item>
			<sortIndex_itemset><xsl:value-of select="position()" /></sortIndex_itemset>
			<title><xsl:value-of select="@title" /></title>
			<timestamp><xsl:apply-templates select="@date" mode="as-date" /></timestamp>
			<content><xsl:value-of select="." /></content>
		</item>
	</xsl:template>

</xsl:stylesheet>