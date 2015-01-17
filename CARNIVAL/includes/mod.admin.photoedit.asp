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
' * @version         SVN: $Id: mod.admin.photoedit.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "inc.admin.check.asp"--><%
'*****************************************************

dim strAction, strReturnQuerystring
strAction = normalize(request.QueryString("action"),"edit","new")
strReturnQuerystring = request.QueryString("returnpage")

dim strSubTitle, strButtonCaption
select case strAction
	case "new"
		strSubTitle = "Nuova foto"
		strButtonCaption = "salva"
	case "edit"
		strSubTitle = "Modifica foto"
		strButtonCaption = "modifica"
end select

dim lngPhotoId
lngPhotoId = inputLong(request.QueryString("id"))

dim lngDBPhotoId, strDBPhotoTitle, strDBPhotoDescription, blnDBPhotoCropped, blnDBPhotoElaborated, dtmDBPhotoPub, bytDBPhotoPubQueue, blnDBPhotoActive, blnDBPhotoDownloadable, lngDBPhotoSet, strDBPhotoOriginal
SQL = "SELECT * FROM tba_photo WHERE photo_id = " & lngPhotoId
set rs = dbManager.Execute(SQL)
if rs.eof then response.Redirect("admin.asp?module=photo-list")
lngDBPhotoId = rs("photo_id")
strDBPhotoTitle = rs("photo_title")
strDBPhotoDescription = rs("photo_description")
blnDBPhotoCropped = inputBoolean(rs("photo_cropped"))
blnDBPhotoElaborated = inputBoolean(rs("photo_elaborated"))
dtmDBPhotoPub = inputDate(rs("photo_pub"))
bytDBPhotoPubQueue = inputByte(rs("photo_pubqueue"))
blnDBPhotoActive = inputBoolean(rs("photo_active"))
blnDBPhotoDownloadable = inputBoolean(rs("photo_downloadable"))
lngDBPhotoSet = inputLong(rs("photo_set")) : if lngDBPhotoSet < 1 then lngDBPhotoSet = 1
strDBPhotoOriginal = rs("photo_original")
set rs = nothing

dim strDBPhotoTags
SQL = "SELECT tba_tag.tag_name FROM tba_rel INNER JOIN tba_tag ON tba_rel.rel_tag = tba_tag.tag_id WHERE tba_rel.rel_photo=" & lngDBPhotoId & " ORDER BY tba_tag.tag_photos, tba_tag.tag_name"
set rs = dbManager.Execute(SQL)
strDBPhotoTags = ""
while not rs.eof
	strDBPhotoTags = strDBPhotoTags & outputHTMLString(rs("tag_name")) & " "
	rs.movenext
wend
set rs = nothing

%><h2><%=strSubTitle%></h2>
	<form class="post" action="admin.asp?module=pro-photo-edit" method="post">
		<div><input type="hidden" name="action" id="action" value="edit" />
		<input type="hidden" name="id" id="id" value="<%=lngDBPhotoId%>" />
		<input type="hidden" name="returnpage" id="returnpage" value="<%=strReturnQuerystring%>" />
		<label for="title">titolo</label>
		<input type="text" id="title" name="title" class="text" maxlength="50" value="<%=outputHTMLString(strDBPhotoTitle)%>" /></div>
		<div><label for="description">descrizione</label>
		<img src="<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & lngDBPhotoId & CARNIVAL_THUMBPOSTFIX & IIF(blnDBPhotoActive,"",strDBPhotoOriginal) & ".jpg?nc=" & noCache%>" alt="" class="photo-thumb"/><textarea id="description" name="description" cols="20" rows="10" style="width:460px;"><%=outputHTMLString(strDBPhotoDescription)%></textarea></div>
		<div style="float:left;margin-right:5px;"><label for="title">data di pubblicazione (aaaa/mm/gg h:m:s)</label>
		<input type="text" id="pub" name="pub" class="text" maxlength="19" value="<%=formatGMTDate(IIF(strAction="new",now,dtmDBPhotoPub),0,"yyyy/mm/dd hh:nn:ss")%>" /><br /></div>
		<div><label for="pubqueue">pubblicazione automatica</label>
		<select style="width:250px;" id="pubqueue" name="pubqueue">
        	<option value="0"<% if bytDBPhotoPubQueue = 0 then response.write " selected=""selected"""%>>disattivata</option>
        	<option value="1"<% if bytDBPhotoPubQueue = 1 then response.write " selected=""selected"""%>>alla data indicata</option>
        	<option value="2"<% if bytDBPhotoPubQueue = 2 then response.write " selected=""selected"""%>>periodica</option>
        </select>
		</div>
