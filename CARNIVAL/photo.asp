<!--#include file = "includes/inc.first.asp"--><%
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
' * @version         SVN: $Id: photo.asp 18 2008-06-29 02:54:08Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

crnPopupTagCloud = true
crnIsPhotoPage = true

dim crn_photoPrevId, crn_photoNextId
dim crn_photoPrevTitle, crn_photoNextTitle
dim crn_photoPhotos

crnPhotoId = cleanLong(request.QueryString("id"))
if crnPhotoId < 0 then crnPhotoId = 0

crnTagName = request.QueryString("tag")
if crnTagName = "(NEW)" then crnTagName = ""
crnTagId = 0

crnSetId = cleanLong(request.QueryString("set"))
crnSetName = ""

if crnTagName <> "" then
	SQL = "SELECT tag_id, tag_name,tag_photos FROM tba_tag WHERE tag_name = '" & replace(crnTagName,"'","''") & "'"
	set rs = dbManager.conn.execute(SQL)
	if rs.eof then response.Redirect("default.asp")
	crnTagId = rs("tag_id")
	crnTagName = rs("tag_name")
	crn_photoPhotos = rs("tag_photos")
	'crnTitle = replace(crnLang_photo_title_tag,"%s",crnTagName) & replace(crnLang_photo_title_photos,"%n",crn_photoPhotos)
elseif crnSetId > 0 then
	SQL = "SELECT set_id,set_name, set_photos FROM tba_set WHERE set_id = " & crnSetId
	set rs = dbManager.conn.execute(SQL)
	if rs.eof then response.Redirect("default.asp")
	crnSetId = rs("set_id")
	crnSetName = rs("set_name")
	crn_photoPhotos = rs("set_photos")
else
	SQL = "SELECT Count(*) AS photos FROM tba_photo WHERE photo_active = 1"
	set rs = dbManager.conn.execute(SQL)
	crn_photoPhotos = rs("photos")
	'crnTitle = crnLang_photo_title_all & replace(crnLang_photo_title_photos,"%n",crn_photoPhotos)
end if
if crnPhotoId = 0 then
	if crnTagId > 0 then
		SQL = "SELECT TOP 1 tba_photo.photo_id, tba_photo.photo_title, tba_photo.photo_description " & _
			  "FROM tba_rel INNER JOIN tba_photo ON tba_rel.rel_photo = tba_photo.photo_id " & _
			  "WHERE tba_rel.rel_tag=" & crnTagId & " AND tba_photo.photo_active = 1 ORDER BY tba_rel.rel_photo DESC"
	elseif crnSetId > 0 then
		SQL = "SELECT TOP 1 photo_id FROM tba_photo WHERE photo_active = 1 AND photo_set = " & crnSetId & " ORDER BY photo_order, photo_id DESC"
	else
		SQL = "SELECT TOP 1 photo_id FROM tba_photo WHERE photo_active = 1 ORDER BY photo_id DESC"
	end if
	set rs = dbManager.conn.execute(SQL)
	if rs.eof then
		if crnTagId = 0 and crnSetId = 0 then response.redirect("errors.asp?c=photo0")
		response.Redirect("default.asp")
	end if
	set rs = dbManager.conn.execute(SQL)
	crnPhotoId = rs("photo_id")
end if

call checkPhoto(crnPhotoId)

if crnTagId > 0 then
	SQL = "SELECT tba_photo.photo_id, tba_photo.photo_title, tba_photo.photo_description, tba_photo.photo_pub, tba_photo.photo_order " & _
		  "FROM tba_rel INNER JOIN tba_photo ON tba_rel.rel_photo = tba_photo.photo_id " & _
		  "WHERE tba_rel.rel_tag=" & crnTagId & " AND tba_rel.rel_photo = " & crnPhotoId & " AND tba_photo.photo_active = 1"
else 'sia photo che set
	SQL = "SELECT photo_title, photo_description, photo_pub, photo_order FROM tba_photo WHERE photo_id = " & crnPhotoId & " AND photo_active = 1"
end if
set rs = dbManager.conn.execute(SQL)
'se la foto non esiste manda default.asp (carica l'ultima foto)
if rs.eof then response.redirect "default.asp"

