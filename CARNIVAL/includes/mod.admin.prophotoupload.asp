<!--#include file = "inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		mod.admin.prophotoupload.asp 0 20080312120000
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
<!--#include file = "class.upload.asp"-->
<%
	dim crn_action, crn_type
	crnPhotoId = cleanLong(request.QueryString("id"))
	crn_action = normalize(trim(request.QueryString("action")),"edit","new")
	crn_type = normalize(trim(request.QueryString("type")),"copy|new|thumb|photo","none")

	SQL = "SELECT photo_original FROM tba_photo WHERE photo_id = " & crnPhotoId
	set rs = conn.execute(SQL)
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
		response.Redirect("admin.asp?module=photo-resize&id=" & crnPhotoId & "&action=" & crn_action)
		case "copy", "photo"
		response.Redirect("admin.asp?module=photo-thumb&id=" & crnPhotoId & "&action=" & crn_action)
		case "thumb"
		response.Redirect("admin.asp?module=photo-check&id=" & crnPhotoId & "&action=" & crn_action)
	end select
	
%>