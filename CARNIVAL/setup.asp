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
' * @version         SVN: $Id: setup.asp 115 2010-10-11 19:15:16Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

option explicit

'*****************************************************
'ENVIROMENT SETUP
%><!--#include file = "includes/class.include.asp"-->
<!--#include file = "includes/inc.set.asp"-->
<!--#include file = "includes/inc.md5.asp"-->
<!--#include file = "includes/inc.func.common.asp"-->
<!--#include file = "includes/inc.func.common.io.asp"-->
<!--#include file = "includes/inc.func.common.file.asp"-->
<!--#include file = "includes/class.aspdbbox.asp"-->
<!--#include file = "includes/inc.setuptools.asp"-->
<%
'*****************************************************

'CARNIVALS SETUP.ASP

const CARNIVAL_INSTALLER_VERSION = "1.0.0"

'FASE D'INSTALLAZIONE
dim phase
phase = trim(request.QueryString("p"))
if phase = "" then phase = 0
if not isnumeric(phase) then phase = 0
if phase > 4 then phase = 4
if phase < 0 then phase = 0

dim allright
allright = false

dim dbManager, SQL
dim str_host, str_user, str_password

%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--
 *
 *	Carnival SETUP <%=CARNIVAL_INSTALLER_VERSION%>
 *	http://www.carnivals.it
 *
 -->
