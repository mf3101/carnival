<!--#include file = "inc.first.asp"--><%
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
' * @version         SVN: $Id: mod.admin.prophotoedit.asp 31 2008-07-04 14:43:29Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"--><%

'see functions at the end of file

dim crn_tags, crn_action, crn_id, crn_photoActive, crn_returnpage, crn_setid
dim crn_oldPhotoSet, crn_oldPhotoActive 'load current befor updating (edit/del)

crn_returnpage = cleanLong(request.Form("returnpage"))
if crn_returnpage = 0 then crn_returnpage = cleanLong(request.querystring("returnpage"))

crn_setid = cleanLong(request.QueryString("setid"))
if crn_setid = 0 then crn_setid = cleanLong(request.Form("setid"))

crn_action = request.form("action")
if crn_action = "" then crn_action = request.querystring("action")
crn_action = normalize(crn_action,"multi|new|edit|show|hide|del|downon|downoff|order","")	

dim crn_order
crn_order = cleanLong(request.QueryString("order"))
if crn_order = 0 then crn_order = cleanLong(request.form("order"))

if crn_action <> "" then
	if crn_returnpage = 0 then crn_returnpage = cleanLong(request.querystring("returnpage"))
	select case crn_action
		case "edit","show","hide","del","downon","downoff","order"
			crn_id = request.form("id")
			if crn_id = "" then crn_id = request.querystring("id")
			SQL = "SELECT photo_id, photo_active, photo_set, photo_original FROM tba_photo WHERE photo_id = " & crn_id
			set rs = dbManager.conn.execute(SQL)
			if rs.eof then response.Redirect("errors.asp?c=post0")
			crnPhotoId = rs("photo_id")	
			crn_photoActive = rs("photo_active")
			crnPhotoSet = rs("photo_set")
			crnPhotoOriginal = rs("photo_original")
		case "new"
			crn_action = "new"
			crnPhotoId = 0
			crnPhotoTitle = "!INDICA UN TITOLO!"
			crnPhotoDescription = ""
			crnPhotoCropped = 0
			crnPhotoElaborated = 0
			crnPhotoSet = 1
			crnPhotoOrder = 0
			crnPhotoOriginal = createKey(10)
			crnPhotoPub = formatDBDate(now,CARNIVAL_DATABASETYPE)
		'case "multi"
	end select
	
	select case crn_action
		case "multi"
		
			dim multiid, multisel, multiaction
			multiaction = normalize(request.Form("multiaction"),"del|order|show|hide|downon|downoff|addtag|moveset|removeset","")
			dim ii : ii = 1
			while (trim(request.Form("multiid"&ii))<>"")
				if cleanBool(request.Form("multisel"&ii)) then
					multiid = cleanLong(request.Form("multiid"&ii))
					
					select case multiaction
						case "downon","downoff"
							SQL = "SELECT photo_original, photo_downloadable FROM tba_photo WHERE photo_id = " & multiid
							set rs = dbManager.conn.execute(SQL)
							if not rs.eof then
								if cleanBool(rs("photo_downloadable")) <> IIF(multiaction="downon",true,false) then 
									crnPhotoOriginal = rs("photo_original")
									call downloadPhoto(multiid,IIF(multiaction = "downon",true,false),crnPhotoOriginal)
								end if
							end if
						case "show","hide"
							SQL = "SELECT photo_active FROM tba_photo WHERE photo_id = " & multiid
							set rs = dbManager.conn.execute(SQL)
							if not rs.eof then
								if cleanBool(rs("photo_active")) <> IIF(multiaction="show",true,false) then 
									call activePhoto(multiid,IIF(multiaction="show",true,false))
								end if
							end if
						case "del"
							SQL = "SELECT photo_active, photo_set FROM tba_photo WHERE photo_id = " & multiid
							set rs = dbManager.conn.execute(SQL)
							if not rs.eof then
								crnPhotoSet = rs("photo_set")
								crn_photoActive = rs("photo_active")
								call deletePhoto(multiid,crn_photoActive,crnPhotoSet)
							end if
						case "moveset","removeset"
							crnPhotoSet = cleanLong(request.Form("set")) : if crnPhotoSet < 1 then crnPhotoSet = 1
							if multiaction = "removeset" then crnPhotoSet = 1
							SQL = "SELECT photo_active,photo_set FROM tba_photo WHERE photo_id = " & multiid
							set rs = dbManager.conn.execute(SQL)
							if not rs.eof then
								crn_oldPhotoSet = rs("photo_set")
								crn_photoActive = rs("photo_active")
								if clng(crn_oldPhotoSet) <> clng(crnPhotoSet) then
								call setPhoto(multiid,crnPhotoSet)
								call updateSetAfterEdit(multiid,cleanBool(crn_photoActive),cleanBool(crn_photoActive),crn_oldPhotoSet,crnPhotoSet)
								end if
							end if
							crn_setid = crnPhotoSet 'per redirect
							if multiaction = "removeset" then crn_setid = crn_oldPhotoSet
						case "addtag"
							dim crn_tag
							crn_tag = cleanTagName(trim(request.Form("tagname")))
							SQL = "SELECT photo_active FROM tba_photo WHERE photo_id = " & multiid
							set rs = dbManager.conn.execute(SQL)
							if not rs.eof and crn_tag <> "" then
								crn_photoActive = rs("photo_active")
								call addTagToPhoto(multiid,crn_tag,cleanBool(crn_photoActive))
							end if
						case "order"
							call orderPhoto(multiid,crn_order)
					end select
				end if
				ii=ii+1
			wend
			
		case "show","hide"
		
			call activePhoto(crnPhotoId,IIF(crn_action="show",true,false))
			
		case "order"
			
			call orderPhoto(crnPhotoId,crn_order)
			
		case "downon","downoff"
			
			call downloadPhoto(crnPhotoId,IIF(crn_action = "downon",true,false),crnPhotoOriginal)
				
		case "new"
	
			SQL = "INSERT INTO tba_photo (photo_title, photo_description, photo_cropped, photo_elaborated, photo_pub, photo_original, photo_active, photo_views, photo_downloadable, photo_set, photo_order) VALUES ('" & crnPhotoTitle & "','" & crnPhotoDescription & "'," & crnPhotoCropped & "," & crnPhotoElaborated & "," & crnPhotoPub & ",'" & crnPhotoOriginal & "',0,0,0," & crnPhotoSet & "," & crnPhotoOrder & ")"
			dbManager.conn.execute(SQL)
										
			SQL = "SELECT TOP 1 photo_id FROM tba_photo ORDER BY photo_id DESC"
			set rs = dbManager.conn.execute(SQL)
			
			crnPhotoId = rs("photo_id")
			
			call setCookie("lastphoto",crnPhotoId,now+365)
		
		case "edit"
		
			crn_oldPhotoSet = crnPhotoSet
			crn_oldPhotoActive = crn_photoActive
		
			crnPhotoTitle = cleanString(request.form("title"),0,50)
			crnPhotoDescription = cleanString(request.form("description"),0,1000)
			crnPhotoCropped = cleanDelimitedByte(request.form("cropped"),1)
			crnPhotoElaborated = cleanDelimitedByte(request.form("elaborated"),1)
			crn_photoActive = cleanDelimitedByte(request.form("active"),1)
			crnPhotoDownloadable = cleanDelimitedByte(request.form("downloadable"),1)
			crnPhotoSet = cleanLong(request.Form("set")) : if crnPhotoSet < 1 then crnPhotoSet = 1
			crn_tags = split(trim(request.form("tags"))," ")
			
			if crnPhotoTitle = "" then response.Redirect("errors.asp?c=post1")
			
			if ubound(crn_tags) = -1 then response.Redirect("errors.asp?c=post2")
		
			SQL = "UPDATE tba_photo SET photo_title = '" & crnPhotoTitle & "', photo_description = '" & crnPhotoDescription & "', photo_cropped = " & crnPhotoCropped & ", photo_elaborated = " & crnPhotoElaborated & ",photo_active = " & crn_photoActive & ", photo_downloadable = " & crnPhotoDownloadable & ", photo_set = " & crnPhotoSet & " WHERE photo_id = " & crnPhotoId
			dbManager.conn.execute(SQL)
			
			call updateTagsAfterEdit(crnPhotoId,crn_tags,cleanBool(crn_oldPhotoActive),cleanBool(crn_photoActive))
			call updateSetAfterEdit(crnPhotoId,cleanBool(crn_oldPhotoActive),cleanBool(crn_photoActive),crn_oldPhotoSet,crnPhotoSet)
		
		case "del"
		
			call deletePhoto(crnPhotoId,crn_photoActive,crnPhotoSet)
		
	end select
