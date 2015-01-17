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
' * @version         SVN: $Id: mod.admin.tools.asp 29 2008-07-04 14:03:45Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"-->
<%
dim crn_done
crn_done = normalize(request.QueryString("done"),"styles|styles-debug|rss|wbresize|tags|sets|dbclean|dbcompress|statsthisoff|statsthison|ccvon|ccvoff|aspnetfail|aspnetoff","")

if crn_done <> "" then
dim crn_excTitle, crn_excDescription,crn_excLink
crn_excLink = "<a href=""admin.asp?module=tools"">continua</a>"
select case crn_done
	case "styles", "styles-debug"
	crn_excTitle = "Compilazione stile"
	crn_excDescription = "lo stile &egrave; stato compilato correttamente<br/>(potrebbe essere necessario cancellare la cache per visualizzare lo stile correttamente)"
	if crn_done = "styles" then
		crn_excLink = "<a href=""admin.asp?module=pro-styles&amp;style=" & carnival_style & "&amp;from=tools&amp;compress=1"">ricompila ancora</a> - " & crn_excLink
	else
		crn_excLink = "<a href=""admin.asp?module=pro-styles&amp;style=" & carnival_style & "&amp;from=tools&amp;compress=0"">ricompila ancora</a> - " & crn_excLink
	end if
	case "rss"
	crn_excTitle = "Pubblicazione feed Rss"
	crn_excDescription = "i feed sono stati pubblicati correttamente"
	case "wbresize"
	crn_excTitle = "Compilazione wbresize"
	crn_excDescription = "asp.net è attivo e il servizio wbresize &egrave; stato compilato correttamente"
	case "aspnetfail"
	crn_excTitle = "Asp.net non attivo"
	crn_excDescription = "attualmente asp.net non risulta utilizzabile in questo dominio<br/>wbResize necessita del supporto asp.net e non è pertanto attivabile"
	case "aspnetoff"
	crn_excTitle = "wbResize non attivo"
	crn_excDescription = "wbresize è stato disattivato. è possibile sempre riattivarlo dagli strumenti"
	case "tags"
	crn_excTitle = "Sincronizzazione tag"
	crn_excDescription = "i tag e le foto sono stati sincronizzati"
	case "sets"
	crn_excTitle = "Sincronizzazione set"
	crn_excDescription = "i set e le foto sono stati sincronizzati"
	case "dbclean"
	crn_excTitle = "Pulizia Database"
	crn_excDescription = "le copie di backup presenti sono state eliminate"
	case "dbcompress"
	crn_excTitle = "Compressione Database"
	crn_excDescription = "il database &egrave; stato compresso ed &egrave; stata creata una copia di backup"
	crn_excLink = "<a href=""admin.asp?module=pro-db&amp;action=dbclean"">elimina tutti i backup</a> - <a href=""admin.asp?module=tools"">mantieni i backup</a>"
	case "statsthison"
	crn_excTitle = "Inclusione nele statistiche"
	crn_excDescription = "questo computer verr&agrave; conteggiato nelle statistiche"
	case "statsthisoff"
	crn_excTitle = "Esclusione dalle statistiche"
	crn_excDescription = "questo computer non verr&agrave; conteggiato nelle statistiche<br/>fino a quando non lo includerai o cancellerai i cookie"
	case "ccvon"
	crn_excTitle = "Controllo versione attivo"
	crn_excDescription = "carnival controller&agrave; periodicamente la presenza di aggiornamenti e lo segnaler&agrave; all'utente"
	case "ccvoff"
	crn_excTitle = "Controllo versione non attivo"
	crn_excDescription = "nessun controllo per aggiornamenti verr&agrave; eseguito"
end select
%>
	<div id="exclamation">
		<div class="title"><%=crn_excTitle%></div>
		<div class="description"><%=crn_excDescription%></div>
		<div class="link"><%=crn_excLink%></div>
	</div><%
else

	dim crn_ccv
	SQL = "SELECT config_ccv FROM tba_config"
	set rs = dbManager.conn.execute(SQL)
	crn_ccv = cleanBool(rs("config_ccv"))
