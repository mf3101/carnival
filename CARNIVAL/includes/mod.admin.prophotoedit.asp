<!--#include file = "inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		mod.admin.prophotoedit.asp 0 20080312120000
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

dim crn_tags, crn_action, crn_id, crn_photoActive
crn_action = request.form("action")
if crn_action = "" then crn_action = request.querystring("action")
select case crn_action
	case "edit","show","hide","del","downon","downoff"
		crn_id = request.form("id")
		if crn_id = "" then crn_id = request.querystring("id")
		SQL = "SELECT photo_id, photo_active,photo_original FROM tba_photo WHERE photo_id = " & crn_id
		set rs = conn.execute(SQL)
		if rs.eof then response.Redirect("errors.asp?c=post0")
		crnPhotoId = rs("photo_id")	
		crn_photoActive = rs("photo_active")
		crnPhotoOriginal = rs("photo_original")
	case else
		crn_action = "new"
		crnPhotoId = 0
		crnPhotoTitle = "!INDICA UN TITOLO!"
		crnPhotoDescription = ""
		crnPhotoCropped = 0
		crnPhotoElaborated = 0
		crnPhotoOriginal = createKey(10)
		crnPhotoPub = formatDBDate(now,"mdb")
end select

select case crn_action
	case "show","hide"
	
		dim crn_show
		crn_show = 0
		if crn_action = "show" then crn_show = 1
		SQL = "UPDATE tba_photo SET photo_active = " & crn_show & " WHERE photo_id = " & crnPhotoId
		conn.execute(SQL)
		
		crn_show = "-"
		if crn_action = "show" then crn_show = "+"
		SQL = "SELECT rel_id, rel_tag FROM tba_rel WHERE rel_photo = " & crnPhotoId
		set rs = conn.execute(SQL)
		while not rs.eof
			SQL = "UPDATE tba_tag SET tag_photos = tag_photos " & crn_show & " 1 WHERE tag_id = " & rs("rel_tag")
			conn.execute(SQL)			
			rs.movenext
		wend
	case "downon","downoff"
	
		dim crn_down
		crn_down = 0
		if crn_action = "downon" then crn_down = 1
		SQL = "UPDATE tba_photo SET photo_downloadable = " & crn_down & " WHERE photo_id = " & crnPhotoId
		conn.execute(SQL)
			
	case "new"

		SQL = "INSERT INTO tba_photo (photo_title, photo_description, photo_cropped, photo_elaborated, photo_pub, photo_original, photo_active, photo_views, photo_downloadable) VALUES ('" & crnPhotoTitle & "','" & crnPhotoDescription & "'," & crnPhotoCropped & "," & crnPhotoElaborated & "," & crnPhotoPub & ",'" & crnPhotoOriginal & "',0,0,0)"
		conn.execute(SQL)
									
		SQL = "SELECT TOP 1 photo_id FROM tba_photo ORDER BY photo_id DESC"
		set rs = conn.execute(SQL)
		
		crnPhotoId = rs("photo_id")
		
		call setCookie("lastphoto",crnPhotoId,now+365)
	
	case "edit"
		crnPhotoTitle = cleanString(request.form("title"),0,50)
		crnPhotoDescription = cleanString(request.form("description"),0,1000)
		crnPhotoCropped = cleanDelimitedByte(request.form("cropped"),1)
		crnPhotoElaborated = cleanDelimitedByte(request.form("elaborated"),1)
		crn_photoActive = cleanDelimitedByte(request.form("active"),1)
		crnPhotoDownloadable = cleanDelimitedByte(request.form("downloadable"),1)
		crn_tags = split(trim(request.form("tags"))," ")
		
		if crnPhotoTitle = "" then response.Redirect("errors.asp?c=post1")
		
		if ubound(crn_tags) = -1 then response.Redirect("errors.asp?c=post2")
	
		SQL = "UPDATE tba_photo SET photo_title = '" & crnPhotoTitle & "', photo_description = '" & crnPhotoDescription & "', photo_cropped = " & crnPhotoCropped & ", photo_elaborated = " & crnPhotoElaborated & ",photo_active = " & crn_photoActive & ", photo_downloadable = " & crnPhotoDownloadable & " WHERE photo_id = " & crnPhotoId
		conn.execute(SQL)
	
	case "del"
	
		dim fso, p
		
		if crn_photoActive = 1 then
			SQL = "SELECT rel_id, rel_tag FROM tba_rel WHERE rel_photo = " & crnPhotoId
			set rs = conn.execute(SQL)
			while not rs.eof
				SQL = "UPDATE tba_tag SET tag_photos = tag_photos - 1 WHERE tag_id = " & rs("rel_tag")
				conn.execute(SQL)
				SQL = "DELETE * FROM tba_rel WHERE rel_id = " & rs("rel_id")
				conn.execute(SQL)
				rs.movenext
			wend
		end if
		
		SQL = "DELETE * FROM tba_comment WHERE comment_photo = " & crnPhotoId
		conn.execute(SQL)
		
		SQL = "DELETE * FROM tba_photo WHERE photo_id = " & crnPhotoId
		conn.execute(SQL)
		
		on error resume next
		Set fso = CreateObject("Scripting.FileSystemObject")
		Set p = fso.GetFile(Server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crnPhotoId & _
							CARNIVAL_ORIGINALPOSTFIX & crnPhotoOriginal & ".jpg")) : p.Delete
		Set p = fso.GetFile(Server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crnPhotoId & _
							".jpg")) : p.Delete
		Set p = fso.GetFile(Server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crnPhotoId & _
							CARNIVAL_THUMBPOSTFIX & ".jpg")) : p.Delete
		on error goto 0
	
