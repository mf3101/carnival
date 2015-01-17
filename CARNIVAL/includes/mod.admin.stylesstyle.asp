<!--#include file = "inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		mod.admin.stylesstyle.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"-->
<!--#include file = "inc.func.style.asp"--><%
dim crn_stylecontent, crn_style
crn_style = trim(request.form("style"))
if crn_style = "" then crn_style = trim(request.querystring("style"))
if crn_style = "" then crn_style = carnival_style

dim crn_act
crn_act = normalize(request.QueryString("action"),"select|customize","info")

crn_stylecontent = loadStyle(CARNIVAL_PUBLIC & CARNIVAL_STYLES & crn_style & "/cstyleconfig.txt")
if isnull(crn_stylecontent) or crn_stylecontent = "" then response.Redirect("errors.asp?c=style0")



dim crn_input_style,crn_output_style_main,crn_output_style_admin, crn_compatible
crn_input_style = CARNIVAL_PUBLIC & CARNIVAL_STYLES & crn_style & "/" & getStyleVar("css_input",crn_stylecontent)
crn_output_style_main = CARNIVAL_PUBLIC & CARNIVAL_STYLES & crn_style & "/" & getStyleVar("css_output_main",crn_stylecontent)
crn_output_style_admin = CARNIVAL_PUBLIC & CARNIVAL_STYLES & crn_style & "/" & getStyleVar("css_output_admin",crn_stylecontent)
'crn_font =  getStyleVar("font",crn_stylecontent)
crn_compatible = checkStyle(crn_stylecontent)
if not crn_compatible then response.Redirect("errors.asp?c=style1")
if not fileExist(crn_input_style) then response.Redirect("errors.asp?c=style2")
%>
<!--<h2>informazioni su &quot;<%=crn_style%>&quot;</h2>-->
	<!--<div class="page-description"><p>...</p></div>-->
	<div class="style-logo"><img src="<%=CARNIVAL_PUBLIC & CARNIVAL_STYLES & crn_style & "/logo.jpg"%>" alt="<%=crn_style%>" /></div>
	<form method="get" action="admin.asp" class="style">
	<div>
	<input type="hidden" name="module" value="pro-styles" />
	<input type="hidden" name="style" value="<%=crn_style%>" />
	<input type="hidden" name="compress" value="1" />
	<input type="hidden" name="from" value="stylesstyle" />
	<table class="style">
		<% if crn_act <> "customize" then %>
		<tr>
			<td class="d">path stile:</td>
			<td class="c"><%=CARNIVAL_PUBLIC & CARNIVAL_STYLES & crn_style%></td>
		</tr>
		<tr>
			<td class="d">path configurazione:</td>
			<td class="c"><a href="<%=CARNIVAL_HOME & CARNIVAL_PUBLIC & CARNIVAL_STYLES & crn_style & "/cstyleconfig.txt"%>" target="_blank"><%=CARNIVAL_PUBLIC & CARNIVAL_STYLES & crn_style & "/cstyleconfig.txt"%></a></td>
		</tr>
		<tr>
			<td class="d">compatibilit&agrave;:</td>
			<td class="c"><%=getStyleVar("version",crn_stylecontent)%></td>
		</tr>
		<tr>
			<td class="d">nome stile:</td>
			<td class="c"><%=getStyleVar("name",crn_stylecontent)%></td>
		</tr>
		<tr>
			<td class="d">autore stile:</td>
			<td class="c"><%=getStyleVar("author",crn_stylecontent)%></td>
		</tr>
		<tr>
			<td class="d">pubblicazione:</td>
			<td class="c"><%=getStyleVar("date",crn_stylecontent)%></td>
		</tr>
		<tr>
			<td class="d">path input css:</td>
			<td class="c"><%=crn_input_style%></td>
		</tr>
		<tr>
			<td class="d">path output main css:</td>
			<td class="c"><%=crn_output_style_main%></td>
		</tr>
		<tr>
			<td class="d">path output admin css:</td>
			<td class="c"><%=crn_output_style_admin%></td>
		</tr>
		<tr>
			<td class="d">path immagini:</td>
			<td class="c"><%=CARNIVAL_PUBLIC & CARNIVAL_STYLES & crn_style & "/" & getStyleVar("images_path",crn_stylecontent)%></td>
		</tr>
		<tr>
			<td class="d">sfondo chiaro<br/>nella pagina foto:</td>
			<td class="c"><%=cleanBool(getStyleVar("page_photo_islight",crn_stylecontent))%></td>
		</tr>
		<tr>
			<td class="d">sfondo chiaro<br/>nelle altre pagine:</td>
			<td class="c"><%=cleanBool(getStyleVar("page_islight",crn_stylecontent))%></td>
		</tr>
		<% end if %>
	<%
	SQL = "SELECT config_style_font, config_style_header_color, config_style_header_backcolor, config_style_title_color, config_style_title_margin, config_style_text_light_color, config_style_text_dark_color, config_style_text_menu_color FROM tba_config WHERE config_id = 1"
	dim crn_font,crn_header_color,crn_header_backcolor,crn_title_color,crn_title_margin
	dim crn_text_light_color, crn_text_dark_color, crn_text_menu_color
	if crn_act = "customize" then
		set rs = conn.execute(SQL)
		crn_font = rs("config_style_font")
		crn_header_color = rs("config_style_header_color")
		crn_header_backcolor = rs("config_style_header_backcolor")
		crn_title_color = rs("config_style_title_color")
		crn_title_margin = cleanLong(rs("config_style_title_margin"))
		crn_text_light_color = rs("config_style_text_light_color")
		crn_text_dark_color = rs("config_style_text_dark_color")
		crn_text_menu_color = rs("config_style_text_menu_color")
	else
		crn_font = getStyleVar("font",crn_stylecontent)
		crn_header_color =  getStyleVar("header_color",crn_stylecontent)
		crn_header_backcolor =  getStyleVar("header_backcolor",crn_stylecontent)
		crn_title_color =  getStyleVar("title_color",crn_stylecontent)
		crn_title_margin =  cleanLong(getStyleVar("title_margin",crn_stylecontent))
		crn_text_light_color =  getStyleVar("text_light_color",crn_stylecontent)
		crn_text_dark_color =  getStyleVar("text_dark_color",crn_stylecontent)
		crn_text_menu_color =  getStyleVar("text_menu_color",crn_stylecontent)
	end if
	
	%><tr>
			<td class="d">font family:</td>
			<td class="c">
		<div class="style"><div class="font" style="font-family:<%=crn_font%>;"><%=crn_font%></div><div class="value"><input name="style-font-family" id="style-font-family" <% if crn_act <> "info" then %>type="text"<% else %>type="hidden"<% end if %> value="<%=crn_font%>" /></div></div>
			</td>
	  </tr>
	  <tr>
			<td class="d">header backcolor:</td>
			<td class="c">
		<div class="style"><div class="color" style="background-color:<%=crn_header_backcolor%>;"></div><div class="value"><% if crn_act = "info" then response.write crn_header_backcolor %><input name="style-header-backcolor" id="style-header-backcolor" <% if crn_act <> "info" then %>type="text"<% else %>type="hidden"<% end if %> value="<%=crn_header_backcolor%>" /></div></div>
			</td>
	  </tr>
	  <tr>
			<td class="d">header text color:</td>
			<td class="c">
		<div class="style"><div class="color" style="background-color:<%=crn_header_color%>;"></div><div class="value"><% if crn_act = "info" then response.write crn_header_color %><input name="style-header-color" id="style-header-color" <% if crn_act <> "info" then %>type="text"<% else %>type="hidden"<% end if %> value="<%=crn_header_color%>" /></div></div>
			</td>
	  </tr>
	  <tr>
			<td class="d">title text color:</td>
			<td class="c">
		<div class="style"><div class="color" style="background-color:<%=crn_title_color%>;"></div><div class="value"><% if crn_act = "info" then response.write crn_title_color %><input name="style-title-color" id="style-title-color" <% if crn_act <> "info" then %>type="text"<% else %>type="hidden"<% end if %> value="<%=crn_title_color%>" /></div></div>
			</td>
	  </tr>
	  <tr>
			<td class="d">title margin:</td>
			<td class="c">
		<div class="style"><div class="number"><%=crn_title_margin%>px</div><div class="value"><input name="style-title-margin" id="style-title-margin" <% if crn_act <> "info" then %>type="text"<% else %>type="hidden"<% end if %> value="<%=crn_title_margin%>" /></div></div>
			</td>
	  </tr>
	  <tr>
			<td class="d">light text color:</td>
			<td class="c">
		<div class="style"><div class="color" style="background-color:<%=crn_text_light_color%>;"></div><div class="value"><% if crn_act = "info" then response.write crn_text_light_color %><input name="style-text-light-color" id="style-light-color" <% if crn_act <> "info" then %>type="text"<% else %>type="hidden"<% end if %> value="<%=crn_text_light_color%>" /></div></div>
			</td>
	  </tr>
	  <tr>
			<td class="d">dark text color:</td>
			<td class="c">
		<div class="style"><div class="color" style="background-color:<%=crn_text_dark_color%>;"></div><div class="value"><% if crn_act = "info" then response.write crn_text_dark_color %><input name="style-text-dark-color" id="style-text-dark-color" <% if crn_act <> "info" then %>type="text"<% else %>type="hidden"<% end if %> value="<%=crn_text_dark_color%>" /></div></div>
			</td>
	  </tr>
	  <tr>
			<td class="d">menu text color:</td>
			<td class="c">
		<div class="style"><div class="color" style="background-color:<%=crn_text_menu_color%>;"></div><div class="value"><% if crn_act = "info" then response.write crn_text_menu_color %><input name="style-text-menu-color" id="style-text-menu-color" <% if crn_act <> "info" then %>type="text"<% else %>type="hidden"<% end if %> value="<%=crn_text_menu_color%>" /></div></div>
			</td>
	  </tr>		
	</table>
	
	<div class="clear"></div>
	
	<div class="nbuttons">
		<a href="admin.asp?module=styles">
			<span>
			<img src="<%=carnival_pathimages%>/lay-adm-ico-but-prev.gif" alt=""/> 
			indietro
			</span>
		</a>
		<% if crn_act = "select" or crn_act = "customize" then
		if crn_act = "customize" then %>
		<a href="admin.asp?module=styles-style&amp;action=select">
			<span>
			<img src="<%=carnival_pathimages%>/lay-adm-ico-but-style.gif" alt=""/> 
			stile non personalizzato
			</span>
		</a>
		<% end if %>
		<button type="submit">
			<span class="a"><span class="b">
			<img src="<%=carnival_pathimages%>/lay-adm-ico-but-accept.gif" alt=""/> 
			<% if crn_act = "select" then %>utilizza lo stile<% else %>personalizza lo stile<%end if %>
			</span></span>
		</button>
		<% end if %>
	</div>
	</div>
	</form>