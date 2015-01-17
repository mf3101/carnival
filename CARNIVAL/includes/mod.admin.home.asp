<!--#include file = "inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		mod.admin.home.asp 0 20080312120000
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
<div style="float:left;">
<div class="admin-logo"><img class="carnival-logo" src="images/carnival-logo150.gif" alt="[logo]" /><br/>
amministrazione</div>
</div>
<div style="float:left;">
<div class="admin-button">
	<div style="padding-left:220px;">
		<div class="img"><img src="<%=carnival_pathimages%>lay-adm-ico-zone-photo-new.gif" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=photo-new">nuovo post</a><br/>
						  <span>crea un nuovo post caricando una foto</span></div>
	</div>
</div>
<div class="clear"></div>
<div class="admin-button">
	<div style="padding-left:250px;">
		<div class="img"><img src="<%=carnival_pathimages%>lay-adm-ico-zone-photo-edit.gif" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=photo-list">post</a><br/>
						  <span>modifica le foto</span></div>
	</div>
</div>
<div class="clear"></div>
<div class="admin-button">
	<div style="padding-left:270px;">
		<div class="img"><img src="<%=carnival_pathimages%>lay-adm-ico-zone-tag.gif" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=tag-list">tag</a><br/>
						   <span>modifica i tag</span></div>
	</div>
</div>
<div class="clear"></div>
<div class="admin-button">
	<div style="padding-left:280px;">
		<div class="img"><img src="<%=carnival_pathimages%>lay-adm-ico-zone-style.gif" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=styles">stili</a><br/>
						   <span>modifica gli stili di visualizzazione</span></div>
	</div>
</div>
<div class="clear"></div>
<div class="admin-button">
	<div style="padding-left:290px;">
		<div class="img"><img src="<%=carnival_pathimages%>lay-adm-ico-zone-config.gif" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=config">configurazione</a><br/>
						   <span>modifica le impostazioni</span></div>
	</div>
</div>
<div class="clear"></div>
<div class="admin-button">
	<div style="padding-left:280px;">
		<div class="img"><img src="<%=carnival_pathimages%>lay-adm-ico-zone-tools.gif" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=tools">strumenti</a><br/>
						   <span>alcuni strumenti utili</span></div>
	</div>
</div>
<div class="clear"></div>
<div class="admin-button">
	<div style="padding-left:270px;">
		<div class="img"><img src="<%=carnival_pathimages%>lay-adm-ico-zone-info.gif" alt=""  /></div>
		<div class="call"><a href="admin.asp?module=info">informazioni</a><br/>
						   <span>informazioni su carnival</span></div>
	</div>
</div>
<div class="clear"></div>
<div class="admin-button">
	<div style="padding-left:250px;">
		<div class="img"><img src="<%=carnival_pathimages%>lay-adm-ico-zone-logout.gif" alt=""  /></div>
		<div class="call"><a href="admin_logout.asp">esci</a><br/>
						   <span>disconnette l'admin</span></div>
	</div>
</div>
<div class="clear"></div>
</div>
<div class="clear"></div>