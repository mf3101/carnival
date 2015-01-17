<!--#include file = "inc.first.asp"--><%
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
' * @version         SVN: $Id: mod.admin.proset.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "inc.admin.check.asp"-->
<!--#include file = "inc.func.set.asp"--><%
'*****************************************************

dim strAction, strFrom, strReturnQuerystring
dim lngSetId, strSetName, strSetDescription, lngSetOrder, lngSetCover

strFrom = normalize(request.QueryString("from"),"tools","set-list")

strAction = request.QueryString("action")
if strAction = "" then strAction = request.form("action")
strAction = normalize(strAction,"multi|del|edit|new|update|order","")

lngSetId = inputLong(request.QueryString("id"))
if lngSetId = 0 then lngSetId = inputLong(request.form("id"))

strSetName = request.QueryString("name")
if strSetName = "" then strSetName = request.form("name")
strSetName = inputStringD(cleanSetName(strSetName),0,50)

strSetDescription = request.QueryString("description")
if strSetDescription = "" then strSetDescription = request.form("description")
strSetDescription = inputStringD(strSetDescription,0,1000)

lngSetOrder = inputLong(request.QueryString("order"))
if lngSetOrder = 0 then lngSetOrder = inputLong(request.form("order"))

lngSetCover = inputLong(request.QueryString("setCover"))
if lngSetCover = 0 then lngSetCover = inputLong(request.form("setCover"))

strReturnQuerystring = request.QueryString("returnpage")
if strReturnQuerystring = "" then strReturnQuerystring = request.form("returnpage")

select case strAction
	case "multi"
	
		dim multiid, multisel, multiaction
		multiaction = normalize(request.Form("multiaction"),"del|order","")
		dim ii : ii = 1
		while (trim(request.Form("multiid"&ii))<>"")
			if inputBoolean(request.Form("multisel"&ii)) then
				multiid = inputLong(request.Form("multiid"&ii))
				if multiid > 1 then 'il set 1 non si tocca
				select case multiaction
					case "del"
						call deleteSet(multiid)
					case "order"
						call orderSet(multiid, lngSetOrder)
				end select
				end if
			end if
			ii=ii+1
		wend
	case "del"
		call deleteSet(lngSetId)
	case "order"
		call orderSet(lngSetId, lngSetOrder)
	case "new"
		if strSetName <> "" then
			'se il nome del set è valido controlla se non esiste un set con lo stesso nome
			SQL = "SELECT set_id FROM tba_set WHERE set_name = '" & formatDBString(strSetName,null) & "' AND set_id <> " & lngSetId
			set rs = dbManager.Execute(SQL)
			if not rs.eof then response.Redirect("errors.asp?c=set0")
			'se non esistono altri set con lo stesso nome modifica
			SQL = "INSERT INTO tba_set (set_name, set_description, set_order, set_cover) VALUES ('" & formatDBString(strSetName,null) & "', '" & formatDBString(strSetDescription,null) & "', " & lngSetOrder & ", " & lngSetCover & ")"
			dbManager.Execute(SQL)
		end if
	case "edit"
		if strSetName <> "" then
			'se il nome del set è valido controlla se non esiste un set con lo stesso nome
			SQL = "SELECT set_id FROM tba_set WHERE set_name = '" & formatDBString(strSetName,null) & "' AND set_id <> " & lngSetId
			set rs = dbManager.Execute(SQL)
			if not rs.eof then response.Redirect("errors.asp?c=set0")
			'se non esistono altri set con lo stesso nome modifica
			SQL = "UPDATE tba_set SET set_name = '" & formatDBString(strSetName,null) & "', set_description = '" & formatDBString(strSetDescription,null) & "', set_order = " & lngSetOrder & ", set_cover = " & lngSetCover & " WHERE set_id = " & lngSetId
			dbManager.Execute(SQL)
		end if
	case "update"
		call syncSets()
end select

select case strFrom
	case "tools"
	response.Redirect("admin.asp?module=tools&done=sets")
	case "set-list"
	response.Redirect("admin.asp?module=set-list&"&readyToQuerystring(strReturnQuerystring))
end select
%>