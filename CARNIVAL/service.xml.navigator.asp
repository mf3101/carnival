<%
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
' * @version         SVN: $Id: service.xml.navigator.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

Option Explicit
'*****************************************************
'ENVIROMENT BASE (senza inc.config.lang.asp)
%><!--#include file = "includes/inc.config.asp"-->
<!--#include file = "includes/inc.set.asp"-->
<!--#include file = "includes/inc.dba.asp"-->
<!--#include file = "includes/inc.func.common.asp"-->
<!--#include file = "includes/inc.func.common.io.asp"-->
<!--#include file = "includes/inc.func.common.math.asp"-->
<!--#include file = "includes/inc.func.common.file.asp"-->
<!--#include file = "includes/inc.func.common.special.asp"--><%
'*****************************************************

'connette al db
call connect()

'***********************************************************************************
'* inc.first.asp wrapper
dim config__mode__
SQL = "SELECT config_mode FROM tba_config"
set rs = dbManager.execute(SQL)
config__mode__ = rs("config_mode")
'***********************************************************************************

dim lngSetId, lngTagId, bytMode
lngSetId = inputLong(request.QueryString("set"))
lngTagId = inputLong(request.QueryString("tag"))
bytMode = inputLong(request.QueryString("mode")) ' 1 = stream | 2 = tag | 3 = set | 0 = auto

if bytMode = 0 then
	if lngSetId > 0 and config__mode__ <> 2 then
		bytMode = 3
		SQL = "SELECT set_id FROM tba_set WHERE set_id = " & lngSetId
		set rs = dbManager.Execute(SQL)
		'se il set non esiste
		if rs.eof then bytMode = 1
	elseif lngTagId > 0 then
		bytMode = 2
		SQL = "SELECT tag_id FROM tba_tag WHERE tag_id = " & lngTagId
		set rs = dbManager.Execute(SQL)
		'se il tag non esiste
		if rs.eof then bytMode = 1
	else
		bytMode = 1
	end if
elseif bytMode > 3 then
	bytMode = 1
end if

'***********************************************************************************

'Prepara l'output

Public output
output = "<?xml version=""1.0"" encoding=""iso-8859-1""?>" & _
		 "<carnivalnavigator>"
		 
'***********************************************************************************


select case bytMode
	case 1, 2
		SQL = "SELECT Count(photo_id) AS photos FROM tba_photo WHERE photo_active = 1"
		set rs = dbManager.Execute(SQL)
		output = output & "<f" & IIF(bytMode = 1," current=""1""","") & ">" & _
						  "<i>0</i>" & _
						  "<n><![CDATA[" & "Tutte le foto" & "]]></n>" & _
						  "<d>" & rs("photos") & "</d>" & _
						  "</f>"
		SQL = "SELECT tag_id, tag_name, tag_type, tag_photos FROM tba_tag WHERE tag_photos > 0 ORDER BY tag_photos DESC, tag_name"
		set rs = dbManager.Execute(SQL)
		while not rs.eof
			output = output & "<t" & IIF(inputLong(rs("tag_id"))=lngTagId," current=""1""","") & ">" & _
					          "<i>" & rs("tag_id") & "</i>" & _
					          "<n><![CDATA[" & rs("tag_name") & "]]></n>" & _
					          "<d>" & rs("tag_photos") & "</d>" & _
							  "</t>"
			rs.movenext
		wend
	
	case 3
		SQL = "SELECT set_id, set_name, set_photos FROM tba_set WHERE set_photos > 0 ORDER BY set_order, set_photos DESC"
		set rs = dbManager.Execute(SQL)
		while not rs.eof
			output = output & "<s" & IIF(inputLong(rs("set_id"))=lngSetId," current=""1""","") & ">" & _
					          "<i>" & rs("set_id") & "</i>" & _
					          "<n><![CDATA[" & rs("set_name") & "]]></n>" & _
					          "<d>" & rs("set_photos") & "</d>" & _
							  "</s>"
			rs.movenext
		wend
	
end select


'***********************************************************************************

output = output & "</carnivalnavigator>"

response.ContentType = "text/xml"
response.write output

'***********************************************************************************

'disconnette dal db
call disconnect()
%>