<head>
<title>CARNIVAL SETUP <%=CARNIVAL_INSTALLER_VERSION%></title>
<link href="setup/main.css" type="text/css" rel="stylesheet" />
</head>
<body>
<div id="container">
<h1><img src="setup/top-setup.jpg" alt="Carnival Installer" /></h1>
<div id="box">
<%
select case phase
	case 0
	allright = true
	%>
	<div class="phase">Fase 0/4</div>
	<h2>Welcome to  Carnival</h2>
	<p>Innanzitutto grazie per aver scaricato Carnival, &egrave; un piacere offrirti questa applicazione.<br />
	Questa breve procedura di setup ti guider&agrave; nella semplice installazione di Carnival sul tuo spazio web.</p>
	<p>Se hai aperto questa pagina significa che hai gi&agrave; copiato tutti i file di Carnival sul tuo spazio, ora &egrave; quindi venuto il momento di configurare l'applicazione affinch&eacute; funzioni e lo faccia al meglio.</p>
	<p>Prendi il file <strong>includes/inc.config.dist.asp</strong> e fanne una copia nominandola <strong>inc.config.asp</strong></p>
    <p>Ora apri <strong>inc.config.asp</strong> e, leggendo attentamente ci&ograve; che vi &egrave; scritto, modifica le costanti di Carnival al fine di adattarle alla tua situazione.</p>
	<p>Quando hai terminato salva il file e clicca su &quot;continua&quot;, questa procedura guidata controller&agrave; la validit&agrave; dei valori che hai inserito.</p>
	<hr/>
	<a href="?p=1" class="button"><span>continua <img src="setup/next.gif" alt="" /></span></a><%
	case 1
	allright = true
	
	%>
	<div class="phase">Fase 1/4</div><h2>Controllo configurazione</h2>
	<hr/>
	<%
	
	dim check_title, check_description, check_error
	set dbManager = new Class_ASPdBManager
	
	'**********************************************************************************
	'**********************************************************************************
	'*** ESISTENZA FILE INC.CONFIG.ASP
	if allright then
	
		dim strConfigFile
		strConfigFile = "includes/inc.config.asp"
		
		check_title = "Presenza file di configurazione ( " & strConfigFile & " )"
		if not fileExists(strConfigFile) then
			allright = false
			check_description = "il file di configurazione non esiste"
			check_error = true
		else
			check_description = "il file di configurazione &egrave; presente"
			check_error = false
		end if
		
		'printing
		call printResult(check_title, check_description, check_error, false, "")
		
	end if
	'**********************************************************************************
	'**********************************************************************************
	
	
		
	'**********************************************************************************
	'**********************************************************************************
	'*** CONTROLLO VALIDITA' INC.CONFIG.ASP
	if allright then
		on error resume next
		
		call execute(IncludeFile(strConfigFile))	
			
		check_title = "Controllo file di configurazione ( " & strConfigFile & " )"
		if err.number<>0 then
			allright = false
			check_description = "il file non &egrave; valido poich&eacute; presenta un errore"
			check_error = true
		else
			check_description = "il file risulta essere valido"
			check_error = false
		end if
		
		'printing
		call printResult(check_title, check_description, check_error, true, strConfigFile)
		
		on error goto 0
	end if
	'**********************************************************************************
	'**********************************************************************************
	
	'**********************************************************************************
	'**********************************************************************************
	'*** PRESENZA DATABASE MDB
	if allright and CARNIVAL_DATABASE_TYPE = "mdb" then
		
		check_title = "Presenza database ( " & CARNIVAL_DATABASE & " )"
		
		
		if not hasWritePermission(CARNIVAL_DATABASE) then
			allright = false
			check_description = "la cartella non possiede permessi di scrittura"
			check_error = true
		else
			dbManager.database = CARNIVAL_DATABASE_TYPE
			if not fileExists(CARNIVAL_DATABASE) then
			    check_description = "il database non esiste (verr&agrave; creato) e la cartella possiede permessi di scrittura"
			    check_error = false
            else
			    check_description = "il database esiste (verr&agrave; svuotato) e la cartella possiede permessi di scrittura"
			    check_error = false
			end if
		end if
		
		'printing
		call printResult(check_title, check_description, check_error, false,"")
	end if
	'**********************************************************************************
	'**********************************************************************************
	'*** PRESENZA DATABASE MYSQL
	if allright and CARNIVAL_DATABASE_TYPE = "mysql" then
		
		check_title = "Presenza database ( " & CARNIVAL_DATABASE & " )"
		
		dbManager.database = CARNIVAL_DATABASE_TYPE
		if not dbManager.Connect(CARNIVAL_DATABASE,CARNIVAL_DATABASE_USER,CARNIVAL_DATABASE_PASSWORD,"") then
			allright = false
			check_description = "impossibile connettersi al database (se il database non esiste &egrave; necessario crearlo: ""<strong>" & CARNIVAL_DATABASE & "</strong>"")"
			check_error = true
		else
			check_description = "connessione database mysql effettuata correttamente"
			check_error = false
		end if
		
		'printing
		call printResult(check_title, check_description, check_error, false,"")
	end if
	'**********************************************************************************
	'**********************************************************************************
	
	'**********************************************************************************
	'**********************************************************************************
	'*** ESISTENZA CARTELLA PRINCIPALE
	if allright then
		
		check_title = "Cartella principale ( " & CARNIVAL_MAIN & " )"
		if left(CARNIVAL_MAIN,1) <> "/" then
			allright = false
			check_description = "indica il percorso assoluto cominciando con ""/"""
			check_error = true
		else
			if not folderExists(CARNIVAL_MAIN) then
				allright = false
				check_description = "hai indicato male la cartella (devi indicare quella dove è contenuto QUESTO file)"
				check_error = true
			else
				if not fileExists(CARNIVAL_MAIN & "LICENCE.TXT") then
					allright = false
					check_description = "hai indicato la cartella corretta? ho cercato il file ""LICENCE.TXT"" ma non l'ho trovato<br/>è il file della licenza ed &egrave; sempre presente nella cartella principale (se l'hai cancellato per favore ripristinalo). "
					check_error = true
				else
					check_description = "la cartella &egrave; stata indicata correttamente"
					check_error = false
				end if
			end if
		end if
		
		'printing
		call printResult(check_title, check_description, check_error, false,"")
		
	end if
	'**********************************************************************************
	'**********************************************************************************
	
	'**********************************************************************************
	'**********************************************************************************
	'*** ESISTENZA E SCRITTURA CARTELLA DELLE FOTO
	if allright then
		
		check_title = "Cartella delle foto ( " & CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & " )"
		if not folderExists(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS) then
			allright = false
			check_description = "la cartella non esiste"
			check_error = true
		else
			if not hasWritePermission(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS) then
				allright = false
				check_description = "la cartella esiste ma non possiede permessi di scrittura"
				check_error = true
			else
				check_description = "la cartella esiste e possiede permessi di scrittura"
				check_error = false
			end if
		end if
		
		'printing
		call printResult(check_title, check_description, check_error, false,"")
		
	end if
	'**********************************************************************************
	'**********************************************************************************
	
	'**********************************************************************************
	'**********************************************************************************
	'*** ESISTENZA E SCRITTURA CARTELLA DEGLI STILI
	if allright then
		
		check_title = "Cartella degli stili ( " & CARNIVAL_PUBLIC & CARNIVAL_STYLES & " )"
		if not folderExists(CARNIVAL_PUBLIC & CARNIVAL_STYLES) then
			allright = false
			check_description = "la cartella non esiste"
			check_error = true
		else
			if not hasWritePermission(CARNIVAL_PUBLIC & CARNIVAL_STYLES) then
				allright = false
				check_description = "la cartella esiste ma non possiede permessi di scrittura"
				check_error = true
			else
				check_description = "la cartella esiste e possiede permessi di scrittura"
				check_error = false
			end if
		end if
		
		'printing
		call printResult(check_title, check_description, check_error, false,"")
		
	end if
	'**********************************************************************************
	'**********************************************************************************
	
	'**********************************************************************************
	'**********************************************************************************
	'*** ESISTENZA E SCRITTURA CARTELLA DI SUPPORTO
	if allright then
		
		check_title = "Cartella di supporto ( " & CARNIVAL_PUBLIC & CARNIVAL_SERVICES & " )"
		if not folderExists(CARNIVAL_PUBLIC & CARNIVAL_SERVICES) then
			allright = false
			check_description = "la cartella non esiste"
			check_error = true
		else
			if not hasWritePermission(CARNIVAL_PUBLIC & CARNIVAL_SERVICES) then
				allright = false
				check_description = "la cartella esiste ma non possiede permessi di scrittura"
				check_error = true
			else
				check_description = "la cartella esiste e possiede permessi di scrittura"
				check_error = false
			end if
		end if
		
		'printing
		call printResult(check_title, check_description, check_error, false,"")
		
	end if
	'**********************************************************************************
	'**********************************************************************************
	
	'**********************************************************************************
	'**********************************************************************************
	'*** ESISTENZA E SCRITTURA CARTELLA DEI FEED
	if allright then
		
		check_title = "Cartella dei feed ( " & CARNIVAL_PUBLIC & CARNIVAL_FEED & " )"
		if not folderExists(CARNIVAL_PUBLIC & CARNIVAL_FEED) then
			allright = false
			check_description = "la cartella non esiste"
			check_error = true
		else
			if not hasWritePermission(CARNIVAL_PUBLIC & CARNIVAL_FEED) then
				allright = false
				check_description = "la cartella esiste ma non possiede permessi di scrittura"
				check_error = true
			else
				check_description = "la cartella esiste e possiede permessi di scrittura"
				check_error = false
			end if
		end if
		
		'printing
		call printResult(check_title, check_description, check_error, false,"")
		
	end if
	'**********************************************************************************
	'**********************************************************************************
	
	'**********************************************************************************
	'**********************************************************************************
	'*** ESISTENZA CARTELLA DEI LOGHI
	if allright then
		
		check_title = "Presenza cartella dei loghi ( " & CARNIVAL_LOGOS & " )"
		if not folderExists(CARNIVAL_LOGOS) then
			allright = false
			check_description = "la cartella non esiste<br/>crea la cartella nel percorso indicato oppure modifica il file di configurazione affinch&eacute; punti a una cartella esistente"
			check_error = true
		else
			check_description = "la cartella esiste"
			check_error = false
		end if
		
		'printing
		call printResult(check_title, check_description, check_error, false,"")
		
	end if
	'**********************************************************************************
	'**********************************************************************************
	
	'**********************************************************************************
	'**********************************************************************************
	'*** HOME CHECK
	if allright then
	
		dim basehome
		if trim(request.ServerVariables("HTTP_REFERER")) <> "" then
			basehome = left(request.ServerVariables("HTTP_REFERER"),instr(request.ServerVariables("HTTP_REFERER"),"setup.asp")-1) 
		end if
		
		check_title = "Controllo conformit&agrave; indirizzo base ( " & CARNIVAL_HOME & " )"
		if trim(request.ServerVariables("HTTP_REFERER")) = "" then
			allright = false
			check_description = "per eseguire il test &egrave; necessario attivare i REFERER del tuo browser e premere &quot;test&quot;"
			check_error = true
		else
			if CARNIVAL_HOME <> basehome then
				allright = false
				if (instr(request.ServerVariables("HTTP_REFERER"),"setup.asp")>0) then
				check_description = "l'indirizzo base indicato non corrisponde ( è necessario indicare """
				
				
				check_description = check_description & basehome
				 
				check_description = check_description & """ )"
				else
				check_description = "l'indirizzo base indicato non corrisponde"
				end if
				check_error = true
			else
				check_description = "l'indirizzo base &egrave; considerato valido"
				check_error = false
			end if
		end if
		
		'printing
		call printResult(check_title, check_description, check_error, false,"")
		
	end if
	'**********************************************************************************
	'**********************************************************************************
	
	%>
	<hr/>
	<% if allright then 
	%><p class="go">tutti i test sono risultati positivi. premi "continua" per avanzare nel setup.</p>
	<hr/><a href="?p=2" class="button"><span>continua <img src="setup/next.gif" alt="" /></span></a>
	<% else
	%><p class="alert">il test non &egrave; andato a buon fine. prova a modificare i file o le cartelle interessate dal problema per risolverlo, quindi premi &quot;test&quot; per vedere se le modifiche hanno sortito effetto.<br />
<small>(se l'errore indica che un file o una cartella non esiste ma in realtà tale cartella è presente e indicata correttamente nel file di configurazione controlla che possieda permessi di lettura)</small></p>
	<hr/>
	<a href="?p=1" class="button"><span>test <img src="setup/reload.gif" alt="" /></span></a><%
	end if %>
	<a href="?p=0" class="button"><span><img src="setup/back.gif" alt="" /> indietro</span></a><%
	case 2
	%>
    <div id="workin">
	<div class="phase">Fase 2/4</div>
	<h2>Impostazioni base</h2>
	<hr/></div>
	<form action="setup.asp?p=3" method="post" id="setform">
	<p>Ora che la configurazione sembra essere corretta verranno eseguite alcune operazioni necessarie al corretto funzionamento dell'applicazione. Inserisci la password che vuoi utilizzare per accedere all'amministrazione e premi &quot;continua&quot;; il setup si occuper&agrave; di tutto il resto </p>
	<hr/>
	<div>
	<label for="title">titolo</label>
	<p class="desc">indica il titolo del tuo photoblog </p>
	<input type="text" name="title" id="title" value="my photoblog" />
	</div>
	<div>
	<label for="password">password</label>
	<p class="desc">indica la password di amministrazione </p>
	<input type="text" name="password" id="password" value="" />
	</div>
	<hr/>
	<button type="submit" onClick="workin();return false;"><span>continua <img src="setup/next.gif" alt="" /></span></button>
	<a href="?p=1" class="button"><span><img src="setup/back.gif" alt="" /> indietro</span></a>
	</form>
    <script type="text/javascript">/*<![CDATA[*/
	function workin() {
		document.getElementById('setform').submit();
		document.getElementById('setform').style.display = 'none';
		document.getElementById('workin').innerHTML = '<div class="workin"><img src="setup/workin.gif" /><br/><span>inizializzazione database</span><br/><small>(abbi pazienza e non fermare l\'esecuzione della pagina)</small></div>';
	}
	/*]]>*/</script><%
	case 3
	if trim(request.form("password")) = "" or trim(request.Form("title")) = "" then response.Redirect("setup.asp?p=2")
	%>
	<div class="phase">Fase 3/4</div>
	<h2>Inizializzazione database </h2>
	<hr/>
	<%
	
	call execute(IncludeFile("includes/inc.config.asp"))
	call execute(IncludeFile("includes/inc.func.style.asp"))
	call execute(IncludeFile("includes/inc.func.services.asp"))
	
	set dbManager = new Class_ASPdBManager
	dbManager.database = CARNIVAL_DATABASE_TYPE
	str_host = "" : if CARNIVAL_DATABASE_TYPE = "mysql" then str_host = CARNIVAL_DATABASE_HOST
	str_user = "" : if CARNIVAL_DATABASE_TYPE = "mysql" then str_user = CARNIVAL_DATABASE_USER
	str_password = "" : if CARNIVAL_DATABASE_TYPE = "mysql" then str_password = CARNIVAL_DATABASE_PASSWORD
	
	if not CreateDatabase(CARNIVAL_DATABASE,str_user,str_password,"") then
		%><div class="readme"><p><strong>ATTENZIONE:</strong><br />
impossibile inizializzare il database.<br/>verificare che il file non sia aperto o protetto in scrittura.</p></div>
		<hr/>
		<a href="?p=3" class="button"><span>riprova <img src="setup/reload.gif" alt="" /></span></a><%
	else
	
        'copia file wbresize.aspx
        call copyFile(server.MapPath("setup/wbresize.aspx.install"),server.MapPath(CARNIVAL_PUBLIC&CARNIVAL_SERVICES&"wbresize.aspx"))
		dim aspnetactive
		aspnetactive = aspnetOn() 'tenta di attivare e compilare wbresize
		
		call setStyle("light",true,true)
		
		SQL = "UPDATE tba_config SET config_applicationblock = 0, config_title = '" & left(replace(request.form("title"),"'","''"),50) & "',config_password = '" & md5(request.form("password")) & "', config_start = " & formatDBDate(cdate("12/03/1985"),CARNIVAL_DATABASE_TYPE) & ""
		dbManager.Execute(SQL)
		%>
		<p class="ok"><img src="setup/tick.gif" alt="" /> Creata struttura base database </p>
		<p class="ok"><img src="setup/tick.gif" alt="" /> Salvata password per accesso all'amministrazione </p>
		<p class="ok"><img src="setup/tick.gif" alt="" /> Impostato titolo del photoblog </p>
		<p class="ok"><img src="setup/tick.gif" alt="" /> Impostata data di inizio pubblicazione </p>
		<p class="ok"><img src="setup/tick.gif" alt="" /> Compilato stile predefinito &quot;light&quot; </p>
		<%
		if not aspnetactive then
		%><p class="alert"><img src="setup/cross.gif" alt="" /> Asp.NET non supportato (ridimensionamento automatico non disponibile)</p>
		<%
		else
		%><p class="ok"><img src="setup/tick.gif" alt="" /> Asp.NET supportato (ridimensionamento automatico disponibile)</p>
		<p class="ok"><img src="setup/tick.gif" alt="" /> Creato wbresize.aspx per ridimensionamento automatico</p>
		<%
	    end if %>
	<hr/>
	<p>La configurazione basilare di Carnival &egrave; terminata; potrai modificare tutte le altre impostazioni direttamente dal pannello di controllo che ti verr&agrave; presentato a breve.<br/>Premi &quot;continua&quot; per leggere le ultime operazioni da eseguire</p>
	<hr/>
	<a href="?p=4" class="button"><span>continua <img src="setup/next.gif" alt="" /></span></a>
	<%
	end if
	case 4
	%>
	<div class="phase">Fase 4/4</div>
	<h2>Gi&agrave; finito? </h2>
	<hr/>
	<p>Ora che il setup &egrave; terminato non resta che andare all'amministrazione, accedere con la password pocanzi indicata e modificare il titolo e le informazioni sul tuo photoblog, personalizzare lo stile e poi aggiungere foto...</p>
    <p class="alert">Ricorda di cancellare la cartella <strong>setup</strong> e i file <strong>setup.asp</strong> e <strong>update.asp</strong> dal tuo sito</p>
	<p>Buon divertimento con Carnival</p>
	<hr/>
	<a href="admin.asp" class="button"><span>vai all'admin <img src="setup/next.gif" alt="" /></span></a>
	<%
end select
%>
<div class="clear"></div>
</div>
<div><img src="setup/bottom.jpg" alt="" /></div>
</div>
</body>
</html>
