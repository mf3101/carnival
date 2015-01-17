<%
option explicit
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		setup.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------
%><!--#include file = "includes/class.include.asp"-->
<!--#include file = "includes/inc.dba.asp"-->
<!--#include file = "includes/inc.md5.asp"-->
<!--#include file = "includes/inc.func.asp"-->
<!--#include file = "includes/inc.func.file.asp"-->
<%

sub printError()
%>	<div class="error">
		<strong>Errore:</strong><br/>
		<%=err.source%> (<%=err.number%>)<br/>
		<%=err.description%><br/>
	</div><%
end sub

sub printResult(title, description, error, codeerror)
	response.write "<div class=""check"">" & vbcrlf
	if error then
		response.write "<p class=""title alert""><img src=""setup/cross.gif"" alt="""" /> " & title & "</p>" & vbcrlf
		response.write "<p class=""description"">" & description & "</p>" & vbcrlf
		if codeerror then call printError()
	else
		response.write "<p class=""title""><img src=""setup/tick.gif"" alt="""" /> " & title & "</p>" & vbcrlf
		response.write "<p class=""description"">" & description & "</p>" & vbcrlf
	end if
	response.write "</div>" & vbcrlf
end sub
'CARNIVALS INSTALL.ASP

const CARNIVAL_INSTALLER_VERSION = "1.0.0"

'FASE D'INSTALLAZIONE
dim phase
phase = trim(request.QueryString("p"))
if phase = "" then phase = 0
if not isnumeric(phase) then phase = 0
if phase > 4 then phase = 4
if phase < 0 then phase = 0
'VALORE COMPRESO FRA 0 E 10

dim allright
allright = false

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
<style type="text/css">
/*<![CDATA[*/
a, a:link, a:hover, a:active { color:#DDD; }
body {
	margin:0;
	padding:0;
	background-color:#343434;
	color:#222;
	font-family:tahoma,verdana,serif;
	font-size:0.9em;
}
.clear { clear:both; }
hr {
	border:0;
	margin:10px 0;
	width:auto;
	background-color:#CCC;
	height:3px;
	font-size:0;
}
#container {
	width:820px;
	margin:5px auto 20px;
	background:url(setup/content.jpg) top center repeat-y #FFF;
}
#box {
	padding:0 20px;
}
h1 {
	margin:0;
	letter-spacing:-1px;
}
h2 {
	font-family:arial,verdana,serif;
	margin:0;
	color:#CC2396;
	padding-left:20px;
	letter-spacing:-1.5px;
	font-size:1.6em;
}
.phase {
	float:right;
	color:#CC2396;
	font-weight:bold;
	font-family:arial,verdana,serif;
	letter-spacing:-1px;
	padding:6px 20px 0 0;
}

p {
	margin:0;
	padding:5px;
}
a.button, button {
	font-family:tahoma,verdana,serif;
	float:right;
	text-decoration:underline;
	display:block;
	width:150px;
	text-align:center;
	border:0;/*1px outset #CCC;*/
	background:url(setup/button.gif) center center no-repeat transparent;
	color:#DDD;
	font-weight:bold;
	cursor:pointer;
	font-size:1.0em;
	margin-left:20px;
}
a.button span, button span { display:block; padding:7px 0; }

