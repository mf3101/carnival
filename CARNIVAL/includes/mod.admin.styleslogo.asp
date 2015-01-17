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
' * @version         SVN: $Id: mod.admin.styleslogo.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "inc.admin.check.asp"--><%
'*****************************************************

dim strOptionLogoLight,strOptionLogoDark


strOptionLogoLight = "<select name=""logo_light"" id=""logo_light"" onchange=""setCover('logo_light_box',this.value);"">" & vbcrlf & "<option value=""$TEXT$"">nessun logo</option>" & vbcrlf
strOptionLogoDark = "<select name=""logo_dark"" id=""logo_dark"" onchange=""setCover('logo_dark_box',this.value);"">" & vbcrlf & "<option value=""$TEXT$"">nessun logo</option>" & vbcrlf
			
dim obj_FSO, obj_Folder, File
Set obj_FSO = CreateObject("Scripting.FileSystemObject")
obj_Folder = server.MapPath(CARNIVAL_LOGOS)

Set obj_Folder = obj_FSO.GetFolder(obj_Folder)

For Each File in obj_Folder.Files
	strOptionLogoLight = strOptionLogoLight & "<option value=""" & outputHTMLString(File.Name) & """"
	strOptionLogoDark = strOptionLogoDark & "<option value=""" & outputHTMLString(File.Name) & """"
	if config__logo_light__ = File.Name then strOptionLogoLight = strOptionLogoLight & " selected=""selected"""
	if config__logo_dark__ = File.Name then strOptionLogoDark = strOptionLogoDark & " selected=""selected"""
	strOptionLogoLight = strOptionLogoLight & ">" & outputHTMLString(File.Name) & "</option>"
	strOptionLogoDark = strOptionLogoDark & ">" & outputHTMLString(File.Name) & "</option>"
Next

strOptionLogoLight = strOptionLogoLight & "</select>"
strOptionLogoDark = strOptionLogoDark & "</select>"


%>
<script type="text/javascript">
function setCover(id,value) {
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
		<%=strOptionLogoLight%></div>
	</div>
	
	<div class="boxright">
		<p><strong>logo su sfondo chiaro</strong></p>
		<div class="styles-logo-light">
			<div class="styles-logo">
				<div class="logo"><div id="logo_light_box"><%
				if config__logo_light__ <> "" then
				%>
				<img src="<%=CARNIVAL_LOGOS & config__logo_light__%>" alt="" /><%
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
		<%=strOptionLogoDark%></div>
	</div>
	
	<div class="boxright">
		<p><strong>logo su sfondo scuro</strong></p>
		<div class="styles-logo-dark">
			<div class="styles-logo">
				<div class="logo"><div id="logo_dark_box"><%
				if config__logo_dark__ <> "" then
				%>
				<img src="<%=CARNIVAL_LOGOS & config__logo_dark__%>" alt="" /><%
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
			<img src="<%=getImagePath("lay-adm-ico-but-prev.gif")%>" alt=""/> 
			indietro
			</span>
		</a>
		<button type="submit">
			<span class="a"><span class="b">
			<img src="<%=getImagePath("lay-adm-ico-but-accept.gif")%>" alt=""/> 
			salva
			</span></span>
		</button>
	</div>
		
	</form>
	<div class="clear"></div>