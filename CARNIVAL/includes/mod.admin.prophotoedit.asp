<!--#include file = "inc.first.asp"--><%
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
' * @version         SVN: $Id: mod.admin.prophotoedit.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "inc.admin.check.asp"-->
<!--#include file = "inc.func.rss.asp"-->
<!--#include file = "inc.func.photo.asp"--><%
'*****************************************************

dim lngDBPhotoId, strDBPhotoTitle, strDBPhotoDescription, dtmDBPhotoPub, lngDBPhotoOrder
dim blnDBPhotoCropped, blnDBPhotoElaborated, blnDBPhotoDownloadable, strDBPhotoOriginal, lngDBPhotoSet
dim blnDBPhotoActive, bytDBPhotoPubQueue

'load current befor updating (edit/del)
dim lngPhotoSet_old, blnPhotoActive_old, dtmPhotoPub_old
dim bytPhotoPubQueue_old, blnPhotoDownloadable_old, strPhotoOriginal_old 

dim blnCompileRss : blnCompileRss = false

dim lngPhotoId, lngPhotoSet
dim strAction, strReturnQuerystring

strReturnQuerystring = (request.Form("returnpage"))
if strReturnQuerystring = "" then strReturnQuerystring = request.querystring("returnpage")

lngPhotoSet = inputLong(request.QueryString("setid"))
if lngPhotoSet = 0 then lngPhotoSet = inputLong(request.Form("setid"))

strAction = request.form("action")
if strAction = "" then strAction = request.querystring("action")
strAction = normalize(strAction,"multi|new|edit|show|hide|del|downon|downoff|order|pubup|pubdown|updatepub","")	

dim lngPhotoOrder
lngPhotoOrder = inputLong(request.QueryString("order"))
if lngPhotoOrder = 0 then lngPhotoOrder = inputLong(request.form("order"))

