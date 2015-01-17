<%
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
' * @version         SVN: $Id: service.xml.photo.asp 29 2008-07-04 14:03:45Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------
%><!--#include file = "includes/inc.config.asp"-->
<!--#include file = "includes/inc.set.asp"-->
<!--#include file = "includes/inc.dba.asp"-->
<!--#include file = "includes/inc.func.asp"-->
<%

call connect()

public output
output = "<?xml version=""1.0"" encoding=""iso-8859-1""?>" & _
		 "<carnival>"

sub printPhoto(photoid, phototitle, photopub, isthumb)

	output = output & "<photo>" & _
						"<id>" & photoid & "</id>" & _
						"<title><![CDATA[" & phototitle & "]]></title>"
	if photoid <> 0 then
		output = output & "<src>" & CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & photoid 
		if isthumb then output = output & CARNIVAL_THUMBPOSTFIX
		output = output &  ".jpg</src>"
	else
		output = output & "<src>-</src>"
	end if
	if photopub <> "" then
		output = output & "<pub>" & formatGMTDate(photopub,0,"dd/mm/yyyy") & "</pub>"
	else
		output = output & "<pub>-</pub>"
	end if
	output = output & "</photo>"
end sub

dim tagid, setid, id, order
tagid = cleanLong(request.QueryString("tag"))
if trim(tagid) = "" then tagid = 0
setid = cleanLong(request.QueryString("set"))
if trim(setid) = "" then setid = 0

id = request.QueryString("id")
if trim(id) = "" then
	tagid = 0
	setid = 0
end if



'se l'id non è indicato seleziona l'ultima foto
if id = 0 then

	if tagid > 0 then
		SQL = "SELECT TOP 1 tba_photo.photo_id " & _
			  "FROM tba_rel INNER JOIN tba_photo ON tba_rel.rel_photo = tba_photo.photo_id " & _
			  "WHERE tba_rel.rel_tag=" & tagid & " AND tba_photo.photo_active = 1 ORDER BY tba_rel.rel_photo DESC"
	elseif setid > 0 then
		SQL = "SELECT TOP 1 photo_id FROM tba_photo WHERE photo_active = 1 AND photo_set = " & setid & " ORDER BY photo_order, photo_id DESC"
	else
		SQL = "SELECT TOP 1 photo_id FROM tba_photo WHERE photo_active = 1 ORDER BY photo_id DESC"
	end if

else
	SQL = "SELECT photo_id, photo_order FROM tba_photo WHERE photo_id = " & id	
end if

set rs = dbManager.conn.execute(SQL)
id = cleanLong(rs("photo_id"))
order = cleanLong(rs("photo_order"))

call checkPhoto(id)
dim crnLastViewedPhoto, crnLastPhoto
call refreshSession()

'SELEZIONA FOTO PRECEDENTE
if tagid > 0 then
	SQL = "SELECT TOP 1 tba_photo.photo_id, tba_photo.photo_title, tba_photo.photo_pub " & _
		  "FROM tba_rel INNER JOIN tba_photo ON tba_rel.rel_photo = tba_photo.photo_id " & _
		  "WHERE tba_rel.rel_tag=" & tagid & " AND tba_rel.rel_photo < " & id & " AND tba_photo.photo_active = 1 ORDER BY tba_rel.rel_photo DESC"
elseif setid > 0 then
	SQL = "SELECT TOP 1 photo_id, photo_title, photo_pub FROM tba_photo WHERE ((photo_id < " & id & " AND photo_order = " & order & ") OR (photo_order > " & order & ")) AND (photo_active = 1) AND (photo_set = " & setid & ") ORDER BY photo_order ASC, photo_id DESC"
else
	SQL = "SELECT TOP 1 photo_id, photo_title, photo_pub FROM tba_photo WHERE photo_id < " & id & " AND photo_active = 1 ORDER BY photo_id DESC"
end if
set rs = dbManager.conn.execute(SQL)
if rs.eof then
	'nessuna foto precedente
	call printPhoto(0,"-","",0)
else
	'foto trovata
	call printPhoto(rs("photo_id"),rs("photo_title"),rs("photo_pub"),1)
end if

'SELEZIONA FOTO CORRENTE
SQL = "SELECT photo_id, photo_title, photo_pub FROM tba_photo WHERE photo_active = 1 AND photo_id = " & id
set rs = dbManager.conn.execute(SQL)
if rs.eof then
	call printPhoto(0,"-","",0)
else
	call printPhoto(rs("photo_id"),rs("photo_title"),rs("photo_pub"),0)
end if

'SELEZIONA FOTO SUCCESSIVA
if tagid > 0 then
	SQL = "SELECT TOP 1 tba_photo.photo_id, tba_photo.photo_title, tba_photo.photo_pub " & _
		  "FROM tba_rel INNER JOIN tba_photo ON tba_rel.rel_photo = tba_photo.photo_id " & _
		  "WHERE tba_rel.rel_tag=" & tagid & " AND tba_rel.rel_photo > " & id & " AND tba_photo.photo_active = 1 ORDER BY tba_rel.rel_photo ASC"
elseif setid > 0 then
	SQL = "SELECT TOP 1 photo_id, photo_title, photo_pub FROM tba_photo WHERE ((photo_id > " & id & " AND photo_order = " & order & ") OR (photo_order < " & order & ")) AND (photo_active = 1) AND (photo_set = " & setid & ") ORDER BY photo_order DESC, photo_id ASC"
else
	SQL = "SELECT TOP 1 photo_id, photo_title, photo_pub FROM tba_photo WHERE photo_id > " & id & " AND photo_active = 1 ORDER BY photo_id ASC"
end if
set rs = dbManager.conn.execute(SQL)
if rs.eof then
	'nessuna foto successiva
	call printPhoto(0,"-","",0)
else
	'foto trovata
	call printPhoto(rs("photo_id"),rs("photo_title"),rs("photo_pub"),1)
end if

		 
output = output & "</carnival>"

response.ContentType = "text/xml"
response.write output

call disconnect()

%>