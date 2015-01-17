
<%
'-----------------------------------------------------------------
' ******************** HELLO THIS IS CARNIVAL ********************
'-----------------------------------------------------------------
' Copyright (c) 2007-2011 Simone Cingano
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
' * @author          Simone Cingano <info@carnivals.it>
' * @copyright       2007-2011 Simone Cingano
' * @license         http://www.opensource.org/licenses/mit-license.php
' * @version         SVN: $Id: inc.top.asp 117 2010-10-11 19:22:40Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

blnIsLightPage__ = IIF(blnIsPhotosPage__,config__style_photopage_islight__,config__style_page_islight__)
%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--
 *
 *	This photoblog is powered by Carnival <%=CARNIVAL_VERS%>
 *	http://www.carnivals.it
 *
 -->
<head>
<title><%=server.htmlEncode(strPageTitleHead__)%></title>
<meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
<meta name="generator" content="Carnival <%=CARNIVAL_VERS%>" />
<% if config__author__ <> "" then %><meta name="author" content="<%=outputHTMLString(config__author__)%>" />
<% end if
if config__description__ <> "" then %><meta name="description" content="<%=outputHTMLString(config__description__)%>" />
<% end if 
 if config__copyright__ <> "" then %><meta name="copyright" content="<%=outputHTMLString(config__copyright__)%>" />
<% end if
%><meta name="robots" content="index,follow" />
<meta http-equiv="pragma" content="no-cache" />
<link rel="alternate" href="feed.asp" title="<%=outputHTMLString(config__title__)%>" type="application/rss+xml" />
<link rel="shortcut icon" href="favicon.ico" />
<script type="text/javascript" src="javascript/mootools.js"></script>
<script type="text/javascript" src="javascript/commons.js"></script>
<script type="text/javascript" src="javascript/baloon.js"></script>
<link type="text/css" rel="stylesheet" href="<%=CARNIVAL_PUBLIC & CARNIVAL_STYLES & config__style__ & "/" & config__style_output_main__%>" />
<% if blnIsAdminPage__ then 
%><link type="text/css" rel="stylesheet" href="<%=CARNIVAL_PUBLIC & CARNIVAL_STYLES & config__style__ & "/" & config__style_output_admin__%>" />
<% end if 
%><%
if blnIsAdminPage__ then 
%><script type="text/javascript" src="javascript/commons.admin.js"></script>
<% end if
if config__jsactive__ and blnIsPhotosPage__ then 
%><script type="text/javascript" src="javascript/carnival.js"></script>
<% 
end if 
%><%=config__headadd__
%>
</head>
<body id="body" class="<%=classColor(blnIsLightPage__)%>">
<div id="overlay"></div>
<% if (config__jsactive__ and blnIsPhotosPage__) or blnIsAdminPage__ then %>
<div id="baloon"></div>
<script type="text/javascript">/* <![CDATA[ */
function eventOnMouseOut() { if (baloons) { baloonsChecks(); } }
/* ]]> */</script>
<div id="add"></div>
<% end if 
if config__bodyaddwhere__ = 0 then response.write config__bodyadd__
%><div id="container" >
	<div id="top">
		<div id="topbox" class="<%=classColor(blnIsLightPage__)%>">
			<div id="logo">
				<a href="default.asp"><%
				if config__logo_light__ <> "" and blnIsLightPage__ then
				%><img src="<%=CARNIVAL_LOGOS & config__logo_light__%>" alt="logo" /><span style="display:none;"><%=config__title__%></span><%
				elseif config__logo_dark__ <> "" and not blnIsLightPage__ then
				%><img src="<%=CARNIVAL_LOGOS & config__logo_dark__%>" alt="logo" /><span style="display:none;"><%=config__title__%></span><%
				else
				%><span><%=config__title__%></span><%
				end if
				%></a>
			</div>
			<div id="menu">
				<a href="photo.asp<% if blnIsCommentsPage__ and lngCurrentPhotoId__ <> 0 then %>?id=<%=lngCurrentPhotoId__%><% end if %>"><span><%=lang__menu_photos__%></span></a>
				<a href="gallery.asp<% if lngCurrentTagId__ <> 0 then %>?mode=stream&amp;tag=<%=strCurrentTagName__%><%elseif lngCurrentSetId__ <> 0 then %>?mode=sets&amp;set=<%=lngCurrentSetId__%><%end if%>" id="gallerylink"><span><%=lang__menu_gallery__%></span></a>
				<a href="comments.asp<% if blnIsPhotosPage__ then %>?id=<%=lngCurrentPhotoId__%><% end if %>" id="commentsshow"><span><%=strMenuCommentText__%></span></a>
				<a href="tags.asp" id="cloudshow"><span><%=lang__menu_tags__%></span></a><%
				if config__parent__ <> "" then %>
                <a href="<%=config__parent__%>"><span>HOME</span></a>
                <% elseif config__about__ then %>
				<a href="about.asp"><span><%=lang__menu_about__%></span></a><%
				end if %>
				<a href="admin.asp" title="<%=lang__menu_admin__%>" class="admin"><span><img class="admin" src="images/carnival-logo25.gif" alt=" <%=lang__menu_admin__%> " /></span></a>
			</div>
		</div>
	</div>
	<% if not blnIsPhotosPage__ then %><div id="header" class="page">
    	<div class="content">
		<div id="carnivalinfo">
			<a href="http://www.carnivals.it">powered by <b>carnival</b> <%=CARNIVAL_VERS%></a>
		</div>
		<h1><%=strPageTitle__%></h1></div>
	</div>
	<div id="box">
		<div class="content"><%
	end if %>
