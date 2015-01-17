<!--#include file = "includes/inc.first.asp"--><%
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
' * @version         SVN: $Id: gallery.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
' nessun enviroment aggiuntivo
'*****************************************************

strPageTitle__ = lang__gallery_title__

dim strGalleryMode
strGalleryMode = normalize(request.QueryString("mode"),"sets|archives|stream",IIF(config__mode__=1,"sets","stream"))
if config__mode__ = 2 then strGalleryMode = "stream"

dim lngTagPhotos, strSetName

strCurrentTagName__ = trim(request.QueryString("tag"))
lngCurrentTagId__ = 0
lngCurrentSetId__ = inputLong(request.QueryString("set"))

if cstr(request.QueryString("top")) = "0" then intRecordsOnce__ = 0

select case strGalleryMode
	case "stream"
		if (strCurrentTagName__ <> "" and strCurrentTagName__ <> "(NEW)") or (strCurrentTagName__ = "(NEW)" and lngLastViewedPhotoId__ > 0) then
			if strCurrentTagName__ = "(NEW)" then
				
				SQL = "SELECT Count(*) AS photos FROM tba_photo WHERE photo_pub > " & formatDBDate(inputDate(dtmLastViewedPhotoPub__),CARNIVAL_DATABASE_TYPE) & " AND photo_active = 1"
				set rs = dbManager.Execute(SQL)
				lngTagPhotos = rs("photos")
				strPageTitleHead__ = lang__photo_title_newphotos__ & replace(lang__photo_title_photos__,"%n",lngTagPhotos)
				lngCurrentTagId__ = -1
			else
			
				SQL = "SELECT tag_name, tag_id, tag_photos FROM tba_tag WHERE tag_name = '" & formatDBString(strCurrentTagName__,null) & "'"
				set rs = dbManager.Execute(SQL)
				if not rs.eof then
					lngCurrentTagId__ = rs("tag_id")
					strCurrentTagName__ = rs("tag_name")
					lngTagPhotos = rs("tag_photos")
					strPageTitleHead__ = replace(lang__photo_title_tag__,"%s",strCurrentTagName__) & replace(lang__photo_title_photos__,"%n",lngTagPhotos)
				else
					lngCurrentTagId__ = 0
				end if
				
			end if
		end if
		
		if lngCurrentTagId__ = 0 then
				SQL = "SELECT Count(*) AS photos FROM tba_photo WHERE photo_active = 1"
				set rs = dbManager.Execute(SQL)
				lngTagPhotos = rs("photos")
				strCurrentTagName__ = ""
				strPageTitleHead__ = lang__photo_title_all__ & replace(lang__photo_title_photos__,"%n",lngTagPhotos)
		end if
	case "sets"
		if lngCurrentSetId__ > 0 then
			SQL = "SELECT set_name FROM tba_set WHERE set_id = " & lngCurrentSetId__
			set rs = dbManager.Execute(SQL)
			if rs.eof then response.redirect("gallery.asp?mode=sets")
			strSetName = rs("set_name")
			strPageTitleHead__ = "Set &quot;" & strSetName & "&quot;"
		else
			strPageTitleHead__ = "Set"
		end if
end select

strPageTitleHead__ = config__title__ & " ::: " & lang__gallery_title__ & " > " & strPageTitleHead__

