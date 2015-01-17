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
' * @version         SVN: $Id: inc.func.photo.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'********************************************************************************************
' }}}
' {{{ GENERALI

'*
'* Controlla se esistono foto in autopub scadute (e quindi da pubblicare) e le pubblica
'*
sub checkPhotoPub()
	dim bln_Published, rst
	bln_Published = false
	'verificare se esistono foto non visibili pronte per essere pubblicate
	SQL = "SELECT photo_id,photo_pub, photo_original FROM tba_photo WHERE photo_pubqueue <> 0 AND photo_pub < " & formatDBDate(now,CARNIVAL_DATABASE_TYPE) & " ORDER BY photo_pub ASC"
	set rst = dbManager.Execute(SQL)
	while not rst.eof
		'send byt_PubQueue = 0 to bypass useless check
		call activePhoto(inputLong(rst("photo_id")),true,false,inputDate(rst("photo_pub")),0,rst("photo_original"))
		rst.movenext
		bln_Published = true
	wend
	set rst = nothing
	
	if bln_Published then call compileRss()
end sub

'********************************************************************************************
' }}}
' {{{ AZIONI

'*
'* rende una foto visibile
'* (necessità di ID, TRUE/FALSE, data di pubblicazione, queue di pubblicazione)
'*
sub activePhoto(lng_Id,bln_Active, bln_OldActive ,dtm_Pub,byt_PubQueue, byval str_Original)
	
	dim str_NewOriginal
	if (bln_OldActive) then
		'se la foto viene nascosta (era visibile) modifica la chiave
		str_NewOriginal = createKey(10)
	else
		'rimane invariata
		str_NewOriginal = str_Original
	end if
	call updateOriginalPhoto(lng_Id,bln_Active,bln_OldActive,str_Original,str_NewOriginal)

	SQL = "UPDATE tba_photo SET photo_active = " & IIF(bln_Active,1,0) & IIF(dtm_Pub>now,", photo_pub = " & formatDBDate(now,CARNIVAL_DATABASE_TYPE),"") & IIF(bln_Active,", photo_pubqueue = 0","") & ", photo_original = '" & formatDBString(str_NewOriginal,null) & "' WHERE photo_id = " & lng_Id
	dbManager.Execute(SQL)
	
	if not bln_Active then
		SQL = "UPDATE tba_set SET set_cover = 0 WHERE set_cover = " & lng_Id
		dbManager.Execute(SQL)			
	else
		'resync autopubs
		if byt_PubQueue = 2 then call syncAutoPubFrom(dtm_Pub)
	end if
	
	call updateTagPhotosCountByPhotoId(lng_Id,IIF(bln_Active,"+","-"))
	call updateSetPhotosCountByPhotoId(lng_Id,IIF(bln_Active,"+","-"))
	
end sub

'*
'* aggiunge un tag a una foto
'* (necessità di ID, TAGNAME e ACTIVE)
'*
sub addTagToPhoto(lng_Id,str_TagName,bln_Active)

	dim lng_TagId, rst
	SQL = "SELECT tag_id FROM tba_tag WHERE tag_name = '" & formatDBString(str_TagName,null) & "'"
	set rst = dbManager.Execute(SQL)
	if rst.eof then
	
		'nuovo str_TagName
		SQL = "INSERT INTO tba_tag (tag_name, tag_photos, tag_type) VALUES ('" & formatDBString(str_TagName,null) & "'," & IIF(bln_Active,"1","0")& ",0)"
		dbManager.Execute(SQL)
		
		SQL = "SELECT TOP 1 tag_id FROM tba_tag ORDER BY tag_id DESC"
		set rst = dbManager.Execute(SQL)
		lng_TagId = rst("tag_id")
	
		SQL = "INSERT INTO tba_rel (rel_photo,rel_tag) VALUES (" & lng_Id & "," & lng_TagId & ")"
		dbManager.Execute(SQL)
		
	else
	
		'str_TagName esistente
		lng_TagId = rst("tag_id")
		
		SQL = "SELECT rel_tag FROM tba_rel WHERE rel_tag = " & lng_TagId & " AND rel_photo = " & lng_Id
		set rst = dbManager.Execute(SQL)
		if rst.eof then
		
			if bln_Active then
				SQL = "UPDATE tba_tag SET tag_photos = tag_photos + 1 WHERE tag_id = " & lng_TagId
				dbManager.Execute(SQL)
			end if
		
			SQL = "INSERT INTO tba_rel (rel_photo,rel_tag) VALUES (" & lng_Id & "," & lng_TagId & ")"
			dbManager.Execute(SQL)
			
		end if
		
	end if
	
	set rst = nothing

