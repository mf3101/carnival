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
' * @version         SVN: $Id: mod.admin.proset.asp 28 2008-07-04 12:27:48Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"-->
<%

dim crn_action, crn_id, crn_name, crn_description, crn_from, crn_order, crn_cover, crn_returnpage

crn_from = normalize(request.QueryString("from"),"tools","set-list")

crn_action = request.QueryString("action")
if crn_action = "" then crn_action = request.form("action")
crn_action = normalize(crn_action,"multi|del|edit|new|update|order","")

crn_id = cleanLong(request.QueryString("id"))
if crn_id = 0 then crn_id = cleanLong(request.form("id"))

crn_name = request.QueryString("name")
if crn_name = "" then crn_name = request.form("name")
crn_name = cleanString(cleanSetName(crn_name),0,50)

crn_description = request.QueryString("description")
if crn_description = "" then crn_description = request.form("description")
crn_description = cleanString(crn_description,0,1000)

crn_order = cleanLong(request.QueryString("order"))
if crn_order = 0 then crn_order = cleanLong(request.form("order"))

crn_cover = cleanLong(request.QueryString("setCover"))
if crn_cover = 0 then crn_cover = cleanLong(request.form("setCover"))

crn_returnpage = cleanLong(request.QueryString("returnpage"))
if crn_returnpage = 0 then crn_returnpage = cleanLong(request.form("returnpage"))

select case crn_action
	case "multi"
	
		dim multiid, multisel, multiaction
		multiaction = normalize(request.Form("multiaction"),"del|order","")
		dim ii : ii = 1
		while (trim(request.Form("multiid"&ii))<>"")
			if cleanBool(request.Form("multisel"&ii)) then
				multiid = cleanLong(request.Form("multiid"&ii))
				if multiid > 1 then 'il set 1 non si tocca
				select case multiaction
					case "del"
						call deleteSet(multiid)
					case "order"
						call orderSet(multiid, crn_order)
				end select
				end if
			end if
			ii=ii+1
		wend
	case "del"
		call deleteSet(crn_id)
	case "order"
		call orderSet(crn_id, crn_order)
	case "new"
		if crn_name <> "" then
			'se il nome del set è valido controlla se non esiste un set con lo stesso nome
			SQL = "SELECT set_id FROM tba_set WHERE set_name = '" & crn_name & "' AND set_id <> " & crn_id
			set rs = dbManager.conn.execute(SQL)
			if not rs.eof then response.Redirect("errors.asp?c=set0")
			'se non esistono altri set con lo stesso nome modifica
			SQL = "INSERT INTO tba_set (set_name, set_description, set_order, set_cover) VALUES ('" & crn_name & "', '" & crn_description & "', " & crn_order & ", " & crn_cover & ")"
			dbManager.conn.execute(SQL)
		end if
	case "edit"
		if crn_name <> "" then
			'se il nome del set è valido controlla se non esiste un set con lo stesso nome
			SQL = "SELECT set_id FROM tba_set WHERE set_name = '" & crn_name & "' AND set_id <> " & crn_id
			set rs = dbManager.conn.execute(SQL)
			if not rs.eof then response.Redirect("errors.asp?c=set0")
			'se non esistono altri set con lo stesso nome modifica
			SQL = "UPDATE tba_set SET set_name = '" & crn_name & "', set_description = '" & crn_description & "', set_order = " & crn_order & ", set_cover = " & crn_cover & " WHERE set_id = " & crn_id
			dbManager.conn.execute(SQL)
		end if
	case "update"
		dim rs2
		set rs2 = Server.CreateObject("ADODB.Recordset")
	
		SQL = "SELECT set_id FROM tba_set"
		set rs = dbManager.conn.execute(SQL)
		while not rs.eof
			SQL = "SELECT Count(photo_id) AS photos FROM tba_photo WHERE photo_set = " & rs("set_id") & " AND photo_active=1"
			set rs2 = dbManager.conn.execute(SQL)
			SQL = "UPDATE tba_set SET set_photos = " & rs2("photos") & " WHERE set_id = " & rs("set_id")
			dbManager.conn.execute(SQL)
			rs.movenext
		wend
		
		set rs2 = nothing
end select

select case crn_from
	case "tools"
	response.Redirect("admin.asp?module=tools&done=sets")
	case "set-list"
	response.Redirect("admin.asp?module=set-list&page="&crn_returnpage)
end select

'**********************************************************************************************************
'MAIN FUNCTIONS
'--------------
sub deleteSet(id)
	if id > 1 then 'non si può eliminare il set 1
		'elimina tutti i riferimenti alle foto
		SQL = "UPDATE tba_photo SET photo_set = 1 WHERE photo_set = " & id
		dbManager.conn.execute(SQL)
		'aggiorna quantità foto
		SQL = "SELECT set_photos FROM tba_set WHERE set_id = " & id
		set rs = dbManager.conn.execute(SQL)
		if not rs.eof then
			SQL = "UPDATE tba_set SET set_photos = set_photos + " & rs("set_photos") & " WHERE set_id = 1"
			dbManager.conn.execute(SQL)
		end if
		'elimina fisicamente il tag
		SQL = "DELETE * FROM tba_set WHERE set_id = " & id
		dbManager.conn.execute(SQL)
	end if
end sub

sub orderSet(id,order)
	SQL = "UPDATE tba_set SET set_order = " & order & " WHERE set_id = " & id
	dbManager.conn.execute(SQL)
end sub
%>