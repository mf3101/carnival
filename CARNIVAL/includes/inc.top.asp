<%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		inc.top.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
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
<script type="text/javascript" src="javascript/func.js"></script>
<script type="text/javascript" src="javascript/baloon.js"></script>
<% if carnival_jsactive and crnIsPhotoPage then 
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
<% if carnival_jsactive and crnIsPhotoPage then %>
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
				<a href="photo.asp"><%
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
				<a href="gallery.asp<% if crnTagId <> 0 then %>?tag=<%=crnTagName%><%end if%>"><span><%=crnLang_menu_gallery%></span></a>
				<a href="comments.asp<% if crnIsPhotoPage then %>?id=<%=crnPhotoId%><% end if %>" id="commentsshow"><span><%=crnMenuComment%></span></a>
				<a href="tags.asp" id="cloudshow"><span><%=crnLang_menu_tags%></span></a><%
				if carnival_about then %>
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