end sub

'*
'* elimina una foto
'*
sub deletePhoto(lng_Id, bln_Active, lng_SetId, str_Original, byt_PubQueue, dtm_Pub)
	
	dim rst
	if bln_Active then
		'updates rstr_TagName count
		SQL = "SELECT rel_id, rel_tag FROM tba_rel WHERE rel_photo = " & lng_Id
		set rst = dbManager.Execute(SQL)
		while not rst.eof
			SQL = "UPDATE tba_tag SET tag_photos = tag_photos - 1 WHERE tag_id = " & rst("rel_tag")
			dbManager.Execute(SQL)
			SQL = "DELETE * FROM tba_rel WHERE rel_id = " & rst("rel_id")
			dbManager.Execute(SQL)
			rst.movenext
		wend
		
		'updates set count
		SQL = "UPDATE tba_set SET set_photos = set_photos - 1 WHERE set_id = " & lng_SetId
		dbManager.Execute(SQL)
	end if
	set rst = nothing
	
	'updates set logo
	SQL = "UPDATE tba_set SET set_cover = 0 WHERE set_cover = " & lng_Id
	dbManager.Execute(SQL)	
	
	'deletes comments
	SQL = "DELETE * FROM tba_comment WHERE comment_photo = " & lng_Id
	dbManager.Execute(SQL)
	
	'check autopub
	if byt_PubQueue = 2 then
		'removes autopub
		SQL = "UPDATE tba_photo SET photo_pubqueue = 0 WHERE photo_id = " & lng_Id
		dbManager.Execute(SQL)
		'resync autopubs
		call syncAutoPubFrom(dtm_Pub)
	end if
	
	'deletes the photo
	SQL = "DELETE * FROM tba_photo WHERE photo_id = " & lng_Id
	dbManager.Execute(SQL)
	
	dim fso, file
	'deletes files
	on error resume next
	Set fso = CreateObject("Scripting.FileSystemObject")
	Set file = fso.GetFile(Server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & lng_Id & _
						CARNIVAL_ORIGINALPOSTFIX & str_Original & ".jpg")) : file.Delete
	Set file = fso.GetFile(Server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & lng_Id & _
						IIF(bln_Active,"",str_Original) & ".jpg")) : file.Delete
	Set file = fso.GetFile(Server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & lng_Id & _
						CARNIVAL_THUMBPOSTFIX & IIF(bln_Active,"",str_Original) & ".jpg")) : file.Delete
	on error goto 0
	Set file = Nothing
	Set fso = Nothing
end sub

'*
'* ordina una foto
'*
sub orderPhoto(lng_Id,lng_Order)
	SQL = "UPDATE tba_photo SET photo_order = " & lng_Order & " WHERE photo_id = " & lng_Id
	dbManager.Execute(SQL)
end sub

'*
'* reimposta la posizione di una foto (in stato autopub = 2)
'* bln_MoveUp = true (sali), bln_MoveUp = false (scendi)
'*
sub autopubPhoto(lng_Id,bln_MoveUp,dtm_Pub)
	dim rst
	SQL = "SELECT TOP 1 photo_id, photo_pub FROM tba_photo WHERE photo_pubqueue = 2 AND photo_pub " & IIF(bln_MoveUp,">","<") & " " & formatDBDate(dtm_Pub,CARNIVAL_DATABASE_TYPE) & " ORDER BY photo_pub " & IIF(bln_MoveUp,"ASC","DESC")
	set rst = dbManager.Execute(SQL)
	
	if not rst.eof then
		SQL = "UPDATE tba_photo SET photo_pub = " & formatDBDate(inputDate(rst("photo_pub")),CARNIVAL_DATABASE_TYPE) & " WHERE photo_id = " & lng_Id
		dbManager.Execute(SQL)
		SQL = "UPDATE tba_photo SET photo_pub = " & formatDBDate(dtm_Pub,CARNIVAL_DATABASE_TYPE) & " WHERE photo_id = " & inputLong(rst("photo_id"))
		dbManager.Execute(SQL)
	end if
	set rst = Nothing
	
end sub

