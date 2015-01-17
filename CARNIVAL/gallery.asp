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
' * @version         SVN: $Id: gallery.asp 20 2008-06-29 15:36:00Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

crnPopupTagCloud = false

crnTitle = crnLang_gallery_title

dim crn_tagPhotos, crn_galleryMode, crn_set, crn_setName
crn_galleryMode = normalize(request.QueryString("mode"),"sets|archives|stream",IIF(carnival_mode=1,"sets","stream"))
if carnival_mode = 2 then crn_galleryMode = "stream"

crnTagName = trim(request.QueryString("tag"))
crnTagId = 0
crn_set = cleanLong(request.QueryString("set"))

if cstr(request.QueryString("top")) = "0" then crnShowTop = 0

select case crn_galleryMode
	case "stream"
		if (crnTagName <> "" and crnTagName <> "(NEW)") or (crnTagName = "(NEW)" and crnLastViewedPhoto > 0) then
			if crnTagName = "(NEW)" then
				
				SQL = "SELECT Count(*) AS photos FROM tba_photo WHERE photo_id > " & crnLastViewedPhoto & " AND photo_active = 1"
				set rs = dbManager.conn.execute(SQL)
				crn_tagPhotos = rs("photos")
				crnPageTitle = crnLang_photo_title_newphotos & replace(crnLang_photo_title_photos,"%n",crn_tagPhotos)
				crnTagId = -1
			else
			
				SQL = "SELECT tag_name, tag_id, tag_photos FROM tba_tag WHERE tag_name = '" & replace(crnTagName,"'","''") & "'"
				set rs = dbManager.conn.execute(SQL)
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
				set rs = dbManager.conn.execute(SQL)
				crn_tagPhotos = rs("photos")
				crnTagName = ""
				crnPageTitle = crnLang_photo_title_all & replace(crnLang_photo_title_photos,"%n",crn_tagPhotos)
		end if
	case "sets"
		if crn_set > 0 then
			SQL = "SELECT set_name FROM tba_set WHERE set_id = " & crn_set
			set rs = dbManager.conn.execute(SQL)
			if rs.eof then response.redirect("gallery.asp?mode=sets")
			crn_setName = rs("set_name")
			crnPageTitle = "Set &quot;" & crn_setName & "&quot;"
		else
			crnPageTitle = "Set"
		end if
end select

crnPageTitle = carnival_title & " ::: " & crnLang_gallery_title & " > " & crnPageTitle

