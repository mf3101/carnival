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
' * @version         SVN: $Id: inc.func.rss.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

sub compileRss()
	dim rst,rst2
	
	dim str_XMLOutput
	str_XMLOutput = "<?xml version=""1.0""?>" & vbcrlf & _
			 "<rss version=""2.0"">" & vbcrlf & _
			 "<channel>" & vbcrlf & _
			 "<title><![CDATA[" & config__title__ & "]]></title>" & vbcrlf & _
			 "<link>" & CARNIVAL_HOME & "</link>" & vbcrlf & _
			 "<description><![CDATA[" & config__description__ & "]]></description>" & vbcrlf & _
			 "<language>" & CARNIVAL_LANG & "</language>" & vbcrlf & _
			 "<copyright><![CDATA[" & config__copyright__ & "]]></copyright>" & vbcrlf & _
			 "<pubDate>" & formatRSSDate(config__start__) & "</pubDate>" & vbcrlf & _
			 "<lastBuildDate>" & formatRSSDate(now) & "</lastBuildDate>" & vbcrlf & _
			 "<docs>http://www.rssboard.org/rss-specification</docs>" & vbcrlf & _
			 "<generator>Carnival " & CARNIVAL_VERS & "</generator>" & vbcrlf & _
			 "<image>" & vbcrlf & _
			 "<title>" & config__title__ & "</title>" & vbcrlf & _
			 "<url>" & CARNIVAL_HOME & "images/logo-rss.gif</url>" & vbcrlf & _
			 "<link>" & CARNIVAL_HOME & "</link>" & vbcrlf & _
			 "</image>" & vbcrlf
	
	SQL = "SELECT TOP 10 photo_id, photo_title, photo_description, photo_pub FROM tba_photo WHERE photo_active = 1 ORDER BY photo_pub DESC"
	set rst = dbManager.Execute(SQL)
	
	while not rst.eof
	
		str_XMLOutput = str_XMLOutput & "<item>" & vbcrlf & _
					  "<title><![CDATA[" & server.HTMLEncode(rst("photo_title")) & "]]></title>" & vbcrlf & _
					  "<link>" & CARNIVAL_HOME & "photo.asp?id=" & rst("photo_id") & "</link>" & vbcrlf & _
					  "<description><![CDATA[" & replace(server.HTMLEncode(rst("photo_description")),vbcr,"<br/>") & "]]></description>" & vbcrlf
					  
		SQL = "SELECT tba_tag.tag_name FROM tba_rel INNER JOIN tba_tag ON tba_rel.rel_tag = tba_tag.tag_id WHERE tba_rel.rel_photo=" & rst("photo_id") & " ORDER BY tba_tag.tag_photos DESC"
		set rst2 = dbManager.Execute(SQL)
		while not rst2.eof
			str_XMLOutput = str_XMLOutput & "<category>" & rst2("tag_name") & "</category>" & vbcrlf
			rst2.movenext
		wend
		
	str_XMLOutput = str_XMLOutput & "<comments>" & CARNIVAL_HOME & "comments.asp?id=" & rst("photo_id") & "#comments</comments>" & vbcrlf & _
					  "<enclosure url=""" & CARNIVAL_HOME & CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & rst("photo_id") & ".jpg"" type=""image/jpeg"" length=""1"" />" & vbcrlf & _
					  "<guid>" & CARNIVAL_HOME & "photo.asp?id=" & rst("photo_id") & "</guid>" & vbcrlf & _
					  "<pubDate>" & formatRSSDate(rst("photo_pub")) & "</pubDate>" & vbcrlf & _
					  "</item>" & vbcrlf
		rst.movenext
	wend
	set rst = Nothing
	set rst2 = Nothing
	
	str_XMLOutput = str_XMLOutput & "</channel>" & vbcrlf & _
					  "</rss>"
	
	Dim obj_FSO, obj_File
	Set obj_FSO = Server.CreateObject("Scripting.FileSystemObject")
	Set obj_File = obj_FSO.CreateTextFile(Server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_FEED & "feed.xml"), True)
	obj_File.Write str_XMLOutput
	obj_File.Close
	Set obj_File = Nothing
	Set obj_FSO = Nothing
	
	Set str_XMLOutput = Nothing
	
end sub
%>