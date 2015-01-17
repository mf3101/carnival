<!--#include file = "inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		mod.admin.taglist.asp 0 20080312120000
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
	<div class="admin-minibutton"><img src="<%=carnival_pathimages%>/lay-adm-ico-act-update.gif" alt="" /><a href="admin.asp?module=pro-tag&amp;action=update">sincronizza foto/tag</a></div>
	<h2>Elenco tag</h2>
	<div class="clear"></div>
	<%	
	SQL = "SELECT tag_id, tag_name, tag_type, tag_photos FROM tba_tag ORDER BY tag_name"
	set rs = conn.execute(SQL)
	%>
	<table class="post">
		<tr class="head">
			<td class="img"></td>
			<td class="id">ID</td>
			<td class="title">TAG</td>
			<td class="photos">PHOTO</td>
			<td class="act">T</td>
			<td class="act"></td>
			<td class="act"></td>
		</tr>
	<%
	dim crn_tagId, crn_tagName, crn_tagType, crn_tagTypeImg, crn_tagPhotos
	crnCounter = 0
	while not rs.eof
		
		crn_tagId = rs("tag_id")
		crn_tagName = rs("tag_name")
		crn_tagType = cbyte(rs("tag_type"))
		if crn_tagType = 1 then
			crn_tagType = "typenormal"
			crn_tagTypeImg = "typecommon"
		else
			crn_tagType = "typecommon"
			crn_tagTypeImg = "typenormal"
		end if
		crn_tagPhotos = rs("tag_photos")
		crnCounter = crnCounter + 1
		
		%>
		<tr>
			<td class="img"><a href="gallery.asp?tag=<%=crn_tagName%>" target="_blank"><img src="<%=carnival_pathimages%>lay-adm-ico-id-tag.gif" alt="tag" /></a></td>
			<td class="id"><%=crn_tagId%></td>
			<td class="title"><%=crn_tagName%></td>
			<td class="photos"><%=crn_tagPhotos%></td>
			<td class="act"><a href="admin.asp?module=pro-tag&amp;id=<%=crn_tagId%>&amp;action=<%=crn_tagType%>" title="normale/comune"><img src="<%=carnival_pathimages%>lay-adm-ico-act-<%=crn_tagTypeImg%>.gif" alt="" /></a></td>
			<td class="act"><a href="admin.asp?module=tag-edit&amp;id=<%=crn_tagId%>" title="modifica"><img src="<%=carnival_pathimages%>lay-adm-ico-act-edit.gif" alt="modifica" /></a></td>
			<td class="act"><a href="admin.asp?module=pro-tag&amp;action=del&amp;id=<%=crn_tagId%>" onclick="if (!confirm('vuoi veramente cancellare il tag?')) return false;" title="cancella"><img src="<%=carnival_pathimages%>lay-adm-ico-act-del.gif" alt="cancella" /></a></td>
		</tr>
		<%
		
		rs.movenext
	wend
	%>
	</table>
	<script type="text/javascript">/* <![CDATA[ */
	function quest(question,value,goto) {
		var result = prompt(question,value);
		if (result != null) {
			document.location.href = String(goto) + String(result);
		}
	}
	/* ]]> */</script>