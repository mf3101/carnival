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
' * @version         SVN: $Id: mod.admin.photoresize.asp 16 2008-06-28 12:25:27Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"-->
<% 
dim crn_returnpage
crnPhotoId = cleanLong(request.QueryString("id"))
crn_returnpage = cleanLong(request.QueryString("returnpage"))

SQL = "SELECT photo_original FROM tba_photo WHERE photo_id = " & crnPhotoId
set rs = dbManager.conn.execute(SQL)
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
		<div class="resize-call"><a href="<%=CARNIVAL_PUBLIC & CARNIVAL_SERVICES%>wbresize.aspx?f=<%=carnival_wbresizeprepath()%><%= CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crnPhotoId & CARNIVAL_ORIGINALPOSTFIX & crnPhotoOriginal%>.jpg&amp;h=480&amp;c=100&amp;q=1&amp;t=<%=carnival_wbresizeprepath()%><%=CARNIVAL_PHOTOS%>&amp;n=<%=CARNIVAL_PHOTOPREFIX & crnPhotoId%>&amp;k=<%=carnival_wbresizekey%>&amp;r=<%=CARNIVAL_MAIN%>admin.asp?module=photo-thumb%26id=<%=crnPhotoId%>%26action=<%=crn_action%>%26returnpage=<%=crn_returnpage%>">ridimensiona</a></div>
	</div>
	<% end if %>
	<div class="upload-box">
		<div class="upload-result"><img src="<%=carnival_pathimages%>lay-adm-ico-photo-upload.gif" alt=""  /></div>
		<form action="admin.asp?module=pro-photo-upload&amp;id=<%=crnPhotoId%>&amp;type=photo&amp;action=<%=crn_action%>&amp;returnpage=<%=crn_returnpage%>" method="post" enctype="multipart/form-data" class="upload">
			<div><label for="file">upload photo (max height 480px)</label><input name="file" id="file" type="file" class="file" /><input type="submit" value="upload" class="submit" /></div>
		</form>
	</div>
	<div class="clear"></div>
	<div class="resize-box">
		<div class="resize-result"><img src="<%=carnival_pathimages%>lay-adm-ico-photo-copy.gif" alt=""  /></div>
		<div class="resize-call"><a href="admin.asp?module=pro-photo-upload&amp;id=<%=crnPhotoId%>&amp;type=copy&amp;action=<%=crn_action%>&amp;returnpage=<%=crn_returnpage%>">copia l'originale</a></div>
	</div>
	<% if not crn_isnew then %>
	<div class="resize-box">
		<div class="resize-result"><img src="<%=carnival_pathimages%>lay-adm-ico-photo-keep.gif" alt=""  /></div>
		<div class="resize-call"><a href="admin.asp?module=photo-thumb&amp;id=<%=crnPhotoId%>&amp;action=<%=crn_action%>&amp;returnpage=<%=crn_returnpage%>">mantieni</a></div>
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