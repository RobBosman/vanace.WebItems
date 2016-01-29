<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://ns.bransom.nl/vanace/webitems/v20110101"
	xmlns:out="http://ns.bransom.nl/vanace/webitems/v20110101"
	exclude-result-prefixes="out"
	version="1.0">

	<xsl:template match="/data">
		<xsl:choose>
			<xsl:when test="$site-id">
				<xsl:call-template name="itemset_type_B" />
			</xsl:when>
			<xsl:otherwise>
				<site>
					<name><xsl:value-of select="$site-name" /></name>
					<xsl:call-template name="itemset_type_B" />
				</site>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="itemset_type_B">
		<itemset>
			<xsl:if test="$site-id">
				<xsl:attribute name="ownerId"><xsl:value-of select="$site-id" /></xsl:attribute>
			</xsl:if>
			<name><xsl:value-of select="$itemset-name" /></name>
			<xsl:apply-templates select="*" />
		</itemset>
	</xsl:template>

	<xsl:template match="/data/settings">
		<type>B</type>
		<settings_b>
			<xsl:apply-templates select="*" />
		</settings_b>
	</xsl:template>

	<xsl:template match="/data/news">
		<xsl:apply-templates select="item" />
	</xsl:template>

	<xsl:template match="/data/news/item">
		<item>
			<sortIndex_itemset><xsl:value-of select="position()" /></sortIndex_itemset>
			<xsl:apply-templates select="*" />
		</item>
	</xsl:template>

	<!-- specific templates for nodes that require CDATA tags -->
	<xsl:template match="/data/news/item/title">
		<title><xsl:value-of select="." /></title>
	</xsl:template>
	<xsl:template match="/data/news/item/subTitle">
		<subTitle><xsl:value-of select="." /></subTitle>
	</xsl:template>
	<xsl:template match="/data/news/item/content">
		<content><xsl:value-of select="." /></content>
	</xsl:template>

	<xsl:template match="/data/news/item/image">
		<image>
			<width><xsl:value-of select="@width" /></width>
			<height><xsl:value-of select="@height" /></height>
			<caption><xsl:value-of select="substring-after(substring-before(., '.'), '/')" /></caption>
			<mediatype><xsl:value-of select="substring-after(., '.')" /></mediatype>
			<url><xsl:value-of select="$base-url" /><xsl:value-of select="." /></url>
		</image>
	</xsl:template>

	<!-- map boolean node values to numbers -->
	<xsl:template match="
			/data/settings/showArrows/text()
			| /data/settings/showScrollbar/text()
			| /data/settings/autoPlay/text()
			| /data/settings/pauseOnItemMouseOver/text()
			| /data/settings/itemReflection/text()">
			<xsl:apply-templates select="." mode="boolean-as-number" />
	</xsl:template>

	<!-- map the numeric values of specific nodes to an enumeration -->
	<xsl:template match="/data/news/item/linkTarget/text()">
			<xsl:apply-templates select="." mode="link-target-as-number" />
	</xsl:template>

</xsl:stylesheet>