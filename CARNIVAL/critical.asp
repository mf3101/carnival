<%
dim crn_errorCode,crn_errTitle,crn_errDescription
crn_errorCode = request.QueryString("c")
select case crn_errorCode
	case "01" '01 application block
		crn_errTitle = "APPLICAZIONE IN STATO DI BLOCCO"
		crn_errDescription = "attualmente l'applicazione è in stato di blocco<br/>" & _
							 "terminare il setup o l'aggiornamento"
	case "02" '02 version error
		crn_errTitle = "ERRORE DI CORRISPONDENZA VERSIONI"
		crn_errDescription = "la versione del codice di carnival &egrave; differente da quella del database<br/>" & _
							 "questo può verificarsi a causa di un aggiornamento incompleto o di una modifica manuale"
	case "03" '03 setup me please
		crn_errTitle = "SETUP ME PLEASE"
		crn_errDescription = "l'applicazione prima di essere resa funzionante necessità di un setup<br/>" & _
							 "avvia quindi <a href=""setup.asp"">setup.asp</a> e segui le indicazioni"
	case else '00 connection error
		crn_errTitle = "ERRORE DI CONNESSIONE AL DATABASE"
		crn_errDescription = "attualmente l'applicazione non può connettersi ad alcun database<br/>" & _
							 "terminare il setup o l'aggiornamento, o verificare il file inc.config.asp"
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
<h2><%=crn_errTitle%></h2>
<p><%=crn_errDescription%></p>
<small>(<a href="default.asp">verifica se l'errore &egrave; stato corretto</a>)</small>
</body>
</html>
