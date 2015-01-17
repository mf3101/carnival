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
' * @version         SVN: $Id: mod.admin.protag.asp 21 2008-06-29 22:05:09Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"-->
<%

dim crn_action, crn_id, crn_name, crn_from, crn_type, crn_returnpage

crn_from = normalize(request.QueryString("from"),"tools","tag-list")

crn_action = request.QueryString("action")
if crn_action = "" then crn_action = request.form("action")
crn_action = normalize(crn_action,"multi|del|edit|update|typenormal|typecommon","")

crn_id = cleanLong(request.QueryString("id"))
if crn_id = 0 then crn_id = cleanLong(request.form("id"))

crn_type = request.QueryString("type")
if crn_type = "" then crn_type = request.form("type")
crn_type = cleanByte(crn_type)

crn_name = request.QueryString("name")
if crn_name = "" then crn_name = request.form("name")
crn_name = cleanString(cleanTagName(crn_name),0,50)

crn_returnpage = cleanLong(request.QueryString("returnpage"))
if crn_returnpage = 0 then crn_returnpage = cleanLong(request.form("returnpage"))

select case crn_action
	case "multi"
	
		dim multiid, multisel, multiaction
		multiaction = normalize(request.Form("multiaction"),"del","")
		dim ii : ii = 1
		while (trim(request.Form("multiid"&ii))<>"")
			if cleanBool(request.Form("multisel"&ii)) then
				multiid = cleanLong(request.Form("multiid"&ii))
				select case multiaction
					case "del"
					call deleteTag(multiid)
				end select
			end if
			ii=ii+1
		wend
	case "del"
		call deleteTag(crn_id)
	case "typenormal", "typecommon"
		crn_type = 0
		if crn_action = "typecommon" then crn_type = 1
		SQL = "UPDATE tba_tag SET tag_type = " & crn_type & " WHERE tag_id = " & crn_id
		dbManager.conn.execute(SQL)
	case "edit"
		if crn_name <> "" then
			'se il nome del tag è valido controlla se non esiste un tag con lo stesso nome
			SQL = "SELECT tag_id FROM tba_tag WHERE tag_name = '" & crn_name & "' AND tag_id <> " & crn_id
			set rs = dbManager.conn.execute(SQL)
			if not rs.eof then response.Redirect("errors.asp?c=tag0")
			'se non esistono altri tag con lo stesso nome modifica
			SQL = "UPDATE tba_tag SET tag_name = '" & crn_name & "', tag_type = " & crn_type & " WHERE tag_id = " & crn_id
			dbManager.conn.execute(SQL)
		end if
	case "update"
		dim rs2
		set rs2 = Server.CreateObject("ADODB.Recordset")
	
		SQL = "SELECT tag_id FROM tba_tag"
		set rs = dbManager.conn.execute(SQL)
		while not rs.eof
			SQL = "SELECT Count(tba_rel.rel_id) AS photos FROM tba_rel INNER JOIN tba_photo ON tba_rel.rel_photo = tba_photo.photo_id WHERE tba_rel.rel_tag = " & rs("tag_id") & " AND tba_photo.photo_active=1"
			set rs2 = dbManager.conn.execute(SQL)
			SQL = "UPDATE tba_tag SET tag_photos = " & rs2("photos") & " WHERE tag_id = " & rs("tag_id")
			dbManager.conn.execute(SQL)
			rs.movenext
		wend
		
		set rs2 = nothing
end select

select case crn_from
	case "tools"
	response.Redirect("admin.asp?module=tools&done=tags")
	case "tag-list"
	response.Redirect("admin.asp?module=tag-list&page="&crn_returnpage)
end select

'**********************************************************************************************************
'MAIN FUNCTIONS
'--------------
sub deleteTag(id)
	'elimina tutti i riferimenti alle foto
	SQL = "DELETE * FROM tba_rel WHERE rel_tag = " & id
	dbManager.conn.execute(SQL)
	'elimina fisicamente il tag
	SQL = "DELETE * FROM tba_tag WHERE tag_id = " & id
	dbManager.conn.execute(SQL)
end sub
'**********************************************************************************************************
%>