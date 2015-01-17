<!--#include file = "inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		mod.admin.photolist.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"-->
	<div class="admin-minibutton"><img src="<%=carnival_pathimages%>/lay-adm-ico-act-new.gif" alt="" /><a href="admin.asp?module=photo-new">nuovo post</a></div>
	<h2>Elenco post</h2>
	<div class="clear"></div>
	<%
	
	if cstr(request.QueryString("top")) = "0" then crnShowTop = 0
	
	dim crn_photoActive, crn_photoActiveImg
	dim crn_photoDownloadable, crn_photoDownloadableImg
	
	SQL = "SELECT"
	if crnShowTop > 0 then SQL = SQL & " TOP " & crnShowTop
	SQL = SQL & " photo_id, photo_title, photo_pub,photo_active,photo_views,photo_downloadable,photo_original FROM tba_photo ORDER BY photo_id DESC"
	set rs = conn.execute(SQL)
	
	%>
	<table class="post">
		<tr class="head">
			<td class="act"></td>
			<td class="img"></td>
			<td class="id">ID</td>
			<td class="title">TITOLO</td>
			<td class="pub">DATA PUB</td>
			<td class="view">VIEW</td>
			<td class="act"></td>
			<td class="act"></td>
			<td class="act"></td>
			<td class="act"></td>
			<td class="act"></td>
		</tr>
	<%
	crnCounter = 0
	while not rs.eof
		
		crnPhotoId = rs("photo_id")
		crnPhotoTitle = rs("photo_title")
		crn_photoActive = rs("photo_active")
		if crn_photoActive = 1 then
			crn_photoActive = "hide"
			crn_photoActiveImg = "show"
		else
			crn_photoActive = "show"
			crn_photoActiveImg = "hide"
		end if
		crn_photoDownloadable  = rs("photo_downloadable")
		if crn_photoDownloadable = 1 then
			crn_photoDownloadable = "downoff"
			crn_photoDownloadableImg = "downon"
		else
			crn_photoDownloadable = "downon"
			crn_photoDownloadableImg = "downoff"
		end if
		crnPhotoOriginal = rs("photo_original")
		crnPhotoViews = rs("photo_views")
		crnPhotoPub = formatGMTDate(rs("photo_pub"),0,"dd/mm/yyyy")
		crnCounter = crnCounter + 1
		
		%>
		<tr>
			<td class="act"><a href="<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crnPhotoId & CARNIVAL_ORIGINALPOSTFIX & crnPhotoOriginal & ".jpg"%>" target="_blank" title="visualizza foto alta risoluzione"><img src="<%=carnival_pathimages%>lay-adm-ico-act-download.gif" alt="download" /></a></td>
			<td class="img"><a href="photo.asp?id=<%=crnPhotoId%>" target="_blank" title="visualizza foto"><img src="<%=carnival_pathimages%>lay-adm-ico-id-photo.gif" alt="photo" /></a></td>
			<td class="id"><%=crnPhotoId%></td>
			<td class="title"><%=crnPhotoTitle%></td>
			<td class="pub"><%=crnPhotoPub%></td>
			<td class="view"><%=crnPhotoViews%></td>
			<td class="act"><a href="admin.asp?module=pro-photo-edit&amp;id=<%=crnPhotoId%>&amp;action=<%=crn_photoDownloadable%>" title="permetti/nega download immagine ad alta risoluzione"><img src="<%=carnival_pathimages%>lay-adm-ico-act-<%=crn_photoDownloadableImg%>.gif" alt="" /></a></td>
			<td class="act"><a href="admin.asp?module=pro-photo-edit&amp;id=<%=crnPhotoId%>&amp;action=<%=crn_photoActive%>" title="visualizza/nascondi"><img src="<%=carnival_pathimages%>lay-adm-ico-act-<%=crn_photoActiveImg%>.gif" alt="" /></a></td>
			<td class="act"><a href="admin.asp?module=photo-edit&amp;id=<%=crnPhotoId%>&amp;action=edit" title="modifica"><img src="<%=carnival_pathimages%>lay-adm-ico-act-edit.gif" alt="modifica" /></a></td>
			<td class="act"><a href="admin.asp?module=photo-upload&amp;id=<%=crnPhotoId%>&amp;action=edit" title="carica nuove foto"><img src="<%=carnival_pathimages%>lay-adm-ico-act-upload.gif" alt="upload" /></a></td>
			<td class="act"><a href="admin.asp?module=pro-photo-edit&amp;id=<%=crnPhotoId%>&amp;action=del" onclick="if (!confirm('la cancellazione di un post &egrave; irreversibile e comporta anche l\'eliminazione delle immagini caricate.\nvuoi veramente cancellare il post?')) return false;" title="cancella"><img src="<%=carnival_pathimages%>lay-adm-ico-act-del.gif" alt="cancella" /></a></td>
		</tr>
		<%
		
		rs.movenext
	wend
	%>
	</table>
	<% if crnShowTop > 0 and clng(crnCounter) => clng(crnShowTop) then %>
	<div class="showall">questi sono gli ultimi <%=crnShowTop%> post<br/><a href="admin.asp?module=photo-list&amp;top=0">visualizza tutti i post</a></div>	<% end if %>