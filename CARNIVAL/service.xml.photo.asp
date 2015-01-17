<%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		service.xml.photo.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------
%><!--#include file = "includes/inc.config.asp"-->
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

dim tagid, id
tagid = request.QueryString("tag")
if trim(tagid) = "" then tagid = 0
id = request.QueryString("id")
if trim(id) = "" then tagid = 0



'se l'id non è indicato seleziona l'ultima foto
if id = 0 then

	if tagid = 0 then
		SQL = "SELECT TOP 1 photo_id FROM tba_photo WHERE photo_active = 1 ORDER BY photo_id DESC"
	else
		SQL = "SELECT TOP 1 tba_photo.photo_id " & _
			  "FROM tba_rel INNER JOIN tba_photo ON tba_rel.rel_photo = tba_photo.photo_id " & _
			  "WHERE tba_rel.rel_tag=" & tagid & " AND tba_photo.photo_active = 1 ORDER BY tba_rel.rel_photo DESC"
	end if
	set rs = conn.execute(SQL)
	id = rs("photo_id")
	
end if

call checkPhoto(id)
dim crnLastViewedPhoto, crnLastPhoto
call refreshSession()

'SELEZIONA FOTO PRECEDENTE
if tagid = 0 then
	SQL = "SELECT TOP 1 photo_id, photo_title, photo_pub FROM tba_photo WHERE photo_id < " & id & " AND photo_active = 1 ORDER BY photo_id DESC"
else
	SQL = "SELECT TOP 1 tba_photo.photo_id, tba_photo.photo_title, tba_photo.photo_pub " & _
		  "FROM tba_rel INNER JOIN tba_photo ON tba_rel.rel_photo = tba_photo.photo_id " & _
		  "WHERE tba_rel.rel_tag=" & tagid & " AND tba_rel.rel_photo < " & id & " AND tba_photo.photo_active = 1 ORDER BY tba_rel.rel_photo DESC"
end if
set rs = conn.execute(SQL)
if rs.eof then
	'nessuna foto precedente
	call printPhoto(0,"-","",0)
else
	'foto trovata
	call printPhoto(rs("photo_id"),rs("photo_title"),rs("photo_pub"),1)
end if

'SELEZIONA FOTO CORRENTE
SQL = "SELECT photo_id, photo_title, photo_pub FROM tba_photo WHERE photo_active = 1 AND photo_id = " & id
set rs = conn.execute(SQL)
if rs.eof then
	call printPhoto(0,"-","",0)
else
	call printPhoto(rs("photo_id"),rs("photo_title"),rs("photo_pub"),0)
end if

'SELEZIONA FOTO SUCCESSIVA
if tagid = 0 then
	SQL = "SELECT TOP 1 photo_id, photo_title, photo_pub FROM tba_photo WHERE photo_id > " & id & " AND photo_active = 1 ORDER BY photo_id ASC"
else
	SQL = "SELECT TOP 1 tba_photo.photo_id, tba_photo.photo_title, tba_photo.photo_pub " & _
		  "FROM tba_rel INNER JOIN tba_photo ON tba_rel.rel_photo = tba_photo.photo_id " & _
		  "WHERE tba_rel.rel_tag=" & tagid & " AND tba_rel.rel_photo > " & id & " AND tba_photo.photo_active = 1 ORDER BY tba_rel.rel_photo ASC"
end if
set rs = conn.execute(SQL)
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