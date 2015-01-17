<!--#include file = "includes/inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		gallery.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------

crnPopupTagCloud = false

crnTitle = crnLang_gallery_title

dim crn_tagPhotos
crnTagName = trim(request.QueryString("tag"))
crnTagId = 0

if cstr(request.QueryString("top")) = "0" then crnShowTop = 0

if (crnTagName <> "" and crnTagName <> "(NEW)") or (crnTagName = "(NEW)" and crnLastViewedPhoto > 0) then
	if crnTagName = "(NEW)" then
		
		SQL = "SELECT Count(*) AS photos FROM tba_photo WHERE photo_id > " & crnLastViewedPhoto & " AND photo_active = 1"
		set rs = conn.execute(SQL)
		crn_tagPhotos = rs("photos")
		crnPageTitle = crnLang_photo_title_newphotos & replace(crnLang_photo_title_photos,"%n",crn_tagPhotos)
		crnTagId = -1
	else
	
		SQL = "SELECT tag_name, tag_id, tag_photos FROM tba_tag WHERE tag_name = '" & replace(crnTagName,"'","''") & "'"
		set rs = conn.execute(SQL)
		if not rs.eof then
			crnTagId = rs("tag_id")
			crnTagName = rs("tag_name")
			crn_tagPhotos = rs("tag_photos")
			crnPageTitle = replace(crnLang_photo_title_tag,"%s",crnTagName) & replace(crnLang_photo_title_photos,"%n",crn_tagPhotos)
		else
			crnTagId = 0
		end if
		
	end if
end if

if crnTagId = 0 then
		SQL = "SELECT Count(*) AS photos FROM tba_photo WHERE photo_active = 1"
		set rs = conn.execute(SQL)
		crn_tagPhotos = rs("photos")
		crnTagName = ""
		crnPageTitle = crnLang_photo_title_all & replace(crnLang_photo_title_photos,"%n",crn_tagPhotos)
end if

crnPageTitle = carnival_title & " ::: " & crnLang_gallery_title & " > " & crnPageTitle

%><!--#include file = "includes/inc.top.asp"-->
<script type="text/javascript">/* <![CDATA[ */
/*editDom_cloud();
init_cloud();
loadCloud();*/
/* ]]> */</script>
	<div class="tagselect"><form id="form_tag" action="gallery.asp" method="get">
	<div><b><%=crnLang_gallery_tag%>:</b> <select class="tagselect" id="tag" name="tag" onchange="document.getElementById('form_tag').submit();">
		<option value="" style="font-weight:bold;"><%=crnLang_gallery_tag_all%></option>
		<% if cstr(crnLastViewedPhoto) <> cstr(crnLastPhoto) and crnLastViewedPhoto > 0 then %><option value="(NEW)" style="color:red;" <% if crnTagName = "(NEW)" then %> selected="selected"<% end if %>><%=crnLang_gallery_tag_new%></option><% end if %>
	<%
	SQL = "SELECT tag_id, tag_name, tag_photos FROM tba_tag ORDER BY tag_photos DESC,tag_name"
	set rs = conn.execute(SQL)
	while not rs.eof
%>		<option value="<%=rs("tag_name")%>"<% if clng(rs("tag_id")) = clng(crnTagId) then %> selected="selected"<% end if %>>
			<%=rs("tag_name")%> (<%=rs("tag_photos")%>)
		</option>
<%
		rs.movenext
	wend
%>	</select>
	<input id="tag_send" type="submit" value="<%=crnLang_gallery_tag_send%>" class="tagselect" /></div>
	<script type="text/javascript">/* <![CDATA[ */ Element.hide('tag_send') /* ]]> */</script>
	</form></div>
	<hr />
	<div class="clear"></div>
	<div id="thumbs">
	<%
	select case crnTagId
		case 0 'tutte
			SQL = "SELECT"
			if crnShowTop > 0 then SQL = SQL & " TOP " & crnShowTop
			SQL = SQL & " photo_id FROM tba_photo WHERE photo_active = 1 ORDER BY photo_id DESC"
		case -1 'nuove
			SQL = "SELECT"
			if crnShowTop > 0 then SQL = SQL & " TOP " & crnShowTop
			SQL = SQL & " photo_id FROM tba_photo WHERE photo_id > " & crnLastViewedPhoto & " AND photo_active = 1 ORDER BY photo_id DESC"
		case else
			SQL = "SELECT"
			if crnShowTop > 0 then SQL = SQL & " TOP " & crnShowTop
			SQL = SQL & " tba_photo.photo_id " & _
				  "FROM tba_rel INNER JOIN tba_photo ON tba_rel.rel_photo = tba_photo.photo_id " & _
				  "WHERE tba_rel.rel_tag=" & crnTagId & " AND tba_photo.photo_active = 1 ORDER BY tba_rel.rel_photo DESC"
	end select
	set rs = conn.execute(SQL)
	if rs.eof then %>
	<div class="thumb-empty"><%=crnLang_gallery_nophotos%></div>
	<% end if
	while not rs.eof
		crnPhotoId = rs("photo_id")
		crnPhotoUrl = CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crnPhotoId & CARNIVAL_THUMBPOSTFIX & ".jpg"
%>	<div class="thumb-back"><div class="thumb"><a href="photo.asp?id=<%=crnPhotoId%><% if crnTagId <> 0 then %>&amp;tag=<%=crnTagName%><%end if%>"><img src="<%=crnPhotoUrl%>" alt="" /></a></div></div>
	<% rs.movenext
	wend
%>	</div>
<div class="clear"></div>
	<% if crnShowTop > 0 and clng(crn_tagPhotos) > clng(crnShowTop) then %>
	<hr />
	<div class="showall"><%=replace(crnLang_gallery_last_photos,"%n",crnShowTop)%><br/><a href="gallery.asp?<% if crnTagId <> 0 then %>tag=<%=crnTagName%>&amp;<%end if%>top=0"><%=crnLang_gallery_last_showall%></a></div><% end if %>
<!--#include file = "includes/inc.bottom.asp"-->