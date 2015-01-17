<!--#include file = "inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		mod.admin.photocheck.asp 0 20080312120000
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
<%
crnPhotoId = cleanLong(request.QueryString("id"))
SQL = "SELECT photo_original FROM tba_photo WHERE photo_id = " & crnPhotoId
set rs = conn.execute(SQL)
if rs.eof then  response.redirect("errors.asp?c=post0")
crnPhotoOriginal = rs("photo_original")

dim crn_action
crn_action = normalize(request.QueryString("action"),"edit","new")
%>
	<h2>Controllo foto</h2>
	<div class="page-description"><p>L'immagine originale, l'immagine da visualizzare e la miniatura sono state caricate o create correttamente.<br />
	Controllare che le tre immagine corrispondano e siano delle dimensioni desiderate; se non sono corrette &egrave; possibile caricarne altre.</p></div>
	<div class="cnbuttons">
	<div class="nbuttons">
	<% if crn_action = "edit" then %>
		<a href="admin.asp?module=photo-list">
			<span>
			<img src="<%=carnival_pathimages%>/lay-adm-ico-but-next.gif" alt=""/> 
			continua
			</span>
		</a>
		<a href="admin.asp?module=photo-upload&amp;id=<%=crnPhotoId%>&amp;action=edit">
			<span>
			<img src="<%=carnival_pathimages%>/lay-adm-ico-but-upload.gif" alt=""/> 
			carica immagini differenti
			</span>
		</a>
	<% else %>
		<a href="admin.asp?module=photo-edit&amp;id=<%=crnPhotoId%>&amp;action=new">
			<span>
			<img src="<%=carnival_pathimages%>/lay-adm-ico-but-next.gif" alt=""/> 
			continua
			</span>
		</a>
		<a href="admin.asp?module=photo-upload&amp;id=<%=crnPhotoId%>&amp;action=new">
			<span>
			<img src="<%=carnival_pathimages%>/lay-adm-ico-but-upload.gif" alt=""/> 
			carica immagini differenti
			</span>
		</a>
	<% end if %>
	</div>
	</div>
	<hr/>
	<div class="check-box">
		<div class="check-title">miniatura (altezza massima 90px)</div>
		<p>questa miniatura verrà utilizzata per la galleria e i dettagli</p>
		<div class="check-photo"><img src="<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crnPhotoId & CARNIVAL_THUMBPOSTFIX & ".jpg?nc=" & noCache%>" alt="original photo" /></div>
		<hr/>
		<div class="check-title">immagine da visualizzare (altezza massima 480px)</div>
		<p>questa foto viene visualizzata sul photoblog</p>
		<p class="alert">ATTENZIONE: la foto NON è stata tagliata,<br/>semplicemente se &egrave; pi&ugrave; larga di 700pixel non viene visualizzata interamente!</p>
		<div class="check-photo"><img src="<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crnPhotoId & ".jpg?nc=" & noCache%>" alt="original photo" /></div>
		<hr/>
		<div class="check-title">immagine originale (dimensioni personalizzate, alta risoluzione)</div>
		<p>questa foto non viene visualizzata direttamente sul photoblog</p>
		<p class="alert">ATTENZIONE: la foto NON è stata tagliata,<br/>semplicemente se &egrave; pi&ugrave; larga di 700pixel non viene visualizzata interamente!</p>
		<div class="check-photo"><img src="<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crnPhotoId & CARNIVAL_ORIGINALPOSTFIX & crnPhotoOriginal & ".jpg?nc=" & noCache%>" alt="original photo" /></div>
	</div>
	<div class="clear"></div>