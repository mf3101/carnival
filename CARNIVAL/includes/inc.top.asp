<%
'-----------------------------------------------------------------
' ******************** HELLO THIS IS CARNIVAL ********************
'-----------------------------------------------------------------
' Copyright (c) 2007-2008 Simone Cingano
' 
' Permission is hereby granted, free of charge, to any person
' obtaining a copy of this software and associated documentation
' files (the "Software"), to deal in the Software without
' restriction, including without limitation the rights to use,
' copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the
' Software is furnished to do so, subject to the following
' conditions:
' 
' The above copyright notice and this permission notice shall be
' included in all copies or substantial portions of the Software.
' 
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
' EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
' OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
' NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
' HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
' WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
' FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
' OTHER DEALINGS IN THE SOFTWARE.
'-----------------------------------------------------------------
' * @category        Carnival
' * @package         Carnival
' * @author          Simone Cingano <simonecingano@imente.org>
' * @copyright       2007-2008 Simone Cingano
' * @license         http://www.opensource.org/licenses/mit-license.php
' * @version         SVN: $Id: inc.top.asp 21 2008-06-29 22:05:09Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

crnIsLightPage = IIF(crnIsPhotoPage,carnival_style_photopage_islight,carnival_style_page_islight)
%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--
 *
 *	This photoblog is powered by Carnival <%=CARNIVAL_VERS%>
 *	http://www.carnivals.it
 *
 -->
<head>
<title><%=server.htmlEncode(crnPageTitle)%></title>
<meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
<meta name="generator" content="Carnival <%=CARNIVAL_VERS%>" />
<% if carnival_author <> "" then %><meta name="author" content="<%=cleanOutputString(carnival_author)%>" />
<% end if
if carnival_description <> "" then %><meta name="description" content="<%=cleanOutputString(carnival_description)%>" />
<% end if 
 if carnival_copyright <> "" then %><meta name="copyright" content="<%=cleanOutputString(carnival_copyright)%>" />
<% end if
%><meta name="robots" content="index,follow" />
<meta http-equiv="pragma" content="no-cache" />
<link rel="alternate" href="<%=CARNIVAL_PUBLIC & CARNIVAL_FEED & "feed.xml"%>" title="<%=cleanOutputString(carnival_title)%>" type="application/rss+xml" />
<link rel="shortcut icon" href="favicon.ico" />
<script type="text/javascript" src="javascript/prototype.lite.js"></script>
<script type="text/javascript" src="javascript/navsniffer.js"></script>
<script type="text/javascript" src="javascript/extend.js"></script>
<script type="text/javascript" src="javascript/moo.fx.js"></script>
<script type="text/javascript" src="javascript/ahah.js"></script>
<script type="text/javascript" src="javascript/baloon.js"></script>
<script type="text/javascript" src="javascript/func.js"></script>
<%
if crnIsAdminPage then 
%><script type="text/javascript" src="javascript/func.admin.js"></script>
<% end if
if carnival_jsactive and crnIsPhotoPage then 
%><script type="text/javascript" src="javascript/carnival.js"></script>
<% end if 
%><link type="text/css" rel="stylesheet" href="<%=CARNIVAL_PUBLIC & CARNIVAL_STYLES & carnival_style & "/" & carnival_style_output_main%>" />
<% if crnIsAdminPage then 
%><link type="text/css" rel="stylesheet" href="<%=CARNIVAL_PUBLIC & CARNIVAL_STYLES & carnival_style & "/" & carnival_style_output_admin%>" />
<% end if 
%><%=carnival_headadd
%>
</head>
<body id="body" class="<%=classColor(crnIsLightPage)%>">
<div id="overlay"></div>
<% if (carnival_jsactive and crnIsPhotoPage) or crnIsAdminPage then %>
<div id="baloon"></div>
<script type="text/javascript">/* <![CDATA[ */
function bodyOnMouseOut() { if (baloons) { baloonsChecks();	} }
/* ]]> */</script>
<div id="add"></div>
<% end if 
if carnival_bodyaddwhere = 0 then response.write carnival_bodyadd
%><div id="container" >
	<div id="top">
		<div id="topbox" class="<%=classColor(crnIsLightPage)%>">
			<div id="logo">
				<a href="default.asp"><%
				if carnival_logo_light <> "" and crnIsLightPage then
				%><img src="<%=CARNIVAL_LOGOS & carnival_logo_light%>" alt="logo" /><span style="display:none;"><%=carnival_title%></span><%
				elseif carnival_logo_dark <> "" and not crnIsLightPage then
				%><img src="<%=CARNIVAL_LOGOS & carnival_logo_dark%>" alt="logo" /><span style="display:none;"><%=carnival_title%></span><%
				else
				%><span><%=carnival_title%></span><%
				end if
				%></a>
			</div>
			<div id="menu">
				<a href="photo.asp<% if crnIsCommentPage and crnPhotoId <> 0 then %>?id=<%=crnPhotoId%><% end if %>"><span><%=crnLang_menu_photos%></span></a>
				<a href="gallery.asp<% if crnTagId <> 0 then %>?mode=stream&amp;tag=<%=crnTagName%><%elseif crnSetId <> 0 then %>?mode=sets&amp;set=<%=crnSetId%><%end if%>"><span><%=crnLang_menu_gallery%></span></a>
				<a href="comments.asp<% if crnIsPhotoPage then %>?id=<%=crnPhotoId%><% end if %>" id="commentsshow"><span><%=crnMenuComment%></span></a>
				<a href="tags.asp" id="cloudshow"><span><%=crnLang_menu_tags%></span></a><%
				if carnival_parent <> "" then %>
                <a href="<%=carnival_parent%>"><span>HOME</span></a>
                <% elseif carnival_about then %>
				<a href="about.asp"><span><%=crnLang_menu_about%></span></a><%
				end if %>
				<a href="admin.asp" title="<%=crnLang_menu_admin%>" class="admin"><span><img class="admin" src="images/carnival-logo25.gif" alt=" <%=crnLang_menu_admin%> " /></span></a>
			</div>
		</div>
	</div>
	<div id="header" class="<%=classColor(crnIsLightPage)%>">
		<% if not crnIsPhotoPage then %><div id="carnivalinfo">
			<a href="http://www.carnivals.it">powered by <b>carnival</b> <%=CARNIVAL_VERS%></a>
		</div>
		<h1><%=crnTitle%></h1><% end if %>
	</div><%
	if not crnIsPhotoPage then %>
	<div id="box">
		<div class="content"><%
	end if %>