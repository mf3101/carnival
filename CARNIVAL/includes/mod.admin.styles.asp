<!--#include file = "inc.first.asp"--><%
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
' * @version         SVN: $Id: mod.admin.styles.asp 27 2008-07-04 12:22:52Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"-->
<h2>Stili</h2>
	<div class="page-description"><p>La gestione stili permette di personalizzare l'aspetto estetico del tuo photoblog. Uno stile &egrave; un'insieme di icone, impostazioni di formattazione e colore per tutte le pagine; inoltre alcune impostazioni sono personalizzabili. E' poi possibile selezionare un logo grafico per dare maggiore identit&agrave; al tuo photoblog.<br/>
	Gli stili vengono selezionati dalla cartella <strong>/<%=CARNIVAL_PUBLIC & CARNIVAL_STYLES%></strong> di Carnival; per ritrovare gli stili nella lista seguente dovrai caricarli in tale cartella.</p></div>
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
	dim objFSO, objFolder, Subfolder
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	objFolder = server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_STYLES)
	
	Set objFolder = objFSO.GetFolder(objFolder)
	
	For Each Subfolder in objFolder.SubFolders
		%>			<option value="<%=Subfolder.Name%>"<% if carnival_style = Subfolder.Name then%> selected="selected" style="font-weight:bold;"<% end if %>><%=Subfolder.Name%></option>
	<%
	Next
	
	set Subfolder = nothing
	set objFolder = nothing
	set objFSO = nothing
	%>		</select></div>
	
			<div class="nbuttons">
				<button type="submit">
					<span class="a"><span class="b">
					<img src="<%=carnival_pathimages%>/lay-adm-ico-but-next.gif" alt=""/> 
					seleziona
					</span></span>
				</button>
			</div>
		</form>
	</div>
	
	<div class="boxright">
		<p>Lo stile attualmente selezionato &egrave; <b><%=carnival_style%></b><br />
		<a href="admin.asp?module=styles-style&amp;action=info">visualizza informazioni sullo stile</a></p>
	</div>
	
	<div class="clear"></div>
	
	<hr/>
	
	
	
	<h3>Personalizzazione stile</h3>
	
	<div class="boxleft">
		<p>E' possibile personalizzare uno stile modificando alcuni parametri relativi a caratteri e colori</p>
		<div class="nbuttons">
			<a href="admin.asp?module=styles-style&amp;style=<%=carnival_style%>&amp;action=customize">
				<span>
				<img src="<%=carnival_pathimages%>lay-adm-ico-but-style.gif" alt=""/> 
				personalizza
				</span>
			</a>
		</div>
	</div>
	
	<div class="boxright">
		<%
		SQL = "SELECT config_style_font, config_style_header_color, config_style_header_backcolor, config_style_title_color,config_style_title_margin, config_style_text_light_color, config_style_text_dark_color, config_style_text_menu_color FROM tba_config"
		set rs = dbManager.conn.execute(SQL)
		dim crn_font,crn_header_color,crn_header_backcolor,crn_title_color,crn_title_margin
		dim crn_text_light_color, crn_text_dark_color, crn_text_menu_color
		crn_font =  rs("config_style_font")
		crn_header_color =  rs("config_style_header_color")
		crn_header_backcolor =  rs("config_style_header_backcolor")
		crn_title_color =  rs("config_style_title_color")
		crn_title_margin =  cleanLong(rs("config_style_title_margin"))
		crn_text_light_color =  rs("config_style_text_light_color")
		crn_text_dark_color =  rs("config_style_text_dark_color")
		crn_text_menu_color =  rs("config_style_text_menu_color")
		
		%>
		<p>Gli attuali valori personalizzati</p>
			<div class="style"><div class="font" style="font-family:<%=crn_font%>;"><%=crn_font%></div><div class="description">font family</div></div><div class="clear"></div>
			<div class="style"><div class="color" style="background-color:<%=crn_header_backcolor%>;"></div><div class="description">header background color</div></div><div class="clear"></div>
			<div class="style"><div class="color" style="background-color:<%=crn_header_color%>;"></div><div class="description">header text color</div></div><div class="clear"></div>
			<div class="style"><div class="color" style="background-color:<%=crn_title_color%>;"></div><div class="description">title text color</div></div><div class="clear"></div>
			<div class="style"><div class="number"><%=crn_title_margin%>px</div><div class="description">title margin</div></div><div class="clear"></div>
			<div class="style"><div class="color" style="background-color:<%=crn_text_light_color%>;"></div><div class="description">light text color</div></div><div class="clear"></div>
			<div class="style"><div class="color" style="background-color:<%=crn_text_dark_color%>;"></div><div class="description">dark text color</div></div><div class="clear"></div>
			<div class="style"><div class="color" style="background-color:<%=crn_text_menu_color%>;"></div><div class="description">menu text color</div></div><div class="clear"></div>
			
	</div>
	
	<div class="clear"></div>
	
	<hr/>
	
	
	
	<h3>Personalizzazione logo</h3>
	
	<div class="boxleft">
		<p>E' possibile personalizzare il logo in alto a sinistra in ogni pagina utilizzando una propria immagine.</p>
		<div class="nbuttons">
			<a href="admin.asp?module=styles-logo">
				<span>
				<img src="<%=carnival_pathimages%>lay-adm-ico-but-stylelogo.gif" alt=""/> 
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
		if carnival_logo_light <> "" then
		%>
					<img src="<%=CARNIVAL_LOGOS & carnival_logo_light%>" alt="" /><%
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
		if carnival_logo_dark <> "" then
		%>
					<img src="<%=CARNIVAL_LOGOS & carnival_logo_dark%>" alt="" /><%
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