end select

if crn_action = "edit" then

	'TAGS
	dim ii, crn_tagid
	for ii=0 to ubound(crn_tags)
	
		crn_tags(ii) = cleanString(cleanTagName(crn_tags(ii)),0,50)
		if crn_tags(ii) <> "" then
			SQL = "SELECT tag_id FROM tba_tag WHERE tag_name = '" & crn_tags(ii) & "'"
			set rs = conn.execute(SQL)
			if rs.eof then
			
				'nuovo tag
				SQL = "INSERT INTO tba_tag (tag_name, tag_photos) VALUES ('" & crn_tags(ii) & "',1)"
				conn.execute(SQL)
				
				SQL = "SELECT TOP 1 tag_id FROM tba_tag ORDER BY tag_id DESC"
				set rs = conn.execute(SQL)
				crn_tagid = rs("tag_id")
			
				SQL = "INSERT INTO tba_rel (rel_photo,rel_tag) VALUES (" & crnPhotoId & "," & crn_tagid & ")"
				conn.execute(SQL)
				
			else
			
				'tag esistente
				crn_tagid = rs("tag_id")
				
				SQL = "SELECT rel_tag FROM tba_rel WHERE rel_tag = " & crn_tagid & " AND rel_photo = " & crnPhotoId
				set rs = conn.execute(SQL)
				if rs.eof then
				
					SQL = "UPDATE tba_tag SET tag_photos = tag_photos + 1 WHERE tag_id = " & crn_tagid
					conn.execute(SQL)
				
					SQL = "INSERT INTO tba_rel (rel_photo,rel_tag) VALUES (" & crnPhotoId & "," & crn_tagid & ")"
					conn.execute(SQL)
					
				end if
				
			end if
		end if
	
	next
	
	dim deletedtag
	SQL = "SELECT tba_tag.tag_id,tba_tag.tag_name FROM tba_rel INNER JOIN tba_tag ON tba_rel.rel_tag = tba_tag.tag_id WHERE tba_rel.rel_photo=" & crnPhotoId
	set rs = conn.execute(SQL)
	while not rs.eof
		deletedtag = true
		for ii=0 to ubound(crn_tags)
			if crn_tags(ii) = rs("tag_name") then
				deletedtag = false
				exit for
			end if
		next
		if deletedtag then
			SQL = "DELETE * FROM tba_rel WHERE rel_tag = " & rs("tag_id") & " AND rel_photo = " & crnPhotoId
			conn.execute(SQL)
			SQL = "UPDATE tba_tag SET tag_photos = tag_photos - 1 WHERE tag_id = " & rs("tag_id")
			conn.execute(SQL)
		end if
		rs.movenext
	wend
end if

if crn_action = "new" then
	response.Redirect("admin.asp?module=photo-upload&id=" & crnPhotoId)
else
	response.Redirect("admin.asp?module=pro-rss&from=photo")
end if

%>