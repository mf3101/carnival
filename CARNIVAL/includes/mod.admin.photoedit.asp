<!--#include file = "inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		mod.admin.photoedit.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"--><%

dim crn_action
crn_action = normalize(request.QueryString("action"),"edit","new")
dim crn_photoActive
if crn_action <> "edit" then
	crn_subtitle = "Nuovo post"
	crn_send = "salva"
	crn_photoActive = 1
else
	crn_subtitle = "Modifica post"
	crn_send = "modifica"
	crn_photoActive = 0
end if

dim crn_id
crn_id = cleanLong(request.QueryString("id"))

dim crn_tags, crn_subtitle, crn_send

SQL = "SELECT * FROM tba_photo WHERE photo_id = " & crn_id
set rs = conn.execute(SQL)
if rs.eof then response.Redirect("admin.asp?module=photo-list")
crnPhotoId = rs("photo_id")
crnPhotoTitle = cleanOutputString(rs("photo_title"))
crnPhotoDescription = cleanOutputString(rs("photo_description"))
crnPhotoCropped = rs("photo_cropped")
crnPhotoElaborated = rs("photo_elaborated")
if crn_photoActive = 0 then crn_photoActive = rs("photo_active")
crnPhotoDownloadable = rs("photo_downloadable")

SQL = "SELECT tba_tag.tag_name FROM tba_rel INNER JOIN tba_tag ON tba_rel.rel_tag = tba_tag.tag_id WHERE tba_rel.rel_photo=" & crnPhotoId & " ORDER BY tba_tag.tag_photos, tba_tag.tag_name"
set rs = conn.execute(SQL)
crn_tags = ""
while not rs.eof
	crn_tags = crn_tags & cleanOutputString(rs("tag_name")) & " "
	rs.movenext
wend

%><h2><%=crn_subtitle%></h2>
	<form class="post" action="admin.asp?module=pro-photo-edit" method="post">
		<div><input type="hidden" name="action" id="action" value="edit" />
		<input type="hidden" name="id" id="id" value="<%=crnPhotoId%>" />
		<label for="title">titolo</label>
		<input type="text" id="title" name="title" class="text" maxlength="50" value="<%=cleanOutputString(crnPhotoTitle)%>" /></div>
		<div><label for="description">descrizione</label>
		<img src="<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crnPhotoId & CARNIVAL_THUMBPOSTFIX & ".jpg?nc=" & noCache%>" alt="" class="photo-thumb"/><textarea id="description" name="description" cols="20" rows="10" style="width:460px;"><%=cleanOutputString(crnPhotoDescription)%></textarea></div>
		<div style="float:left;margin-right:5px;"><label for="tags">tags (dividere i tag con uno spazio)</label>
		<input type="text" id="tags" name="tags" class="text" value="<%=cleanOutputString(crn_tags)%>" /></div>
		<div><label for="elaborated">lista tag</label>
		<select style="width:250px;" id="tagslist" name="tagslist" onchange="document.getElementById('tags').value+=this.value;this.selectedIndex = 0;">
			<option value="" selected="selected">seleziona un tag da aggiungere</option>
			<%
			SQL = "SELECT tag_id, tag_name, tag_photos FROM tba_tag ORDER BY tag_photos DESC,tag_name"
			set rs = conn.execute(SQL)
			while not rs.eof
		%>		<option value=" <%=rs("tag_name")%>"><%=rs("tag_name")%> (<%=rs("tag_photos")%>)</option>
		<%
				rs.movenext
			wend
		%>	</select>
		</div>
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
		<div class="nbuttons">
			<% if crn_action = "edit" then %>
			<a href="admin.asp?module=photo-list">
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