<!--#include file = "inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		mod.admin.photothumb.asp 0 20080312120000
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
<h2>Miniatura</h2>
	<div class="page-description"><p>L'immagine originale e quella visualizzata sul photoblog sono presenti, è quindi ora necessario creare la miniatura (thumbnail) per la galleria.</p>
	<p>E' possibile creare la miniatura <strong>ridimensionando la foto originale</strong>, se il servizio &egrave; disponibile, (ad altezza 90px e larghezza proporzionata) oppure <strong>caricare una miniatura</strong> ridimensionata appositamente da te (si consiglia un'altezza fissa di 90px e una larghezza proporzionata partendo dall'originale).</p><%
	if not crn_isnew then %>
	<p>E' possibile <strong>mantenere la miniatura esistente</strong> (visualizzata più in basso) nel caso in cui non la si voglia modificare.</p>
	<% end if%></div>
	<% if carnival_aspnetactive then %><div class="resize-box">
		<div class="resize-result"><img src="<%=carnival_pathimages%>lay-adm-ico-photo-thumb.gif" alt=""  /></div>
		<div class="resize-call"><a href="<%=CARNIVAL_PUBLIC & CARNIVAL_SERVICES%>wbresize.aspx?f=<%=carnival_wbresizeprepath()%><%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crnPhotoId & CARNIVAL_ORIGINALPOSTFIX & crnPhotoOriginal%>.jpg&amp;h=90&amp;c=100&amp;q=1&amp;t=<%=carnival_wbresizeprepath()%><%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS%>&amp;n=<%=CARNIVAL_PHOTOPREFIX & crnPhotoId & CARNIVAL_THUMBPOSTFIX%>&amp;k=<%=carnival_wbresizekey%>&amp;r=<%=carnival_wbresizeprepath()%>admin.asp?module=photo-check%26id=<%=crnPhotoId%>%26action=<%=crn_action%>">crea miniatura</a></div>
	</div><% end if %>
	<div class="upload-box">
		<div class="upload-result"><img src="<%=carnival_pathimages%>lay-adm-ico-photo-upload.gif" alt=""  /></div>
		<form action="admin.asp?module=pro-photo-upload&amp;id=<%=crnPhotoId%>&amp;type=thumb&amp;action=<%=crn_action%>" method="post" enctype="multipart/form-data" class="upload">
			<div><label for="file">upload thumb (max height 90px)</label><input name="file" id="file" type="file" class="file" /><input type="submit" value="upload" class="submit" /></div>
		</form>
	</div>
	<% if not crn_isnew then %>
	<div class="resize-box">
		<div class="resize-result"><img src="<%=carnival_pathimages%>lay-adm-ico-photo-keep.gif" alt=""  /></div>
		<div class="resize-call"><a href="admin.asp?module=photo-check&amp;id=<%=crnPhotoId%>&amp;action=<%=crn_action%>">mantieni</a></div>
	</div>
	<div class="clear"></div>
	<hr />
	<div class="check-box">
	<div class="check-title">miniatura attuale</div>
		<div class="check-photo"><img src="<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crnPhotoId & CARNIVAL_THUMBPOSTFIX & ".jpg?nc=" & noCache%>" alt="original photo" /></div>
	</div>
	<% end if %>
	<div class="clear"></div>