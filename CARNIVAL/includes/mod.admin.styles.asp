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
' * @version         SVN: $Id: mod.admin.styles.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "inc.admin.check.asp"--><%
'*****************************************************
%>
<h2>Stili</h2>
	<div class="page-description"><p>La gestione stili permette di personalizzare l'aspetto estetico del tuo photoblog. Uno stile &egrave; un'insieme di icone, impostazioni di formattazione e colore per tutte le pagine; inoltre alcune impostazioni sono personalizzabili. E' poi possibile selezionare un logo grafico per dare maggiore identit&agrave; al tuo photoblog.<br/>
	Gli stili vengono selezionati dalla cartella <strong><%=CARNIVAL_PUBLIC & CARNIVAL_STYLES%></strong> di Carnival; per ritrovare gli stili nella lista seguente dovrai caricarli in tale cartella.</p></div>
	<div class="clear"></div>
	<hr/>
	
	<div class="stylepage">
	
	
	<h3>Stile</h3>
	
	<div class="boxleft">
		<p>E' possibile selezionare un nuovo stile fra quelli installati per modificare l'aspetto del photoblog.</p>
		<form action="admin.asp?module=styles-style&amp;action=select" method="post" class="styleselect">
			<div>
			<select name="style" id="style" style="width:100%;">
	<%
	dim obj_FSO, obj_Folder, Subfolder
	Set obj_FSO = CreateObject("Scripting.FileSystemObject")
	obj_Folder = server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_STYLES)
	
	Set obj_Folder = obj_FSO.GetFolder(obj_Folder)
	
	For Each Subfolder in obj_Folder.SubFolders
		if Subfolder.Name <> "icons" then
		%>			<option value="<%=Subfolder.Name%>"<% if config__style__ = Subfolder.Name then%> selected="selected" style="font-weight:bold;"<% end if %>><%=Subfolder.Name%></option>
	<%
		end if
	Next
	
	set Subfolder = nothing
	set obj_Folder = nothing
	set obj_FSO = nothing
	%>		</select></div>
	
			<div class="nbuttons">
				<button type="submit">
					<span class="a"><span class="b">
					<img src="<%=getImagePath("lay-adm-ico-but-next.gif")%>" alt=""/> 
					seleziona
					</span></span>
				</button>
			</div>
		</form>
	</div>
	
	<div class="boxright">
		<p>Lo stile attualmente selezionato &egrave; <b><%=config__style__%></b><br />
		<a href="admin.asp?module=styles-style&amp;action=info">visualizza informazioni sullo stile</a></p>
	</div>
	
	<div class="clear"></div>
	
	<hr/>
	
	
	
	<h3>Personalizzazione stile</h3>
	
	<div class="boxleft">
		<p>E' possibile personalizzare uno stile modificando alcuni parametri relativi a caratteri e colori</p>
		<div class="nbuttons">
			<a href="admin.asp?module=styles-style&amp;style=<%=config__style__%>&amp;action=customize">
				<span>
				<img src="<%=getImagePath("lay-adm-ico-but-style.gif")%>" alt=""/> 
				personalizza
				</span>
			</a>
		</div>
	</div>
	
	<div class="boxright">
		<%
		SQL = "SELECT config_style_font, config_style_header_color, config_style_header_backcolor, config_style_title_color,config_style_title_margin, config_style_text_light_color, config_style_text_dark_color, config_style_text_menu_color FROM tba_config"
		set rs = dbManager.Execute(SQL)
		dim strDBStyleFont,strDBStyleHeaderColor,strDBStyleHeaderBackcolor,strDBStyleTitleColor,lngDBStyleTitleMargin
		dim strDBStyleTextLightColor, strDBStyleTextDarkColor, strDBStyleTextMenuColor
		strDBStyleFont =  rs("config_style_font")
		strDBStyleHeaderColor =  rs("config_style_header_color")
		strDBStyleHeaderBackcolor =  rs("config_style_header_backcolor")
		strDBStyleTitleColor =  rs("config_style_title_color")
		lngDBStyleTitleMargin =  inputLong(rs("config_style_title_margin"))
		strDBStyleTextLightColor =  rs("config_style_text_light_color")
		strDBStyleTextDarkColor =  rs("config_style_text_dark_color")
		strDBStyleTextMenuColor =  rs("config_style_text_menu_color")
		
		%>
		<p>Gli attuali valori personalizzati</p>
			<div class="style"><div class="font" style="font-family:<%=strDBStyleFont%>;"><%=strDBStyleFont%></div><div class="description">font family</div></div><div class="clear"></div>
			<div class="style"><div class="color" style="background-color:<%=strDBStyleHeaderBackcolor%>;"></div><div class="description">header background color</div></div><div class="clear"></div>
			<div class="style"><div class="color" style="background-color:<%=strDBStyleHeaderColor%>;"></div><div class="description">header text color</div></div><div class="clear"></div>
			<div class="style"><div class="color" style="background-color:<%=strDBStyleTitleColor%>;"></div><div class="description">title text color</div></div><div class="clear"></div>
			<div class="style"><div class="number"><%=lngDBStyleTitleMargin%>px</div><div class="description">title margin</div></div><div class="clear"></div>
			<div class="style"><div class="color" style="background-color:<%=strDBStyleTextLightColor%>;"></div><div class="description">light text color</div></div><div class="clear"></div>
			<div class="style"><div class="color" style="background-color:<%=strDBStyleTextDarkColor%>;"></div><div class="description">dark text color</div></div><div class="clear"></div>
			<div class="style"><div class="color" style="background-color:<%=strDBStyleTextMenuColor%>;"></div><div class="description">menu text color</div></div><div class="clear"></div>
			
	</div>
	
	<div class="clear"></div>
	
	<hr/>
	
	
	
	<h3>Personalizzazione logo</h3>
	
	<div class="boxleft">
		<p>E' possibile personalizzare il logo in alto a sinistra in ogni pagina utilizzando una propria immagine.</p>
		<div class="nbuttons">
			<a href="admin.asp?module=styles-logo">
				<span>
				<img src="<%=getImagePath("lay-adm-ico-but-stylelogo.gif")%>" alt=""/> 
				seleziona un nuovo logo
				</span>
			</a>
		</div>
	</div>
	
	<div class="boxright">
		<p>I loghi attualmente selezionati</p>
		<p><strong>logo su sfondo chiaro</strong></p>
		<div class="styles-logo-light">
			<div class="styles-logo">
				<div class="logo"><%
		if config__logo_light__ <> "" then
		%>
					<img src="<%=CARNIVAL_LOGOS & config__logo_light__%>" alt="" /><%
		else
		%><span>&lt;logo testuale&gt;</span><%
		end if 
		%>
				</div>
			</div>
		</div>
		<p><strong>logo su sfondo scuro</strong></p>
		<div class="styles-logo-dark">
			<div class="styles-logo">
				<div class="logo"><%
		if config__logo_dark__ <> "" then
		%>
					<img src="<%=CARNIVAL_LOGOS & config__logo_dark__%>" alt="" /><%
		else
		%><span>&lt;logo testuale&gt;</span><%
		end if 
		%>
				</div>
			</div>
		</div>
	</div>
	
	</div>
	<div class="clear"></div>