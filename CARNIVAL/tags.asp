<!--#include file = "includes/inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		tags.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------
crnTitle = crnLang_tags_title
crnPageTitle = carnival_title & " ::: " & crnTitle
crnShowTop = 0 
%><!--#include file = "includes/inc.top.asp"-->
		<div class="tags cloud">
		<!--#include file = "includes/gen.tagcloud.asp"-->
		<%
		SQL = "SELECT tag_name FROM tba_tag WHERE tag_type = 1 AND tag_photos <> 0 ORDER BY tag_name"
		set rs = conn.execute(SQL)
		%>
		</div><%
		if not rs.eof then %>
		<hr />
		<div class="tags common">
		<div class="title">tag comuni</div>
		<div class="tags">
		<%
		while not rs.eof
			%>
			<a href="photo.asp?tag=<%=rs("tag_name")%>"><%=rs("tag_name")%></a>&nbsp;
			<%
			rs.movenext
		wend
		%></div>
		</div><%
		end if
		%>
<!--#include file = "includes/inc.bottom.asp"-->