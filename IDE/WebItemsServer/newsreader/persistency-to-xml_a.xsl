<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:in="http://ns.bransom.nl/vanace/webitems/v20110101"
	exclude-result-prefixes="in"
	version="1.0">

	<!-- put the content of specific nodes in CDATA tags -->
	<xsl:output cdata-section-elements="description" />

	<!-- map the itemset node to the value of its name -->
	<xsl:template match="in:itemset" mode="settings_a">
		<NEWS_READER>
			<xsl:apply-templates select="in:settings_a" mode="settings_a" />
			<xsl:for-each select="in:item">	
				<xsl:sort select="in:sortIndex_itemset" data-type="number" />
				<xsl:apply-templates select="." mode="settings_a" />
			</xsl:for-each>
		</NEWS_READER>
	</xsl:template>

	<!-- map the settings_b node to another name -->
	<xsl:template match="in:settings_a" mode="settings_a">
		<settings_slider
			bgColor="{in:bgColor}"
			bgRadius="{in:bgRadius}"
			htmlFieldWidth="{in:htmlFieldWidth}"
			imageStrokePx="{in:imageStrokePx}"
			stroke1Color="{in:stroke1Color}"
			stroke1Px="{in:stroke1Px}"
			stroke1Radius="{in:stroke1Radius}"
			stroke2Color="{in:stroke2Color}"
			stroke2Px="{in:stroke2Px}"
			stroke2Radius="{in:stroke2Radius}"
			totalHeight="{in:totalHeight}"
			totalWidth="{in:totalWidth}" />
		<settings_menu
			bgHeight="{in:bgHeight}"
			bgWidth="{in:bgWidth}"
			butDistance="{in:butDistance}"
			butHeight="{in:butHeight}"
			maskHeight="{in:maskHeight}" />
	</xsl:template>

	<!-- wrap specific nodes in another node -->
	<xsl:template match="in:item" mode="settings_a">
		<news title="{in:title}">
			<xsl:if test="in:timestamp">
				<xsl:attribute name="date">
					<xsl:if test="$show-date = 'true'">
						<xsl:apply-templates select="in:timestamp" mode="as-date" />
					</xsl:if>
				</xsl:attribute>
				<xsl:attribute name="time">
					<xsl:if test="$show-time = 'true'">
						<xsl:apply-templates select="in:timestamp" mode="as-time" />
					</xsl:if>
				</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="picture">
				<!-- This attribute must be present to prevent the news reader from crashing.
					It should point to an existing URL to prevent warnings in the logs. -->
				<xsl:choose>
					<xsl:when test="in:image"><xsl:apply-templates select="in:image" mode="settings_a" /></xsl:when>
					<xsl:otherwise><xsl:call-template name="base-url" />no_image.png</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="in:linkText != ''">
				<xsl:attribute name="buttonText"><xsl:value-of select="in:linkText" /></xsl:attribute>
				<xsl:attribute name="url"><xsl:value-of select="in:linkUrl" /></xsl:attribute>
				<xsl:attribute name="target"><xsl:apply-templates select="in:linkTarget/text()" mode="number-as-link-target" /></xsl:attribute>
			</xsl:if>
			<description><xsl:value-of select="in:content" /></description>
		</news>
	</xsl:template>

	<!-- map specific nodes to attributes -->
	<xsl:template match="in:image" mode="settings_a">
		<xsl:call-template name="image-as-url">
			<xsl:with-param name="id" select="@id" />
			<xsl:with-param name="mediatype" select="in:mediatype" />
		</xsl:call-template>
	</xsl:template>

	<!-- map specific node values to boolean -->
	<xsl:template match="
			in:showArrows/text()
			| in:showScrollbar/text()
			| in:autoPlay/text()
			| in:pauseOnItemMouseOver/text()
			| in:itemReflection/text()" mode="settings_a">
		<xsl:apply-templates select="." mode="number-as-boolean" />
	</xsl:template>

</xsl:stylesheet>