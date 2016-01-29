<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://ns.bransom.nl/vanace/webitems/v20110101"
	xmlns:out="http://ns.bransom.nl/vanace/webitems/v20110101"
	exclude-result-prefixes="out"
	version="1.0">

	<xsl:param name="base-url" />
	<xsl:param name="site-id" />
	<xsl:param name="site-name" />
	<xsl:param name="itemset-name" />

	<!-- put the content of specific nodes in CDATA tags -->
	<xsl:output method="xml" encoding="utf-8" indent="no"
		cdata-section-elements="title subTitle content" />

	<xsl:include href="import_data_a.xsl" />
	<xsl:include href="import_data_b.xsl" />
	<xsl:include href="import_data_c.xsl" />

	<!-- map 'link-target' enumerations to a number -->
	<xsl:template match="@* | text()" mode="link-target-as-number">
		<xsl:choose>
			<xsl:when test=". = '_blank'">0</xsl:when>
			<xsl:when test=". = '_parent'">1</xsl:when>
			<xsl:when test=". = '_self'">2</xsl:when>
			<xsl:when test=". = '_top'">3</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- map boolean values to a number -->
	<xsl:template match="@* | text()" mode="boolean-as-number">
		<xsl:choose>
			<xsl:when test=". = 'true'">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- format date to yyyy-MM-dd -->
	<xsl:template match="@* | text()" mode="as-date">
		<xsl:choose>
			<!-- dd-MM-yyyy -->
			<xsl:when test="contains(., '-')">
				<xsl:value-of select="substring(., 7, 4)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(., 4, 2)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(., 1, 2)" />
			</xsl:when>
			<!-- dd month yyyy -->
			<xsl:when test="contains(., ' ')">
				<xsl:value-of select="substring-after(substring-after(., ' '), ' ')" />
				<xsl:text>-</xsl:text>
				<xsl:call-template name="month-nl-as-number">
					<xsl:with-param name="name" select="substring-before(substring-after(., ' '), ' ')" />
				</xsl:call-template>
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring-before(., ' ')" />
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- map month name to a number -->
	<xsl:template name="month-nl-as-number">
		<xsl:param name="name" />
		<xsl:choose>
			<xsl:when test="$name = 'januari'">01</xsl:when>
			<xsl:when test="$name = 'februari'">02</xsl:when>
			<xsl:when test="$name = 'maart'">03</xsl:when>
			<xsl:when test="$name = 'april'">04</xsl:when>
			<xsl:when test="$name = 'mei'">05</xsl:when>
			<xsl:when test="$name = 'juni'">06</xsl:when>
			<xsl:when test="$name = 'juli'">07</xsl:when>
			<xsl:when test="$name = 'augustus'">08</xsl:when>
			<xsl:when test="$name = 'september'">09</xsl:when>
			<xsl:when test="$name = 'oktober'">10</xsl:when>
			<xsl:when test="$name = 'november'">11</xsl:when>
			<xsl:when test="$name = 'december'">12</xsl:when>
			<xsl:otherwise>01</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- format time to HH:mm:00 -->
	<xsl:template match="@* | text()" mode="as-time">
		<xsl:if test="normalize-space()">
			<xsl:value-of select="substring(., 1, 5)" />
			<xsl:text>:00</xsl:text>
		</xsl:if>
	</xsl:template>

	<!-- copy data nodes -->
	<xsl:template match="*">
		<xsl:element name="{local-name()}">
			<xsl:apply-templates select="@* | * | text()" />
		</xsl:element>
	</xsl:template>

	<!-- by default copy all attributes and text content, ignoring any namespaces -->
	<xsl:template match="@* | text()">	
		<xsl:copy-of select="@*" />
		<xsl:if test="normalize-space()">
			<xsl:copy>
				<xsl:value-of select="text()" />
			</xsl:copy>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>