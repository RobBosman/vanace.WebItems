<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:in="http://ns.bransom.nl/vanace/webitems/v20110101"
	exclude-result-prefixes="in"
	version="1.0">	

	<!-- put the content of specific nodes in CDATA tags -->
	<xsl:output cdata-section-elements="item" />

	<!-- map the itemset node to the value of its name -->
	<xsl:template match="in:itemset" mode="settings_c">
		<News>
			<xsl:apply-templates select="in:settings_c" mode="settings_c" />
			<xsl:for-each select="in:item">	
				<xsl:sort select="in:sortIndex_itemset" data-type="number" />
				<xsl:apply-templates select="." mode="settings_c" />
			</xsl:for-each>
		</News>
	</xsl:template>

	<!-- map the settings_c node to another name -->
	<xsl:template match="in:settings_c" mode="settings_c">
		<settings>
			<xsl:apply-templates select="in:*" />
		</settings>
	</xsl:template>

	<!-- wrap specific nodes in another node -->
	<xsl:template match="in:item" mode="settings_c">
		<content title="{../in:name}">
			<item title="{in:title}">
				<xsl:attribute name="date">
					<xsl:if test="$show-date = 'true'">
						<xsl:apply-templates select="in:timestamp" mode="as-date-month-nl" />
					</xsl:if>
				</xsl:attribute>
				<xsl:value-of select="in:content" />
			</item>
		</content>
	</xsl:template>

</xsl:stylesheet>