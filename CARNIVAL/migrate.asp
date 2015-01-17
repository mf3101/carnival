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
' * @version         SVN: $Id: migrate.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

option explicit

'*****************************************************
'ENVIROMENT UPDATE
%><!--#include file = "includes/inc.config.asp"-->
<!--#include file = "includes/class.include.asp"-->
<!--#include file = "includes/class.aspdbbox.asp"-->
<!--#include file = "includes/inc.set.asp"-->
<!--#include file = "includes/inc.md5.asp"-->
<!--#include file = "includes/inc.func.common.asp"-->
<!--#include file = "includes/inc.func.common.io.asp"-->
<!--#include file = "includes/inc.func.common.file.asp"-->
<!--#include file = "includes/inc.admin.checklogin.asp"-->
<!--#include file = "includes/inc.setuptools.asp"--><%
'*****************************************************

'* LOGIN
'* se non è stato effettuato il login
if not isAdminLogged then
	response.write "<div style=""margin:50px 0; text-align:center; font-size:1.2em;"">per effettuare la migrazione del database &egrave;<br/>necessario prima eseguire la <a href=""admin.asp"">login in amministrazione</a></div>"
	response.end
end if

'CARNIVALS MIGRATE.ASP

const CARNIVAL_INSTALLER_VERSION = "1.0.0"

'compatibility
dim SQL, rs
dim strDatabaseType
dim dbManager
dim str_host, str_user, str_password

'FASE DI MIGRAZIONE
dim phase
phase = trim(request.QueryString("p"))
if phase = "" then phase = 0
if not isnumeric(phase) then phase = 0
if phase > 4 then phase = 4
if phase < 0 then phase = 0

dim allright, strconfigfile
allright = false
strConfigFile = "includes/inc.config.asp"

%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--
 *
 *	Carnival DATABASE MIGRATION <%=CARNIVAL_INSTALLER_VERSION%>
 *	http://www.carnivals.it
 *
 -->
