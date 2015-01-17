<!--#include file = "includes/inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		inner.comments.asp 0 20080312120000
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
if crnPhotoId < 0 then crnPhotoId = 0

SQL = "SELECT photo_id FROM tba_photo WHERE photo_id = " & crnPhotoId & " AND photo_active = 1"
set rs = conn.execute(SQL)
if rs.eof then response.end

dim crn_viaJs, crn_showCommentForm
crn_viaJs = cleanBool(request.QueryString("js"))
crn_showCommentForm = cleanBool(request.QueryString("showall"))

%>
<!--#include file = "includes/gen.comments.asp"-->