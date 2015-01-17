<!--#include file = "includes/inc.first.asp"-->
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
' * @version         SVN: $Id: service.ccv.asp 27 2008-07-04 12:22:52Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------
if application(CARNIVAL_CODE & "_admin_c"&"cv") then
	Dim xml, url, res, data, status

	SQL = "SELECT config_title, config_c"&"cv FROM tba_config"
	set rs = dbManager.conn.execute(SQL)
	
	url = server.URLEncode(request.ServerVariables("HTTP_REFERER"))
	if url = "" then url = CARNIVAL_HOME
	data = "version=" & CARNIVAL_VERSION & "&" &_
		   "title=" & server.URLEncode(rs("config_title")) & "&" &_
		   "url=" & url
	
	Set xml = Server.CreateObject("Microsoft.XMLHTTP")
	'Set xml = Server.CreateObject("MSXML2.ServerXMLHTTP")
	
	on error resume next
	
	xml.Open "POST", "ht"&"tp://ww"&"w.carni"&"vals.i"&"t/chec"&"kvers"&"ion.a"&"sp", False
	xml.setRequestHeader "Content-type" , "application/x-www-form-urlencoded"
	xml.setRequestHeader "Connection", "close"
	xml.Send data
	
	if cleanBool(rs("config_c"&"cv")) then
	
		status = xml.status
		
		if err.number = 0 and status = 200 then 
			res = cstr(trim(xml.responseText))
			if len(res) > 10 then res = ""
		end if
		
		on error goto 0
		
		if res <> "" then
		%>
		if (confirm("CARNIVAL\nE' disponibile un aggiornamento per carnival\nL'ultima versione disponibile è la <%=res%>, tu stai utilizzando la versione <%=CARNIVAL_VERSION%>\nVuoi collegarti al sito ufficiale per scaricare l'aggiornamento?")) {
			window.location.href = 'ht'+'tp://ww'+'w.carni'+'vals.i'+'t/dow'+'nloads?c=<%=CARNIVAL_VERSION%>&u=<%=res%>';
		}
		<%
		end if
	
	end if
	
	Set xml = Nothing
	
	
	application(CARNIVAL_CODE & "_admin_c"&"cv") = false
	
end if %>