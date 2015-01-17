<!--#include file = "inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		mod.admin.protag.asp 0 20080312120000
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

dim crn_action, crn_id, crn_name, crn_from, crn_type

crn_from = normalize(request.QueryString("from"),"tools","tag-list")

crn_action = request.QueryString("action")
if crn_action = "" then crn_action = request.form("action")
crn_action = normalize(crn_action,"del|edit|update|typenormal|typecommon","")

crn_id = cleanLong(request.QueryString("id"))
if crn_id = 0 then crn_id = cleanLong(request.form("id"))

crn_type = request.QueryString("type")
if crn_type = "" then crn_type = request.form("type")
crn_type = cleanByte(crn_type)

crn_name = request.QueryString("name")
if crn_name = "" then crn_name = request.form("name")
crn_name = cleanString(cleanTagName(crn_name),0,50)

select case crn_action
	case "del"
		'elimina tutti i riferimenti alle foto
		SQL = "DELETE * FROM tba_rel WHERE rel_tag = " & crn_id
		conn.execute(SQL)
		'elimina fisicamente il tag
		SQL = "DELETE * FROM tba_tag WHERE tag_id = " & crn_id
		conn.execute(SQL)
	case "typenormal", "typecommon"
		crn_type = 0
		if crn_action = "typecommon" then crn_type = 1
		SQL = "UPDATE tba_tag SET tag_type = " & crn_type & " WHERE tag_id = " & crn_id
		conn.execute(SQL)
	case "edit"
		if crn_name <> "" then
			'se il nome del tag è valido controlla se non esiste un tag con lo stesso nome
			SQL = "SELECT tag_id FROM tba_tag WHERE tag_name = '" & crn_name & "' AND tag_id <> " & crn_id
			set rs = conn.execute(SQL)
			if not rs.eof then response.Redirect("errors.asp?c=tag0")
			'se non esistono altri tag con lo stesso nome modifica
			SQL = "UPDATE tba_tag SET tag_name = '" & crn_name & "', tag_type = " & crn_type & " WHERE tag_id = " & crn_id
			conn.execute(SQL)
		end if
	case "update"
		dim rs2
		set rs2 = Server.CreateObject("ADODB.Recordset")
	
		SQL = "SELECT tag_id FROM tba_tag"
		set rs = conn.execute(SQL)
		while not rs.eof
			SQL = "SELECT Count(tba_rel.rel_id) AS photos FROM tba_rel INNER JOIN tba_photo ON tba_rel.rel_photo = tba_photo.photo_id WHERE tba_rel.rel_tag = " & rs("tag_id") & " AND tba_photo.photo_active=1"
			set rs2 = conn.execute(SQL)
			SQL = "UPDATE tba_tag SET tag_photos = " & rs2("photos") & " WHERE tag_id = " & rs("tag_id")
			conn.execute(SQL)
			rs.movenext
		wend
		
		set rs2 = nothing
end select

select case crn_from
	case "tools"
	response.Redirect("admin.asp?module=tools&done=tags")
	case "tag-list"
	response.Redirect("admin.asp?module=tag-list")
end select
%>