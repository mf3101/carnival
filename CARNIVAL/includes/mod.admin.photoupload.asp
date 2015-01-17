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
' * @version         SVN: $Id: mod.admin.photoupload.asp 16 2008-06-28 12:25:27Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"-->
<%
dim crn_returnpage
crnPhotoId = request.QueryString("id")
crn_returnpage = cleanLong(request.QueryString("returnpage"))

SQL = "SELECT photo_original FROM tba_photo WHERE photo_id = " & crnPhotoId
set rs = dbManager.conn.execute(SQL)
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
	<form action="admin.asp?module=pro-photo-upload&amp;id=<%=crnPhotoId%>&amp;type=new&amp;action=<%=crn_action%>&amp;returnpage=<%=crn_returnpage%>" method="post" enctype="multipart/form-data" class="upload">
		<div><label for="file">upload original (high resolution)</label><input name="file" id="file" type="file" class="file" /><input type="submit" value="upload" class="submit" /></div>
	</form>
	</div>
	<% if not crn_isnew then %>
	<div class="resize-box">
		<div class="resize-result"><img src="<%=carnival_pathimages%>lay-adm-ico-photo-keep.gif" alt=""  /></div>
		<div class="resize-call"><a href="admin.asp?module=photo-resize&amp;id=<%=crnPhotoId%>&amp;action=<%=crn_action%>&amp;returnpage=<%=crn_returnpage%>">mantieni attuale</a></div>
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