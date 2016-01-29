<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:in="http://ns.bransom.nl/vanace/webitems/v20110101"
	exclude-result-prefixes="in"
	version="1.0">

	<xsl:param name="base-url" />
	<xsl:param name="published">true</xsl:param>
	<xsl:param name="show-date">false</xsl:param>
	<xsl:param name="show-time">false</xsl:param>

	<xsl:include href="persistency-to-xml_a.xsl" />
	<xsl:include href="persistency-to-xml_b.xsl" />
	<xsl:include href="persistency-to-xml_c.xsl" />

	<xsl:output method="xml" encoding="utf-8" indent="no" />

	<!-- main entry point -->
	<xsl:template match="/">
		<xsl:apply-templates select="//in:itemset" />
	</xsl:template>

	<!-- delegate processing to separate style sheets -->
	<xsl:template match="in:itemset">
		<xsl:choose>
			<xsl:when test="in:type = 'A'"><xsl:apply-templates select="." mode="settings_a" /></xsl:when>
			<xsl:when test="in:type = 'B'"><xsl:apply-templates select="." mode="settings_b" /></xsl:when>
			<xsl:when test="in:type = 'C'"><xsl:apply-templates select="." mode="settings_c" /></xsl:when>
			<xsl:otherwise>
				<!-- ERROR: in:type not supported -->
				<xsl:message terminate="yes">
					<xsl:text>Fout in itemset: onbekend type '</xsl:text>
					<xsl:value-of select="in:type" />
					<xsl:text>'.</xsl:text>
				</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- skip entity attributes -->
	<xsl:template match="in:*/@entity" />

	<!-- skip published attributes -->
	<xsl:template match="in:*/@published" />

	<!-- skip timestamp attributes -->
	<xsl:template match="in:*/@at" />

	<!-- skip binary type attributes -->
	<xsl:template match="in:*/@type[. = 'binary']" />

	<!-- map specific node values to boolean -->
	<xsl:template match="@* | text()" mode="number-as-boolean">
		<xsl:choose>
			<xsl:when test="number(.) = 1">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- map specific node values to 'link-target' enumeration -->
	<xsl:template match="@* | text()" mode="number-as-link-target">
		<xsl:choose>
			<xsl:when test="number(.) = 1">_parent</xsl:when>
			<xsl:when test="number(.) = 2">_self</xsl:when>
			<xsl:when test="number(.) = 3">_top</xsl:when>
			<xsl:otherwise>_blank</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- map the timestamp values to a time -->
	<xsl:template match="in:timestamp" mode="as-time">
		<xsl:value-of select="substring(., 12, 2)" />
		<xsl:text>:</xsl:text>
		<xsl:value-of select="substring(., 15, 2)" />
	</xsl:template>

	<!-- map the timestamp values to a date -->
	<xsl:template match="in:timestamp" mode="as-date">
		<xsl:value-of select="substring(., 9, 2)" />
		<xsl:text>-</xsl:text>
		<xsl:value-of select="substring(., 6, 2)" />
		<xsl:text>-</xsl:text>
		<xsl:value-of select="substring(., 1, 4)" />
	</xsl:template>
	<xsl:template match="in:timestamp" mode="as-date-month-nl">
		<xsl:value-of select="substring(., 9, 2)" />
		<xsl:text> </xsl:text>
		<xsl:call-template name="number-as-month-nl">
			<xsl:with-param name="index" select="substring(., 6, 2)" />
		</xsl:call-template>
		<xsl:text> </xsl:text>
		<xsl:value-of select="substring(., 1, 4)" />
	</xsl:template>

	<!-- map specific node values to month name -->
	<xsl:template name="number-as-month-nl">
		<xsl:param name="index" />
		<xsl:choose>
			<xsl:when test="number($index) = 1">januari</xsl:when>
			<xsl:when test="number($index) = 2">februari</xsl:when>
			<xsl:when test="number($index) = 3">maart</xsl:when>
			<xsl:when test="number($index) = 4">april</xsl:when>
			<xsl:when test="number($index) = 5">mei</xsl:when>
			<xsl:when test="number($index) = 6">juni</xsl:when>
			<xsl:when test="number($index) = 7">juli</xsl:when>
			<xsl:when test="number($index) = 8">augustus</xsl:when>
			<xsl:when test="number($index) = 9">september</xsl:when>
			<xsl:when test="number($index) = 10">oktober</xsl:when>
			<xsl:when test="number($index) = 11">november</xsl:when>
			<xsl:when test="number($index) = 12">december</xsl:when>
			<xsl:otherwise>januari</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- map specific node values to a URL -->
	<xsl:template name="image-as-url">
		<xsl:param name="id" />
		<xsl:param name="mediatype" />
		<!-- image URL: '$base-url/image/$id/data.$mediatype?$published=$published',
			e.g. '/webitems/image/33/data.jpg?$published=false' -->
		<xsl:call-template name="base-url" />
		<xsl:text>image/</xsl:text>
		<xsl:value-of select="$id" />
		<xsl:text>/data.</xsl:text>
		<xsl:value-of select="$mediatype" />
		<xsl:if test="$published = 'false'">
			<xsl:text>?$published=false</xsl:text>
		</xsl:if>
	</xsl:template>

        <!-- get the URL of the cutrrent location -->
	<xsl:template name="base-url">
		<xsl:if test="$base-url">
			<xsl:value-of select="$base-url" />
			<xsl:if test="substring($base-url, string-length($base-url)) != '/'">
				<xsl:text>/</xsl:text>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<!-- by default copy all nodes -->
	<xsl:template match="in:*" priority="-1">
		<xsl:if test="normalize-space()">
			<xsl:element name="{local-name()}">
				<xsl:apply-templates select="@* | in:* | text()" />
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<!-- by default copy all attributes and text content, ignoring any namespaces -->
	<xsl:template match="@* | text()" priority="-1">	
		<xsl:copy-of select="@*" />
		<xsl:if test="normalize-space()">
			<xsl:copy>
				<xsl:value-of select="text()" />
			</xsl:copy>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>