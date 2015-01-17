<%
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
' * @version         SVN: $Id: gen.tagcloud.asp 16 2008-06-28 12:25:27Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------
%><!--#include file = "class.wbclouds.asp"--><%

dim objCloud
set objCloud = new wbClouds
objCloud.init()
objCloud.baseUrl = "photo.asp?tag="

if crnShowTop <> 0 then
	SQL = "SELECT TOP " & crnShowTop & " tag_name,tag_photos FROM tba_tag WHERE tag_type = 0 AND tag_photos > 0 ORDER BY tag_photos DESC"
	objCloud.percSize = 90
else
	SQL = "SELECT tag_name,tag_photos FROM tba_tag WHERE tag_type = 0 AND tag_photos > 0 ORDER BY tag_photos DESC"
	objCloud.percSize = 150
end if
set rs = dbManager.conn.execute(SQL)

while not rs.eof
	call objCloud.add(rs("tag_name"),rs("tag_photos"),rs("tag_name"))
	rs.movenext
wend

call objCloud.sort("name","asc")
call objCloud.print()

%>