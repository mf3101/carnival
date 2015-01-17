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
' * @version         SVN: $Id: mod.admin.tools.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "inc.admin.check.asp"--><%
'*****************************************************

dim strDone
strDone = normalize(request.QueryString("done"),"styles|styles-debug|rss|pub|wbresize|tags|sets|dbclean|dbcompress|statsthisoff|statsthison|ccvon|ccvoff|aspnetfail|aspnetoff","")

if strDone <> "" then
dim strExcTitle, strExcDescription, strExcLink
strExcLink = "<a href=""admin.asp?module=tools"">continua</a>"
select case strDone
	case "styles", "styles-debug"
	strExcTitle = "Compilazione stile"
	strExcDescription = "lo stile &egrave; stato compilato correttamente<br/>(potrebbe essere necessario cancellare la cache per visualizzare lo stile correttamente)"
	if strDone = "styles" then
		strExcLink = "<a href=""admin.asp?module=pro-styles&amp;style=" & config__style__ & "&amp;from=tools&amp;compress=1"">ricompila ancora</a> - " & strExcLink
	else
		strExcLink = "<a href=""admin.asp?module=pro-styles&amp;style=" & config__style__ & "&amp;from=tools&amp;compress=0"">ricompila ancora</a> - " & strExcLink
	end if
	case "rss"
	strExcTitle = "Pubblicazione feed Rss"
	strExcDescription = "i feed sono stati pubblicati correttamente"
	case "wbresize"
	strExcTitle = "Compilazione wbresize"
	strExcDescription = "asp.net è attivo e il servizio wbresize &egrave; stato compilato correttamente"
	case "aspnetfail"
	strExcTitle = "Asp.net non attivo"
	strExcDescription = "attualmente asp.net non risulta utilizzabile in questo dominio<br/>wbResize necessita del supporto asp.net e non è pertanto attivabile"
	case "aspnetoff"
	strExcTitle = "wbResize non attivo"
	strExcDescription = "wbresize è stato disattivato. è possibile sempre riattivarlo dagli strumenti"
	case "pub"
	strExcTitle = "Aggiornamento pubblicazione automatica"
	strExcDescription = "le date per la pubblicazione sono state ricalcolate"
	case "tags"
	strExcTitle = "Sincronizzazione tag"
	strExcDescription = "i tag e le foto sono stati sincronizzati"
	case "sets"
	strExcTitle = "Sincronizzazione set"
	strExcDescription = "i set e le foto sono stati sincronizzati"
	case "dbclean"
	strExcTitle = "Pulizia Database"
	strExcDescription = "le copie di backup presenti sono state eliminate"
	case "dbcompress"
	strExcTitle = "Compressione Database"
	strExcDescription = "il database &egrave; stato compresso ed &egrave; stata creata una copia di backup"
	strExcLink = "<a href=""admin.asp?module=pro-db&amp;action=dbclean"">elimina tutti i backup</a> - <a href=""admin.asp?module=tools"">mantieni i backup</a>"
	case "statsthison"
	strExcTitle = "Inclusione nele statistiche"
	strExcDescription = "questo computer verr&agrave; conteggiato nelle statistiche"
	case "statsthisoff"
	strExcTitle = "Esclusione dalle statistiche"
	strExcDescription = "questo computer non verr&agrave; conteggiato nelle statistiche<br/>fino a quando non lo includerai o cancellerai i cookie"
	case "ccvon"
	strExcTitle = "Controllo versione attivo"
	strExcDescription = "carnival controller&agrave; periodicamente la presenza di aggiornamenti e lo segnaler&agrave; all'utente"
	case "ccvoff"
	strExcTitle = "Controllo versione non attivo"
	strExcDescription = "nessun controllo per aggiornamenti verr&agrave; eseguito"
end select
%>
	<div id="exclamation">
		<div class="title"><%=strExcTitle%></div>
		<div class="description"><%=strExcDescription%></div>
		<div class="link"><%=strExcLink%></div>
	</div><%
else

	dim blnCv
	SQL = "SELECT config_cc"&"v FROM tba_config"
	set rs = dbManager.Execute(SQL)
	blnCv = inputBoolean(rs("config_cc"&"v"))