'*
'* imposta lo stato di download ad alta risoluzione
'*
sub downloadPhoto(lng_Id,bln_Downloadable,bln_Active,str_Original)

	dim str_newOriginal
	str_newOriginal = str_Original
	if not bln_Downloadable then
		'rinomina foto con nuovo codice
		str_newOriginal = createKey(10)
		call updateOriginalPhoto(lng_Id,bln_Active,bln_Active,str_Original,str_newOriginal)
	end if
	SQL = "UPDATE tba_photo SET photo_downloadable = " & IIF(bln_Downloadable,1,0) & ", photo_original = '" & formatDBString(str_newOriginal,null) & "' WHERE photo_id = " & lng_Id
	dbManager.Execute(SQL)

end sub

sub updateOriginalPhoto(lng_Id,bln_Active,bln_OldActive,byVal str_Original,byVal str_newOriginal)

	call renameFile(server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & lng_Id & CARNIVAL_ORIGINALPOSTFIX & str_Original & ".jpg"),_
					server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & lng_Id & CARNIVAL_ORIGINALPOSTFIX & str_newOriginal & ".jpg"))
			
	if bln_Active <> bln_OldActive then		
		'differenti
		if bln_Active then str_newOriginal = "" : else : str_Original = "" : end if
	else
		'uguali (se la foto è visibile non modifica il nome)
		if bln_Active then : str_newOriginal = "" : str_Original = "" : end if
	end if
	if str_newOriginal <> str_Original then
		'rinomina foto
		call renameFile(server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & lng_Id & str_Original & ".jpg"),_
						server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & lng_Id & str_newOriginal & ".jpg"))
		'rinomina thumb
		call renameFile(server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & lng_Id & CARNIVAL_THUMBPOSTFIX & str_Original & ".jpg"),_
						server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & lng_Id & CARNIVAL_THUMBPOSTFIX & str_newOriginal & ".jpg"))
	end if
	
end sub

'*
'* imposta il set di una foto (al termine della modifica è necessario avviare updateSetAfterEdit)
'*
sub setPhoto(lng_Id,lng_SetId)
	SQL = "UPDATE tba_photo SET photo_set = " & lng_SetId & " WHERE photo_id = " & lng_Id
	dbManager.Execute(SQL)
end sub




'********************************************************************************************
' }}}
' {{{ AGGIORNAMENTI

'*
'* aggiorna il conteggio foto +/- 1 del str_TagName dall'lng_Id photo
'*
sub updateTagPhotosCountByPhotoId(lng_Id,str_Sign)
	dim rst
	SQL = "SELECT rel_id, rel_tag FROM tba_rel WHERE rel_photo = " & lng_Id
	set rst = dbManager.Execute(SQL)
	while not rst.eof
		SQL = "UPDATE tba_tag SET tag_photos = tag_photos " & str_Sign & " 1 WHERE tag_id = " & rst("rel_tag")
		dbManager.Execute(SQL)			
		rst.movenext
	wend
	set rst = nothing
end sub

'*
'* aggiorna il conteggio foto +/- 1 del set dall'lng_Id set
'*
sub updateSetPhotosCountBySetId(lng_Id,str_Sign)
	SQL = "UPDATE tba_set SET set_photos = set_photos " & str_Sign & " 1 WHERE set_id = " & lng_Id
	dbManager.Execute(SQL)
end sub

'*
'* aggiorna il conteggio foto +/- 1 del set dall'lng_Id photo
'*
sub updateSetPhotosCountByPhotoId(lng_Id,sign)
	dim rst
	SQL = "SELECT photo_set FROM tba_photo WHERE photo_id = " & lng_Id
	set rst = dbManager.Execute(SQL)
	call updateSetPhotosCountBySetId(rst("photo_set"),sign)
	set rst = Nothing
end sub


'********************************************************************************************
' }}}
' {{{ AGGIORNAMENTI DOPO EDIT