%><!--#include file = "includes/inc.top.asp"-->
	<% if carnival_mode <> 2 then %>
	<div class="gallerytabs">
        <ul class="tabmenu">
            <li<% if crn_galleryMode = "stream" then %> class="selected"<% end if %>>
            	<a href="?mode=stream">Stream</a>
            </li>
            <li<% if crn_galleryMode = "sets" then %> class="selected"<% end if %>>
            	<a href="?mode=sets">Set</a>
            </li>
            <!--<li<% if crn_galleryMode = "archives" then %> class="selected"<% end if %>>
            	<a href="?mode=archives">Archivi</a>
            </li>-->
        </ul>
    </div>
    <% end if %>
    <% select case crn_galleryMode 
		case "stream"%>
    <div class="galleryselect<%if carnival_mode = 2 then response.write " pure"%>"><form id="form_tag" action="gallery.asp" method="get">
    	<input type="hidden" id="mode" name="mode" value="stream" />
        <div><b><%=crnLang_gallery_tag%>:</b> <select class="galleryselect" id="tag" name="tag" onchange="document.getElementById('form_tag').submit();">
            <option value="" style="font-weight:bold;"><%=crnLang_gallery_tag_all%></option>
            <% if cstr(crnLastViewedPhoto) <> cstr(crnLastPhoto) and crnLastViewedPhoto > 0 then %><option value="(NEW)" style="color:red;" <% if crnTagName = "(NEW)" then %> selected="selected"<% end if %>><%=crnLang_gallery_tag_new%></option><% end if %>
        <%
        SQL = "SELECT tag_id, tag_name, tag_photos FROM tba_tag ORDER BY tag_photos DESC,tag_name"
        set rs = dbManager.conn.execute(SQL)
        while not rs.eof
    %>		<option value="<%=rs("tag_name")%>"<% if clng(rs("tag_id")) = clng(crnTagId) then %> selected="selected"<% end if %>>
                <%=rs("tag_name")%> (<%=rs("tag_photos")%>)
            </option>
    <%
            rs.movenext
        wend
    %>	</select>
        <input id="tag_send" type="submit" value="<%=crnLang_gallery_tag_send%>" class="galleryselect" /></div>
        <script type="text/javascript">/* <![CDATA[ */ Element.hide('tag_send') /* ]]> */</script>
        </form>
    </div>
    <% case "sets"
		if crn_set > 0 then
			%><div class="galleryset"><img src="<%=carnival_pathimages%>lay-adm-ico-id-set.gif" alt="" class="icon" /> &quot;<%=cleanOutputString(crn_setName)%>&quot;</div><%
		end if
	end select %>
    
    <div class="hrtabmenu"></div>
        
	<div class="clear"></div>
	<%
	dim crn_printmode
	crn_printmode = "photo"
	
	select case crn_galleryMode
		case "stream"
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
		case "sets"
			if crn_set > 0 then
				
				SQL = "SELECT photo_id FROM tba_photo WHERE photo_set = " & crn_set & " AND photo_active = 1 ORDER BY photo_order, photo_id DESC"

			
			else
				crn_printmode = "set"
				SQL = "SELECT set_id, set_name, set_cover FROM tba_set ORDER BY set_order, set_name"
			
			end if
	end select
	set rs = dbManager.conn.execute(SQL)
	%>
	<div id="thumbs" class="<%=crn_printmode%>">
    <%
	if rs.eof then %>
	<div class="thumb-empty"><%=crnLang_gallery_nophotos%></div>
	<% end if
	dim crn_id, crn_title, crn_url, crn_photourl
	while not rs.eof
		if crn_printmode = "set" then
			crn_id = rs("set_id")
			crn_title = rs("set_name")
			crn_url = "gallery.asp?mode=sets&amp;set=" & crn_id
			crn_photourl = IIF(cleanLong(rs("set_cover"))=0,carnival_pathimages & "/thumb-set-empty.gif",CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & rs("set_cover") & CARNIVAL_THUMBPOSTFIX & ".jpg")
		else
			crn_id = rs("photo_id")
			crn_title = ""
			crn_url = "photo.asp?id=" & crn_id
			if crnTagId <> 0 and crn_galleryMode = "stream" then crn_url = crn_url & "&amp;tag=" & crnTagName
			if crn_set > 0 and crn_galleryMode = "sets" then crn_url = crn_url & "&amp;set=" & crn_set
			crn_photourl = CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crn_id & CARNIVAL_THUMBPOSTFIX & ".jpg"
		end if
%>
		<div class="thumb-back"><div class="thumb"><a href="<%=crn_url%>"><img src="<%=crn_photourl%>" alt="" /></a></div>
		<% if crn_title <> "" then 
		%><div class="thumb-title"><%=left(crn_title,40) & IIF(len(crn_title)>40,"...","")%></div><% 
		end if %>
		</div>
	<% rs.movenext
	wend
%>	</div>
<div class="clear"></div>
	<% if crnShowTop > 0 and clng(crn_tagPhotos) > clng(crnShowTop) then %>
	<hr />
	<div class="showall"><%=replace(crnLang_gallery_last_photos,"%n",crnShowTop)%><br/><a href="gallery.asp?<% if crnTagId <> 0 then %>tag=<%=crnTagName%>&amp;<%end if%>top=0"><%=crnLang_gallery_last_showall%></a></div><% end if %>
<!--#include file = "includes/inc.bottom.asp"-->