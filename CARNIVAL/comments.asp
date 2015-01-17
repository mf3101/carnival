<!--#include file = "includes/inc.first.asp"--><%
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
' * @version         SVN: $Id: comments.asp 18 2008-06-29 02:54:08Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

crnIsCommentPage = true

dim crn_viaJs, crn_showCommentForm
crn_viaJs = false
crn_showCommentForm = true

crnPhotoId = cleanLong(request.QueryString("id"))
if crnPhotoId < 0 then crnPhotoId = 0

if crnPhotoId <> 0 then
SQL = "SELECT photo_title, photo_description, photo_pub, photo_cropped, photo_elaborated, photo_views,photo_downloadable,photo_original,photo_set FROM tba_photo WHERE photo_id = " & crnPhotoId & " AND photo_active = 1"
	set rs = dbManager.conn.execute(SQL)
	if rs.eof then response.Redirect("comments.asp")
	crnPhotoTitle = server.HTMLEncode(rs("photo_title"))
	crnPhotoDescription = server.HTMLEncode(rs("photo_description"))
	crnPhotoPub = formatGMTDate(rs("photo_pub"),0,"dd/mm/yyyy")
	crnPhotoCropped = rs("photo_cropped")
	crnPhotoElaborated = rs("photo_elaborated")
	crnPhotoViews = rs("photo_views")
	crnPhotoDownloadable = rs("photo_downloadable")
	crnPhotoOriginal = rs("photo_original")
	crnPhotoSet = cleanLong(rs("photo_set"))
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