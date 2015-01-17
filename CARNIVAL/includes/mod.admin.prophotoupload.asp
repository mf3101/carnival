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
' * @version         SVN: $Id: mod.admin.prophotoupload.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "inc.admin.check.asp"-->
<!--#include file = "class.upload.asp"--><%
'*****************************************************

dim lngPhotoId, strDBPhotoOriginal, blnDBPhotoActive

	dim strAction, strUploadType, strReturnQuerystring
	lngPhotoId = inputLong(request.QueryString("id"))
	strAction = normalize(trim(request.QueryString("action")),"edit","new")
	strUploadType = normalize(trim(request.QueryString("type")),"copy|new|thumb|photo","none")
	strReturnQuerystring = request.QueryString("returnpage")

	SQL = "SELECT photo_original, photo_active FROM tba_photo WHERE photo_id = " & lngPhotoId
	set rs = dbManager.Execute(SQL)
	if rs.eof then  response.redirect("errors.asp?c=upload3")
	strDBPhotoOriginal = rs("photo_original")
	blnDBPhotoActive = inputBoolean(rs("photo_active"))
	
	dim file
	
	if strUploadType = "none" then response.redirect("errors.asp?c=upload3")
	
	if strUploadType = "copy" then
	
		dim obj_FSO
		Set obj_FSO = CreateObject("Scripting.FileSystemObject")
		Set file = obj_FSO.GetFile(server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & lngPhotoId & CARNIVAL_ORIGINALPOSTFIX & strDBPhotoOriginal & ".jpg"))
		file.Copy (server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & lngPhotoId & IIF(blnDBPhotoActive,"",strDBPhotoOriginal) & ".jpg"))
		set file = nothing
		set obj_FSO = nothing
	
	else

		dim lngUploadSize, strUploadExtension, lngUploadHeight, lngUploadWidth
		
		Dim oUpload
		Set oUpload = new cUpload
			oUpload.AutoRename = False
			oUpload.Overwrite = true
		
		call oUpload.SetPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS)
		call oUpload.Upload()
		
		'* controllo upload
		if oUpload.count = 0 then response.redirect("errors.asp?c=upload0")
		
		lngUploadSize = inputLong(oUpload.Files("size"))
		if lngUploadSize = 0 then response.redirect("errors.asp?c=upload1")
		strUploadExtension = oUpload.Files("ext")
		if strUploadExtension = "jpeg" then strUploadExtension = "jpg"
		lngUploadHeight = inputLong(oUpload.Files("height"))
		lngUploadWidth = inputLong(oUpload.Files("width"))
		
		'* controllo formato
		if strUploadExtension <> "jpg" then response.redirect("errors.asp?c=upload2")
		'* controllo dimensioni (size)
		'if lngUploadSize > (1000 * 1024) then response.redirect("upload_result.asp?error=2")
		'* controllo dimensioni (width|height)
		'if lngUploadHeight > 1500 or lngUploadWidth > 1500 or lngUploadHeight = 0 or lngUploadWidth = 0 then response.redirect("upload_result.asp?error=3")
	
		'* determina il nome del file caricato
		dim strUploadFilenameFull, strUploadFilename
		select case strUploadType
			case "new"
			strUploadFilename = CARNIVAL_PHOTOPREFIX & lngPhotoId & CARNIVAL_ORIGINALPOSTFIX & strDBPhotoOriginal & "." & strUploadExtension
			case "thumb"
			strUploadFilename = CARNIVAL_PHOTOPREFIX & lngPhotoId & CARNIVAL_THUMBPOSTFIX & IIF(blnDBPhotoActive,"",strDBPhotoOriginal) & "." & strUploadExtension
			case "photo"
			strUploadFilename = CARNIVAL_PHOTOPREFIX & lngPhotoId & IIF(blnDBPhotoActive,"",strDBPhotoOriginal) & "." & strUploadExtension
		end select
		
		'* se un file con lo stesso nome esiste viene eliminato
		strUploadFilenameFull = server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & strUploadFilename)
		if oUpload.Fso.Fileexists(strUploadFilenameFull) then
			Set file=oUpload.Fso.GetFile(strUploadFilenameFull)
			file.delete
		end if
		set file = nothing
		
		'* salva il nuovo file
		call oUpload.SaveAs(strUploadFilename)
		Set oUpload = Nothing
	
	end if
	
	
	'* prossima pagina
	select case strUploadType
		case "new"
		response.Redirect("admin.asp?module=photo-resize&id=" & lngPhotoId & "&action=" & strAction & "&returnpage=" & strReturnQuerystring)
		case "copy", "photo"
		response.Redirect("admin.asp?module=photo-thumb&id=" & lngPhotoId & "&action=" & strAction & "&returnpage=" & strReturnQuerystring)
		case "thumb"
		response.Redirect("admin.asp?module=photo-check&id=" & lngPhotoId & "&action=" & strAction & "&returnpage=" & strReturnQuerystring)
	end select
	
%>