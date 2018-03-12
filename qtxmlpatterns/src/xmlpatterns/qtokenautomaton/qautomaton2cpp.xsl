<?xml version='1.0' encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xml:lang="en"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:local="http://www.w3.org/2005/xquery-local-functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <xsl:variable name="className" as="xs:string" select="tokenAutomaton/@className"/>
    <xsl:variable name="defaultToken" as="xs:string" select="tokenAutomaton/@defaultToken"/>
    <xsl:variable name="tokens" as="element(token)+" select="tokenAutomaton/tokens/token"/>
    <xsl:variable name="tokenEnum" as="xs:string" select="tokenAutomaton/@tokenEnum"/>

    <xsl:variable name="warningGenerated" as="xs:string">/* NOTE: This file is AUTO GENERATED by qautomaton2cpp.xsl. */&#xA;</xsl:variable>

    <xsl:template match="tokenAutomaton">

        <xsl:variable name="uniqueLengths" as="xs:integer+" select="distinct-values(tokens/token/string-length())"/>

        <xsl:result-document method="text" href="{@headerFile}">

            <xsl:variable name="includeGuardName" select="string(@includeGuardName)"/>

            <xsl:value-of select="boilerplate/prolog"/>

            <xsl:value-of select="$warningGenerated"/>

            <xsl:text>&#xA;#ifndef </xsl:text>
            <xsl:value-of select="$includeGuardName"/>
            <xsl:text>&#xA;#define </xsl:text>
            <xsl:value-of select="$includeGuardName"/>
            <xsl:text>&#xA;&#xA;</xsl:text>

            <xsl:text>#include &lt;QtCore/QString>&#xA;</xsl:text>
            <xsl:text>&#xA;</xsl:text>
            <xsl:text>QT_BEGIN_NAMESPACE&#xA;</xsl:text>
            <xsl:text>&#xA;</xsl:text>

            <xsl:if test="@namespace">
                <xsl:text>namespace </xsl:text>
                <xsl:value-of select="@namespace"/>
                {
            </xsl:if>

            <xsl:text>class </xsl:text>
            <xsl:value-of select="@className"/>
                {
                <xsl:value-of select="@scope"/>:
                <xsl:text>enum </xsl:text>
                <xsl:value-of select="$tokenEnum"/>
                <xsl:text>&#xA;</xsl:text>
                {
                <xsl:value-of separator=",&#xA;">
                    <xsl:sequence select="@defaultToken"/>
                    <xsl:perform-sort select="tokens/token/local:tokenToEnumName(.)">
                        <xsl:sort select="."/>
                    </xsl:perform-sort>
                </xsl:value-of>
                };

                <xsl:text>static inline </xsl:text>
                <xsl:value-of select="$tokenEnum"/>
                <xsl:text> toToken(const QString &amp;value);&#xA;</xsl:text>
                <xsl:text>static inline </xsl:text>
                <xsl:value-of select="$tokenEnum"/>
                <xsl:text> toToken(const QStringRef &amp;value);&#xA;</xsl:text>
                <xsl:text>static </xsl:text>
                <xsl:value-of select="$tokenEnum"/>
                <xsl:text> toToken(const QChar *data, int length);&#xA;</xsl:text>
                    <xsl:if test="xs:boolean(@hasToString)">
                        <xsl:text>static QString toString(</xsl:text>
                        <xsl:value-of select="$tokenEnum"/>
                        <xsl:text> token);&#xA;</xsl:text>
                    </xsl:if>

                private:
                    <xsl:for-each select="$uniqueLengths">
                        <xsl:sort select="."/>
                        <xsl:text>static inline </xsl:text>
                        <xsl:value-of select="$tokenEnum"/>
                        <xsl:text> classifier</xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:text>(const QChar *data);&#xA;</xsl:text>
                    </xsl:for-each>
                };

                <xsl:text>inline </xsl:text>
                <xsl:value-of select="@className"/>::<xsl:value-of select="$tokenEnum"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="@className"/>::toToken(const QString &amp;value)
                {
                    return toToken(value.constData(), value.length());
                }

                <xsl:text>inline </xsl:text>
                <xsl:value-of select="@className"/>::<xsl:value-of select="$tokenEnum"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="@className"/>::toToken(const QStringRef &amp;value)
                {
                    return toToken(value.constData(), value.length());
                }

                <xsl:if test="@namespace">
                    <xsl:text>}&#xA;</xsl:text>
                </xsl:if>

                <xsl:text>&#xA;</xsl:text>
                <xsl:text>QT_END_NAMESPACE&#xA;</xsl:text>
                <xsl:text>&#xA;</xsl:text>

                <xsl:text>#endif&#xA;</xsl:text>
        </xsl:result-document>

        <xsl:result-document method="text" href="{@sourceFile}">
            <xsl:value-of select="boilerplate/prolog"/>

            <xsl:value-of select="$warningGenerated"/>

            <xsl:text>&#xA;#include "</xsl:text>
            <xsl:value-of select="@headerFile"/>
            <xsl:text>"&#xA;</xsl:text>
            <xsl:text>&#xA;</xsl:text>
            <xsl:text>QT_BEGIN_NAMESPACE&#xA;</xsl:text>

            <xsl:if test="@namespace">
                <xsl:text>&#xA;</xsl:text>
                <xsl:text>using namespace </xsl:text>
                <xsl:value-of select="@namespace"/>
                <xsl:text>;&#xA;</xsl:text>
            </xsl:if>

            <xsl:text>&#xA;</xsl:text>
            <xsl:variable name="tokens" select="tokens/token"/>

            <xsl:for-each select="$uniqueLengths">
                <xsl:sort select="."/>
                <xsl:call-template name="generate-classifier">
                    <xsl:with-param name="strings" select="$tokens[string-length() eq current()]"/>
                </xsl:call-template>
            </xsl:for-each>

            <xsl:value-of select="@className"/>::<xsl:value-of select="$tokenEnum"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="@className"/>::toToken(const QChar *data, int length)
            {
                switch(length)
                {
                    <xsl:for-each select="$uniqueLengths">
                        <xsl:sort data-type="number" select="."/>
                        case <xsl:value-of select="."/>:
                            return classifier<xsl:value-of select="."/>(data);

                    </xsl:for-each>
                        default:
                            return <xsl:value-of select="@defaultToken"/>;
                }
            }

            <xsl:if test="xs:boolean(@hasToString)">
                QString <xsl:value-of select="@className"/>::toString(<xsl:value-of select="$tokenEnum"/> token)
                {
                    const unsigned short *data = 0;
                    int length = 0;

                    switch(token)
                    {
                    <xsl:for-each select="tokens/token">
                        <xsl:sort select="local:tokenToEnumName(.)"/>
                        case <xsl:sequence select="local:tokenToEnumName(.)"/>:
                        {<!-- Without these braces, the code doesn't compile on MSVC 2008. -->
                            static const unsigned short staticallyStored<xsl:value-of select="local:tokenToEnumName(.)"/>[] =
                            {
                            <xsl:value-of separator=", " select="string-to-codepoints(.), 0"/>
                            };
                            data = staticallyStored<xsl:value-of select="local:tokenToEnumName(.)"/>;
                            length = <xsl:value-of select="string-length(.)"/>;
                            break;
                        }
                    </xsl:for-each>
                        default:
                            /* It's either the default token, or an undefined enum
                             * value. We silence a compiler warning, and return the
                             * empty string. */
                            ;
                    }

                    union
                    {
                        const unsigned short *data;
                        const QChar *asQChar;
                    } converter;
                    converter.data = data;

                    return QString::fromRawData(converter.asQChar, length);
                }
            </xsl:if>

            <xsl:text>&#xA;</xsl:text>
            <xsl:text>QT_END_NAMESPACE&#xA;</xsl:text>
            <xsl:text>&#xA;</xsl:text>
        </xsl:result-document>

    </xsl:template>

    <xsl:template name="generate-classifier">
        <xsl:param name="strings" as="xs:string+"/>

        <xsl:value-of select="$className"/>::<xsl:value-of select="$tokenEnum"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$className"/>::classifier<xsl:value-of select="."/>(const QChar *data)

        {
            <xsl:sequence select="local:generateBranching($strings, 1, 1)"/>

            return <xsl:value-of select="$defaultToken"/>;
        }
    </xsl:template>

    <xsl:function name="local:generateBranching" ><!--as="xs:string+">-->
        <xsl:param name="strings" as="xs:string+"/>
        <xsl:param name="depth" as="xs:integer"/>
        <xsl:param name="currentPos" as="xs:integer"/>

        <xsl:choose>
            <xsl:when test="count($strings) eq 1">
                <xsl:variable name="remainingLength" as="xs:integer" select="(string-length($strings) - $currentPos) + 1"/>
                <xsl:variable name="toMatch" as="xs:integer+" select="string-to-codepoints(substring($strings, $currentPos))"/>

                <xsl:if test="$remainingLength ne 0">
                    <xsl:choose>
                        <xsl:when test="$remainingLength eq 1">
                            if (data[<xsl:sequence select="$depth - 1"/>].unicode() == <xsl:sequence select="$toMatch"/>)
                        </xsl:when>
                        <xsl:when test="$remainingLength &gt; 1">
                            static const unsigned short string[] =
                            {
                                <xsl:value-of separator=", " select="string-to-codepoints(substring($strings, $currentPos))"/>
                            };
                            if(memcmp(&amp;data[<xsl:sequence select="$depth - 1"/>], &amp;string, sizeof(QChar) * <xsl:value-of select="$remainingLength"/>) == 0)
                        </xsl:when>
                    </xsl:choose>
                </xsl:if>

                return <xsl:value-of select="local:tokenToEnumName($strings)"/>;
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="distinct-values(for $i in $strings return substring($i, $currentPos, 1))">
                    <xsl:if test="position() &gt; 1">
                        <xsl:text>else </xsl:text>
                    </xsl:if>

                    <xsl:text>if (data[</xsl:text>
                    <xsl:sequence select="string($depth - 1)"/>
                    <xsl:text>].unicode() == </xsl:text>
                    <xsl:sequence select="string-to-codepoints(.)"/>
                    <xsl:text>)&#xA;</xsl:text>

                    {
                    <xsl:sequence select="local:generateBranching($strings[substring(., $currentPos, 1) eq current()], $depth + 1, $currentPos + 1)"/>
                    }

                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="local:toCamelCase" as="xs:string">
        <xsl:param name="arg" as="xs:string"/>

        <xsl:sequence select="string-join((for $word in tokenize($arg,'[:-]+')
                                           return concat(upper-case(substring($word,1,1)),
                                                         substring($word, 2))) ,'')"/>

    </xsl:function>

    <xsl:function name="local:tokenToEnumName" as="xs:string">
        <xsl:param name="string" as="xs:string"/>

        <xsl:variable name="token" select="$tokens[. eq $string]"/>

        <xsl:choose>
            <xsl:when test="$token/@name">
                <xsl:sequence select="$token/@name"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- We take the token's string value, and coerces into a C++
                     name. So get rid of invalid characters. Also do basic camel casing. -->
                <xsl:variable name="normalized" select="translate($string, 'ABCDEFGHIJKLMNOPQRSTYXZabcdefghijklmnopqrstyxz1234567890_', 'ABCDEFGHIJKLMNOPQRSTYXZabcdefghijklmnopqrstyxz1234567890_')"/>
                <xsl:value-of select="local:toCamelCase($normalized)"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:function>

</xsl:stylesheet>

<!--
vim: et:ts=4:sw=4:sts=4
-->