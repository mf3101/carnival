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
' * @version         SVN: $Id: mod.admin.prorss.asp 16 2008-06-28 12:25:27Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"-->
<%
dim crn_from, crn_returnpage
crn_from = normalize(request.QueryString("from"),"photo","tools")
crn_returnpage = cleanLong(request.QueryString("returnpage"))
dim output
output = "<?xml version=""1.0""?>" & vbcrlf & _
		 "<rss version=""2.0"">" & vbcrlf & _
		 "<channel>" & vbcrlf & _
		 "<title><![CDATA[" & carnival_title & "]]></title>" & vbcrlf & _
		 "<link>" & CARNIVAL_HOME & "</link>" & vbcrlf & _
		 "<description><![CDATA[" & carnival_description & "]]></description>" & vbcrlf & _
		 "<language>" & CARNIVAL_LANG & "</language>" & vbcrlf & _
		 "<copyright><![CDATA[" & carnival_copyright & "]]></copyright>" & vbcrlf & _
		 "<pubDate>" & formatRSSDate(carnival_start) & "</pubDate>" & vbcrlf & _
		 "<lastBuildDate>" & formatRSSDate(now) & "</lastBuildDate>" & vbcrlf & _
		 "<docs>http://www.rssboard.org/rss-specification</docs>" & vbcrlf & _
		 "<generator>Carnival " & CARNIVAL_VERS & "</generator>" & vbcrlf & _
		 "<image>" & vbcrlf & _
		 "<title>" & carnival_title & "</title>" & vbcrlf & _
		 "<url>" & CARNIVAL_HOME & "images/logo-rss.gif</url>" & vbcrlf & _
		 "<link>" & CARNIVAL_HOME & "</link>" & vbcrlf & _
		 "</image>" & vbcrlf

SQL = "SELECT TOP 10 photo_id, photo_title, photo_description, photo_pub FROM tba_photo WHERE photo_active = 1 ORDER BY photo_id DESC"
set rs = dbManager.conn.execute(SQL)

dim rs2
set rs2 = Server.CreateObject("ADODB.Recordset")
while not rs.eof

output = output & "<item>" & vbcrlf & _
			      "<title><![CDATA[#" & rs("photo_id") & " - " & server.HTMLEncode(rs("photo_title")) & "]]></title>" & vbcrlf & _
			      "<link>" & CARNIVAL_HOME & "photo.asp?id=" & rs("photo_id") & "</link>" & vbcrlf & _
			      "<description><![CDATA[" & replace(server.HTMLEncode(rs("photo_description")),vbcr,"<br/>") & "]]></description>" & vbcrlf
				  
	SQL = "SELECT tba_tag.tag_name FROM tba_rel INNER JOIN tba_tag ON tba_rel.rel_tag = tba_tag.tag_id WHERE tba_rel.rel_photo=" & rs("photo_id") & " ORDER BY tba_tag.tag_photos DESC"
	set rs2 = dbManager.conn.execute(SQL)
	while not rs2.eof
	output = output & "<category>" & rs2("tag_name") & "</category>" & vbcrlf
		rs2.movenext
	wend
	
output = output & "<comments>" & CARNIVAL_HOME & "comments.asp?id=" & rs("photo_id") & "#comments</comments>" & vbcrlf & _
				  "<enclosure url=""" & CARNIVAL_HOME & CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & rs("photo_id") & ".jpg"" type=""image/jpeg"" length=""1"" />" & vbcrlf & _
				  "<guid>" & CARNIVAL_HOME & "photo.asp?id=" & rs("photo_id") & "</guid>" & vbcrlf & _
				  "<pubDate>" & formatRSSDate(rs("photo_pub")) & "</pubDate>" & vbcrlf & _
				  "</item>" & vbcrlf
	rs.movenext
wend
set rs2 = Nothing

output = output & "</channel>" & vbcrlf & _
				  "</rss>"

Dim objFSO, objFile
Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.CreateTextFile(Server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_FEED & "feed.xml"), True)
objFile.Write output
objFile.Close
Set objFile = Nothing
Set objFSO = Nothing

select case crn_from
	case "tools"
	response.Redirect("admin.asp?module=tools&done=rss")
	case "photo"
	response.Redirect("admin.asp?module=photo-list&page="&crn_returnpage)
end select

%>