crnPhotoTitle = server.HTMLEncode(rs("photo_title"))
crnPhotoDescription = server.HTMLEncode(rs("photo_description"))
crnPhotoPub = formatGMTDate(rs("photo_pub"),0,"dd/mm/yyyy")
crnPhotoOrder = cleanLong(rs("photo_order"))

dim crn_photoCommentsCount
crn_photoCommentsCount = 0
SQL = "SELECT Count(comment_id) AS commentscount FROM tba_comment WHERE comment_photo = " & crnPhotoId
set rs = dbManager.conn.execute(SQL)
crn_photoCommentsCount = rs("commentscount")
crnMenuComment = crnLang_menu_comments & " (" & crn_photoCommentsCount & ")"
	
if crnTagId > 0 then
	SQL = "SELECT TOP 1 tba_photo.photo_id, tba_photo.photo_title " & _
		  "FROM tba_rel INNER JOIN tba_photo ON tba_rel.rel_photo = tba_photo.photo_id " & _
		  "WHERE tba_rel.rel_tag=" & crnTagId & " AND tba_rel.rel_photo < " & crnPhotoId & " AND tba_photo.photo_active = 1 ORDER BY tba_rel.rel_photo  DESC"
elseif crnSetId > 0 then
	SQL = "SELECT TOP 1 photo_id, photo_title FROM tba_photo WHERE ((photo_id < " & crnPhotoId & " AND photo_order = " & crnPhotoOrder & ") OR (photo_order > " & crnPhotoOrder & ")) AND (photo_active = 1) AND (photo_set = " & crnSetId & ") ORDER BY photo_order ASC, photo_id DESC"
else
	SQL = "SELECT TOP 1 photo_id, photo_title FROM tba_photo WHERE photo_id < " & crnPhotoId & " AND photo_active = 1 ORDER BY photo_id DESC"
end if
set rs = dbManager.conn.execute(SQL)
if rs.eof then
	crn_photoPrevId = 0
	crn_photoPrevTitle = "-"
else
	crn_photoPrevId = rs("photo_id")
	crn_photoPrevTitle = rs("photo_title")
end if
if crnTagId > 0 then
	SQL = "SELECT TOP 1 tba_photo.photo_id, tba_photo.photo_title " & _
		  "FROM tba_rel INNER JOIN tba_photo ON tba_rel.rel_photo = tba_photo.photo_id " & _
		  "WHERE tba_rel.rel_tag=" & crnTagId & " AND tba_rel.rel_photo > " & crnPhotoId & " AND tba_photo.photo_active = 1 ORDER BY tba_rel.rel_photo ASC"
elseif crnSetId > 0 then
	SQL = "SELECT TOP 1 photo_id, photo_title FROM tba_photo WHERE ((photo_id > " & crnPhotoId & " AND photo_order = " & crnPhotoOrder & ") OR (photo_order < " & crnPhotoOrder & ")) AND (photo_active = 1) AND (photo_set = " & crnSetId & ") ORDER BY photo_order DESC, photo_id ASC"
else
	SQL = "SELECT TOP 1 photo_id, photo_title FROM tba_photo WHERE photo_id > " & crnPhotoId & " AND photo_active = 1 ORDER BY photo_id ASC"
end if
set rs = dbManager.conn.execute(SQL)
if rs.eof then
	crn_photoNextId = 0
	crn_photoNextTitle = "-"
else
	crn_photoNextId = rs("photo_id")
	crn_photoNextTitle = rs("photo_title")
end if

crnPhotoUrl = CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crnPhotoId & ".jpg"
crnPageTitle = carnival_title '& " ::: " & crnLang_photo_title & " > """ & crnPhotoTitle & """"

%><!--#include file = "includes/inc.top.asp"-->
<% if carnival_jsactive then %>
<script type="text/javascript">/* <![CDATA[ */
var title = String('<%=cleanJSOutputString(carnival_title)%>')
var selected = Number(<%=crnPhotoId%>);
var tag = Number(<%=crnTagId%>);
var set = Number(<%=crnSetId%>);
var pathimages = '<%=carnival_pathimages%>';
var lastviewedphoto = Number(<%=crnLastViewedPhoto%>);
var baloons = true;

