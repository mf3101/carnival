<%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		gen.photoinfo.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
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
set rs = conn.execute(SQL)
if not rs.eof then
do
	%><a href="gallery.asp?tag=<%=rs("tag_name")%>"><%=rs("tag_name")%></a><%
	rs.movenext
	if not rs.eof then
		%>, <%
	else
		exit do
	end if
loop
end if
%></div>
<% if carnival_exifactive then %>
<hr/>
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