<small>indicando una data futura la foto verr&agrave; automaticamente pubblicata<br />
selezionando pubblicazione periodica la data verr&agrave; calcolata automaticamente</small>
        
        <div class="clear"></div><hr style="margin-bottom:0;"/><div class="clear"></div>
		<div style="float:left;margin-right:5px;"><label for="tags">tags (dividere i tag con uno spazio)</label>
		<input type="text" id="tags" name="tags" class="text" value="<%=outputHTMLString(strDBPhotoTags)%>" /></div>
		<div><label for="tagslist">lista tag</label>
		<select style="width:250px;" id="tagslist" name="tagslist" onchange="document.getElementById('tags').value+=this.value;this.selectedIndex = 0;">
			<option value="" selected="selected">seleziona un tag da aggiungere</option>
			<%
			SQL = "SELECT tag_id, tag_name, tag_photos FROM tba_tag ORDER BY tag_photos DESC,tag_name"
			set rs = dbManager.Execute(SQL)
			while not rs.eof
		%>		<option value=" <%=rs("tag_name")%>"><%=rs("tag_name")%> (<%=rs("tag_photos")%>)</option>
		<%
				rs.movenext
			wend
		%>	</select>
		</div>
        
        <div class="clear"></div><hr style="margin-bottom:0;"/><div class="clear"></div>
		<div><label for="set">set</label>
		<select style="width:250px;" id="set" name="set">
			<%
			SQL = "SELECT set_id, set_name FROM tba_set ORDER BY set_order, set_name"
			set rs = dbManager.Execute(SQL)
			while not rs.eof
		%>		<option value="<%=rs("set_id")%>"<% if lngDBPhotoSet = clng(rs("set_id")) then response.write " selected=""selected"""%>><%=rs("set_name")%></option>
		<%
				rs.movenext
			wend
		%>	</select>
		</div>
        
        <div class="clear"></div><hr style="margin-bottom:0;"/><div class="clear"></div>
             
		<div style="float:left;margin-right:5px;"><label for="cropped">tagliata</label>
		<select id="cropped" name="cropped">
			<option value="1"<% if blnDBPhotoCropped then %> selected="selected"<% end if %>>Si</option>
			<option value="0"<% if not blnDBPhotoCropped then %> selected="selected"<% end if %>>No</option>
		</select></div>
		<div><label for="elaborated">elaborata</label>
		<select id="elaborated" name="elaborated">
			<option value="1"<% if blnDBPhotoElaborated then %> selected="selected"<% end if %>>Si</option>
			<option value="0"<% if not blnDBPhotoElaborated then %> selected="selected"<% end if %>>No</option>
		</select></div>
		<div style="float:left;margin-right:5px;"><label for="cropped">foto visibile</label>
		<select id="active" name="active">
			<option value="1"<% if blnDBPhotoActive or strAction = "new" then %> selected="selected"<% end if %>>Si</option>
			<option value="0"<% if not blnDBPhotoActive and strAction <> "new"then %> selected="selected"<% end if %>>No</option>
		</select></div>
		<div><label for="elaborated">foto ad alta risoluzione scaricabile</label>
		<select id="downloadable" name="downloadable">
			<option value="1"<% if blnDBPhotoDownloadable then %> selected="selected"<% end if %>>Si</option>
			<option value="0"<% if not blnDBPhotoDownloadable then %> selected="selected"<% end if %>>No</option>
		</select></div>
        
        <div class="clear"></div><hr style="margin-bottom:0;"/><div class="clear"></div>
        
		<div class="nbuttons">
			<% if strAction = "edit" then %>
			<a href="admin.asp?module=photo-list&amp;<%=readyToQuerystring(strReturnQuerystring)%>">
				<span>
				<img src="<%=getImagePath("lay-adm-ico-but-prev.gif")%>" alt=""/> 
				indietro
				</span>
			</a>
			<% end if %>
			<button type="submit">
				<span class="a"><span class="b">
				<img src="<%=getImagePath("lay-adm-ico-but-accept.gif")%>" alt=""/> 
				<%=strButtonCaption%>
				</span></span>
			</button>
		</div>
	</form>
	<div class="clear"></div>