var lang_title = String('<%=cleanJSOutputString(crnLang_photo_title)%>');
var lang_comments = String('<%=cleanJSOutputString(crnLang_main_comments)%>');
var lang_details = String('<%=cleanJSOutputString(crnLang_main_details)%>');
var lang_close = String('<%=cleanJSOutputString(crnLang_main_close)%>');
var lang_new = String('<%=cleanJSOutputString(crnLang_photo_new)%>');
//overlay
function overlay() {
	//#overlay > div#init
	$('overlay').appendChild(createDiv('init'));
	
	//#init > img
	$('init').appendChild(createImg('',pathimages+'lay-loading-bar.gif','LOADING...'));
	
	//#init > div#initinfo
	$('init').appendChild(createDiv('initinfo'));
	
	var arrayPageSize = getPageSize();
	//var arrayPageScroll = getPageScroll();
	Element.setHeight('overlay', arrayPageSize[1]);
	Element.hide('container');
	Element.show('overlay');
}
overlay();

document.onmouseout = function() { bodyOnMouseOut(); };
if (!is_ie) window.onresize = function() { resizeWin(); };
/* ]]> */</script>
<% end if %>
<div id="photo-header-nojs"><div id="photo-date"><%=crnPhotoPub%></div><div id="photo-tag"><% if crnTagName <> "" then response.write "( " & crnTagName & " )" %><% if crnSetName <> "" then response.write "( " & crnSetName & " )" %></div><div id="photo-new"><% if clng(crnLastViewedPhoto) < clng(crnPhotoId) and crnLastViewedPhoto <> 0 then%><%=crnLang_photo_new%><% end if %></div><div id="photo-title"><span class="number">#<%=crnPhotoId%></span> <%=crnPhotoTitle%></div></div>
<div id="photo-box-nojs">
	<div id="photo-overlay-open"></div>
	<div id="photo-overlay"></div>
	<div id="photo-overlay-comments"></div>
	<div id="photo-overlay-details"></div>
	<div id="photo-overlay-buttons"></div>
	<div id="photo"><img id="photo-img-nojs" src="<%=crnPhotoUrl%>" alt="photo" /></div>
</div>
<div id="photo-info">
	<div id="photo-buttons-nojs">
		<a href="comments.asp?id=<%=crnPhotoId%>#details" title="<%=crnLang_main_details%>"><img src="<%=carnival_pathimages%>photo-details-w.gif" alt="<%=crnLang_main_details%>" /></a>
		<a href="comments.asp?id=<%=crnPhotoId%>#comments" title="<%=crnLang_main_comments%>"><img src="<%=carnival_pathimages%>photo-comments-w.gif" alt="<%=crnLang_main_comments%>" /></a>
	</div>
</div>
<div id="photo-slideshow"></div>
<div id="photo-nav-nojs">
	<div id="photo-next"<% if crn_photoNextId = 0 then %> style="display:none;"<% end if %>><a href="?id=<%=crn_photoNextId%><% if crnTagId <> 0 then %>&amp;tag=<%=crnTagName%><% end if %>" <% if carnival_jsactive then %>onclick="next();return false;" <% end if %>id="next" title="<%=crn_photoNextTitle%>"><img id="nextimg" src="<%=carnival_pathimages%>lay-photo-nav-next-nojs.gif" alt="<%=crnLang_main_next%>"  /></a></div>
	<div id="photo-prev"<% if crn_photoPrevId = 0 then %> style="display:none;"<% end if %>><a href="?id=<%=crn_photoPrevId%><% if crnTagId <> 0 then %>&amp;tag=<%=crnTagName%><% end if %>" id="prev" <% if carnival_jsactive then %>onclick="previous();return false;" <% end if %>title="<%=crn_photoPrevTitle%>"><img id="previmg" src="<%=carnival_pathimages%>lay-photo-nav-prev-nojs.gif" alt="<%=crnLang_main_prev%>"  /></a></div>
</div>
<% if carnival_jsactive then %>
<script type="text/javascript">/* <![CDATA[ */ initCarnival(); /* ]]> */</script>
<% end if %>
<!--#include file = "includes/inc.bottom.asp"-->