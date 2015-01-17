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
' * @version         SVN: $Id: inner.photoinfo.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
' nessun enviroment aggiuntivo
'*****************************************************

dim strDBPhotoTitle, strDBPhotoDescription, lngDBPhotoViews
dim blnDBPhotoCropped, blnDBPhotoElaborated, blnDBPhotoDownloadable
dim strDBPhotoOriginal, lngDBPhotoSet

lngCurrentPhotoId__ = inputLong(request.QueryString("id"))
dim blnViaJavascript
blnViaJavascript = inputBoolean(request.QueryString("js"))
if lngCurrentPhotoId__ <= 0 then
%><b>errore:</b> id non valido<%
response.end
end if

SQL = "SELECT photo_title, photo_description, photo_cropped, photo_elaborated, photo_views,photo_downloadable,photo_original,photo_set FROM tba_photo WHERE photo_id = " & lngCurrentPhotoId__ & " AND photo_active = 1"
set rs = dbManager.Execute(SQL)
if rs.eof then
%><b>errore:</b> id non valido<%
response.end
end if 
dim title, description
strDBPhotoTitle = rs("photo_title")
strDBPhotoDescription = rs("photo_description")
blnDBPhotoCropped = inputBoolean(rs("photo_cropped"))
blnDBPhotoElaborated = inputBoolean(rs("photo_elaborated"))
blnDBPhotoDownloadable = inputBoolean(rs("photo_downloadable"))
strDBPhotoOriginal = rs("photo_original")
lngDBPhotoViews = rs("photo_views")
lngDBPhotoSet = rs("photo_set")%>
<!--#include file = "includes/gen.photoinfo.asp"-->