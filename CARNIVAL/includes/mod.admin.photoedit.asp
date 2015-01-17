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
' * @version         SVN: $Id: mod.admin.photoedit.asp 18 2008-06-29 02:54:08Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"--><%

dim crn_action, crn_returnpage
crn_action = normalize(request.QueryString("action"),"edit","new")
crn_returnpage = cleanLong(request.QueryString("returnpage"))

dim crn_photoActive
if crn_action <> "edit" then
	crn_subtitle = "Nuova foto"
	crn_send = "salva"
	crn_photoActive = 1
else
	crn_subtitle = "Modifica foto"
	crn_send = "modifica"
	crn_photoActive = 0
end if

dim crn_id
crn_id = cleanLong(request.QueryString("id"))

dim crn_tags, crn_subtitle, crn_send

SQL = "SELECT * FROM tba_photo WHERE photo_id = " & crn_id
set rs = dbManager.conn.execute(SQL)
if rs.eof then response.Redirect("admin.asp?module=photo-list")
crnPhotoId = rs("photo_id")
crnPhotoTitle = rs("photo_title")
crnPhotoDescription = rs("photo_description")
crnPhotoCropped = rs("photo_cropped")
crnPhotoElaborated = rs("photo_elaborated")
if crn_photoActive = 0 then crn_photoActive = rs("photo_active")
crnPhotoDownloadable = rs("photo_downloadable")
crnPhotoSet = cleanLong(rs("photo_set")) : if crnPhotoSet < 1 then crnPhotoSet = 1

SQL = "SELECT tba_tag.tag_name FROM tba_rel INNER JOIN tba_tag ON tba_rel.rel_tag = tba_tag.tag_id WHERE tba_rel.rel_photo=" & crnPhotoId & " ORDER BY tba_tag.tag_photos, tba_tag.tag_name"
set rs = dbManager.conn.execute(SQL)
crn_tags = ""
while not rs.eof
	crn_tags = crn_tags & cleanOutputString(rs("tag_name")) & " "
	rs.movenext
wend

%><h2><%=crn_subtitle%></h2>
	<form class="post" action="admin.asp?module=pro-photo-edit" method="post">
		<div><input type="hidden" name="action" id="action" value="edit" />
		<input type="hidden" name="id" id="id" value="<%=crnPhotoId%>" />
		<input type="hidden" name="returnpage" id="returnpage" value="<%=crn_returnpage%>" />
		<label for="title">titolo</label>
		<input type="text" id="title" name="title" class="text" maxlength="50" value="<%=cleanOutputString(crnPhotoTitle)%>" /></div>
		<div><label for="description">descrizione</label>
		<img src="<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crnPhotoId & CARNIVAL_THUMBPOSTFIX & ".jpg?nc=" & noCache%>" alt="" class="photo-thumb"/><textarea id="description" name="description" cols="20" rows="10" style="width:460px;"><%=cleanOutputString(crnPhotoDescription)%></textarea></div>
        
        <div class="clear"></div><hr style="margin-bottom:0;"/><div class="clear"></div>
		<div style="float:left;margin-right:5px;"><label for="tags">tags (dividere i tag con uno spazio)</label>
		<input type="text" id="tags" name="tags" class="text" value="<%=cleanOutputString(crn_tags)%>" /></div>
		<div><label for="tagslist">lista tag</label>
		<select style="width:250px;" id="tagslist" name="tagslist" onchange="document.getElementById('tags').value+=this.value;this.selectedIndex = 0;">
			<option value="" selected="selected">seleziona un tag da aggiungere</option>
			<%
			SQL = "SELECT tag_id, tag_name, tag_photos FROM tba_tag ORDER BY tag_photos DESC,tag_name"
			set rs = dbManager.conn.execute(SQL)
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
			set rs = dbManager.conn.execute(SQL)
			while not rs.eof
		%>		<option value="<%=rs("set_id")%>"<% if crnPhotoSet = clng(rs("set_id")) then response.write " selected=""selected"""%>><%=rs("set_name")%></option>
		<%
				rs.movenext
			wend
		%>	</select>
		</div>
        
        <div class="clear"></div><hr style="margin-bottom:0;"/><div class="clear"></div>
             
		<div style="float:left;margin-right:5px;"><label for="cropped">tagliata</label>
		<select id="cropped" name="cropped">
			<option value="1"<% if crnPhotoCropped = 1 then %> selected="selected"<% end if %>>Si</option>
			<option value="0"<% if crnPhotoCropped = 0 then %> selected="selected"<% end if %>>No</option>
		</select></div>
		<div><label for="elaborated">elaborata</label>
		<select id="elaborated" name="elaborated">
			<option value="1"<% if crnPhotoElaborated = 1 then %> selected="selected"<% end if %>>Si</option>
			<option value="0"<% if crnPhotoElaborated = 0 then %> selected="selected"<% end if %>>No</option>
		</select></div>
		<div style="float:left;margin-right:5px;"><label for="cropped">foto visibile</label>
		<select id="active" name="active">
			<option value="1"<% if crn_photoActive = 1 then %> selected="selected"<% end if %>>Si</option>
			<option value="0"<% if crn_photoActive = 0 then %> selected="selected"<% end if %>>No</option>
		</select></div>
		<div><label for="elaborated">foto ad alta risoluzione scaricabile</label>
		<select id="downloadable" name="downloadable">
			<option value="1"<% if crnPhotoDownloadable = 1 then %> selected="selected"<% end if %>>Si</option>
			<option value="0"<% if crnPhotoDownloadable = 0 then %> selected="selected"<% end if %>>No</option>
		</select></div>
        
        <div class="clear"></div><hr style="margin-bottom:0;"/><div class="clear"></div>
        
		<div class="nbuttons">
			<% if crn_action = "edit" then %>
			<a href="admin.asp?module=photo-list&amp;page=<%=crn_returnpage%>">
				<span>
				<img src="<%=carnival_pathimages%>/lay-adm-ico-but-prev.gif" alt=""/> 
				indietro
				</span>
			</a>
			<% end if %>
			<button type="submit">
				<span class="a"><span class="b">
				<img src="<%=carnival_pathimages%>/lay-adm-ico-but-accept.gif" alt=""/> 
				<%=crn_send%>
				</span></span>
			</button>
		</div>
	</form>
	<div class="clear"></div>