<head>
<title>CARNIVAL DATABASE MIGRATION <%=CARNIVAL_INSTALLER_VERSION%></title>
<link href="setup/main.css" type="text/css" rel="stylesheet" />
</head>
<body>
<div id="container">
<h1><img src="setup/top-migrate.jpg" alt="Carnival Migrator" /></h1>
<div id="box">
<%
select case phase
	case 0
	allright = true
	%>
	<div class="phase">Fase 0/4</div>
	<h2>Welcome to  Carnival Migration</h2>
	<p>Questo semplice tool ti guider&agrave; nella migrazione del tuo database da <strong><%=IIF(CARNIVAL_DATABASE_TYPE="mdb","Access MDB","MySQL")%></strong> a <strong><%=IIF(CARNIVAL_DATABASE_TYPE="mysql","Access MDB","MySQL")%></strong> (e viceversa).</p>
    <p>La migraziona consta di due semplici passaggi: nel primo passaggio ti verr&agrave; chiesto di <% if CARNIVAL_DATABASE_TYPE = "mdb" then %>preparare il nuovo database e di <% end if %>riconfigurare carnival; nella seconda fase il tool si occuper&agrave; di copiare i dati dal vecchio database a quello nuovo.</p>
    <p>Prima di cominciare &egrave; fortemente consigliato un backup del tuo <strong>includes/inc.config.asp</strong> e del tuo attuale <strong>database</strong>.</p>
    <p>Quando sei pronto/a per cominciare l'operazione clicca su continua</p>
	<hr/>
	<a href="?p=1" class="button"><span>continua <img src="setup/next.gif" alt="" /></span></a><%
	case 1
	allright = true
	session(CARNIVAL_CODE & "DBTYPE") = CARNIVAL_DATABASE_TYPE
	session(CARNIVAL_CODE & "DB") = CARNIVAL_DATABASE
	session(CARNIVAL_CODE & "DBHOST") = CARNIVAL_DATABASE_HOST
	session(CARNIVAL_CODE & "DBUSER") = CARNIVAL_DATABASE_USER
	session(CARNIVAL_CODE & "DBPASSWORD") = CARNIVAL_DATABASE_PASSWORD
	%>
	<div class="phase">Fase 1/3</div>
	<h2>Nuova configurazione</h2>
	<p>Apri il file <strong>includes/inc.config.asp</strong> e modifica le costanti CARNIVAL_DATABASE_TYPE, CARNIVAL_DATABASE<% if session(CARNIVAL_CODE & "DBTYPE") = "mdb" then %>, CARNIVAL_DATABASE_HOST, CARNIVAL_DATABASE_USER, CARNIVAL_DATABASE_PASSWORD<% end if %> con i valori corretti per il nuovo database.</p>
	<p>Quando hai effettuato le modifiche continua, questo tool si occuper&agrave; di verificare che sia tutto corretto</p>
	<hr/>
	<a href="?p=2" class="button"><span>continua <img src="setup/next.gif" alt="" /></span></a><%
	case 2
	%>
    <div id="workin">
	<div class="phase">Fase 2/4</div><h2>Controllo configurazione</h2>
    <p>
    <% if session(CARNIVAL_CODE & "DBTYPE") = "mdb" then %>
    La migrazione a database <strong>MySql</strong> necessita di tutti i parametri impostati nel file di configurazione (DATABASE, HOST, USER e PASSWORD) secondo le impostazioni del server.<br/>
    Inoltre l'applicazione non &egrave; in grado di creare un nuovo database autonomamente, si rende quindi necessario fornire un database vuoto (se saranno presenti dati nella fase di migrazione verranno sovrascritti).<br />
	Se il database indicato non esiste &egrave; richiesta la creazione da parte dell'utente.
    <% elseif session(CARNIVAL_CODE & "DBTYPE") = "mysql" then %>
    La migrazione a database <strong>MDB</strong> necessita esclusivamente del parametro DATABASE impostato su un file MDB che non dovrebbe esistere (se esiste sar&agrave; sovrascritto).<br />
	E' necessario indicare una cartella con esclusivi permessi di scrittura (spesso &egrave; la cartella "mdb-database" o semplicemente "db")
    <% end if %><p>
	<hr/>
    
    <%
	allright = true
	dim check_title, check_description, check_error
	set dbManager = new Class_ASPdBManager
	
	'**********************************************************************************
	'**********************************************************************************
	'*** NUOVO DATABASE
	if allright then
		
		check_title = "Possibilit&agrave; di migrazione"
		if CARNIVAL_DATABASE_TYPE <> "mdb" and CARNIVAL_DATABASE_TYPE <> "mysql" then
			allright = false
			check_description = "formato non supportato. &egrave; necessario indicare ""mdb"" o ""mysql"""
			check_error = true
		else
			if session(CARNIVAL_CODE & "DBTYPE") = CARNIVAL_DATABASE_TYPE then
				allright = false
				check_description = "la migrazione pu&ograve; essere effettuata su database differenti<br/>hai configurato un database dello stesso tipo dell'originale"
				check_error = true
			else
				check_description = "configurazione base corretta"
				check_error = false
			end if
		end if
		
		'printing
		call printResult(check_title, check_description, check_error, false,"")
	end if
	
	'**********************************************************************************
	'**********************************************************************************
	'*** PRESENZA DATABASE
	if allright and CARNIVAL_DATABASE_TYPE = "mdb" then
		
		check_title = "Nuovo database Access MDB"
		if not hasWritePermission(CARNIVAL_DATABASE) then
			allright = false
			check_description = "la cartella indicata non possiede permessi di scrittura"
			check_error = true
		else
			check_description = "la cartella possiede permessi di scrittura (se il file esiste gi&agrave; verr&agrave; sovrascritto)"
			check_error = false
		end if
		
		'printing
		call printResult(check_title, check_description, check_error, false,"")
	end if
	
	'**********************************************************************************
	'**********************************************************************************
	'*** CONNESSIONE DATABASE
	if allright and CARNIVAL_DATABASE_TYPE = "mysql" then
		
		check_title = "Nuovo database MySql"
		
		dbManager.database = CARNIVAL_DATABASE_TYPE
		if not dbManager.Connect(CARNIVAL_DATABASE,CARNIVAL_DATABASE_USER,CARNIVAL_DATABASE_PASSWORD,"") then
			allright = false
			check_description = "impossibile connettersi al database<br/> * se il database non esiste &egrave; necessario crearlo: ""<strong>" & CARNIVAL_DATABASE & "</strong>""<br/> * l'errore potrebbe essere dovuto a una coppia nome utente/password errata<br/> * potrebbe essere stato indicato un host non corretto"
			check_error = true
		else
			check_description = "connessione effettuata correttamente"
			check_error = false
		end if
		
		'printing
		call printResult(check_title, check_description, check_error, false,"")
	end if
	set dbManager = Nothing
	
	%>
	<hr/>
	<% if allright then 
	%><p class="go">tutti i test sono risultati positivi.</p>
    <p>premendo continua verr&agrave; effettuata la migrazione dei dati con la sovrascrittura dei dati presenti nel nuovo database<% if session(CARNIVAL_CODE & "DBTYPE") = "mdb" then %> (se esistente)<% end if %><br/>
    La procedura potrebbe durare anche parecchi secondi, si prega l'utente di attendere pazientemente senza ricaricare o fermare l'esecuzione della pagina</p>
    <script type="text/javascript">/*<![CDATA[*/
	function workin() {
		document.getElementById('workin').innerHTML = '<div class="workin"><img src="setup/workin.gif" /><br/><span>migrazione database</span><br/><small>(abbi pazienza e non fermare l\'esecuzione della pagina)</small></div>';
		window.location.href = '?p=3';
	}
	/*]]>*/</script>
	<hr/><a href="?p=3" class="button" onClick="workin();return true;"><span>continua <img src="setup/next.gif" alt="" /></span></a>
	<% else
	%><p class="alert">il test non &egrave; andato a buon fine. prova a modificare i file o la configurazione interessata dal problema, quindi premi &quot;test&quot; per vedere se le modifiche hanno sortito effetto.</p>
	<hr/>
	<a href="?p=2" class="button"><span>test <img src="setup/reload.gif" alt="" /></span></a><%
	end if%></div><%
	
	case 3
	%>
    
	<div class="phase">Fase 3/4</div>
    <div class="clear"></div>
	<h2>Migrazione dati</h2>
    <%
		set dbManager = new Class_ASPdBManager
		dbManager.database = CARNIVAL_DATABASE_TYPE
		str_host = "" : if CARNIVAL_DATABASE_TYPE = "mysql" then str_host = CARNIVAL_DATABASE_HOST
		str_user = "" : if CARNIVAL_DATABASE_TYPE = "mysql" then str_user = CARNIVAL_DATABASE_USER
		str_password = "" : if CARNIVAL_DATABASE_TYPE = "mysql" then str_password = CARNIVAL_DATABASE_PASSWORD
		
		call CreateDatabase(CARNIVAL_DATABASE,str_user,str_password,"")
		
		if not dbManager.Connect(CARNIVAL_DATABASE,str_user,str_password,"") then
			%><p>si &egrave; verificato un errore nella connessione. si prega di <a href="?p=2" class="link">controllare la configurazione</a></p><%
		else
		
			if not dbManager.CopyTables(session(CARNIVAL_CODE & "DBTYPE"),session(CARNIVAL_CODE & "DB"),session(CARNIVAL_CODE & "DBUSER"),session(CARNIVAL_CODE & "DBPASSWORD"),"") then
				%>
                
                %><div class="readme"><p><strong>ATTENZIONE:</strong><br/>si &egrave; verificato un errore.<br/>
				la procedura si &egrave; bloccata e ha lasciato il database parzialmente migrato</p>
				<p>si consiglia viviamente di ripristinare il file <strong>includes/inc.config.asp</strong> e ripetere la procedura. (il vecchio database &egrave; rimasto intatto)</p></div>
                <hr/>
                <a href="?p=0" class="button"><span>ricomincia <img src="setup/reload.gif" alt="" /></span></a><%
			else
		
				%>
				<p>Procedura di migrazione dati effettuata con successo.</p>
                <h3>Operazioni eseguite</h3>
                <p>
                <% if CARNIVAL_DATABASE_TYPE = "mdb" then %><img src="setup/dbedit_add.gif" alt="""" /> creato database<br/><% end if%>
                <img src="setup/dbedit_add.gif" alt="""" /> creata struttura<br/>
                <img src="setup/dbedit_edit.gif" alt="""" /> copiato il contenuto
                </p>
                <p>Premi continua per andare all'ultima fase.</p>
				<hr/><a href="?p=4" class="button"><span>continua <img src="setup/next.gif" alt="" /></span></a>
				<%
			end if
		
		end if
	
	case 4
	%>
	<div class="phase">Fase 4/4</div>
    <div class="clear"></div>
	<h2>Migrazione completata</h2>
        <p>La procedura di migrazione &egrave; terminata.<br />
		Vai in amministrazione e verifica che tutto sia funzionante<br />
        Nel caso in cui ci fossero problemi ripristina il <strong>includes/inc.config.asp</strong> e il <strong>database</strong> che hai salvato all'inizio della migrazione e ricomincia la procedura dall'inizio; se il problema persiste puoi scrivere sul <a href="http://forum.imente.org/viewforum.php?f=7" class="link">forum di supporto</a>.</p>
<hr/>
        <a href="admin.asp" class="button"><span>Vai all'admin <img src="setup/next.gif" alt="" /></span></a><%


end select
%>


<div class="clear"></div>
</div>
<div><img src="setup/bottom.jpg" alt="" /></div>
</div>
</body>
</html>
