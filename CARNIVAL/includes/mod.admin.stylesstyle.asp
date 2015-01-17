<!--#include file = "inc.first.asp"--><%
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
' * @version         SVN: $Id: mod.admin.stylesstyle.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "inc.admin.check.asp"-->
<!--#include file = "inc.func.style.asp"--><%
'*****************************************************

dim strStyleContent, strStyleName
strStyleName = trim(request.form("style"))
if strStyleName = "" then strStyleName = trim(request.querystring("style"))
if strStyleName = "" then strStyleName = config__style__

dim strAction
strAction = normalize(request.QueryString("action"),"select|customize","info")

strStyleContent = loadStyle(CARNIVAL_PUBLIC & CARNIVAL_STYLES & strStyleName & "/cstyleconfig.txt")
if isnull(strStyleContent) or strStyleContent = "" then response.Redirect("errors.asp?c=style0")



dim strStyleInputFile,strStyleOutputFileMain,strStyleOutputFileAdmin, blnIsCompatible
strStyleInputFile = CARNIVAL_PUBLIC & CARNIVAL_STYLES & strStyleName & "/" & getStyleVar("css_input",strStyleContent)
strStyleOutputFileMain = CARNIVAL_PUBLIC & CARNIVAL_STYLES & strStyleName & "/" & getStyleVar("css_output_main",strStyleContent)
strStyleOutputFileAdmin = CARNIVAL_PUBLIC & CARNIVAL_STYLES & strStyleName & "/" & getStyleVar("css_output_admin",strStyleContent)
'strDBStyleFont =  getStyleVar("font",strStyleContent)
blnIsCompatible = checkStyle(strStyleContent)
if not blnIsCompatible then response.Redirect("errors.asp?c=style1")
if not fileExists(strStyleInputFile) then response.Redirect("errors.asp?c=style2")
%>
<!--<h2>informazioni su &quot;<%=strStyleName%>&quot;</h2>-->
	<!--<div class="page-description"><p>...</p></div>-->
	<div class="style-logo"><img src="<%=CARNIVAL_PUBLIC & CARNIVAL_STYLES & strStyleName & "/logo.jpg"%>" alt="<%=strStyleName%>" /></div>
	<form method="get" action="admin.asp" class="style">
	<div>
	<input type="hidden" name="module" value="pro-styles" />
	<input type="hidden" name="style" value="<%=strStyleName%>" />
	<input type="hidden" name="compress" value="1" />
	<input type="hidden" name="from" value="stylesstyle" />
	<table class="style">
		<% if strAction <> "customize" then %>
		<tr>
			<td class="d">path stile:</td>
			<td class="c"><%=CARNIVAL_PUBLIC & CARNIVAL_STYLES & strStyleName%></td>
		</tr>
		<tr>
			<td class="d">path configurazione:</td>
			<td class="c"><a href="<%=CARNIVAL_HOME & CARNIVAL_PUBLIC & CARNIVAL_STYLES & strStyleName & "/cstyleconfig.txt"%>" target="_blank"><%=CARNIVAL_PUBLIC & CARNIVAL_STYLES & strStyleName & "/cstyleconfig.txt"%></a></td>
		</tr>
		<tr>
			<td class="d">compatibilit&agrave;:</td>
			<td class="c"><%=getStyleVar("version",strStyleContent)%></td>
		</tr>
		<tr>
			<td class="d">nome stile:</td>
			<td class="c"><%=getStyleVar("name",strStyleContent)%></td>
		</tr>
		<tr>
			<td class="d">autore stile:</td>
			<td class="c"><%=getStyleVar("author",strStyleContent)%></td>
		</tr>
		<tr>
			<td class="d">pubblicazione:</td>
			<td class="c"><%=getStyleVar("date",strStyleContent)%></td>
		</tr>
		<tr>
			<td class="d">path input css:</td>
			<td class="c"><%=strStyleInputFile%></td>
		</tr>
		<tr>
			<td class="d">path output main css:</td>
			<td class="c"><%=strStyleOutputFileMain%></td>
		</tr>
		<tr>
			<td class="d">path output admin css:</td>
			<td class="c"><%=strStyleOutputFileAdmin%></td>
		</tr>
		<tr>
			<td class="d">path icone:</td>
			<td class="c"><%=replace(getImagePath("lay-ico"),"lay-ico","")%></td>
		</tr>
		<tr>
			<td class="d">sfondo chiaro<br/>nella pagina foto:</td>
			<td class="c"><%=inputBoolean(getStyleVar("page_photo_islight",strStyleContent))%></td>
		</tr>
		<tr>
			<td class="d">sfondo chiaro<br/>nelle altre pagine:</td>
			<td class="c"><%=inputBoolean(getStyleVar("page_islight",strStyleContent))%></td>
		</tr>
		<% end if %>
	<%
	SQL = "SELECT config_style_font, config_style_header_color, config_style_header_backcolor, config_style_title_color, config_style_title_margin, config_style_text_light_color, config_style_text_dark_color, config_style_text_menu_color FROM tba_config"
	dim strDBStyleFont,strDBStyleHeaderColor,strDBStyleHeaderBackcolor,strDBStyleTitleColor,lngDBStyleTitleMargin
	dim strDBStyleTextLightColor, strDBStyleTextDarkColor, strDBStyleTextMenuColor,strDBStyleIcons
	if strAction = "customize" then
		set rs = dbManager.Execute(SQL)
		strDBStyleFont = rs("config_style_font")
		strDBStyleHeaderColor = rs("config_style_header_color")
		strDBStyleHeaderBackcolor = rs("config_style_header_backcolor")
		strDBStyleTitleColor = rs("config_style_title_color")
		lngDBStyleTitleMargin = inputLong(rs("config_style_title_margin"))
		strDBStyleTextLightColor = rs("config_style_text_light_color")
		strDBStyleTextDarkColor = rs("config_style_text_dark_color")
		strDBStyleTextMenuColor = rs("config_style_text_menu_color")
		strDBStyleIcons = config__style_icons__
	else
		strDBStyleFont = getStyleVar("font",strStyleContent)
		strDBStyleHeaderColor =  getStyleVar("header_color",strStyleContent)
		strDBStyleHeaderBackcolor =  getStyleVar("header_backcolor",strStyleContent)
		strDBStyleTitleColor =  getStyleVar("title_color",strStyleContent)
		lngDBStyleTitleMargin =  inputLong(getStyleVar("title_margin",strStyleContent))
		strDBStyleTextLightColor =  getStyleVar("text_light_color",strStyleContent)
		strDBStyleTextDarkColor =  getStyleVar("text_dark_color",strStyleContent)
		strDBStyleTextMenuColor =  getStyleVar("text_menu_color",strStyleContent)
		strDBStyleIcons = ""
	end if
	
	%><tr>
			<td class="d">font family:</td>
			<td class="c">
		<div class="style"><div class="font" style="font-family:<%=strDBStyleFont%>;"><%=strDBStyleFont%></div><div class="value"><input name="style-font-family" id="style-font-family" <% if strAction <> "info" then %>type="text"<% else %>type="hidden"<% end if %> value="<%=strDBStyleFont%>" /></div></div>
			</td>
	  </tr>
	  <tr>
			<td class="d">header backcolor:</td>
			<td class="c">
		<div class="style"><div class="color" style="background-color:<%=strDBStyleHeaderBackcolor%>;"></div><div class="value"><% if strAction = "info" then response.write strDBStyleHeaderBackcolor %><input name="style-header-backcolor" id="style-header-backcolor" <% if strAction <> "info" then %>type="text"<% else %>type="hidden"<% end if %> value="<%=strDBStyleHeaderBackcolor%>" /></div></div>
			</td>
	  </tr>
	  <tr>
			<td class="d">header text color:</td>
			<td class="c">
		<div class="style"><div class="color" style="background-color:<%=strDBStyleHeaderColor%>;"></div><div class="value"><% if strAction = "info" then response.write strDBStyleHeaderColor %><input name="style-header-color" id="style-header-color" <% if strAction <> "info" then %>type="text"<% else %>type="hidden"<% end if %> value="<%=strDBStyleHeaderColor%>" /></div></div>
			</td>
	  </tr>
	  <tr>
			<td class="d">title text color:</td>
			<td class="c">
		<div class="style"><div class="color" style="background-color:<%=strDBStyleTitleColor%>;"></div><div class="value"><% if strAction = "info" then response.write strDBStyleTitleColor %><input name="style-title-color" id="style-title-color" <% if strAction <> "info" then %>type="text"<% else %>type="hidden"<% end if %> value="<%=strDBStyleTitleColor%>" /></div></div>
			</td>
	  </tr>
	  <tr>
			<td class="d">title margin:</td>
			<td class="c">
		<div class="style"><div class="number"><%=lngDBStyleTitleMargin%>px</div><div class="value"><input name="style-title-margin" id="style-title-margin" <% if strAction <> "info" then %>type="text"<% else %>type="hidden"<% end if %> value="<%=lngDBStyleTitleMargin%>" /></div></div>
			</td>
	  </tr>
	  <tr>
			<td class="d">light text color:</td>
			<td class="c">
		<div class="style"><div class="color" style="background-color:<%=strDBStyleTextLightColor%>;"></div><div class="value"><% if strAction = "info" then response.write strDBStyleTextLightColor %><input name="style-text-light-color" id="style-light-color" <% if strAction <> "info" then %>type="text"<% else %>type="hidden"<% end if %> value="<%=strDBStyleTextLightColor%>" /></div></div>
			</td>
	  </tr>
	  <tr>
			<td class="d">dark text color:</td>
			<td class="c">
		<div class="style"><div class="color" style="background-color:<%=strDBStyleTextDarkColor%>;"></div><div class="value"><% if strAction = "info" then response.write strDBStyleTextDarkColor %><input name="style-text-dark-color" id="style-text-dark-color" <% if strAction <> "info" then %>type="text"<% else %>type="hidden"<% end if %> value="<%=strDBStyleTextDarkColor%>" /></div></div>
			</td>
	  </tr>
	  <tr>
			<td class="d">menu text color:</td>
			<td class="c">
		<div class="style"><div class="color" style="background-color:<%=strDBStyleTextMenuColor%>;"></div><div class="value"><% if strAction = "info" then response.write strDBStyleTextMenuColor %><input name="style-text-menu-color" id="style-text-menu-color" <% if strAction <> "info" then %>type="text"<% else %>type="hidden"<% end if %> value="<%=strDBStyleTextMenuColor%>" /></div></div>
			</td>
	  </tr>		
	  <% if strAction <> "info" then %><tr>
			<td class="d">set icone:</td>
			<td class="c">
		<div class="style"><div class="value">
        <select name="style-icons" id="style-icons">
        	<option value=""<% if config__style_icons__ = "" then%> selected="selected" style="font-weight:bold;"<% end if %>>integrate nello stile</option>
        <%
		dim obj_FSO, objFolder, Subfolder
		Set obj_FSO = CreateObject("Scripting.FileSystemObject")
		objFolder = server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_STYLES & "icons")
		
		Set objFolder = obj_FSO.GetFolder(objFolder)
		
		For Each Subfolder in objFolder.SubFolders
			%>			<option value="<%=Subfolder.Name%>"<% if strDBStyleIcons = Subfolder.Name then%> selected="selected" style="font-weight:bold;"<% end if %>><%=Subfolder.Name%></option>
		<%
		Next
		
		set Subfolder = nothing
		set objFolder = nothing
		set obj_FSO = nothing
		%>
        </select></div></div>
			</td>
	  </tr><% end if %>
	</table>
	
	<div class="clear"></div>
	
	<div class="nbuttons">
		<a href="admin.asp?module=styles">
			<span>
			<img src="<%=getImagePath("lay-adm-ico-but-prev.gif")%>" alt=""/> 
			indietro
			</span>
		</a>
		<% if strAction = "select" or strAction = "customize" then
		if strAction = "customize" then %>
		<a href="admin.asp?module=styles-style&amp;action=select">
			<span>
			<img src="<%=getImagePath("lay-adm-ico-but-style.gif")%>" alt=""/> 
			stile non personalizzato
			</span>
		</a>
		<% end if %>
		<button type="submit">
			<span class="a"><span class="b">
			<img src="<%=getImagePath("lay-adm-ico-but-accept.gif")%>" alt=""/> 
			<% if strAction = "select" then %>utilizza lo stile<% else %>personalizza lo stile<%end if %>
			</span></span>
		</button>
		<% end if %>
	</div>
	</div>
	</form>