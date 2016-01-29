<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://ns.bransom.nl/vanace/webitems/v20110101"
	xmlns:out="http://ns.bransom.nl/vanace/webitems/v20110101"
	exclude-result-prefixes="out"
	version="1.0">

	<xsl:template match="/NEWS_READER">
		<xsl:choose>
			<xsl:when test="$site-id">
				<xsl:call-template name="itemset_type_A" />
			</xsl:when>
			<xsl:otherwise>
				<site>
					<name><xsl:value-of select="$site-name" /></name>
					<xsl:call-template name="itemset_type_A" />
				</site>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="itemset_type_A">
		<itemset>
			<xsl:if test="$site-id">
				<xsl:attribute name="ownerId"><xsl:value-of select="$site-id" /></xsl:attribute>
			</xsl:if>
			<name><xsl:value-of select="$itemset-name" /></name>
			<type>A</type>
			<settings_a>
				<xsl:apply-templates select="settings_slider " />
				<xsl:apply-templates select="settings_menu" />
			</settings_a>
			<xsl:apply-templates select="news" />
		</itemset>
	</xsl:template>

	<xsl:template match="/NEWS_READER/settings_slider ">
		<stroke2Radius><xsl:value-of select="@stroke2Radius" /></stroke2Radius>
		<stroke1Radius><xsl:value-of select="@stroke1Radius" /></stroke1Radius>
		<totalWidth><xsl:value-of select="@totalWidth" /></totalWidth>
		<imageStrokePx><xsl:value-of select="@imageStrokePx" /></imageStrokePx>
		<stroke1Color><xsl:value-of select="@stroke1Color" /></stroke1Color>
		<stroke2Color><xsl:value-of select="@stroke2Color" /></stroke2Color>
		<stroke1Px><xsl:value-of select="@stroke1Px" /></stroke1Px>
		<htmlFieldWidth><xsl:value-of select="@htmlFieldWidth" /></htmlFieldWidth>
		<totalHeight><xsl:value-of select="@totalHeight" /></totalHeight>
		<bgRadius><xsl:value-of select="@bgRadius" /></bgRadius>
		<bgColor><xsl:value-of select="@bgColor" /></bgColor>
		<stroke2Px><xsl:value-of select="@stroke2Px" /></stroke2Px>
	</xsl:template>

	<xsl:template match="/NEWS_READER/settings_menu">
		<bgHeight><xsl:value-of select="@bgHeight" /></bgHeight>
		<butDistance><xsl:value-of select="@butDistance" /></butDistance>
		<bgWidth><xsl:value-of select="@bgWidth" /></bgWidth>
		<maskHeight><xsl:value-of select="@maskHeight" /></maskHeight>
		<butHeight><xsl:value-of select="@butHeight" /></butHeight>
	</xsl:template>

	<xsl:template match="/NEWS_READER/news">
		<item>
			<xsl:apply-templates select="@title" />
			<sortIndex_itemset><xsl:value-of select="position()" /></sortIndex_itemset>
			<xsl:apply-templates select="description" />
			<xsl:if test="normalize-space(@date) or normalize-space(@time)">
				<timestamp>
					<xsl:apply-templates select="@date" />
					<xsl:if test="normalize-space(@date) and normalize-space(@time)">
						<xsl:text> </xsl:text>
					</xsl:if>
					<xsl:apply-templates select="@time" />
				</timestamp>
			</xsl:if>
			<linkText><xsl:value-of select="@buttonText" /></linkText>
			<linkUrl><xsl:value-of select="@url" /></linkUrl>
			<linkTarget><xsl:apply-templates select="@target" /></linkTarget>
			<xsl:if test="contains(@picture, '.')">
				<image>
					<caption><xsl:value-of select="substring-after(substring-before(@picture, '.'), '/')" /></caption>
					<mediatype><xsl:value-of select="substring-after(@picture, '.')" /></mediatype>
					<url><xsl:value-of select="$base-url" /><xsl:value-of select="@picture" /></url>
				</image>
			</xsl:if>
		</item>
	</xsl:template>

	<!-- specific templates for nodes that require CDATA tags -->
	<xsl:template match="/NEWS_READER/news/@title">
		<title><xsl:value-of select="." /></title>
	</xsl:template>
	<xsl:template match="/NEWS_READER/news/description">
		<content><xsl:value-of select="." /></content>
	</xsl:template>

	<!-- format date -->
	<xsl:template match="/NEWS_READER/news/@date">
		<xsl:apply-templates select="." mode="as-date" />
	</xsl:template>

	<!-- format time -->
	<xsl:template match="/NEWS_READER/news/@time">
		<xsl:apply-templates select="." mode="as-time" />
	</xsl:template>

	<!-- map the numeric values of specific nodes to an enumeration -->
	<xsl:template match="/NEWS_READER/news/@target">
		<xsl:apply-templates select="." mode="link-target-as-number" />
	</xsl:template>

</xsl:stylesheet>