end if

if crn_action = "new" then
	response.Redirect("admin.asp?module=photo-upload&id=" & crnPhotoId)
elseif (crn_action = "order") _
	or (crn_action = "multi" and (request.Form("multiaction") = "order" or request.Form("multiaction") = "moveset" or request.Form("multiaction") = "removeset")) then
	response.Redirect("admin.asp?module=set-photo-list&id=" & crn_setid & "&page=" & crn_returnpage)
else
	response.Redirect("admin.asp?module=pro-rss&from=photo&returnpage="&crn_returnpage)
end if

'**********************************************************************************************************
'FUNCTIONS
'---------

'aggiorna il conteggio foto +/- 1 del tag dall'id photo
sub updateTagPhotosCountByPhotoId(id,sign)
	dim rst
	SQL = "SELECT rel_id, rel_tag FROM tba_rel WHERE rel_photo = " & id
	set rst = dbManager.conn.execute(SQL)
	while not rst.eof
		SQL = "UPDATE tba_tag SET tag_photos = tag_photos " & sign & " 1 WHERE tag_id = " & rst("rel_tag")
		dbManager.conn.execute(SQL)			
		rst.movenext
	wend
	set rst = nothing
end sub

'aggiorna il conteggio foto +/- 1 del set dall'id set
sub updateSetPhotosCountBySetId(id,sign)
	SQL = "UPDATE tba_set SET set_photos = set_photos " & sign & " 1 WHERE set_id = " & id
	dbManager.conn.execute(SQL)
