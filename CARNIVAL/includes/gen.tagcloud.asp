<%
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
' * @version         SVN: $Id: gen.tagcloud.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "class.wbclouds.asp"--><%
'*****************************************************

dim objCloud
set objCloud = new wbClouds
objCloud.init()
objCloud.baseUrl = "photo.asp?tag=%name"
if config__jsnavigatoractive__ and config__jsactive__ and blnViaJavascript then objCloud.aOnClick = "callNavigator(0,%id,0);return false;"

if intTagsCount <> 0 then
	SQL = "SELECT TOP " & intTagsCount & " tag_name,tag_id,tag_photos FROM tba_tag WHERE tag_type = 0 AND tag_photos > 0 ORDER BY tag_photos DESC"
	objCloud.percSize = 90
else
	SQL = "SELECT tag_name,tag_id,tag_photos FROM tba_tag WHERE tag_type = 0 AND tag_photos > 0 ORDER BY tag_photos DESC"
	objCloud.percSize = 150
end if
set rs = dbManager.Execute(SQL)

if rs.eof then
	
	response.write "nessun tag presente"

else	

	while not rs.eof
		call objCloud.add(rs("tag_name"),rs("tag_id"),rs("tag_photos"),"")
		rs.movenext
	wend
	
	call objCloud.sort("name","asc")
	call objCloud.print()

end if
%>