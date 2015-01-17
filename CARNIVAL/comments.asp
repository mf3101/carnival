<!--#include file = "includes/inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		comments.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------

crnIsCommentPage = true

dim crn_viaJs, crn_showCommentForm
crn_viaJs = false
crn_showCommentForm = true

crnPhotoId = cleanLong(request.QueryString("id"))
if crnPhotoId < 0 then crnPhotoId = 0

if crnPhotoId <> 0 then
	SQL = "SELECT photo_title, photo_description, photo_pub, photo_cropped, photo_elaborated, photo_views,photo_downloadable,photo_original FROM tba_photo WHERE photo_id = " & crnPhotoId & " AND photo_active = 1"
	set rs = conn.execute(SQL)
	if rs.eof then response.Redirect("comments.asp")
	crnPhotoTitle = server.HTMLEncode(rs("photo_title"))
	crnPhotoDescription = server.HTMLEncode(rs("photo_description"))
	crnPhotoPub = formatGMTDate(rs("photo_pub"),0,"dd/mm/yyyy")
	crnPhotoCropped = rs("photo_cropped")
	crnPhotoElaborated = rs("photo_elaborated")
	crnPhotoViews = rs("photo_views")
	crnPhotoDownloadable = rs("photo_downloadable")
	crnPhotoOriginal = rs("photo_original")
	crnTitle = crnLang_comments_title_details
	crnPageTitle = carnival_title & " ::: " & crnTitle & " > """ & crnPhotoTitle & """"
else
	crnTitle = crnLang_comments_title_recent
	crnPageTitle = carnival_title & " ::: " & crnTitle
end if
%><!--#include file = "includes/inc.top.asp"-->
	<% if crnPhotoId <> 0 then%>
		<a id="detailshere"></a>
		<div id="details-info">
		<div class="title"><%=crnPhotoTitle%></div>
		<!--#include file = "includes/gen.photoinfo.asp"-->
		</div>
		<hr/>
		<%
	end if %>
	<a id="commentshere"></a>
	<div class="comments">
	<!--#include file = "includes/gen.comments.asp"-->
	</div>
<!--#include file = "includes/inc.bottom.asp"-->