'*
'* aggiorna i str_TagName di una foto dopo una modifica
'* prende un array di rstr_TagName (string)
'*
sub updateTagsAfterEdit(lng_Id,rstr_TagName,bln_Active_O,bln_Active_C)

	dim ii, rst
	
	for ii=0 to ubound(rstr_TagName)
	
		rstr_TagName(ii) = inputStringD(cleanTagName(rstr_TagName(ii)),0,50)
		if rstr_TagName(ii) <> "" then call addTagToPhoto(lng_Id,rstr_TagName(ii),bln_Active_O)
	
	next
	
	dim bln_DeletedTag
	SQL = "SELECT tba_tag.tag_id,tba_tag.tag_name FROM tba_rel INNER JOIN tba_tag ON tba_rel.rel_tag = tba_tag.tag_id WHERE tba_rel.rel_photo=" & lng_Id
	set rst = dbManager.Execute(SQL)
	while not rst.eof
		bln_DeletedTag = true
		for ii=0 to ubound(rstr_TagName)
			if rstr_TagName(ii) = rst("tag_name") then
				bln_DeletedTag = false
				exit for
			end if
		next
		if bln_DeletedTag then
			SQL = "DELETE * FROM tba_rel WHERE rel_tag = " & rst("tag_id") & " AND rel_photo = " & lng_Id
			dbManager.Execute(SQL)
			if bln_Active_O then
				'se era attiva la foto riduce il str_TagName
				SQL = "UPDATE tba_tag SET tag_photos = tag_photos - 1 WHERE tag_id = " & rst("tag_id")
				dbManager.Execute(SQL)
			end if
		end if
		rst.movenext
	wend
	set rst = Nothing
	
	'se è modificata la visibilità aggiorna i str_TagName photo count
	if bln_Active_C <> bln_Active_O then
		call updateTagPhotosCountByPhotoId(lng_Id,IIF(bln_Active_C,"+","-"))
	end if
	
end sub

'*
'* aggiorna i set di una foto dopo una modifica
'*
sub updateSetAfterEdit(lng_Id,bln_Active_O,bln_Active_C,lng_Set_O,lng_Set_C)

	if clng(lng_Set_O) <> clng(lng_Set_C) then
		'se è cambiato il set
		
		'toglie la cover
		SQL = "UPDATE tba_set SET set_cover = 0 WHERE set_cover = " & lng_Id
		dbManager.Execute(SQL)
		if bln_Active_C then
			SQL = "UPDATE tba_set SET set_photos = set_photos + 1 WHERE set_id = " & lng_Set_C
			dbManager.Execute(SQL)
		end if
		if bln_Active_O then
			SQL = "UPDATE tba_set SET set_photos = set_photos - 1 WHERE set_id = " & lng_Set_O
			dbManager.Execute(SQL)
		end if
	elseif bln_Active_C <> bln_Active_O then
		'se è modificata la visibilità aggiorna i set photo count
		call updateSetPhotosCountBySetId(lng_Set_C,IIF(bln_Active_C,"+","-"))
	end if
	
end sub

'********************************************************************************************
' }}}
' {{{ AUTOPUB

'*
'* restituisce la prossima data utile di pubblicazione automatica
'*
function getNewAutopub()
	dim lng_Count, rst
	SQL = "SELECT Count(photo_id) AS photocount FROM tba_photo WHERE photo_pubqueue = 2 AND photo_pub > " & formatDBDate(now,CARNIVAL_DATABASE_TYPE)
	set rst = dbManager.Execute(SQL)
	lng_Count = rst("photocount")
	set rst = nothing
	getNewAutopub = getAutopubDate(now,lng_Count)
end function

'*
'* calcola la data di pubblicazione fra X passaggi da dtm_Start
'* se i passaggi sono 0 calcola la prossima data utile
'*
function getAutopubDate(dtm_Start,int_Passes)
	dim byt_AutopubMode, dtm_NextAutopub
	byt_AutopubMode = inputByte(mid(config__autopub__,1,1))
	
	dtm_NextAutopub = getAutopubNextstart(dtm_Start)
	select case byt_AutopubMode
		case 1
			'settimanale
			dtm_NextAutopub = dateadd("d",7*int_Passes,dtm_NextAutopub)
		case 2
			'mensile
			dtm_NextAutopub = dateadd("m",int_Passes,dtm_NextAutopub)
		case else
			'giornaliero
			dtm_NextAutopub = dateadd("d",int_Passes,dtm_NextAutopub)
	end select
	
	getAutopubDate = dtm_NextAutopub

end function

