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
' * @version         SVN: $Id: mod.admin.prophotoupload.asp 16 2008-06-28 12:25:27Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"-->
<!--#include file = "class.upload.asp"-->
<%
	dim crn_action, crn_type, crn_returnpage
	crnPhotoId = cleanLong(request.QueryString("id"))
	crn_action = normalize(trim(request.QueryString("action")),"edit","new")
	crn_type = normalize(trim(request.QueryString("type")),"copy|new|thumb|photo","none")
	crn_returnpage = cleanLong(request.QueryString("returnpage"))

	SQL = "SELECT photo_original FROM tba_photo WHERE photo_id = " & crnPhotoId
	set rs = dbManager.conn.execute(SQL)
	if rs.eof then  response.redirect("errors.asp?c=upload3")
	crnPhotoOriginal = rs("photo_original")
	
	if crn_type = "none" then response.redirect("errors.asp?c=upload3")
	
	if crn_type = "copy" then
	
		dim fso, file
		Set fso = CreateObject("Scripting.FileSystemObject")
		Set file = fso.GetFile(server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crnPhotoId & CARNIVAL_ORIGINALPOSTFIX & crnPhotoOriginal & ".jpg"))
		file.Copy (server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crnPhotoId & ".jpg"))
		set file = nothing
		set fso = nothing
	
	else

		dim crn_size, crn_extension, crn_height, crn_width
		
		Dim oUpload
		Set oUpload = new cUpload
			oUpload.AutoRename = False
			oUpload.Overwrite = true
		
		call oUpload.SetPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS)
		call oUpload.Upload()
		
		'* controllo upload
		if oUpload.count = 0 then response.redirect("errors.asp?c=upload0")
		
		crn_size = cleanLong(oUpload.Files("size"))
		if crn_size = 0 then response.redirect("errors.asp?c=upload1")
		crn_extension = oUpload.Files("ext")
		if crn_extension = "jpeg" then crn_extension = "jpg"
		crn_height = cleanLong(oUpload.Files("height"))
		crn_width = cleanLong(oUpload.Files("width"))
		
		'* controllo formato
		if crn_extension <> "jpg" then response.redirect("errors.asp?c=upload2")
		'* controllo dimensioni (size)
		'if crn_size > (1000 * 1024) then response.redirect("upload_result.asp?error=2")
		'* controllo dimensioni (width|height)
		'if crn_height > 1500 or crn_width > 1500 or crn_height = 0 or crn_width = 0 then response.redirect("upload_result.asp?error=3")
	
		'* determina il nome del file caricato
		dim crn_tmpfilepath, crn_filename
		select case crn_type
			case "new"
			crn_filename = CARNIVAL_PHOTOPREFIX & crnPhotoId & CARNIVAL_ORIGINALPOSTFIX & crnPhotoOriginal & "." & crn_extension
			case "thumb"
			crn_filename = CARNIVAL_PHOTOPREFIX & crnPhotoId & CARNIVAL_THUMBPOSTFIX & "." & crn_extension
			case "photo"
			crn_filename = CARNIVAL_PHOTOPREFIX & crnPhotoId & "." & crn_extension
		end select
		
		'* se un file con lo stesso nome esiste viene eliminato
		dim objFile
		crn_tmpfilepath = server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & crn_filename)
		if oUpload.Fso.Fileexists(crn_tmpfilepath) then
			Set objFile=oUpload.Fso.GetFile(crn_tmpfilepath)
			objFile.delete
		end if
		set objFile = nothing
		
		'* salva il nuovo file
		call oUpload.SaveAs(crn_filename)
		Set oUpload = Nothing
	
	end if
	
	
	'* prossima pagina
	select case crn_type
		case "new"
		response.Redirect("admin.asp?module=photo-resize&id=" & crnPhotoId & "&action=" & crn_action & "&returnpage=" & crn_returnpage)
		case "copy", "photo"
		response.Redirect("admin.asp?module=photo-thumb&id=" & crnPhotoId & "&action=" & crn_action & "&returnpage=" & crn_returnpage)
		case "thumb"
		response.Redirect("admin.asp?module=photo-check&id=" & crnPhotoId & "&action=" & crn_action & "&returnpage=" & crn_returnpage)
	end select
	
%>