.check { margin:10px 0; }
.title { font-weight:bold; }
.description { font-size:0.85em; margin:-7px 0 0 20px; }
.alert { color:#E62D2E; font-weight:bold; }
.go { color:#69B614; font-weight:bold; }

.error { margin-left:35px; padding-left:5px; font-size:0.85em; border-left:2px solid #E62D2E; }

img { margin-bottom:-3px; border:0; }

form div { margin:10px 0 20px; }
label { margin-left:10px;font-weight:bold; }
p.desc { margin:0 0 5px 10px;padding:0;font-size:0.8em;  }
input { margin-left:10px;font-size:0.9em; width:400px; }

/*]]>*/
</style>
</head>
<body>
<div id="container">
<h1><img src="setup/top.jpg" alt="Carnival Installer" /></h1>
<div id="box">
<%
select case phase
	case 0
	allright = true
	%>
	<div class="phase">Fase 0/4</div>
	<h2>Welcome to  Carnival</h2>
	<hr/>
	<p>Innanzitutto grazie per aver scaricato Carnival, &egrave; un piacere offrirti questa applicazione.<br />
	Questa breve procedura di setup ti guider&agrave; nella semplice installazione di Carnival sul tuo spazio web.</p>
	<p>Se hai aperto questa pagina significa che hai gi&agrave; copiato tutti i file di Carnival sul tuo spazio, ora &egrave; quindi venuto il momento di configurare l'applicazione affinch&eacute; funzioni e lo faccia al meglio.</p>
	<p>Apri il file<strong> includes/inc.config.asp   </strong>e leggendo attentamente ci&ograve; che vi &egrave; scritto modifica le costanti di Carnival al fine di adattarle alla tua situazione.</p>
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
	
	'**********************************************************************************
	'**********************************************************************************
	'*** ESISTENZA FILE INC.CONFIG.ASP
	if allright then
	
		dim strConfigFile
		strConfigFile = "includes/inc.config.asp"
		
		check_title = "Presenza file di configurazione ( " & strConfigFile & " )"
		if not fileExist(strConfigFile) then
			allright = false
			check_description = "il file di configurazione non esiste"
			check_error = true
		else
			check_description = "il file di configurazione &egrave; presente"
			check_error = false
		end if
		
		'printing
		call printResult(check_title, check_description, check_error, false)
		
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
		call printResult(check_title, check_description, check_error, true)
		
		on error goto 0
	end if
	'**********************************************************************************
	'**********************************************************************************
	
	'**********************************************************************************
	'**********************************************************************************
	'*** PRESENZA DATABASE
	if allright then
		
		check_title = "Presenza database ( " & CARNIVAL_DATABASE & " )"
		if not fileExist(CARNIVAL_DATABASE) then
			allright = false
			check_description = "il database non esiste"
			check_error = true
		else
			if not writePermissions(CARNIVAL_DATABASE) then
				allright = false
				check_description = "la database esiste ma la cartella non possiede permessi di scrittura"
				check_error = true
			else
				check_description = "la database esiste e la cartella possiede permessi di scrittura"
				check_error = false
			end if
		end if
		
		'printing
		call printResult(check_title, check_description, check_error, false)
	end if
	'**********************************************************************************
	'**********************************************************************************
	
	'**********************************************************************************
	'**********************************************************************************
	'*** ESISTENZA E SCRITTURA CARTELLA DELLE FOTO
	if allright then
		
		check_title = "Cartella delle foto ( " & CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & " )"
		if not folderExist(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS) then
			allright = false
			check_description = "la cartella non esiste"
			check_error = true
		else
			if not writePermissions(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS) then
				allright = false
				check_description = "la cartella esiste ma non possiede permessi di scrittura"
				check_error = true
			else
				check_description = "la cartella esiste e possiede permessi di scrittura"
				check_error = false
			end if
		end if
		
		'printing
		call printResult(check_title, check_description, check_error, false)
		
	end if
	'**********************************************************************************
	'**********************************************************************************
	
	'**********************************************************************************
	'**********************************************************************************
	'*** ESISTENZA E SCRITTURA CARTELLA DEGLI STILI
	if allright then
		
		check_title = "Cartella degli stili ( " & CARNIVAL_PUBLIC & CARNIVAL_STYLES & " )"
		if not folderExist(CARNIVAL_PUBLIC & CARNIVAL_STYLES) then
			allright = false
			check_description = "la cartella non esiste"
			check_error = true
		else
			if not writePermissions(CARNIVAL_PUBLIC & CARNIVAL_STYLES) then
				allright = false
				check_description = "la cartella esiste ma non possiede permessi di scrittura"
				check_error = true
			else
				check_description = "la cartella esiste e possiede permessi di scrittura"
				check_error = false
			end if
		end if
		
		'printing
		call printResult(check_title, check_description, check_error, false)
		
	end if
	'**********************************************************************************
	'**********************************************************************************
	
	'**********************************************************************************
	'**********************************************************************************
	'*** ESISTENZA E SCRITTURA CARTELLA DI SUPPORTO
	if allright then
		
		check_title = "Cartella di supporto ( " & CARNIVAL_PUBLIC & CARNIVAL_SERVICES & " )"
		if not folderExist(CARNIVAL_PUBLIC & CARNIVAL_SERVICES) then
			allright = false
			check_description = "la cartella non esiste"
			check_error = true
		else
			if not writePermissions(CARNIVAL_PUBLIC & CARNIVAL_SERVICES) then
				allright = false
				check_description = "la cartella esiste ma non possiede permessi di scrittura"
				check_error = true
			else
				check_description = "la cartella esiste e possiede permessi di scrittura"
				check_error = false
			end if
		end if
		
		'printing
		call printResult(check_title, check_description, check_error, false)
		
	end if
	'**********************************************************************************
	'**********************************************************************************
	
	'**********************************************************************************
	'**********************************************************************************
	'*** ESISTENZA E SCRITTURA CARTELLA DEI FEED
	if allright then
		
		check_title = "Cartella dei feed ( " & CARNIVAL_PUBLIC & CARNIVAL_FEED & " )"
		if not folderExist(CARNIVAL_PUBLIC & CARNIVAL_FEED) then
			allright = false
			check_description = "la cartella non esiste"
			check_error = true
		else
			if not writePermissions(CARNIVAL_PUBLIC & CARNIVAL_FEED) then
				allright = false
				check_description = "la cartella esiste ma non possiede permessi di scrittura"
				check_error = true
			else
				check_description = "la cartella esiste e possiede permessi di scrittura"
				check_error = false
			end if
		end if
		
		'printing
		call printResult(check_title, check_description, check_error, false)
		
	end if
	'**********************************************************************************
	'**********************************************************************************
	
	'**********************************************************************************
	'**********************************************************************************
	'*** ESISTENZA CARTELLA DEI LOGHI
	if allright then
		
		check_title = "Presenza cartella dei loghi ( " & CARNIVAL_LOGOS & " )"
		if not folderExist(CARNIVAL_LOGOS) then
			allright = false
			check_description = "la cartella non esiste<br/>crea la cartella nel percorso indicato oppure modifica il file di configurazione affinch&eacute; punti a una cartella esistente"
			check_error = true
		else
			check_description = "la cartella esiste"
			check_error = false
		end if
		
		'printing
		call printResult(check_title, check_description, check_error, false)
		
	end if
	'**********************************************************************************
	'**********************************************************************************
	
	'**********************************************************************************
	'**********************************************************************************
	'*** HOME CHECK
	if allright then
		
		check_title = "Controllo conformit&agrave; indirizzo base ( " & CARNIVAL_HOME & " )"
		if trim(request.ServerVariables("HTTP_REFERER")) = "" then
			allright = false
			check_description = "per eseguire il test &egrave; necessario attivare i REFERER del tuo browser e premere &quot;test&quot;"
			check_error = true
		else
			if CARNIVAL_HOME <> left(request.ServerVariables("HTTP_REFERER"),len(CARNIVAL_HOME)) then
				allright = false
				check_description = "l'indirizzo base indicato non corrisponde ( si consiglia di indicare """ & left(request.ServerVariables("HTTP_REFERER"),len(CARNIVAL_HOME)) & """ )"
				check_error = true
			else
				check_description = "l'indirizzo base &egrave; considerato valido"
				check_error = false
			end if
		end if
		
		'printing
		call printResult(check_title, check_description, check_error, false)
		
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
	<div class="phase">Fase 2/4</div>
	<h2>Impostazioni base</h2>
	<hr/>
	<form action="setup.asp?p=3" method="post">
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
	<button type="submit"><span>continua <img src="setup/next.gif" alt="" /></span></button>
	<a href="?p=1" class="button"><span><img src="setup/back.gif" alt="" /> indietro</span></a>
	</form><%
	case 3
	if trim(request.form("password")) = "" or trim(request.Form("title")) = "" then response.Redirect("setup.asp?p=2")
	%>
	<div class="phase">Fase 3/4</div>
	<h2>Impostazioni applicate </h2>
	<hr/>
	<%
	call execute(IncludeFile("includes/inc.config.asp"))	
	call connect()
	dim wbresize,wbresizekey,aspnetactive
	wbresizekey = createKey(32)
	wbresize = openFile(server.MapPath("setup/wbresize.aspx.install"))
	wbresize = replace(wbresize,"$KEYCHECK$",wbresizekey)
	wbresize = replace(wbresize,"$BASEADDRESS$",CARNIVAL_HOME)
	call writeFile(server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_SERVICES & "wbresize.aspx"),wbresize)
	wbresize = ""
	
	aspnetactive = checkAspnetActive(CARNIVAL_HOME & CARNIVAL_PUBLIC & CARNIVAL_SERVICES & "test.aspx")
	
	SQL = "UPDATE tba_config SET config_title = '" & left(replace(request.form("title"),"'","''"),50) & "',config_password = '" & md5(request.form("password")) & "', config_wbresizekey = '" & wbresizekey & "', config_aspnetactive = " & formatDbBool(aspnetactive) & ", config_start = " & formatDBDate(cdate("12/03/1985"),"mdb") & " WHERE config_id = 1"
	conn.execute(SQL)
	
	call disconnect()
	%>
	<p class="ok"><img src="setup/tick.gif" alt="" /> Salvata password per accesso all'amministrazione </p>
	<p class="ok"><img src="setup/tick.gif" alt="" /> Impostato titolo del photoblog </p>
	<p class="ok"><img src="setup/tick.gif" alt="" /> Impostata data di inizio pubblicazione </p>
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
	case 4
	%>
	<div class="phase">Fase 4/4</div>
	<h2>Gi&agrave; finito? </h2>
	<hr/>
	<p>Ora che il setup &egrave; terminato non resta che andare all'amministrazione, accedere con la password pocanzi indicata e modificare il titolo e le informazioni sul tuo photoblog, personalizzare lo stile e poi aggiungere foto...</p>
	<p>Ricorda per&ograve; di cancellare il file <strong>setup.asp</strong> e la cartella <strong>setup</strong> prima di continuare, altrimenti malintenzionati potrebbero sfruttare questi file per accedere all'amministrazione.</p>
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