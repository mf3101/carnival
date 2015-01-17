<!--#include file = "includes/inc.first.asp"--><%
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
' * @version         SVN: $Id: comments.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
' nessun enviroment aggiuntivo
'*****************************************************

dim strDBPhotoTitle, strDBPhotoDescription, lngDBPhotoViews
dim blnDBPhotoCropped, blnDBPhotoElaborated, blnDBPhotoDownloadable
dim strDBPhotoOriginal, lngDBPhotoSet

blnIsCommentsPage__ = true

dim blnViaJavascript, blnShowCommentForm
blnViaJavascript = false
blnShowCommentForm = true

lngCurrentPhotoId__ = inputLong(request.QueryString("id"))
if lngCurrentPhotoId__ < 0 then lngCurrentPhotoId__ = 0

if lngCurrentPhotoId__ <> 0 then
SQL = "SELECT photo_title, photo_description, photo_pub, photo_cropped, photo_elaborated, photo_views,photo_downloadable,photo_original,photo_set FROM tba_photo WHERE photo_id = " & lngCurrentPhotoId__ & " AND photo_active = 1"
	set rs = dbManager.Execute(SQL)
	if rs.eof then response.Redirect("comments.asp")
	strDBPhotoTitle = server.HTMLEncode(rs("photo_title"))
	strDBPhotoDescription = server.HTMLEncode(rs("photo_description"))
	blnDBPhotoCropped = inputBoolean(rs("photo_cropped"))
	blnDBPhotoElaborated = inputBoolean(rs("photo_elaborated"))
	lngDBPhotoViews = rs("photo_views")
	blnDBPhotoDownloadable = inputBoolean(rs("photo_downloadable"))
	strDBPhotoOriginal = rs("photo_original")
	lngDBPhotoSet = inputLong(rs("photo_set"))
	
	strPageTitle__ = lang__comments_title_details__
	strPageTitleHead__ = config__title__ & " ::: " & strPageTitle__ & " > """ & strDBPhotoTitle & """"
else
	strPageTitle__ = lang__comments_title_recent__
	strPageTitleHead__ = config__title__ & " ::: " & strPageTitle__
end if
%><!--#include file = "includes/inc.top.asp"-->
	<% if lngCurrentPhotoId__ <> 0 then%>
		<a id="detailshere"></a>
		<div id="details-info">
		<div class="title"><%=strDBPhotoTitle%></div>
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