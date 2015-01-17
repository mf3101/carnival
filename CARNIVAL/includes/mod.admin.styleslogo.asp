<!--#include file = "inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		mod.admin.styleslogo.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"--><%

dim crn_optionlogo_light,crn_optionlogo_dark


crn_optionlogo_light = "<select name=""logo_light"" id=""logo_light"" onchange=""setLogo('logo_light_box',this.value);"">" & vbcrlf & "<option value=""$TEXT$"">nessun logo</option>" & vbcrlf
crn_optionlogo_dark = "<select name=""logo_dark"" id=""logo_dark"" onchange=""setLogo('logo_dark_box',this.value);"">" & vbcrlf & "<option value=""$TEXT$"">nessun logo</option>" & vbcrlf
			
dim objFSO, objFolder, File
Set objFSO = CreateObject("Scripting.FileSystemObject")
objFolder = server.MapPath(CARNIVAL_LOGOS)

Set objFolder = objFSO.GetFolder(objFolder)

For Each File in objFolder.Files
	crn_optionlogo_light = crn_optionlogo_light & "<option value=""" & cleanOutputString(File.Name) & """"
	crn_optionlogo_dark = crn_optionlogo_dark & "<option value=""" & cleanOutputString(File.Name) & """"
	if carnival_logo_light = File.Name then crn_optionlogo_light = crn_optionlogo_light & " selected=""selected"""
	if carnival_logo_dark = File.Name then crn_optionlogo_dark = crn_optionlogo_dark & " selected=""selected"""
	crn_optionlogo_light = crn_optionlogo_light & ">" & cleanOutputString(File.Name) & "</option>"
	crn_optionlogo_dark = crn_optionlogo_dark & ">" & cleanOutputString(File.Name) & "</option>"
Next

crn_optionlogo_light = crn_optionlogo_light & "</select>"
crn_optionlogo_dark = crn_optionlogo_dark & "</select>"


%>
<script type="text/javascript">
function setLogo(id,value) {
	if (value!='$TEXT$') {
		Element.setInnerHTML(id,'<'+'img src="<%=CARNIVAL_LOGOS%>'+value+'" alt="" />');
	} else {
		Element.setInnerHTML(id,'<'+'span>&lt;logo testuale&gt;<'+'/span>');
	}
}
</script>
<h2>Personalizzazione logo</h2>
	<div class="page-description"><p>Per dare maggiore identit&agrave; al tuo photoblog puoi selezionare un logo grafico che verr&agrave; posizionato in alto a sinistra.<br/>
	Siccome il photoblog ha due tipologie di pagine (alcune a sfondo chiaro ed altre a sfondo scuro) sono richiesti due loghi personalizzati che si adattino ad entrambe le pagine. Se il tuo logo non supera le dimensioni standard della barra alta (di 33px) puoi utilizzare la stessa immagine per entrambi i contesti.<br/>
	I loghi vengono selezionati dalla cartella <strong>/logos/</strong> di Carnival; per ritrovare le tue immagini nelle liste seguenti dovrai caricarle in tale cartella.</p></div>
	
	<div class="clear"></div>


	<form class="stylelogo" action="admin.asp" method="get">
	<hr/>
	
	<div class="boxleft">
		<div><label for="logo_light">Seleziona un logo fra quelli presenti</label>
		<%=crn_optionlogo_light%></div>
	</div>
	
	<div class="boxright">
		<p><strong>logo su sfondo chiaro</strong></p>
		<div class="styles-logo-light">
			<div class="styles-logo">
				<div class="logo"><div id="logo_light_box"><%
				if carnival_logo_light <> "" then
				%>
				<img src="<%=CARNIVAL_LOGOS & carnival_logo_light%>" alt="" /><%
				else
				%>
				<span>&lt;logo testuale&gt;</span><%
				end if 
				%>
				</div></div>
			</div>
		</div>
	</div>
	
	<div class="clear"></div>
	
	<hr/>
	
	<div class="boxleft">
		<div><label for="logo_dark">Seleziona un logo fra quelli presenti</label>
		<%=crn_optionlogo_dark%></div>
	</div>
	
	<div class="boxright">
		<p><strong>logo su sfondo scuro</strong></p>
		<div class="styles-logo-dark">
			<div class="styles-logo">
				<div class="logo"><div id="logo_dark_box"><%
				if carnival_logo_dark <> "" then
				%>
				<img src="<%=CARNIVAL_LOGOS & carnival_logo_dark%>" alt="" /><%
				else
				%>
				<span>&lt;logo testuale&gt;</span><%
				end if 
				%>
				</div></div>
			</div>
		</div>
	</div>
	
	<div class="clear"></div>
	
	<hr/>
	
	<div class="nbuttons">
		<input type="hidden" value="pro-styles" name="module" id="module" />
		<input type="hidden" value="styleslogo" name="from" id="from" />
		<a href="admin.asp?module=styles">
			<span>
			<img src="<%=carnival_pathimages%>/lay-adm-ico-but-prev.gif" alt=""/> 
			indietro
			</span>
		</a>
		<button type="submit">
			<span class="a"><span class="b">
			<img src="<%=carnival_pathimages%>/lay-adm-ico-but-accept.gif" alt=""/> 
			salva
			</span></span>
		</button>
	</div>
		
	</form>
	<div class="clear"></div>