end sub

'aggiorna il conteggio foto +/- 1 del set dall'id photo
sub updateSetPhotosCountByPhotoId(id,sign)
	dim rst
	SQL = "SELECT photo_set FROM tba_photo WHERE photo_id = " & id
	set rst = dbManager.conn.execute(SQL)
	call updateSetPhotosCountBySetId(rst("photo_set"),sign)
end sub

sub addTagToPhoto(id,tag,photoactive)

	dim tagid
	SQL = "SELECT tag_id FROM tba_tag WHERE tag_name = '" & tag & "'"
	set rs = dbManager.conn.execute(SQL)
	if rs.eof then
	
		'nuovo tag
		SQL = "INSERT INTO tba_tag (tag_name, tag_photos) VALUES ('" & tag & "'," & IIF(photoactive,"1","0")& ")"
		dbManager.conn.execute(SQL)
		
		SQL = "SELECT TOP 1 tag_id FROM tba_tag ORDER BY tag_id DESC"
		set rs = dbManager.conn.execute(SQL)
		tagid = rs("tag_id")
	
		SQL = "INSERT INTO tba_rel (rel_photo,rel_tag) VALUES (" & id & "," & tagid & ")"
		dbManager.conn.execute(SQL)
		
	else
	
		'tag esistente
		tagid = rs("tag_id")
		
		SQL = "SELECT rel_tag FROM tba_rel WHERE rel_tag = " & tagid & " AND rel_photo = " & id
		set rs = dbManager.conn.execute(SQL)
		if rs.eof then
		
			if photoactive then
				SQL = "UPDATE tba_tag SET tag_photos = tag_photos + 1 WHERE tag_id = " & tagid
				dbManager.conn.execute(SQL)
			end if
		
			SQL = "INSERT INTO tba_rel (rel_photo,rel_tag) VALUES (" & id & "," & tagid & ")"
			dbManager.conn.execute(SQL)
			
		end if
		
	end if

end sub

sub updateTagsAfterEdit(id,tags,oldphotoactive,currentphotoactive)
	'===== TAGS =====
	dim ii
	for ii=0 to ubound(tags)
	
		tags(ii) = cleanString(cleanTagName(tags(ii)),0,50)
		if tags(ii) <> "" then call addTagToPhoto(id,tags(ii),oldphotoactive)
	
	next
	
	dim deletedtag
	SQL = "SELECT tba_tag.tag_id,tba_tag.tag_name FROM tba_rel INNER JOIN tba_tag ON tba_rel.rel_tag = tba_tag.tag_id WHERE tba_rel.rel_photo=" & id
	set rs = dbManager.conn.execute(SQL)
	while not rs.eof
		deletedtag = true
		for ii=0 to ubound(tags)
			if tags(ii) = rs("tag_name") then
				deletedtag = false
				exit for
			end if
		next
		if deletedtag then
			SQL = "DELETE * FROM tba_rel WHERE rel_tag = " & rs("tag_id") & " AND rel_photo = " & id
			dbManager.conn.execute(SQL)
			if oldphotoactive then
				'se era attiva la foto riduce il tag
				SQL = "UPDATE tba_tag SET tag_photos = tag_photos - 1 WHERE tag_id = " & rs("tag_id")
				dbManager.conn.execute(SQL)
			end if
		end if
		rs.movenext
	wend
	
	'se è modificata la visibilità aggiorna i tag photo count
	if currentphotoactive <> oldphotoactive then
		call updateTagPhotosCountByPhotoId(id,IIF(currentphotoactive,"+","-"))
	end if
	
	'===== END TAGS =====
	
