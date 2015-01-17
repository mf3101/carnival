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
' * @version         SVN: $Id: mod.admin.home.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "inc.admin.check.asp"--><%
'*****************************************************

'PLect è un valore numerico calcolato
'che rappresenta un margine/padding laterale
dim lngPLeft : lngPLeft = 0
function adminHomeNextPLeft()
	lngPLeft = lngPLeft + 0.35
	adminHomeNextPLeft = int(((sin(lngPLeft)^2))*70+200)
end function
%>
<div style="float:left;">
<div class="admin-logo"><img class="carnival-logo" src="images/carnival-logo150.gif" alt="[logo]" /><br/>
amministrazione</div>
</div>
<div style="float:left;">
<div class="admin-button">
	<div style="padding-left:<%=adminHomeNextPLeft()%>px;">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-zone-photo-new.gif")%>" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=photo-new">nuova foto</a><br/>
						  <span>crea un nuovo post caricando una foto</span></div>
	</div>
</div>
<div class="clear"></div>
<div class="admin-button">
	<div style="padding-left:<%=adminHomeNextPLeft()%>px;">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-zone-photo-edit.gif")%>" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=photo-list">foto</a><br/>
						  <span>gestisce le foto</span></div>
	</div>
</div>

<div class="clear"></div>
<div class="admin-button">
	<div style="padding-left:<%=adminHomeNextPLeft()%>px;">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-zone-set.gif")%>" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=set-list">set</a><br/>
						   <span>gestisce i set<% if config__mode__ = 2 then %> <b style="color:#800000;">(non attivi)</b><% end if %></span></div>
	</div>
</div>

<div class="clear"></div>
<div class="admin-button">
	<div style="padding-left:<%=adminHomeNextPLeft()%>px;">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-zone-tag.gif")%>" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=tag-list">tag</a><br/>
						   <span>gestisce i tag</span></div>
	</div>
</div>
<div class="clear"></div>
<div class="admin-button">
	<div style="padding-left:<%=adminHomeNextPLeft()%>px;">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-zone-style.gif")%>" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=styles">stili</a><br/>
						   <span>modifica gli stili di visualizzazione</span></div>
	</div>
</div>
<div class="clear"></div>
<div class="admin-button">
	<div style="padding-left:<%=adminHomeNextPLeft()%>px;">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-zone-config.gif")%>" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=config">configurazione</a><br/>
						   <span>modifica le impostazioni</span></div>
	</div>
</div>
<div class="clear"></div>
<div class="admin-button">
	<div style="padding-left:<%=adminHomeNextPLeft()%>px;">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-zone-tools.gif")%>" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=tools">strumenti</a><br/>
						   <span>alcuni strumenti utili</span></div>
	</div>
</div>
<div class="clear"></div>
<div class="admin-button">
	<div style="padding-left:<%=adminHomeNextPLeft()%>px;">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-zone-stats.gif")%>" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=stats">statistiche</a><br/>
						   <span>statistiche riguardanti le tue foto</span></div>
	</div>
</div>
<div class="clear"></div>
<div class="admin-button">
	<div style="padding-left:<%=adminHomeNextPLeft()%>px;">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-zone-support.gif")%>" alt=""  /></div>
		<div class="call"><a href="http://www.carnivals.it/support" target="_blank">guida e supporto</a><br/>
						   <span>la sezione di supporto <strong>online</strong> con guide e forum</span></div>
	</div>
</div>
<div class="clear"></div>
<div class="admin-button">
	<div style="padding-left:<%=adminHomeNextPLeft()%>px;">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-zone-info.gif")%>" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=info">informazioni</a><br/>
						   <span>informazioni su carnival</span></div>
	</div>
</div>
<div class="clear"></div>
<div class="admin-button">
	<div style="padding-left:<%=adminHomeNextPLeft()%>px;">
		<div class="img"><img src="<%=getImagePath("lay-adm-ico-zone-logout.gif")%>" alt=""  /></div>
		<div class="call"><a href="admin_logout.asp">esci</a><br/>
						   <span>disconnette l'admin</span></div>
	</div>
</div>
<div class="clear"></div>
</div>
<div class="clear"></div>