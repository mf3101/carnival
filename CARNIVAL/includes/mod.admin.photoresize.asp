<!--#include file = "inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		mod.admin.photoresize.asp 0 20080312120000
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
	
dim crn_action, crn_isnew
crn_action = normalize(request.QueryString("action"),"edit","new")
crn_isnew = crn_action = "new"
%>
<h2>Foto da visualizzare</h2>
	<div class="page-description">
	<p>L'immagine originale &egrave; presente: da essa verranno ora costruite l'immagine visualizzata sul photoblog e successivamente la miniatura per la galleria.</p>
	<p>Per creare l'immagine da visualizzare &egrave; possibile scegliere fra un <strong>ridimensionamento automatico</strong>, se il servizio &egrave; disponibile, (ad altezza 480px e larghezza proporzionata), l'utilizzo di <strong>una copia dell'immagine originale</strong> oppure <strong>il caricamento di una immagine</strong> ridimensionata appositamente da te (si consiglia un'altezza fissa di 480px e una larghezza proporzionata partendo dall'originale).</p><%
	if not crn_isnew then %>
	<p>Se si vuole modificare esclusivamente la miniatura &egrave; anche possibile <strong>mantenere l'immagine attualmente caricata</strong> (visualizzata più in basso).</p><%
	end if%></div>
	<% if carnival_aspnetactive then %>
	<div class="resize-box">
		<div class="resize-result"><img src="<%=carnival_pathimages%>lay-adm-ico-photo-resize.gif" alt=""  /></div>
		<div class="resize-call"><a href="<%=CARNIVAL_PUBLIC & CARNIVAL_SERVICES%>wbresize.aspx?f=<%=carnival_wbresizeprepath()%><%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crnPhotoId & CARNIVAL_ORIGINALPOSTFIX & crnPhotoOriginal%>.jpg&amp;h=480&amp;c=100&amp;q=1&amp;t=<%=carnival_wbresizeprepath()%><%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS%>&amp;n=<%=CARNIVAL_PHOTOPREFIX & crnPhotoId%>&amp;k=<%=carnival_wbresizekey%>&amp;r=<%=carnival_wbresizeprepath()%>admin.asp?module=photo-thumb%26id=<%=crnPhotoId%>%26action=<%=crn_action%>">ridimensiona</a></div>
	</div>
	<% end if %>
	<div class="upload-box">
		<div class="upload-result"><img src="<%=carnival_pathimages%>lay-adm-ico-photo-upload.gif" alt=""  /></div>
		<form action="admin.asp?module=pro-photo-upload&amp;id=<%=crnPhotoId%>&amp;type=photo&amp;action=<%=crn_action%>" method="post" enctype="multipart/form-data" class="upload">
			<div><label for="file">upload photo (max height 480px)</label><input name="file" id="file" type="file" class="file" /><input type="submit" value="upload" class="submit" /></div>
		</form>
	</div>
	<div class="clear"></div>
	<div class="resize-box">
		<div class="resize-result"><img src="<%=carnival_pathimages%>lay-adm-ico-photo-copy.gif" alt=""  /></div>
		<div class="resize-call"><a href="admin.asp?module=pro-photo-upload&amp;id=<%=crnPhotoId%>&amp;type=copy&amp;action=<%=crn_action%>">copia l'originale</a></div>
	</div>
	<% if not crn_isnew then %>
	<div class="resize-box">
		<div class="resize-result"><img src="<%=carnival_pathimages%>lay-adm-ico-photo-keep.gif" alt=""  /></div>
		<div class="resize-call"><a href="admin.asp?module=photo-thumb&amp;id=<%=crnPhotoId%>&amp;action=<%=crn_action%>">mantieni</a></div>
	</div>
	<div class="clear"></div>
	<hr />
	<div class="check-box">
	<div class="check-title">immagine attuale</div>
		<p class="alert">(ATTENZIONE: la foto NON è stata tagliata,<br/>semplicemente se &egrave; pi&ugrave; larga di 700pixel non viene visualizzata interamente!)</p>
		<div class="check-photo"><img src="<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crnPhotoId & ".jpg?nc=" & noCache%>" alt="original photo" /></div>
	</div>
	<% end if %>
	<div class="clear"></div>