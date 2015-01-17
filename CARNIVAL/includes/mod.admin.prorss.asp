<!--#include file = "inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		mod.admin.prorss.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"-->
<%
dim crn_from
crn_from = normalize(request.QueryString("from"),"photo","tools")
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
set rs = conn.execute(SQL)

dim rs2
set rs2 = Server.CreateObject("ADODB.Recordset")
while not rs.eof

output = output & "<item>" & vbcrlf & _
			      "<title><![CDATA[#" & rs("photo_id") & " - " & server.HTMLEncode(rs("photo_title")) & "]]></title>" & vbcrlf & _
			      "<link>" & CARNIVAL_HOME & "photo.asp?id=" & rs("photo_id") & "</link>" & vbcrlf & _
			      "<description><![CDATA[" & replace(server.HTMLEncode(rs("photo_description")),vbcr,"<br/>") & "]]></description>" & vbcrlf
				  
	SQL = "SELECT tba_tag.tag_name FROM tba_rel INNER JOIN tba_tag ON tba_rel.rel_tag = tba_tag.tag_id WHERE tba_rel.rel_photo=" & rs("photo_id") & " ORDER BY tba_tag.tag_photos DESC"
	set rs2 = conn.execute(SQL)
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
	response.Redirect("admin.asp?module=photo-list")
end select

%>