%><!--#include file = "includes/inc.top.asp"-->
	<% if config__mode__ <> 2 then %>
	<div class="gallerytabs">
        <ul class="tabmenu">
            <li<% if strGalleryMode = "stream" then %> class="selected"<% end if %>>
            	<a href="?mode=stream">Stream</a>
            </li>
            <li<% if strGalleryMode = "sets" then %> class="selected"<% end if %>>
            	<a href="?mode=sets">Set</a>
            </li>
            <!--<li<% if strGalleryMode = "archives" then %> class="selected"<% end if %>>
            	<a href="?mode=archives">Archivi</a>
            </li>-->
        </ul>
    </div>
    <% end if %>
    <% select case strGalleryMode 
		case "stream"%>
    <div class="galleryselect<%if config__mode__ = 2 then response.write " pure"%>"><form id="form_tag" action="gallery.asp" method="get">
    	<input type="hidden" id="mode" name="mode" value="stream" />
        <div><b><%=lang__gallery_tag__%>:</b> <select class="galleryselect" id="tag" name="tag" onchange="document.getElementById('form_tag').submit();">
            <option value="" style="font-weight:bold;"><%=lang__gallery_tag_all__%></option>
            <% if (dtmLastViewedPhotoPub__) <> (dtmLastPhotoPub__) and lngLastViewedPhotoId__ > 0 then %><option value="(NEW)" style="color:red;" <% if strCurrentTagName__ = "(NEW)" then %> selected="selected"<% end if %>><%=lang__gallery_tag_new__%></option><% end if %>
        <%
        SQL = "SELECT tag_id, tag_name, tag_photos FROM tba_tag ORDER BY tag_photos DESC,tag_name"
        set rs = dbManager.Execute(SQL)
        while not rs.eof
    %>		<option value="<%=rs("tag_name")%>"<% if clng(rs("tag_id")) = clng(lngCurrentTagId__) then %> selected="selected"<% end if %>>
                <%=rs("tag_name")%> (<%=rs("tag_photos")%>)
            </option>
    <%
            rs.movenext
        wend
    %>	</select>
        <input id="tag_send" type="submit" value="<%=lang__gallery_tag_send__%>" class="galleryselect" /></div>
        <script type="text/javascript">/* <![CDATA[ */ $('tag_send').hide(); /* ]]> */</script>
        </form>
    </div>
    <% case "sets"
		if lngCurrentSetId__ > 0 then
			%><div class="galleryset"><img src="<%=getImagePath("lay-adm-ico-id-set.gif")%>" alt="" class="icon" /> &quot;<%=outputHTMLString(strSetName)%>&quot;</div><%
		end if
	end select %>
    
    <div class="hrtabmenu"></div>
        
	<div class="clear"></div>
	<%
	dim strGalleryPrintMode '"photo", "set"
	strGalleryPrintMode = "photo"
	
	select case strGalleryMode
		case "stream"
			select case lngCurrentTagId__
				case 0 'tutte
					SQL = "SELECT"
					if intRecordsOnce__ > 0 then SQL = SQL & " TOP " & intRecordsOnce__
					SQL = SQL & " photo_id FROM tba_photo WHERE photo_active = 1 ORDER BY photo_pub DESC"
				case -1 'nuove
					SQL = "SELECT"
					if intRecordsOnce__ > 0 then SQL = SQL & " TOP " & intRecordsOnce__
					SQL = SQL & " photo_id FROM tba_photo WHERE photo_pub > " & formatDBDate(inputDate(dtmLastViewedPhotoPub__),CARNIVAL_DATABASE_TYPE) & " AND photo_active = 1 ORDER BY photo_pub DESC"
				case else
					SQL = "SELECT"
					if intRecordsOnce__ > 0 then SQL = SQL & " TOP " & intRecordsOnce__
					SQL = SQL & " tba_photo.photo_id " & _
						  "FROM tba_rel INNER JOIN tba_photo ON tba_rel.rel_photo = tba_photo.photo_id " & _
						  "WHERE tba_rel.rel_tag=" & lngCurrentTagId__ & " AND tba_photo.photo_active = 1 ORDER BY tba_photo.photo_pub DESC"
			end select
		case "sets"
			if lngCurrentSetId__ > 0 then
				
				SQL = "SELECT photo_id FROM tba_photo WHERE photo_set = " & lngCurrentSetId__ & " AND photo_active = 1 ORDER BY photo_order, photo_pub DESC"

			
			else
				strGalleryPrintMode = "set"
				SQL = "SELECT set_id, set_name, set_cover FROM tba_set ORDER BY set_order, set_name"
			
			end if
	end select
	set rs = dbManager.Execute(SQL)
	%>
	<div id="thumbs" class="<%=strGalleryPrintMode%>">
    <%
	if rs.eof then %>
	<div class="thumb-empty"><%=lang__gallery_nophotos__%></div>
	<% end if
	dim lngId, strTitle, strUrl, strPhotoUrl
	while not rs.eof
		if strGalleryPrintMode = "set" then
			lngId = rs("set_id")
			strTitle = rs("set_name")
			strUrl = "gallery.asp?mode=sets&amp;set=" & lngId
			strPhotoUrl = IIF(inputLong(rs("set_cover"))=0,config__pathimages__ & "/thumb-set-empty.gif",CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & rs("set_cover") & CARNIVAL_THUMBPOSTFIX & ".jpg")
		else
			lngId = rs("photo_id")
			strTitle = ""
			strUrl = "photo.asp?id=" & lngId
			if lngCurrentTagId__ <> 0 and strGalleryMode = "stream" then strUrl = strUrl & "&amp;tag=" & strCurrentTagName__
			if lngCurrentSetId__ > 0 and strGalleryMode = "sets" then strUrl = strUrl & "&amp;set=" & lngCurrentSetId__
			strPhotoUrl = CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & lngId & CARNIVAL_THUMBPOSTFIX & ".jpg"
		end if
%>
		<div class="thumb-back"><div class="thumb"><a href="<%=strUrl%>"><img src="<%=strPhotoUrl%>" alt="" /></a></div>
		<% if strTitle <> "" then 
		%><div class="thumb-title"><%=left(strTitle,40) & IIF(len(strTitle)>40,"...","")%></div><% 
		end if %>
		</div>
	<% rs.movenext
	wend
%>	</div>
<div class="clear"></div>
	<% if intRecordsOnce__ > 0 and clng(lngTagPhotos) > clng(intRecordsOnce__) then %>
	<hr />
	<div class="showall"><%=replace(lang__gallery_last_photos__,"%n",intRecordsOnce__)%><br/><a href="gallery.asp?<% if lngCurrentTagId__ <> 0 then %>tag=<%=strCurrentTagName__%>&amp;<%end if%>top=0"><%=lang__gallery_last_showall__%></a></div><% end if %>
<!--#include file = "includes/inc.bottom.asp"-->