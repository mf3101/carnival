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
' * @version         SVN: $Id: mod.admin.protag.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "inc.admin.check.asp"-->
<!--#include file = "inc.func.tag.asp"--><%
'*****************************************************

dim strAction, strFrom, strReturnQuerystring
dim lngTagId, strTagName, bytTagType

strFrom = normalize(request.QueryString("from"),"tools","tag-list")

strAction = request.QueryString("action")
if strAction = "" then strAction = request.form("action")
strAction = normalize(strAction,"multi|del|edit|update|typenormal|typecommon","")

lngTagId = inputLong(request.QueryString("id"))
if lngTagId = 0 then lngTagId = inputLong(request.form("id"))

bytTagType = request.QueryString("type")
if bytTagType = "" then bytTagType = request.form("type")
bytTagType = inputByte(bytTagType)

strTagName = request.QueryString("name")
if strTagName = "" then strTagName = request.form("name")
strTagName = inputStringD(cleanTagName(strTagName),0,50)

strReturnQuerystring = request.QueryString("returnpage")
if strReturnQuerystring = "" then strReturnQuerystring = request.form("returnpage")

select case strAction
	case "multi"
	
		dim multiid, multisel, multiaction
		multiaction = normalize(request.Form("multiaction"),"del","")
		dim ii : ii = 1
		while (trim(request.Form("multiid"&ii))<>"")
			if inputBoolean(request.Form("multisel"&ii)) then
				multiid = inputLong(request.Form("multiid"&ii))
				select case multiaction
					case "del"
					call deleteTag(multiid)
				end select
			end if
			ii=ii+1
		wend
	case "del"
		call deleteTag(lngTagId)
	case "typenormal", "typecommon"
		bytTagType = 0
		if strAction = "typecommon" then bytTagType = 1
		SQL = "UPDATE tba_tag SET tag_type = " & bytTagType & " WHERE tag_id = " & lngTagId
		dbManager.Execute(SQL)
	case "edit"
		if strTagName <> "" then
			'se il nome del tag è valido controlla se non esiste un tag con lo stesso nome
			SQL = "SELECT tag_id FROM tba_tag WHERE tag_name = '" & formatDBString(strTagName,null) & "' AND tag_id <> " & lngTagId
			set rs = dbManager.Execute(SQL)
			if not rs.eof then response.Redirect("errors.asp?c=tag0")
			'se non esistono altri tag con lo stesso nome modifica
			SQL = "UPDATE tba_tag SET tag_name = '" & formatDBString(strTagName,null) & "', tag_type = " & bytTagType & " WHERE tag_id = " & lngTagId
			dbManager.Execute(SQL)
		end if
	case "update"
		call syncTags()
end select

select case strFrom
	case "tools"
	response.Redirect("admin.asp?module=tools&done=tags")
	case "tag-list"
	response.Redirect("admin.asp?module=tag-list&"&readyToQuerystring(strReturnQuerystring))
end select
%>