'*
'* calcola la prima data di pubblicazione successiva a dtm_Start
'* in base ai parametri di configurazione
'*
function getAutopubNextstart(dtm_Start)
	dim byt_AutopubMode, byt_AutopubDay, byt_AutopubHour, byt_AutopubMinute
	dim dtm_NextAutopub, byt_WeekDayToday
	byt_AutopubMode = inputByte(mid(config__autopub__,1,1))
	byt_AutopubDay = inputByte(mid(config__autopub__,2,2))
	byt_AutopubHour = inputByte(mid(config__autopub__,4,2))
	byt_AutopubMinute = inputByte(mid(config__autopub__,6,2))
	
	select case byt_AutopubMode
		case 1
			'settimanale
			dtm_NextAutopub = cdate(year(dtm_Start)&"/"&month(dtm_Start)&"/"&day(dtm_Start)&" "&byt_AutopubHour&":"&byt_AutopubMinute&":00")
			'passato
			byt_WeekDayToday = weekday(dtm_NextAutopub,1)
			if byt_WeekDayToday <> byt_AutopubDay then
				dtm_NextAutopub = dateadd("d",IIF(byt_AutopubDay<byt_WeekDayToday,byt_AutopubDay+7-byt_WeekDayToday,byt_AutopubDay-byt_WeekDayToday),dtm_NextAutopub)
			elseif dtm_NextAutopub <= dtm_Start then
				dtm_NextAutopub = dateadd("d",7,dtm_NextAutopub)
			end if			
		case 2
			'mensile
			dtm_NextAutopub = cdate(year(dtm_Start)&"/"&month(dtm_Start)&"/"&byt_AutopubDay&" "&byt_AutopubHour&":"&byt_AutopubMinute&":00")
			'il prossimo mese? (aggiunge un mese)
			if dtm_NextAutopub <= dtm_Start then dtm_NextAutopub = dateadd("m",1,dtm_NextAutopub)
		case else
			'giornaliero
			dtm_NextAutopub = cdate(year(dtm_Start)&"/"&month(dtm_Start)&"/"&day(dtm_Start)&" "&byt_AutopubHour&":"&byt_AutopubMinute&":00")
			'domani? (aggiunge un giorno)
			if dtm_NextAutopub <= dtm_Start then dtm_NextAutopub = dateadd("d",1,dtm_NextAutopub)
	end select
	
	getAutopubNextstart = dtm_NextAutopub

end function

'*
'* ricalcola tutte le date delle foto in autopub = 2
'*
sub syncAutoPub() 
	
	dim rst
	dim int_Passes : int_Passes = 0
	SQL = "SELECT photo_id FROM tba_photo WHERE photo_pubqueue = 2 AND photo_pub > " & formatDBDate(now,CARNIVAL_DATABASE_TYPE)
	set rst = dbManager.Execute(SQL)
	while not rst.eof
		SQL = "UPDATE tba_photo SET photo_pub = " & formatDBDate(getAutopubDate(now,int_Passes),CARNIVAL_DATABASE_TYPE) & " WHERE photo_id = " & rst("photo_id")
		dbManager.Execute(SQL)
		int_Passes=int_Passes+1
		rst.movenext
	wend
	set rst = nothing

end sub

'*
'* ricalcola tutte le date delle foto in autopub = 2 successive a una certa data
'* (utilizzato per il bln_MoveUp, movedown)
'*
sub syncAutoPubFrom(byval dtm_Pub) 

	dim rst
	dim int_Passes : int_Passes = 0
	
	if dtm_Pub < now then dtm_Pub = now
	
	SQL = "SELECT photo_id FROM tba_photo WHERE photo_pubqueue = 2 AND photo_pub > " & formatDBDate(dtm_Pub,CARNIVAL_DATABASE_TYPE)
	set rst = dbManager.Execute(SQL)
	while not rst.eof
		SQL = "UPDATE tba_photo SET photo_pub = " & formatDBDate(getAutopubDate(dtm_Pub-0.5,int_Passes),CARNIVAL_DATABASE_TYPE) & " WHERE photo_id = " & rst("photo_id")
		dbManager.Execute(SQL)
		int_Passes=int_Passes+1
		rst.movenext
	wend
	set rst = nothing

end sub

'********************************************************************************************
' }}}
' {{{ SELECTIONS

