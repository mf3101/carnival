<%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		gen.tagcloud.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
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
set rs = conn.execute(SQL)

while not rs.eof
	call objCloud.add(rs("tag_name"),rs("tag_photos"),rs("tag_name"))
	rs.movenext
wend

call objCloud.sort("name","asc")
call objCloud.print()

%>