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
' * @version         SVN: $Id: mod.admin.photothumb.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "inc.admin.check.asp"-->
<!--#include file = "inc.func.services.asp"--><%
'*****************************************************

dim lngDBPhotoId, strReturnQuerystring
lngDBPhotoId = inputLong(request.QueryString("id"))
strReturnQuerystring = request.QueryString("returnpage")

dim strDBPhotoOriginal, blnDBPhotoActive
SQL = "SELECT photo_original, photo_active FROM tba_photo WHERE photo_id = " & lngDBPhotoId
set rs = dbManager.Execute(SQL)
if rs.eof then  response.redirect("errors.asp?c=post0")
strDBPhotoOriginal = rs("photo_original")
blnDBPhotoActive = inputBoolean(rs("photo_active"))

dim strAction, blnIsNewphoto
strAction = normalize(request.QueryString("action"),"edit","new")
blnIsNewphoto = strAction = "new"
%>
<h2>Miniatura</h2>
	<div class="page-description"><p>L'immagine originale e quella visualizzata sul photoblog sono presenti, è quindi ora necessario creare la miniatura (thumbnail) per la galleria.</p>
	<p>E' possibile creare la miniatura <strong>ridimensionando la foto originale</strong>, se il servizio &egrave; disponibile, (ad altezza 90px e larghezza proporzionata) oppure <strong>caricare una miniatura</strong> ridimensionata appositamente da te (si consiglia un'altezza fissa di 90px e una larghezza proporzionata partendo dall'originale).</p><%
	if not blnIsNewphoto then %>
	<p>E' possibile <strong>mantenere la miniatura esistente</strong> (visualizzata più in basso) nel caso in cui non la si voglia modificare.</p>
	<% end if%></div>
	<% if config__aspnetactive__ then %><div class="resize-box">
		<div class="resize-result"><img src="<%=getImagePath("lay-adm-ico-photo-thumb.gif")%>" alt=""  /></div>
		<div class="resize-call"><a href="<%=CARNIVAL_PUBLIC & CARNIVAL_SERVICES%>wbresize.aspx?f=<%=getWbresizePath()%><%= CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & lngDBPhotoId & CARNIVAL_ORIGINALPOSTFIX & strDBPhotoOriginal%>.jpg&amp;h=90&amp;c=100&amp;q=1&amp;t=<%=getWbresizePath()%><%=CARNIVAL_PHOTOS%>&amp;n=<%=CARNIVAL_PHOTOPREFIX & lngDBPhotoId & CARNIVAL_THUMBPOSTFIX & IIF(blnDBPhotoActive,"",strDBPhotoOriginal)%>&amp;k=<%=config__wbresizekey__%>&amp;r=<%=CARNIVAL_MAIN%>admin.asp?module=photo-check%26id=<%=lngDBPhotoId%>%26action=<%=strAction%>%26returnpage=<%=strReturnQuerystring%>">crea miniatura</a></div>
	</div><% end if %>
	<div class="upload-box">
		<div class="upload-result"><img src="<%=getImagePath("lay-adm-ico-photo-upload.gif")%>" alt=""  /></div>
		<form action="admin.asp?module=pro-photo-upload&amp;id=<%=lngDBPhotoId%>&amp;type=thumb&amp;action=<%=strAction%>&amp;returnpage=<%=strReturnQuerystring%>" method="post" enctype="multipart/form-data" class="upload">
			<div><label for="file">upload thumb (max height 90px)</label><input name="file" id="file" type="file" class="file" /><input type="submit" value="upload" class="submit" /></div>
		</form>
	</div>
	<% if not blnIsNewphoto then %>
	<div class="resize-box">
		<div class="resize-result"><img src="<%=getImagePath("lay-adm-ico-photo-keep.gif")%>" alt=""  /></div>
		<div class="resize-call"><a href="admin.asp?module=photo-check&amp;id=<%=lngDBPhotoId%>&amp;action=<%=strAction%>&amp;returnpage=<%=strReturnQuerystring%>">mantieni</a></div>
	</div>
	<div class="clear"></div>
	<hr />
	<div class="check-box">
	<div class="check-title">miniatura attuale</div>
		<div class="check-photo"><img src="<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & lngDBPhotoId & CARNIVAL_THUMBPOSTFIX & IIF(blnDBPhotoActive,"",strDBPhotoOriginal) & ".jpg?nc=" & noCache%>" alt="original photo" /></div>
	</div>
	<% end if %>
	<div class="clear"></div>