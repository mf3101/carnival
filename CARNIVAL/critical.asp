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
' * @version         SVN: $Id: critical.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
' nessun enviroment aggiuntivo
'*****************************************************

dim strErrorCode,strErrorTitle,strErrorDescription
strErrorCode = request.QueryString("c")
select case strErrorCode
	case "00" '00 connection error
		strErrorTitle = "ERRORE DI CONNESSIONE AL DATABASE"
		strErrorDescription = "attualmente l'applicazione non può connettersi ad alcun database<br/>" & _
							 "terminare il setup, l'aggiornamento o la migrazione, o verificare il file inc.config.asp"
	case "01" '01 application block
		strErrorTitle = "APPLICAZIONE IN STATO DI BLOCCO"
		strErrorDescription = "attualmente l'applicazione &egrave; in stato di blocco<br/>" & _
							 "terminare il setup o l'aggiornamento"
	case "02" '02 version error
		strErrorTitle = "ERRORE DI CORRISPONDENZA VERSIONI"
		strErrorDescription = "la versione del codice di carnival &egrave; differente da quella del database<br/>" & _
							 "questo pu&ograve; verificarsi a causa di un aggiornamento incompleto o di una modifica manuale"
	case "03" '03 setup me please
		strErrorTitle = "SETUP ME PLEASE"
		strErrorDescription = "l'applicazione prima di essere resa funzionante necessità di un setup<br/>" & _
							 "avvia quindi <a href=""setup.asp"">setup.asp</a> e segui le indicazioni"
	case else
		response.end
end select
%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>carnival - error</title>
<style type="text/css">/*<![CDATA[*/
body { font-color:#000; font-family:arial,serif; font-size:1.2em; padding:50px 0; margin:0; text-align:center; }
h1 { color:#990000; }
/*]]>*/</style>
</head>
<body>
<h1>Carnival</h1>
<h2><%=strErrorTitle%></h2>
<p><%=strErrorDescription%></p>
<small>(<a href="default.asp">verifica se l'errore &egrave; stato corretto</a>)</small>
</body>
</html>
