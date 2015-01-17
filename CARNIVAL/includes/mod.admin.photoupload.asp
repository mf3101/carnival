<!--#include file = "inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		mod.admin.photoupload.asp 0 20080312120000
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
crnPhotoId = request.QueryString("id")
SQL = "SELECT photo_original FROM tba_photo WHERE photo_id = " & crnPhotoId
set rs = conn.execute(SQL)
if rs.eof then  response.redirect("errors.asp?c=post0")
crnPhotoOriginal = rs("photo_original")

dim crn_action, crn_isnew
crn_action = normalize(request.QueryString("action"),"edit","new")
crn_isnew = crn_action = "new"
%>
	<h2>Carica una foto</h2>
	<div class="page-description"><%
	if crn_isnew then %>
	<p>Il nuovo post &egrave; stato creato ma non verr&agrave; visualizzato sul photoblog fino al termine di questa procedura.<br/>Ora &egrave; necessario <strong>caricare una immagine</strong> (di risoluzione minima 640px per 480px) in formato JPG.</p><%
	else %>
	<p>Per cambiare le immagini relative al post &egrave; necessario <strong>caricare una nuova immagine</strong> (di risoluzione minima 640px per 480px) in formato JPG oppure, se si vuole modificare solo l'immagine visualizzata o la miniatura, <strong>mantenere l'immagine</strong> attualmente caricata (visualizzata pi&ugrave; in basso).</p><%
	end if%></div>
	<div class="upload-box">
		<div class="upload-result"><img src="<%=carnival_pathimages%>lay-adm-ico-photo-upload.gif" alt=""  /></div>
	<form action="admin.asp?module=pro-photo-upload&amp;id=<%=crnPhotoId%>&amp;type=new&amp;action=<%=crn_action%>" method="post" enctype="multipart/form-data" class="upload">
		<div><label for="file">upload original (high resolution)</label><input name="file" id="file" type="file" class="file" /><input type="submit" value="upload" class="submit" /></div>
	</form>
	</div>
	<% if not crn_isnew then %>
	<div class="resize-box">
		<div class="resize-result"><img src="<%=carnival_pathimages%>lay-adm-ico-photo-keep.gif" alt=""  /></div>
		<div class="resize-call"><a href="admin.asp?module=photo-resize&amp;id=<%=crnPhotoId%>&amp;action=<%=crn_action%>">mantieni attuale</a></div>
	</div>
	<div class="clear"></div>
	<hr />
	<div class="check-box">
	<div class="check-title">immagine attuale</div>
		<p class="alert">ATTENZIONE: la foto NON è stata tagliata,<br/>semplicemente se &egrave; pi&ugrave; larga di 700pixel non viene visualizzata interamente!</p>
		<div class="check-photo"><img src="<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crnPhotoId & CARNIVAL_ORIGINALPOSTFIX & crnPhotoOriginal & ".jpg?nc=" & noCache%>" alt="original photo" /></div>
	</div>
	<% end if %>
	<div class="clear"></div>