function getLastPhotoSQL(lng_PhotoId, lng_TagId,lng_SetId)
	dim SQLo
	
	if lng_TagId > 0 then
		SQLo = "SELECT TOP 1 tba_photo.photo_id, tba_photo.photo_title, " & _
			               "tba_photo.photo_order, tba_photo.photo_pub " & _
			  "FROM tba_rel INNER JOIN tba_photo ON tba_rel.rel_photo = tba_photo.photo_id " & _
			  "WHERE tba_rel.rel_tag=" & lng_TagId & " AND tba_photo.photo_active = 1" & IIF(lng_PhotoId > 0," AND tba_photo.photo_id = " & lng_PhotoId,"") & " ORDER BY tba_photo.photo_pub DESC"
	elseif lng_SetId > 0 then
		SQLo = "SELECT TOP 1 tba_photo.photo_id, tba_photo.photo_title, " & _
			               "tba_photo.photo_order, tba_photo.photo_pub " & _
			  "FROM tba_photo WHERE photo_active = 1 AND photo_set = " & lng_SetId & IIF(lng_PhotoId > 0," AND tba_photo.photo_id = " & lng_PhotoId,"") & " ORDER BY photo_order, photo_pub DESC"
	else
		SQLo = "SELECT TOP 1 tba_photo.photo_id, tba_photo.photo_title, " & _
			               "tba_photo.photo_order, tba_photo.photo_pub " & _
			  "FROM tba_photo WHERE photo_active = 1" & IIF(lng_PhotoId > 0," AND tba_photo.photo_id = " & lng_PhotoId,"") & " ORDER BY photo_pub DESC"
	end if
	
	getLastPhotoSQL = SQLo
end function

function getPrevPhotoSQL(lng_TagId,lng_SetId,dtm_Pub,lng_Order)
	dim SQLo
	
	if lng_TagId > 0 then
		SQLo = "SELECT TOP 1 tba_photo.photo_id, tba_photo.photo_title, tba_photo.photo_pub, tba_photo.photo_order " & _
			   "FROM tba_rel INNER JOIN tba_photo ON tba_rel.rel_photo = tba_photo.photo_id " & _
			   "WHERE tba_rel.rel_tag=" & lng_TagId & " AND " & _
			  		 "tba_photo.photo_pub < " & formatDBDate(dtm_Pub,CARNIVAL_DATABASE_TYPE) & " AND tba_photo.photo_active = 1 " & _
			   "ORDER BY tba_photo.photo_pub DESC"
	elseif lng_SetId > 0 then
		SQLo = "SELECT TOP 1 photo_id, photo_title, photo_pub, photo_order " & _
			   "FROM tba_photo " & _
			   "WHERE ((photo_pub < " & formatDBDate(dtm_Pub,CARNIVAL_DATABASE_TYPE) & " AND photo_order = " & lng_Order & ") OR " & _
			  	      "(photo_order > " & lng_Order & ")) AND (photo_active = 1) AND (photo_set = " & lng_SetId & ") " & _
			   "ORDER BY photo_order ASC, photo_pub DESC"
	else
		SQLo = "SELECT TOP 1 photo_id, photo_title, photo_pub, photo_order " & _
			   "FROM tba_photo " & _
			   "WHERE photo_pub < " & formatDBDate(dtm_Pub,CARNIVAL_DATABASE_TYPE) & " AND photo_active = 1 " & _
			   "ORDER BY photo_pub DESC"
	end if
	
	getPrevPhotoSQL = SQLo
end function

function getNextPhotoSQL(lng_TagId,lng_SetId,dtm_Pub,lng_Order)
	dim SQLo
	
	if lng_TagId > 0 then
		SQLo = "SELECT TOP 1 tba_photo.photo_id, tba_photo.photo_title, tba_photo.photo_pub, tba_photo.photo_order " & _
			   "FROM tba_rel INNER JOIN tba_photo ON tba_rel.rel_photo = tba_photo.photo_id " & _
			   "WHERE tba_rel.rel_tag=" & lng_TagId & " AND " & _
			  		 "tba_photo.photo_pub > " & formatDBDate(dtm_Pub,CARNIVAL_DATABASE_TYPE) & " AND tba_photo.photo_active = 1 " & _
			   "ORDER BY tba_photo.photo_pub ASC"
	elseif lng_SetId > 0 then
		SQLo = "SELECT TOP 1 photo_id, photo_title, photo_pub, photo_order FROM tba_photo " & _
			   "WHERE ((photo_pub > " & formatDBDate(dtm_Pub,CARNIVAL_DATABASE_TYPE) & " AND photo_order = " & lng_Order & ") OR " & _
			  		  "(photo_order < " & lng_Order & ")) AND (photo_active = 1) AND (photo_set = " & lng_SetId & ") " & _
			   "ORDER BY photo_order DESC, photo_pub ASC"
	else
		SQLo = "SELECT TOP 1 photo_id, photo_title, photo_pub, photo_order " & _
			   "FROM tba_photo " & _
			   "WHERE photo_pub > " & formatDBDate(dtm_Pub,CARNIVAL_DATABASE_TYPE) & " AND photo_active = 1 ORDER BY photo_pub ASC"
	end if
	
	getNextPhotoSQL = SQLo
end function
%>