if strAction <> "" then
	select case strAction
		case "edit","show","hide","del","downon","downoff","order","pubup","pubdown"
			lngPhotoId = inputLong(request.form("id"))
			if lngPhotoId = 0 then lngPhotoId = inputLong(request.querystring("id"))
			SQL = "SELECT photo_id, photo_active, photo_set, photo_original, photo_pub, photo_pubqueue, photo_downloadable FROM tba_photo WHERE photo_id = " & lngPhotoId
			set rs = dbManager.Execute(SQL)
			if rs.eof then response.Redirect("errors.asp?c=post0")
			lngDBPhotoId = rs("photo_id")	
			blnDBPhotoActive = inputByte(rs("photo_active"))
			lngDBPhotoSet = inputLong(rs("photo_set"))
			strDBPhotoOriginal = rs("photo_original")
			dtmDBPhotoPub = inputDate(rs("photo_pub"))
			bytDBPhotoPubQueue = inputByte(rs("photo_pubqueue"))
			blnDBPhotoDownloadable = inputByte(rs("photo_downloadable"))
		case "new"
			strAction = "new"
			lngDBPhotoId = 0
			strDBPhotoTitle = "!INDICA UN TITOLO!"
			strDBPhotoDescription = ""
			blnDBPhotoCropped = 0
			bytDBPhotoPubQueue = 0
			blnDBPhotoElaborated = 0
			lngDBPhotoSet = 1
			lngDBPhotoOrder = 0
			strDBPhotoOriginal = createKey(10)
			dtmDBPhotoPub = formatDBDate(now,CARNIVAL_DATABASE_TYPE)
		'case "multi"
	end select
	
	select case strAction
		case "updatepub"
			call syncAutoPub()
			response.Redirect("admin.asp?module=tools&done=pub")
		case "multi"
		
			dim multiid, multisel, multiaction
			multiaction = normalize(request.Form("multiaction"),"del|order|show|hide|downon|downoff|addtag|moveset|removeset","")
			dim ii : ii = 1
			while (trim(request.Form("multiid"&ii))<>"")
				if inputBoolean(request.Form("multisel"&ii)) then
					multiid = inputLong(request.Form("multiid"&ii))
					
					select case multiaction
						case "downon","downoff"
							SQL = "SELECT photo_original, photo_downloadable, photo_active FROM tba_photo WHERE photo_id = " & multiid
							set rs = dbManager.Execute(SQL)
							if not rs.eof then
								if inputBoolean(rs("photo_downloadable")) <> IIF(multiaction="downon",true,false) then 
									strDBPhotoOriginal = rs("photo_original")
									call downloadPhoto(multiid,IIF(multiaction = "downon",true,false),inputBoolean(rs("photo_active")),strDBPhotoOriginal)
								end if
							end if
						case "show","hide"
							SQL = "SELECT photo_active, photo_pub, photo_pubqueue, photo_original FROM tba_photo WHERE photo_id = " & multiid
							set rs = dbManager.Execute(SQL)
							if not rs.eof then
								if inputBoolean(rs("photo_active")) <> IIF(multiaction="show",true,false) then 
									call activePhoto(multiid,IIF(multiaction="show",true,false),IIF(multiaction="show",false,true),inputDate(rs("photo_pub")),inputByte(rs("photo_pubqueue")),rs("photo_original"))
									blnCompileRss = true 'modificata active
								end if
							end if
						case "del"
							SQL = "SELECT photo_active, photo_set, photo_pubqueue, photo_pub, photo_original FROM tba_photo WHERE photo_id = " & multiid
							set rs = dbManager.Execute(SQL)
							if not rs.eof then
								lngDBPhotoSet = inputLong(rs("photo_set"))
								blnDBPhotoActive = inputByte(rs("photo_active"))
								bytDBPhotoPubQueue = inputByte(rs("photo_pubqueue"))
								dtmDBPhotoPub = inputDate(rs("photo_pub"))
								strDBPhotoOriginal = rs("photo_original")
								call deletePhoto(multiid,inputBoolean(blnDBPhotoActive),lngDBPhotoSet,strDBPhotoOriginal,bytDBPhotoPubQueue,dtmDBPhotoPub)
								if blnDBPhotoActive = 1 then blnCompileRss = true 'cancellata foto
							end if
						case "moveset","removeset"
							lngDBPhotoSet = inputLong(request.Form("set")) : if lngDBPhotoSet < 1 then lngDBPhotoSet = 1
							if multiaction = "removeset" then lngDBPhotoSet = 1
							SQL = "SELECT photo_active,photo_set FROM tba_photo WHERE photo_id = " & multiid
							set rs = dbManager.Execute(SQL)
							if not rs.eof then
								lngPhotoSet_old = rs("photo_set")
								blnDBPhotoActive = rs("photo_active")
								if clng(lngPhotoSet_old) <> clng(lngDBPhotoSet) then
								call setPhoto(multiid,lngDBPhotoSet)
								call updateSetAfterEdit(multiid,inputBoolean(blnDBPhotoActive),inputBoolean(blnDBPhotoActive),lngPhotoSet_old,lngDBPhotoSet)
								end if
							end if
							lngPhotoSet = lngDBPhotoSet 'per redirect
							if multiaction = "removeset" then lngPhotoSet = lngPhotoSet_old
						case "addtag"
							dim strTagName
							strTagName = cleanTagName(trim(request.Form("tagname")))
							SQL = "SELECT photo_active FROM tba_photo WHERE photo_id = " & multiid
							set rs = dbManager.Execute(SQL)
							if not rs.eof and strTagName <> "" then
								blnDBPhotoActive = rs("photo_active")
								call addTagToPhoto(multiid,strTagName,inputBoolean(blnDBPhotoActive))
							end if
						case "order"
							call orderPhoto(multiid,lngPhotoOrder)
					end select
				end if
				ii=ii+1
			wend
			
		case "show","hide"
		
			if (blnDBPhotoActive <> IIF(strAction="show",true,false)) then
				call activePhoto(lngDBPhotoId,IIF(strAction="show",true,false),blnDBPhotoActive,dtmDBPhotoPub,bytDBPhotoPubQueue,strDBPhotoOriginal)
				blnCompileRss = true 'modificata active
			end if
			
		case "pubup","pubdown"
		
			if bytDBPhotoPubQueue = 2 then call autopubPhoto(lngDBPhotoId,IIF(strAction="pubup",true,false),dtmDBPhotoPub)
			
		case "order"
			
			call orderPhoto(lngDBPhotoId,lngPhotoOrder)
			
		case "downon","downoff"
			
			call downloadPhoto(lngDBPhotoId,IIF(strAction = "downon",true,false),blnDBPhotoActive,strDBPhotoOriginal)
				
		case "new"
	
			SQL = "INSERT INTO tba_photo (photo_title, photo_description, photo_cropped, photo_elaborated, photo_pub, photo_pubqueue, photo_original, photo_active, photo_views, photo_downloadable, photo_set, photo_order) VALUES " & _
										"('" & formatDBString(strDBPhotoTitle,null) & "','" & formatDBString(strDBPhotoDescription,null) & "'," & blnDBPhotoCropped & "," & blnDBPhotoElaborated & "," & dtmDBPhotoPub & "," & bytDBPhotoPubQueue & ",'" & formatDBString(strDBPhotoOriginal,null) & "',0,0,0," & lngDBPhotoSet & "," & lngDBPhotoOrder & ")"
			dbManager.Execute(SQL)
										
			SQL = "SELECT TOP 1 photo_id FROM tba_photo ORDER BY photo_id DESC"
			set rs = dbManager.Execute(SQL)
			
			lngDBPhotoId = rs("photo_id")
			
			call setCookie("lastphoto",lngDBPhotoId,now+365)
		
		case "edit"

			lngPhotoSet_old = lngDBPhotoSet
			blnPhotoActive_old = blnDBPhotoActive
			dtmPhotoPub_old = dtmDBPhotoPub
			bytPhotoPubQueue_old = bytDBPhotoPubQueue
			blnPhotoDownloadable_old = blnDBPhotoDownloadable
			strPhotoOriginal_old = strDBPhotoOriginal
			
			strDBPhotoTitle = inputStringD(request.form("title"),0,50)
			strDBPhotoDescription = inputStringD(request.form("description"),0,1000)
			blnDBPhotoCropped = inputByteD(request.form("cropped"),null,1)
			blnDBPhotoElaborated = inputByteD(request.form("elaborated"),null,1)
			blnDBPhotoActive = inputByteD(request.form("active"),null,1)
			blnDBPhotoDownloadable = inputByteD(request.form("downloadable"),null,1)
			lngDBPhotoSet = inputLong(request.Form("set")) : if lngDBPhotoSet < 1 then lngDBPhotoSet = 1
			if bytDBPhotoPubQueue <> 2 then dtmDBPhotoPub = inputDate(request.Form("pub"))
			bytDBPhotoPubQueue = inputByte(request.Form("pubqueue"))
			
			'calcolo data
			if bytDBPhotoPubQueue = 2 then
				'pubblicazione periodica
				blnDBPhotoActive = 0
				if bytPhotoPubQueue_old <> bytDBPhotoPubQueue or dtmPhotoPub_old < now then dtmDBPhotoPub = getNewAutopub()
			else 
				'pubblicazione automatica/disattivata
				if dtmDBPhotoPub > now then
					'solo se la data è futura
					blnDBPhotoActive = 0
					bytDBPhotoPubQueue = 1
				else
					bytDBPhotoPubQueue = 0
				end if
			end if
			
			if (blnDBPhotoActive <> blnPhotoActive_old) or _
			   ((inputBoolean(blnDBPhotoDownloadable) = false) and (inputBoolean(blnPhotoDownloadable_old))) then
			   strDBPhotoOriginal = createKey(10)
			   call updateOriginalPhoto(lngDBPhotoId,blnDBPhotoActive,blnPhotoActive_old,strPhotoOriginal_old,strDBPhotoOriginal)
			end if
			
			
			if strDBPhotoTitle = "" then response.Redirect("errors.asp?c=post1")
			
			dim rstrPhotoTags
			rstrPhotoTags = split(trim(request.form("tags"))," ")
			if ubound(rstrPhotoTags) = -1 then response.Redirect("errors.asp?c=post2")
		
			SQL = "UPDATE tba_photo SET photo_title = '" & formatDBString(strDBPhotoTitle,null) & "', photo_description = '" & formatDBString(strDBPhotoDescription,null) & "', photo_cropped = " & blnDBPhotoCropped & ", photo_elaborated = " & blnDBPhotoElaborated & ",photo_active = " & blnDBPhotoActive & ", photo_downloadable = " & blnDBPhotoDownloadable & ", photo_set = " & lngDBPhotoSet & ", photo_pub = " & formatDBDate(dtmDBPhotoPub,CARNIVAL_DATABASE_TYPE) & ", photo_pubqueue = " & bytDBPhotoPubQueue & ", photo_original = '" & formatDBString(strDBPhotoOriginal,null) & "' WHERE photo_id = " & lngDBPhotoId
			dbManager.Execute(SQL)
			
			call updateTagsAfterEdit(lngDBPhotoId,rstrPhotoTags,inputBoolean(blnPhotoActive_old),inputBoolean(blnDBPhotoActive))
			call updateSetAfterEdit(lngDBPhotoId,inputBoolean(blnPhotoActive_old),inputBoolean(blnDBPhotoActive),lngPhotoSet_old,lngDBPhotoSet)
			if bytPhotoPubQueue_old <> bytDBPhotoPubQueue and bytPhotoPubQueue_old = 2 then call syncAutoPubFrom(dtmPhotoPub_old)
			
			blnCompileRss = true 'modificata foto
		
		case "del"
		
			call deletePhoto(lngDBPhotoId,inputBoolean(blnDBPhotoActive),lngDBPhotoSet,strDBPhotoOriginal,bytDBPhotoPubQueue,dtmDBPhotoPub)
			
			blnCompileRss = true 'cancellata foto
		
	end select
end if

if strAction = "new" then
	response.Redirect("admin.asp?module=photo-upload&id=" & lngDBPhotoId)
elseif (strAction = "order") _
	or (strAction = "multi" and (request.Form("multiaction") = "order" or request.Form("multiaction") = "moveset" or request.Form("multiaction") = "removeset")) then
	response.Redirect("admin.asp?module=set-photo-list&id=" & lngPhotoSet & "&" & readyToQuerystring(strReturnQuerystring))
else
	if blnCompileRss then call compileRss()
	response.Redirect("admin.asp?module=photo-list&"&readyToQuerystring(strReturnQuerystring))
end if
%>