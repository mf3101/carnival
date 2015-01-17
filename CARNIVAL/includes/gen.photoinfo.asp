<%
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
' * @version         SVN: $Id: gen.photoinfo.asp 20 2008-06-29 15:36:00Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------
%><!--#include file = "inc.func.exif.asp"-->
<%
if crnPhotoId <> 0 then
crnPhotoUrl = CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crnPhotoId & CARNIVAL_ORIGINALPOSTFIX & crnPhotoOriginal &  ".jpg"
%>
<div class="photo"><a href="photo.asp?id=<%=crnPhotoId%>"><img src="<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crnPhotoId & CARNIVAL_THUMBPOSTFIX%>.jpg" alt="thumb" /></a></div>
<div class="views"><%=replace(crnLang_details_views,"%n",crnPhotoViews)%></div>
<div class="description"><%
if crn_viaJs then
	response.write replace(server.htmlencode(crnPhotoDescription),vbcr,"<br/>")
else
	response.write replace(crnPhotoDescription,vbcr,"<br/>")
end if %></div>
<div class="clear"></div>
<% if crnPhotoDownloadable then 
%><hr/>
<div class="download">
<img src="<%=carnival_pathimages%>lay-ico-photo.gif" alt="" class="icon" /><a href="<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crnPhotoId & CARNIVAL_ORIGINALPOSTFIX & crnPhotoOriginal%>.jpg" target="_blank"><%=crnLang_details_download%></a>
</div>
<% end if 
%><hr/>
<div class="tags"><b><img src="<%=carnival_pathimages%>lay-ico-tag.gif" alt="" class="icon" /><%=crnLang_details_tag%>:</b> <%
SQL = "SELECT tba_tag.tag_name FROM tba_rel INNER JOIN tba_tag ON tba_rel.rel_tag = tba_tag.tag_id WHERE tba_rel.rel_photo=" & crnPhotoId & " ORDER BY tba_tag.tag_photos, tba_tag.tag_name"
set rs = dbManager.conn.execute(SQL)
if not rs.eof then
do
	%><a href="gallery.asp?mode=stream&amp;tag=<%=rs("tag_name")%>"><%=rs("tag_name")%></a><%
	rs.movenext
	if not rs.eof then
		%>, <%
	else
		exit do
	end if
loop
end if
%></div><hr/><%
if carnival_mode <> 2 then %>
<div class="set"><b><img src="<%=carnival_pathimages%>lay-ico-set.gif" alt="" class="icon" /><%=crnLang_details_set%>:</b> <%
SQL = "SELECT set_name FROM tba_set WHERE set_id = " & crnPhotoSet
set rs = dbManager.conn.execute(SQL)
if not rs.eof then
%><a href="gallery.asp?mode=sets&amp;set=<%=crnPhotoSet%>"><%=cleanOutputString(rs("set_name"))%></a><%
end if
%></div>
<hr/><% end if %>
<% if carnival_exifactive then %>
<div class="clear"></div>
<div class="exif"><%
dim IFDDirectory, ImageFileOffsets

dim crn_imageError
crn_imageError = ""
crn_imageError = LoadImage(Server.MapPath(crnPhotoUrl), IFDDirectory, ImageFileOffsets)

dim crn_shotTime

if crn_imageError = "" then
	crn_shotTime = GetExifByName(IFDDirectory, "Date Time Original", true)
	on error resume next
	crn_shotTime = formatGMTDate(crn_shotTime,0,"hh:nn:ss ddd dd mmm yyyy")
	if err.number <> 0 then crn_shotTime = ""
	on error goto 0
%>
<b><img src="<%=carnival_pathimages%>lay-ico-camera.gif" alt="" class="icon" /><%=crnLang_details_exif%>:</b>
<table class="exif">
	<% if crn_shotTime <> "" then %><tr><td class="parameter"><%=crnLang_details_exif_shot%></td>
		<td class="content"><%=crn_shotTime%></td></tr><% end if%>
	<tr><td class="parameter"><%=crnLang_details_exif_camera%></td>
		<td class="content"><%=GetExifByName(IFDDirectory, "Camera Make", false)%> (<%=GetExifByName(IFDDirectory, "Camera Model", false)%>)</td></tr>
	<tr><td class="parameter"><%=crnLang_details_exif_aperture%></td>
		<td class="content">F/<%=getFStop(IFDDirectory)%></td></tr>
	<tr><td class="parameter"><%=crnLang_details_exif_shutterspeed%></td>
		<td class="content"><%
		dim shutterspeed
		shutterspeed = getShutterSpeed(IFDDirectory, true)
		response.write IIF(shutterspeed = "0","bulb",shutterspeed & " sec")
		%></td></tr>
	<tr><td class="parameter"><%=crnLang_details_exif_focallength%></td>
		<td class="content"><%=int(getFocalLength(IFDDirectory))%> mm</td></tr>
	<tr><td class="parameter"><%=crnLang_details_exif_flash%></td>
		<td class="content"><%=GetExifByName(IFDDirectory, "Flash", true)%></td></tr>
	<tr><td class="parameter"><%=crnLang_details_exif_meteringmode%></td>
		<td class="content"><%=GetExifByName(IFDDirectory, "Metering Mode", true) %></td></tr>
	<tr><td class="parameter"><%=crnLang_details_exif_orientation%></td>
		<td class="content"><%=GetExifByName(IFDDirectory, "Orientation", true) %></td></tr>
	<tr><td class="parameter"><%=crnLang_details_exif_compression%></td>
		<td class="content"><%=GetExifByName(IFDDirectory, "Compression", true)%></td></tr>
	<tr><td class="parameter"><%=crnLang_details_exif_cropped%></td>
		<td class="content"><% if crnPhotoCropped <> 0 then : response.write crnLang_main_yes : else : response.write crnLang_main_no : end if%></td></tr>
	<tr><td class="parameter"><%=crnLang_details_exif_elaborated%></td>
		<td class="content"><% if crnPhotoElaborated <> 0 then : response.write crnLang_main_yes : else : response.write crnLang_main_no : end if%></td></tr>
</table>
<% end if %>
</div>
<% end if %>
<div class="clear"></div>
<% end if %>