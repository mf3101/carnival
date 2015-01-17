<!--#include file = "includes/inc.first.asp"--><%
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
' * @version         SVN: $Id: inner.nav.directory.asp 117 2010-10-11 19:22:40Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
' nessun enviroment aggiuntivo
'*****************************************************

dim lngSetId, strTagName, bytStream
lngSetId = inputLong(request.QueryString("set"))
strTagName = trim(request.QueryString("tag"))
bytStream = inputLong(request.QueryString("mode")) ' 1 = stream | 2 = tag | 3 = set | 0 = auto

if bytStream = 0 then
if lngSetId > 0 and config__mode__ <> 2 then
	bytStream = 3
	SQL = "SELECT set_id FROM tba_set WHERE set_id = " & lngSetId
	set rs = dbManager.Execute(SQL)
	'se il set non esiste
	if rs.eof then bytStream = 1
elseif strTagName <> "" then
	bytStream = 2
	SQL = "SELECT tag_id FROM tba_tag WHERE tag_name = '" & formatDBString(strTagName,null) & "'"
	set rs = dbManager.Execute(SQL)
	'se il tag non esiste
	if rs.eof then bytStream = 1
else
	bytStream = 1
end if
elseif bytStream > 3 then
	bytStream = 1
end if

%>
<div style="float:left;">
<ul class="tabmenu">
    <li<% if bytStream = 1 then %> class="selected"<% end if %>><a href="javascript:;" onclick="loadNavigator(1,0,'');">Stream</a></li>
    <li<% if bytStream = 2 then %> class="selected"<% end if %>><a href="javascript:;" onclick="loadNavigator(2,0,'');">Tag</a></li>
    <li<% if bytStream = 3 then %> class="selected"<% end if %>><a href="javascript:;" onclick="loadNavigator(3,0,'');">Set</a></li>
</ul>
</div>
<div class="hrtabmenu"></div>
<div style="overflow:auto;height:150px;"><%

select case bytStream
	case 1
		%><span>tutte le foto nello stream</span><%
	case 2
		SQL = "SELECT tag_id, tag_name, tag_type, tag_photos FROM tba_tag WHERE tag_photos > 0 ORDER BY tag_photos DESC, tag_name"
		set rs = dbManager.Execute(SQL)
		while not rs.eof
			response.write IIF(rs("tag_name")=strTagName,"<strong>" & rs("tag_name") & "</strong>",rs("tag_name"))
			response.write " [" & rs("tag_photos") & "]"
			response.write "<br/>"
			rs.movenext
		wend
	
	case 3
		SQL = "SELECT set_id, set_name, set_photos FROM tba_set WHERE set_photos > 0 ORDER BY set_order, set_photos DESC"
		set rs = dbManager.Execute(SQL)
		while not rs.eof
			response.write IIF(rs("set_id")=lngSetId,"<strong>" & rs("set_name") & "</strong>",rs("set_name"))
			response.write " [" & rs("set_photos") & "]"
			response.write "<br/>"
			rs.movenext
		wend
	
end select

%>
</div>
