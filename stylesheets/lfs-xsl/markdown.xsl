<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Force plain-text output rather than XML/HTML -->
  <xsl:output method="text" encoding="UTF-8" />
  <xsl:strip-space elements="*" />

  <!-- Root node -->
  <xsl:template match="/">
    <xsl:apply-templates />
  </xsl:template>

  <!-- ==================== Suppress Metadata & Indexes ==================== -->
  <!-- Silently drop index terms, info blocks, and title abbreviations -->
  <xsl:template match="indexterm | bookinfo | sect1info | sect2info | titleabbrev" />

  <!-- ==================== Headings ==================== -->
  <!-- Level 1: Book / Part / Chapter titles -->
  <xsl:template match="book/title | part/title | chapter/title | appendix/title | preface/title">
    <xsl:text># </xsl:text>
    <xsl:apply-templates />
    <xsl:text>&#10;&#10;</xsl:text>
  </xsl:template>

  <!-- Level 2: Section 1 / Package titles -->
  <xsl:template match="sect1/title | section/title">
    <xsl:text>## </xsl:text>
    <xsl:apply-templates />
    <xsl:text>&#10;&#10;</xsl:text>
  </xsl:template>

  <!-- Level 3: Section 2 titles (e.g. Installation, Short Descriptions) -->
  <xsl:template match="sect2/title">
    <xsl:text>### </xsl:text>
    <xsl:apply-templates />
    <xsl:text>&#10;&#10;</xsl:text>
  </xsl:template>

  <!-- Level 4: Section 3 titles -->
  <xsl:template match="sect3/title">
    <xsl:text>#### </xsl:text>
    <xsl:apply-templates />
    <xsl:text>&#10;&#10;</xsl:text>
  </xsl:template>

  <!-- Bridgeheads (arbitrary headings LFS uses inside package pages) -->
  <xsl:template match="bridgehead">
    <xsl:text>### </xsl:text>
    <xsl:apply-templates />
    <xsl:text>&#10;&#10;</xsl:text>
  </xsl:template>

  <!-- ==================== Paragraphs ==================== -->
  <xsl:template match="para">
    <xsl:apply-templates />
    <xsl:text>&#10;&#10;</xsl:text>
  </xsl:template>

  <!-- ==================== Inline Formatting ==================== -->
  <!-- Bold -->
  <xsl:template match="emphasis[@role='bold']">
    <xsl:text>**</xsl:text>
    <xsl:apply-templates />
    <xsl:text>**</xsl:text>
  </xsl:template>

  <!-- Italic -->
  <xsl:template match="emphasis">
    <xsl:text>*</xsl:text>
    <xsl:apply-templates />
    <xsl:text>*</xsl:text>
  </xsl:template>

  <!-- Inline Code & Entities (LFS tags like filename, parameter, replaceable) -->
  <xsl:template match="literal | filename | command | userinput | envar | prompt | parameter | option | replaceable | systemitem">
    <xsl:text>`</xsl:text>
    <xsl:apply-templates />
    <xsl:text>`</xsl:text>
  </xsl:template>

  <!-- Phrases / Productnames inside titles or body -->
  <xsl:template match="phrase | productname">
    <xsl:apply-templates />
  </xsl:template>

  <!-- ==================== Code Blocks ==================== -->
  <xsl:template match="screen | programlisting">
    <xsl:text>```bash&#10;</xsl:text>
    <xsl:value-of select="." />
    <xsl:text>&#10;```&#10;&#10;</xsl:text>
  </xsl:template>

  <!-- ==================== Lists ==================== -->
  <!-- Unordered list -->
  <xsl:template match="itemizedlist/listitem">
    <xsl:text>* </xsl:text>
    <xsl:apply-templates />
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <!-- Ordered list -->
  <xsl:template match="orderedlist/listitem">
    <xsl:value-of select="position()" />
    <xsl:text>. </xsl:text>
    <xsl:apply-templates />
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <!-- Variable Lists (Used heavily in LFS for "Short Descriptions") -->
  <xsl:template match="varlistentry">
    <xsl:text>* **</xsl:text>
    <xsl:for-each select="term">
      <xsl:apply-templates />
      <xsl:if test="position() != last()">, </xsl:if>
    </xsl:for-each>
    <xsl:text>**: </xsl:text>
    <xsl:apply-templates select="listitem/para[1]/node()" />
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="variablelist">
    <xsl:apply-templates select="varlistentry" />
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <!-- ==================== Segmented Lists (Package Contents) ==================== -->
  <xsl:template match="seglistitem">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="seg">
    <xsl:text>* </xsl:text>
    <xsl:apply-templates />
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <!-- ==================== Links ==================== -->
  <xsl:template match="ulink">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates />
    <xsl:text>](</xsl:text>
    <xsl:value-of select="@url" />
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="xref">
    <xsl:text>[Section </xsl:text>
    <xsl:value-of select="@linkend" />
    <xsl:text>](#</xsl:text>
    <xsl:value-of select="@linkend" />
    <xsl:text>)</xsl:text>
  </xsl:template>

  <!-- ==================== Admonitions ==================== -->
  <xsl:template match="note | warning | important | tip | caution">
    <xsl:text>> **</xsl:text>
    <xsl:value-of select="translate(local-name(), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
    <xsl:text>:** </xsl:text>
    <xsl:apply-templates select="para[1]/node()" />
    <xsl:text>&#10;&#10;</xsl:text>
  </xsl:template>

</xsl:stylesheet>