end sub


sub updateSetAfterEdit(id,oldphotoactive,currentphotoactive,oldphotoset,currentphotoset)

	if clng(oldphotoset) <> clng(currentphotoset) then
		'se è cambiato il set
		
		'toglie la cover
		SQL = "UPDATE tba_set SET set_cover = 0 WHERE set_cover = " & id
		dbManager.conn.execute(SQL)
		if currentphotoactive then
			SQL = "UPDATE tba_set SET set_photos = set_photos + 1 WHERE set_id = " & currentphotoset
			dbManager.conn.execute(SQL)
		end if
		if oldphotoactive then
			SQL = "UPDATE tba_set SET set_photos = set_photos - 1 WHERE set_id = " & oldphotoset
			dbManager.conn.execute(SQL)
		end if
	elseif currentphotoactive <> oldphotoactive then
		'se è modificata la visibilità aggiorna i set photo count
		call updateSetPhotosCountBySetId(currentphotoset,IIF(currentphotoactive,"+","-"))
	end if
	
end sub

'**********************************************************************************************************

'MAIN FUNCTIONS
'--------------
sub deletePhoto(id,photoactive, photoset)

	dim fso, p
	
	if photoactive = 1 then
		'updates tags count
		SQL = "SELECT rel_id, rel_tag FROM tba_rel WHERE rel_photo = " & id
		set rs = dbManager.conn.execute(SQL)
		while not rs.eof
			SQL = "UPDATE tba_tag SET tag_photos = tag_photos - 1 WHERE tag_id = " & rs("rel_tag")
			dbManager.conn.execute(SQL)
			SQL = "DELETE * FROM tba_rel WHERE rel_id = " & rs("rel_id")
			dbManager.conn.execute(SQL)
			rs.movenext
		wend
		
		'updates set count
		SQL = "UPDATE tba_set SET set_photos = set_photos - 1 WHERE set_id = " & photoset
		dbManager.conn.execute(SQL)
	end if
	
	'updates set logo
	SQL = "UPDATE tba_set SET set_cover = 0 WHERE set_cover = " & id
	dbManager.conn.execute(SQL)	
	
	'deletes comments
	SQL = "DELETE * FROM tba_comment WHERE comment_photo = " & id
	dbManager.conn.execute(SQL)
	
	'deletes the photo
	SQL = "DELETE * FROM tba_photo WHERE photo_id = " & id
	dbManager.conn.execute(SQL)
	
	'deletes files
	on error resume next
	Set fso = CreateObject("Scripting.FileSystemObject")
	Set p = fso.GetFile(Server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & id & _
						CARNIVAL_ORIGINALPOSTFIX & crnPhotoOriginal & ".jpg")) : p.Delete
	Set p = fso.GetFile(Server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & id & _
						".jpg")) : p.Delete
	Set p = fso.GetFile(Server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & id & _
						CARNIVAL_THUMBPOSTFIX & ".jpg")) : p.Delete
	on error goto 0
end sub

sub orderPhoto(id,order)
	SQL = "UPDATE tba_photo SET photo_order = " & order & " WHERE photo_id = " & id
	dbManager.conn.execute(SQL)
end sub

sub activePhoto(id,value)

	SQL = "UPDATE tba_photo SET photo_active = " & IIF(value,1,0) & " WHERE photo_id = " & id
	dbManager.conn.execute(SQL)
	
	if not value then 
		SQL = "UPDATE tba_set SET set_cover = 0 WHERE set_cover = " & id
		dbManager.conn.execute(SQL)				
	end if
	
	call updateTagPhotosCountByPhotoId(id,IIF(value,"+","-"))
	call updateSetPhotosCountByPhotoId(id,IIF(value,"+","-"))
	
end sub

sub downloadPhoto(id,value,photooriginal)

	dim newphotooriginal
	newphotooriginal = photooriginal
	if not value then
		'rinomina foto con nuovo codice
		newphotooriginal = createKey(10)
		call renameFile(server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & id & CARNIVAL_ORIGINALPOSTFIX & photooriginal & ".jpg"),server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & id & CARNIVAL_ORIGINALPOSTFIX & newphotooriginal & ".jpg"))
	end if
	SQL = "UPDATE tba_photo SET photo_downloadable = " & IIF(value,1,0) & ", photo_original = '" & newphotooriginal & "' WHERE photo_id = " & id
	dbManager.conn.execute(SQL)

end sub


sub setPhoto(id,photoset)
	SQL = "UPDATE tba_photo SET photo_set = " & photoset & " WHERE photo_id = " & id
	dbManager.conn.execute(SQL)
end sub

%>