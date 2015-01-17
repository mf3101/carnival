<%
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
' * @version         SVN: $Id: gen.photoinfo.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "inc.func.exif.asp"--><%
'*****************************************************

dim strPhotoUrl

if lngCurrentPhotoId__ <> 0 then
	strPhotoUrl = CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & lngCurrentPhotoId__ & CARNIVAL_ORIGINALPOSTFIX & strDBPhotoOriginal &  ".jpg"
%>
<div class="photo"><a href="photo.asp?id=<%=lngCurrentPhotoId__%>"><img src="<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & lngCurrentPhotoId__ & CARNIVAL_THUMBPOSTFIX%>.jpg" alt="thumb" /></a></div>
<div class="views"><%=replace(lang__details_views__,"%n",lngDBPhotoViews)%></div>
<div class="description"><%
	if blnViaJavascript then
		response.write replace(server.htmlencode(strDBPhotoDescription),vbcr,"<br/>")
	else
		response.write replace(strDBPhotoDescription,vbcr,"<br/>")
	end if %></div>
<div class="clear"></div>
<% 	if blnDBPhotoDownloadable then 

%><hr/>
<div class="download">
<img src="<%=getImagePath("lay-ico-photo.gif")%>" alt="" class="icon" /><a href="<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & lngCurrentPhotoId__ & CARNIVAL_ORIGINALPOSTFIX & strDBPhotoOriginal%>.jpg" target="_blank"><%=lang__details_download__%></a>
</div>
<% 	
	end if 
%><hr/>
<div class="tags"><b><img src="<%=getImagePath("lay-ico-tag.gif")%>" alt="" class="icon" /><%=lang__details_tag__%>:</b> <%
	SQL = "SELECT tba_tag.tag_name, tba_tag.tag_id FROM tba_rel INNER JOIN tba_tag ON tba_rel.rel_tag = tba_tag.tag_id WHERE tba_rel.rel_photo=" & lngCurrentPhotoId__ & " ORDER BY tba_tag.tag_photos, tba_tag.tag_name"
	set rs = dbManager.Execute(SQL)
	if not rs.eof then
		do
			%><a href="gallery.asp?mode=stream&amp;tag=<%=rs("tag_name")%>"<% 
	if config__jsnavigatoractive__ and config__jsactive__ and blnViaJavascript then
	%> onclick="callNavigator(0,<%=rs("tag_id")%>,<%=lngCurrentPhotoId__%>);return false;"<%
	end if%>><%=rs("tag_name")%></a><%
			rs.movenext
			if not rs.eof then
				%>, <%
			else
				exit do
			end if
		loop
	end if
%></div><hr/><%
	if config__mode__ <> 2 then %>
<div class="set"><b><img src="<%=getImagePath("lay-ico-set.gif")%>" alt="" class="icon" /><%=lang__details_set__%>:</b> <%
	SQL = "SELECT set_name FROM tba_set WHERE set_id = " & lngDBPhotoSet
	set rs = dbManager.Execute(SQL)
	if not rs.eof then
%><a href="gallery.asp?mode=sets&amp;set=<%=lngDBPhotoSet%>"<% 
	if config__jsnavigatoractive__ and config__jsactive__ and blnViaJavascript then
	%> onclick="callNavigator(<%=lngDBPhotoSet%>,0,<%=lngCurrentPhotoId__%>);return false;"<%
	end if%>><%=outputHTMLString(rs("set_name"))%></a><%
	end if
%></div>
<hr/><% 
	end if 


	if config__exifactive__ then %>
<div class="clear"></div>
<div class="exif"><%
		dim IFDDirectory, ImageFileOffsets
	
		dim dtmExifShotTime
	
		if LoadImage(Server.MapPath(strPhotoUrl), IFDDirectory, ImageFileOffsets) = "" then
			dtmExifShotTime = GetExifByName(IFDDirectory, "Date Time Original", true)
			on error resume next
			dtmExifShotTime = formatGMTDate(dtmExifShotTime,0,"hh:nn:ss ddd dd mmm yyyy")
			if err.number <> 0 then dtmExifShotTime = ""
			on error goto 0
			%>
<b><img src="<%=getImagePath("lay-ico-camera.gif")%>" alt="" class="icon" /><%=lang__details_exif__%>:</b>
<table class="exif"><% 
			if dtmExifShotTime <> "" then %>
<tr><td class="parameter"><%=lang__details_exif_shot__%></td>
<td class="content"><%=dtmExifShotTime%></td></tr><% 
			end if%>
<tr><td class="parameter"><%=lang__details_exif_camera__%></td>
<td class="content"><%=GetExifByName(IFDDirectory, "Camera Make", false)%> (<%=GetExifByName(IFDDirectory, "Camera Model", false)%>)</td></tr>
<tr><td class="parameter"><%=lang__details_exif_aperture__%></td>
<td class="content">F/<%=getFStop(IFDDirectory)%></td></tr>
<tr><td class="parameter"><%=lang__details_exif_shutterspeed__%></td>
<td class="content"><%
			dim shutterspeed
			shutterspeed = getShutterSpeed(IFDDirectory, true)
			response.write IIF(shutterspeed = "0","bulb",shutterspeed & " sec")
%></td></tr>
<tr><td class="parameter"><%=lang__details_exif_focallength__%></td>
<td class="content"><%=int(getFocalLength(IFDDirectory))%> mm</td></tr>
<tr><td class="parameter"><%=lang__details_exif_flash__%></td>
<td class="content"><%=GetExifByName(IFDDirectory, "Flash", true)%></td></tr>
<tr><td class="parameter"><%=lang__details_exif_meteringmode__%></td>
<td class="content"><%=GetExifByName(IFDDirectory, "Metering Mode", true) %></td></tr>
<tr><td class="parameter"><%=lang__details_exif_orientation__%></td>
<td class="content"><%=GetExifByName(IFDDirectory, "Orientation", true) %></td></tr>
<tr><td class="parameter"><%=lang__details_exif_compression__%></td>
<td class="content"><%=GetExifByName(IFDDirectory, "Compression", true)%></td></tr>
<tr><td class="parameter"><%=lang__details_exif_cropped__%></td>
<td class="content"><% if blnDBPhotoCropped then : response.write lang__main_yes__ : else : response.write lang__main_no__ : end if%></td></tr>
<tr><td class="parameter"><%=lang__details_exif_elaborated__%></td>
<td class="content"><% if blnDBPhotoElaborated then : response.write lang__main_yes__ : else : response.write lang__main_no__ : end if%></td></tr>
</table>
<% 		end if %>
</div>
<% 	end if %>
<div class="clear"></div>
<% 
end if %>