%>
	<h2>Strumenti utili</h2>
	<hr class="light" />
	<div class="admin-button">
		<div class="img"><img src="<%=carnival_pathimages%>lay-adm-ico-tools-style.gif" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-styles&amp;style=<%=carnival_style%>&amp;from=tools&amp;compress=1">ricompila lo stile</a><br/>
						   <span>ricompila &quot;<strong><%=carnival_style%></strong>&quot; in formato standard</span></div>
	</div>
	<div class="clear"></div>
	<div class="admin-button">
		<div class="img"><img src="<%=carnival_pathimages%>lay-adm-ico-tools-style.gif" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-styles&amp;style=<%=carnival_style%>&amp;from=tools&amp;compress=0">ricompila lo stile (senza compressione)</a><br/>
						   <span>ricompila &quot;<strong><%=carnival_style%></strong>&quot; in versione di <em>debug</em> senza alcuna compressione</span></div>
	</div>
	<div class="clear"></div>
	<hr class="light" />
	<div class="admin-button">
		<div class="img"><img src="<%=carnival_pathimages%>lay-adm-ico-tools-db-comp.gif" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-db&amp;action=dbcompress">comprimi database</a><br/>
						   <span>crea una copia di backup del database e lo comprime</span></div>
	</div>
	<div class="clear"></div>
	<div class="admin-button">
		<div class="img"><img src="<%=carnival_pathimages%>lay-adm-ico-tools-db-clean.gif" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-db&amp;action=dbclean">elimina backup database</a><br/>
						   <span>elimina tutte le copie di backup del database presenti sul server</span></div>
	</div>
	<div class="clear"></div>
	<hr class="light" />
	<div class="admin-button">
		<div class="img"><img src="<%=carnival_pathimages%>lay-adm-ico-tools-rss.gif" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-rss&amp;from=tools">ripubblica feed rss</a><br/>
						   <span>ricompila e pubblica i feed rss</span></div>
	</div>
	<div class="clear"></div>
	<hr class="light" />
	<div class="admin-button">
		<div class="img"><img src="<%=carnival_pathimages%>lay-adm-ico-tools-tags.gif" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-tag&amp;action=update&amp;from=tools">sincronizza foto/tag</a><br/>
						   <span>sincronizza il numero di foto appartenenti ai tag</span></div>
	</div>
	<div class="clear"></div>
	<div class="admin-button">
		<div class="img"><img src="<%=carnival_pathimages%>lay-adm-ico-tools-sets.gif" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-set&amp;action=update&amp;from=tools">sincronizza foto/set</a><br/>
						   <span>sincronizza il numero di foto appartenenti ai set</span></div>
	</div>
	<div class="clear"></div>
	<hr class="light" /><%
	if carnival_aspnetactive then %>
	<div class="admin-button">
		<div class="img"><img src="<%=carnival_pathimages%>lay-adm-ico-tools-service.gif" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-tools&amp;action=wbresize">rigenera wbResize</a><br/>
						   <span>ricompila wbresize.aspx e lo sincronizza con Carnival</span></div>
	</div>
	<div class="clear"></div>
	<div class="admin-button">
		<div class="img"><img src="<%=carnival_pathimages%>lay-adm-ico-tools-service.gif" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-tools&amp;action=aspnetoff">disattiva il servizio wbResize</a><br/>
						   <span>disattivando il servizio non sar&agrave; pi&ugrave; possibile effettuare il ridimensionamento automatico</span></div>
	</div>
	<div class="clear"></div>
	<hr class="light" /><%
	else %>
	<div class="admin-button">
		<div class="img"><img src="<%=carnival_pathimages%>lay-adm-ico-tools-service.gif" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-tools&amp;action=aspneton">attiva il servizio wbResize</a><br/>
						   <span>attualmente il servizio di ridimensionamento automatico non &egrave; attivo</span></div>
	</div>
	<div class="clear"></div>
	<hr class="light" /><%
	end if %><%
	if getCookie("exclude") = "1" then %>
	<div class="admin-button">
		<div class="img"><img src="<%=carnival_pathimages%>lay-adm-ico-tools-stat-off.gif" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-tools&amp;action=statsthison"><em>includi</em> questo computer dalle statistiche</a></a><br/>
						   <span>attualmente questo computer &egrave; <strong>escluso</strong> dalle statistiche tramite l'utilizzo di un cookie</span></div>
	</div>
	<div class="clear"></div>
	<hr class="light" /><%
	else %>
	<div class="admin-button">
		<div class="img"><img src="<%=carnival_pathimages%>lay-adm-ico-tools-stat-on.gif" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-tools&amp;action=statsthisoff"><em>escludi</em> questo computer dalle statistiche</a><br/>
						   <span>attualmente questo computer &egrave; <strong>incluso</strong> nelle statistiche</span></div>
	</div>
	<div class="clear"></div>
	<hr class="light" /><%
	end if %><%
	if not crn_ccv then %>
	<div class="admin-button">
		<div class="img"><img src="<%=carnival_pathimages%>lay-adm-ico-tools-ccv-off.gif" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=pro-tools&amp;action=ccvon"><em>attiva</em> il controllo aggiornamenti</a></a><br/>
						   <span>attualmente carnival <strong>non controlla</strong> la presenza di aggiornamenti</span></div>
	</div>
	<div class="clear"></div>
	<hr class="light" /><%
	else %>
	<div class="admin-button">
		<div class="img"><img src="<%=carnival_pathimages%>lay-adm-ico-tools-ccv-on.gif" alt=""  /></div>
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