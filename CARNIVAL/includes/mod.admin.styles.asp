<!--#include file = "inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		mod.admin.styles.asp 0 20080312120000
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
		SQL = "SELECT config_style_font, config_style_header_color, config_style_header_backcolor, config_style_title_color,config_style_title_margin, config_style_text_light_color, config_style_text_dark_color, config_style_text_menu_color FROM tba_config WHERE config_id = 1"
		set rs = conn.execute(SQL)
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