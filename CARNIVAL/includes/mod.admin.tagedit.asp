<!--#include file = "inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		mod.admin.tagedit.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"--><%

dim crn_id, crn_tagName, crn_tagType
crn_id = cleanLong(request.QueryString("id"))

SQL = "SELECT tag_name,tag_type FROM tba_tag WHERE tag_id = " & crn_id
set rs = conn.execute(SQL)
if rs.eof then response.Redirect("admin.asp?module=tag-list")
crn_tagName = rs("tag_name")
crn_tagType = cbyte(rs("tag_type"))

%><h2>Modifica tag</h2>
	<form class="post" action="admin.asp?module=pro-tag" method="post">
		<div><input type="hidden" name="action" id="action" value="edit" />
		<input type="hidden" name="id" id="id" value="<%=crn_id%>" />
		<label for="name">nome tag</label>
		<input type="text" id="name" name="name" class="text" maxlength="50" value="<%=cleanOutputString(crn_tagName)%>" /></div>
		<div><label for="cropped">tipologia di tag</label>
		<select id="type" name="type">
			<option value="0"<% if crn_tagType = 0 then %> selected="selected"<% end if %>>Normale</option>
			<option value="1"<% if crn_tagType = 1 then %> selected="selected"<% end if %>>Comune</option>
		</select></div>
		
		<div class="nbuttons">
			<a href="admin.asp?module=tag-list">
				<span>
				<img src="<%=carnival_pathimages%>/lay-adm-ico-but-prev.gif" alt=""/> 
				indietro
				</span>
			</a>
			<button type="submit">
				<span class="a"><span class="b">
				<img src="<%=carnival_pathimages%>/lay-adm-ico-but-accept.gif" alt=""/> 
				modifica
				</span></span>
			</button>
		</div>
	</form>
	<div class="clear"></div>