%>
	<h2>Strumenti utili</h2>
	<hr class="light" />
	<div class="admin-button">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-tools-info.gif")%>" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=infoapp">informazioni</a><br/>
						   <span>visualizza informazioni sul sistema</span></div>
	</div>
	<div class="clear"></div>
	<hr class="light" />
	<div class="admin-button">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-tools-style.gif")%>" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-styles&amp;style=<%=config__style__%>&amp;from=tools&amp;compress=1">ricompila lo stile</a><br/>
						   <span>ricompila &quot;<strong><%=config__style__%></strong>&quot; in formato standard</span></div>
	</div>
	<div class="clear"></div>
	<div class="admin-button">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-tools-style.gif")%>" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-styles&amp;style=<%=config__style__%>&amp;from=tools&amp;compress=0">ricompila lo stile (senza compressione)</a><br/>
						   <span>ricompila &quot;<strong><%=config__style__%></strong>&quot; in versione di <em>debug</em> senza alcuna compressione</span></div>
	</div>
	<div class="clear"></div>
    <% if CARNIVAL_DATABASE_TYPE = "mdb" then %>
	<hr class="light" />
	<div class="admin-button">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-tools-db-comp.gif")%>" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-db&amp;action=dbcompress">comprimi database</a><br/>
						   <span>crea una copia di backup del database e lo comprime</span></div>
	</div>
	<div class="clear"></div>
	<div class="admin-button">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-tools-db-clean.gif")%>" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-db&amp;action=dbclean">elimina backup database</a><br/>
						   <span>elimina tutte le copie di backup del database presenti sul server</span></div>
	</div>
	<div class="clear"></div>
    <% end if
	if fileExists("migrate.asp") and folderExists("setup") then %>
	<hr class="light" />
	<div class="admin-button">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-tools-migrate.gif")%>" alt=""  /></div>
		<div class="call"><a href="migrate.asp">migrazione database</a><br/>
						   <span>effettua la migrazione da <strong><%=IIF(CARNIVAL_DATABASE_TYPE="mdb","Access MDB","MySQL")%></strong> a <strong><%=IIF(CARNIVAL_DATABASE_TYPE="mysql","Access MDB","MySQL")%></strong></span></div>
	</div>
	<div class="clear"></div>
    <% end if %>
	<hr class="light" />
	<div class="admin-button">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-tools-rss.gif")%>" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-tools&amp;action=rss">ripubblica feed rss</a><br/>
						   <span>ricompila e pubblica i feed rss</span></div>
	</div>
	<div class="clear"></div>
	<hr class="light" />
	<div class="admin-button">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-tools-tags.gif")%>" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-tag&amp;action=update&amp;from=tools">sincronizza foto/tag</a><br/>
						   <span>sincronizza il numero di foto appartenenti ai tag</span></div>
	</div>
	<div class="clear"></div>
	<div class="admin-button">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-tools-sets.gif")%>" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-set&amp;action=update&amp;from=tools">sincronizza foto/set</a><br/>
						   <span>sincronizza il numero di foto appartenenti ai set</span></div>
	</div>
	<div class="clear"></div>
	<div class="admin-button">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-tools-photopub.gif")%>" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-photo-edit&amp;action=updatepub">aggiorna pubblicazione automatica</a><br/>
						   <span>ricalcola le date di pubblicazione automatica</span></div>
	</div>
	<div class="clear"></div>
	<hr class="light" /><%
	if config__aspnetactive__ then %>
	<div class="admin-button">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-tools-service.gif")%>" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-tools&amp;action=wbresize">rigenera wbResize</a><br/>
						   <span>ricompila wbresize.aspx e lo sincronizza con Carnival</span></div>
	</div>
	<div class="clear"></div>
	<div class="admin-button">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-tools-service.gif")%>" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-tools&amp;action=aspnetoff">disattiva il servizio wbResize</a><br/>
						   <span>disattivando il servizio non sar&agrave; pi&ugrave; possibile effettuare il ridimensionamento automatico</span></div>
	</div>
	<div class="clear"></div>
	<hr class="light" /><%
	else %>
	<div class="admin-button">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-tools-service.gif")%>" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-tools&amp;action=aspneton">attiva il servizio wbResize</a><br/>
						   <span>attualmente il servizio di ridimensionamento automatico non &egrave; attivo</span></div>
	</div>
	<div class="clear"></div>
	<hr class="light" /><%
	end if %><%
	if getCookie("exclude") = "1" then %>
	<div class="admin-button">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-tools-stat-off.gif")%>" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-tools&amp;action=statsthison"><em>includi</em> questo computer dalle statistiche</a></a><br/>
						   <span>attualmente questo computer &egrave; <strong>escluso</strong> dalle statistiche tramite l'utilizzo di un cookie</span></div>
	</div>
	<div class="clear"></div>
	<hr class="light" /><%
	else %>
	<div class="admin-button">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-tools-stat-on.gif")%>" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-tools&amp;action=statsthisoff"><em>escludi</em> questo computer dalle statistiche</a><br/>
						   <span>attualmente questo computer &egrave; <strong>incluso</strong> nelle statistiche</span></div>
	</div>
	<div class="clear"></div>
	<hr class="light" /><%
	end if %><%
	if not blnCv then %>
	<div class="admin-button">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-tools-ccv-off.gif")%>" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-tools&amp;action=ccvon"><em>attiva</em> il controllo aggiornamenti</a></a><br/>
						   <span>attualmente carnival <strong>non controlla</strong> la presenza di aggiornamenti</span></div>
	</div>
	<div class="clear"></div>
	<hr class="light" /><%
	else %>
	<div class="admin-button">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-tools-ccv-on.gif")%>" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-tools&amp;action=ccvoff"><em>disattiva</em> il controllo aggiornamenti</a><br/>
						   <span>attualmente carnival <strong>controlla</strong> la presenza di aggiornamenti</span></div>
	</div>
	<div class="clear"></div>
	<hr class="light" /><%
	end if %>
<%
end if 
%>
<div class="clear"></div>