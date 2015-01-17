<!--#include file = "includes/inc.first.asp"--><% 
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		inner.photoinfo.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------

crnPhotoId = cleanLong(request.QueryString("id"))
dim crn_viaJs
crn_viaJs = cstr(request.QueryString("js"))
if crn_viaJs <> "1" then 
	crn_viaJs = false
else
	crn_viaJs = true
end if
if crnPhotoId <= 0 then
%><b>errore:</b> id non valido<%
response.end
end if

SQL = "SELECT photo_title, photo_description, photo_cropped, photo_elaborated, photo_views,photo_downloadable,photo_original FROM tba_photo WHERE photo_id = " & crnPhotoId
set rs = conn.execute(SQL)
if rs.eof then
%><b>errore:</b> id non valido<%
response.end
end if 
dim title, description
crnPhotoTitle = rs("photo_title")
crnPhotoDescription = rs("photo_description")
crnPhotoCropped = rs("photo_cropped")
crnPhotoElaborated = rs("photo_elaborated")
crnPhotoDownloadable = rs("photo_downloadable")
crnPhotoOriginal = rs("photo_original")
crnPhotoViews = rs("photo_views")%>
<!--#include file = "includes/gen.photoinfo.asp"-->