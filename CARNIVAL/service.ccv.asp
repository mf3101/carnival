<!--#include file = "includes/inc.first.asp"-->
<%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		service.ccv.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------
if application(CARNIVAL_CODE & "_admin_ccv") then
	Dim xml, url, res, data, status

	SQL = "SELECT config_title, config_ccv FROM tba_config WHERE config_id = 1"
	set rs = conn.execute(SQL)
	
	url = server.URLEncode(request.ServerVariables("HTTP_REFERER"))
	if url = "" then url = CARNIVAL_HOME
	data = "version=" & CARNIVAL_VERSION & "&" &_
		   "title=" & server.URLEncode(rs("config_title")) & "&" &_
		   "url=" & url
	
	Set xml = Server.CreateObject("Microsoft.XMLHTTP")
	'Set xml = Server.CreateObject("MSXML2.ServerXMLHTTP")
	
	on error resume next
	
	xml.Open "POST", "http://www.carni"&"vals.it/chec"&"kvers"&"ion.a"&"sp", False
	xml.setRequestHeader "Content-type" , "application/x-www-form-urlencoded"
	xml.setRequestHeader "Connection", "close"
	xml.Send data
	
	if cleanBool(rs("config_ccv")) then
	
		status = xml.status
		
		if err.number = 0 and status = 200 then 
			res = cstr(trim(xml.responseText))
			if len(res) > 10 then res = ""
		end if
		
		on error goto 0
		
		if res <> "" then
		%>
		if (confirm("CARNIVAL\nE' disponibile un aggiornamento per carnival\nL'ultima versione disponibile è la <%=res%>, tu stai utilizzando la versione <%=CARNIVAL_VERSION%>\nVuoi collegarti al sito ufficiale per scaricare l'aggiornamento?")) {
			window.location.href = 'http://www.carni'+'vals.it/downloads?c=<%=CARNIVAL_VERSION%>&u=<%=res%>';
		}
		<%
		end if
	
	end if
	
	Set xml = Nothing
	
	
	application(CARNIVAL_CODE & "_admin_ccv") = false
	
end if %>