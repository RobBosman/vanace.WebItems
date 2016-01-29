<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:in="http://ns.bransom.nl/vanace/webitems/v20110101"
	exclude-result-prefixes="in"
	version="1.0">	

	<!-- put the content of specific nodes in CDATA tags -->
	<xsl:output cdata-section-elements="title subTitle content" />

	<!-- map the itemset node to the value of its name -->
	<xsl:template match="in:itemset" mode="settings_b">
		<data>
			<xsl:apply-templates select="in:settings_b" mode="settings_b" />
			<news>
				<xsl:for-each select="in:item">	
					<xsl:sort select="in:sortIndex_itemset" data-type="number" />
					<xsl:apply-templates select="." mode="settings_b" />
				</xsl:for-each>
			</news>
		</data>
	</xsl:template>

	<!-- map the settings_b node to another name -->
	<xsl:template match="in:settings_b" mode="settings_b">
		<settings>
			<xsl:apply-templates select="in:*" />
		</settings>
	</xsl:template>

	<!-- wrap specific nodes in another node -->
	<xsl:template match="in:item" mode="settings_b">
		<item>
			<xsl:apply-templates select="in:image" mode="settings_b" />
			<title><xsl:value-of select="in:title" /></title>
			<subTitle><xsl:value-of select="in:subTitle" /></subTitle>
			<content><xsl:value-of select="in:content" /></content>
			<xsl:choose>
				<xsl:when test="in:linkText">
					<xsl:apply-templates select="in:linkText | in:linkUrl" />
					<xsl:apply-templates select="in:linkTarget" mode="link-target-as-number" />
				</xsl:when>
				<xsl:otherwise><linkTarget>_blank</linkTarget></xsl:otherwise>
			</xsl:choose>
		</item>
	</xsl:template>

	<!-- map specific nodes to attributes -->
	<xsl:template match="in:image" mode="settings_b">
		<image>
			<xsl:attribute name="width">
				<xsl:choose>
					<xsl:when test="in:width &gt; 0"><xsl:value-of select="in:width" /></xsl:when>
					<xsl:otherwise>271</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="height">
				<xsl:choose>
					<xsl:when test="in:height &gt; 0"><xsl:value-of select="in:height" /></xsl:when>
					<xsl:otherwise>180</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:call-template name="image-as-url">
				<xsl:with-param name="id" select="@id" />
				<xsl:with-param name="mediatype" select="in:mediatype" />
			</xsl:call-template>
		</image>
	</xsl:template>

	<!-- map specific node values to boolean -->
	<xsl:template match="
			in:settings_b/in:showArrows/text()
			| in:settings_b/in:showScrollbar/text()
			| in:settings_b/in:autoPlay/text()
			| in:settings_b/in:pauseOnItemMouseOver/text()
			| in:settings_b/in:itemReflection/text()">
		<xsl:choose>
			<xsl:when test=". = 1">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>