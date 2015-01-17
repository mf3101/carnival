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
' * @version         SVN: $Id: service.xml.photo.asp 114 2010-10-11 19:00:34Z imente $
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
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "includes/inc.func.photo.asp"-->
<!--#include file = "includes/inc.func.rss.asp"--><%
'*****************************************************

'connette al db
call connect()

'verifica se ci sono foto da Pubblicare
call checkPhotoPub()

'***********************************************************************************

'Prepara l'output

Public output, contentoutput
output = "<?xml version=""1.0"" encoding=""iso-8859-1""?>" & _
		 "<carnivalphotos>"
		 
'***********************************************************************************

'Funzione di printoutput
function printXMLPhoto(lng_PhotoId, str_PhotoTitle, dtm_PhotoPub, bln_IsCurrent)
	dim str_Output
	str_Output = str_Output & "<p" & IIF(bln_IsCurrent," current=""1""","") & ">" & _
						"<i>" & lng_PhotoId & "</i>" & _
						"<t><![CDATA[" & str_PhotoTitle & "]]></t>"
	if lng_PhotoId <> 0 then
		str_Output = str_Output & "<s>" & CARNIVAL_PHOTOPREFIX & lng_PhotoId 
		if not bln_IsCurrent or blnOnlyThumbs then str_Output = str_Output & CARNIVAL_THUMBPOSTFIX
		str_Output = str_Output &  ".jpg</s>"
	else
		str_Output = str_Output & "<s>-</s>"
	end if
	if dtm_PhotoPub <> "" then
		str_Output = str_Output & "<d>" & formatGMTDate(dtm_PhotoPub,0,"yyyy/mm/dd hh:nn:ss") & "</d>"
	else
		str_Output = str_Output & "<d>0</d>"
	end if
	str_Output = str_Output & "</p>"
	
	printXMLPhoto = str_Output
	str_Output = null
	
end function

'***********************************************************************************

'Recupera i parametri
dim lngTagId, lngSetId, lngPhotoId, dtmPhotoPub, lngPhotoOrder, strPhotoTitle, bytRange, strDirection, blnOnlyThumbs
lngTagId = inputLong(request.QueryString("tag"))
lngSetId = inputLong(request.QueryString("set"))
lngPhotoId = inputLong(request.QueryString("id"))
bytRange = inputByte(request.QueryString("range"))
strDirection = normalize(request.QueryString("dir"),"next|prev","center")
blnOnlyThumbs = inputBoolean(request.QueryString("thumbs"))
if bytRange <= 0 or bytRange > 10 then bytRange = 1

dim dtmPhotoPubLast, lngPhotoOrderLast, ii

'***********************************************************************************

'se l'id non è indicato seleziona l'ultima foto
SQL = getLastPhotoSQL(lngPhotoId,lngTagId,lngSetId)
set rs = dbManager.Execute(SQL)
if rs.eof then
	
	'nessuna foto corrente (stampa tutti NULL)	
	if isin(strDirection,"prev|center") then
		for ii=1 to bytRange : contentoutput = contentoutput & printXMLPhoto(0,"-","",false) : next
	end if
	contentoutput = contentoutput &  printXMLPhoto(0,"-","",true)
	if isin(strDirection,"next|center") then
		for ii=1 to bytRange : contentoutput = contentoutput &  printXMLPhoto(0,"-","",false) : next
	end if

else

	lngPhotoId = inputLong(rs("photo_id"))
	strPhotoTitle = rs("photo_title")
	dtmPhotoPub = inputDate(rs("photo_pub"))
	lngPhotoOrder = inputLong(rs("photo_order"))
	
	'***********************************************************************************
	
	call checkPhoto(lngPhotoId)
	
	'necessari per la refreshsession (dichiarazioni presenti in inc.first.asp)
	dim lngLastViewedPhotoId__, dtmLastViewedPhotoPub__, lngLastPhotoId__, dtmLastPhotoPub__
	call refreshSession()
	
	'***********************************************************************************
	
	if isin(strDirection,"prev|center") then
		dtmPhotoPubLast = dtmPhotoPub
		lngPhotoOrderLast = lngPhotoOrder
		'SELEZIONA FOTO PRECEDENTE
		for ii=1 to bytRange
			SQL = getPrevPhotoSQL(lngTagId,lngSetId,dtmPhotoPubLast,lngPhotoOrderLast)
			set rs = dbManager.Execute(SQL)
			if rs.eof then
				'nessuna foto precedente
				contentoutput = printXMLPhoto(0,"-","",false) & contentoutput
			else
				'foto trovata
				dtmPhotoPubLast = inputDate(rs("photo_pub"))
				lngPhotoOrderLast = inputLong(rs("photo_order"))
				contentoutput = printXMLPhoto(rs("photo_id"),rs("photo_title"),rs("photo_pub"),false) & contentoutput
			end if
		next
	end if
	
	'***********************************************************************************
	
	'SELEZIONA FOTO CORRENTE
	
	contentoutput = contentoutput & printXMLPhoto(lngPhotoId,strPhotoTitle,dtmPhotoPub,true)
	
	'***********************************************************************************
	
	'SELEZIONA FOTO SUCCESSIVA
	
	if isin(strDirection,"next|center") then
		dtmPhotoPubLast = dtmPhotoPub
		lngPhotoOrderLast = lngPhotoOrder
		for ii=1 to bytRange
			SQL = getNextPhotoSQL(lngTagId,lngSetId,dtmPhotoPubLast,lngPhotoOrderLast)
			set rs = dbManager.Execute(SQL)
			
			if rs.eof then
				'nessuna foto successiva
				contentoutput = contentoutput & printXMLPhoto(0,"-","",false)
			else
				'foto trovata
				dtmPhotoPubLast = inputDate(rs("photo_pub"))
				lngPhotoOrderLast = inputLong(rs("photo_order"))
				contentoutput = contentoutput & printXMLPhoto(rs("photo_id"),rs("photo_title"),rs("photo_pub"),false)
			end if
		next
	end if
	
end if

'***********************************************************************************

output = output & contentoutput & "</carnivalphotos>"

response.ContentType = "text/xml"
response.write output

'***********************************************************************************

'disconnette dal db
call disconnect()
%>