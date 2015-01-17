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
' * @version         SVN: $Id: update.asp 119 2010-10-11 20:06:21Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

option explicit

'*****************************************************
'ENVIROMENT UPDATE
%><!--#include file = "includes/class.include.asp"-->
<!--#include file = "includes/inc.config.asp"-->
<!--#include file = "includes/inc.set.asp"-->
<!--#include file = "includes/inc.md5.asp"-->
<!--#include file = "setup/updateinc/class.aspdbbox.asp"-->
<!--#include file = "setup/updateinc/inc.update.asp"--><%
'*****************************************************

'* LOGIN
'* se non è stato effettuato il login
if not isAdminLogged then
	response.write "<div style=""margin:50px 0; text-align:center; font-size:1.2em;"">per effettuare l'aggiornamento di Carnival &egrave;<br/>necessario prima eseguire la <a href=""admin.asp"">login in amministrazione</a></div>"
	response.end
end if

'CARNIVALS UPDATE.ASP

const CARNIVAL_INSTALLER_VERSION = "1.0.0"

'compatibility
dim SQL, rs
dim strDatabaseType

'FASE D'AGGIORNAMENTO
dim phase
phase = trim(request.QueryString("p"))
if phase = "" then phase = 0
if not isnumeric(phase) then phase = 0
if phase > 3 then phase = 3
if phase < 0 then phase = 0

dim allright, strconfigfile
allright = false
strConfigFile = "includes/inc.config.asp"

%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--
 *
 *	Carnival UPDATE <%=CARNIVAL_INSTALLER_VERSION%>
 *	http://www.carnivals.it
 *
 -->
<head>
<title>CARNIVAL UPDATE TO <%=CARNIVAL_INSTALLER_VERSION%></title>
<link href="setup/main.css" type="text/css" rel="stylesheet" />
</head>
<body>
<div id="container">
<h1><img src="setup/top-update.jpg" alt="Carnival Updater" /></h1>
<div id="box">
<%
select case phase
	case 0
	allright = true
	%>
	<div class="phase">Fase 0/3</div>
	<h2>Welcome to  Carnival Update</h2>
	<p>Innanzitutto grazie per utilizzare Carnival, &egrave; un piacere offrirti questa applicazione.<br />
	Questa breve procedura di update ti guider&agrave; nel semplice aggiornamento della tua installazione di Carnival.</p>
	<p>Se hai aperto questa pagina significa che hai gi&agrave; copiato il file &quot;update.asp&quot; e la cartella &quot;setup&quot; e che vuoi aggiornare la tua installazione alla versione <%=CARNIVAL_INSTALLER_VERSION%>.</p>
	<p>Clicca su continua appena sei pronto/a a cominciare la procedura di aggiornamento.</p>
	<hr/>
	<a href="?p=1" class="button"><span>continua <img src="setup/next.gif" alt="" /></span></a><%
	case 1
	allright = true
	%>
    <div id="workin">
	<div class="phase">Fase 1/3</div>
	<h2>Operazioni preliminari</h2>
	<p>Per prima cosa il mio consiglio &egrave; di effettuare un <strong>backup completo</strong> della tua installazione di Carnival al fine di evitare spiacevoli problemi al termine della procedura avendo la possibilit&agrave; di ripristinare la situazione iniziale.</p>
	<p>Non appena avrai terminato il backup clicca su continua, l'update si occuper&agrave; di effettuare alcuni aggiornamenti sul database.</p>
	<hr/>
	<a href="?p=2" class="button" onclick="workin()"><span>continua <img src="setup/next.gif" alt="" /></span></a>
    <script type="text/javascript">/*<![CDATA[*/
	function workin() {
		document.getElementById('workin').innerHTML = '<div class="workin"><img src="setup/workin.gif" /><br/><span>aggiornamento database</span><br/><small>(la procedura potrebbe durare anche più di un minuto<br/>abbi pazienza e non fermare l\'esecuzione della pagina)</small></div>';
		window.location.href = '?p=2';
	}
	/*]]>*/</script>
	</div><%
	case 2
	%>
    <div id="workin">
	<div class="phase">Fase 2/3</div>
    <div class="clear"></div>
	<h2>Aggiornamento</h2>
    <%
		
		allright = false
	
		on error resume next
		strDatabaseType = "mdb" 'compatibilita con versione < 1.0
		strDatabaseType = CARNIVAL_DATABASE_TYPE
		on error goto 0

		call connect(strDatabaseType,CARNIVAL_DATABASE)
	
		dim XML, active, execcommon, nodename, pathfrom, pathto
		active = false
		execcommon = false
		set XML = new Class_XmlReader
		if CARNIVAL_VERSION = CARNIVAL_INSTALLER_VERSION then
			response.write "<div class=""readme""><p><strong>aggiornamento non necessario</strong><br/>la versione installata &egrave; uguale a quella di questo aggiornamento.</p></div><hr/>"
		elseif not XML.Open(server.MapPath("setup/update.xml"),CARNIVAL_INSTALLER_VERSION) then
			response.write "<div class=""readme""><p><strong>update.xml non trovato o non valido</strong><br/>hai copiato la cartella /setup/ nella tua installazione di carnival?<br />senza tale cartella e i file ivi contenuti non &egrave; possibile effettuare l'aggiornamento</p></div><hr/>"
		elseif XML.versionto <> CARNIVAL_INSTALLER_VERSION then
			response.write "<div class=""readme""><p><strong>update.xml incompatibile</strong><br/>la versione del file ""update.xml"" aggiorna alla " & XML.versionto & " e ""update.asp"" aggiorna a " & CARNIVAL_INSTALLER_VERSION & "<br/>si consiglia di scaricare nuovamente l'aggiornamento e ricominciare dal primo passo</p></div><hr/>"
		elseif convertVersion(XML.versionfrom) > convertVersion(CARNIVAL_VERSION) then
			response.write "<div class=""readme""><p><strong>update non compatibile con la versione corrente</strong><br/>la versione dell'aggiornamento richiede una versione minima installata " & XML.versionfrom & "<br/>la versione attualmente installata &egrave; la " & CARNIVAL_VERSION & "<br/><a href=""http://www.carnivals.it/downloads/?c=" & CARNIVAL_VERSION & "&u=last"" class=""link"">clicca qui per scaricare un aggiornamento compatibile</a></p></div><hr/>"
		else
		%>
    <div class="readme"><strong>ATTENZIONE:</strong><br />
leggere per intero ed attentamente il contenuto di questa pagina ed eseguire le operazioni indicate.</div><%
		
			'blocco applicazione
			on error resume next
			dbManager.Execute("UPDATE tba_config SET config_applicationblock = 1")
			on error goto 0
			
			'copio wbresize
			dbManager.Execute("UPDATE tba_config SET config_aspnetactive = 0")
			call copyFile(server.MapPath("setup/wbresize.aspx.install"),server.MapPath(CARNIVAL_PUBLIC&CARNIVAL_SERVICES&"wbresize.aspx"))
			
			%><p><%
			dim tablename, columnname, columnid, options, fill, skipifexist, ifnot, info, execquery
			allright = true
			Do While Not XML.EOF
				'response.write XML("nodename") & "$"
				'response.write XML("nodevalue") & "|"
				'response.write "from=" & XML("from") & "to=" & XML("to")
				'if CARNIVAL_INSTALLER_VERSION = XML("from") then active = false
				if CARNIVAL_VERSION = XML("from") then active = true
				if XML("nodename") = "common" then
					active = execcommon
				else
					execcommon = inputBoolean(XML("execcommon"))
				end if
				if active then
					'response.write "*"
					Do while not XML.SUBEOF
						nodename = XML.Subnode("nodename")
						select case lcase(nodename)
							case "del"
								pathfrom = convertPath(XML.Subnode("path"))
								call reportUpdate("del","elimina (se esiste) <span style=""color:red;"">" & pathfrom & "</span>")
							case "copy"
								pathfrom = convertPath(XML.Subnode("from"))
								pathto = convertPath(XML.Subnode("to"))
								call reportUpdate("copy","copia da <span style=""color:darkgreen"">" & pathfrom & "</span> a <span style=""color:darkgreen;"">" & pathto & "</span>")
							case "db"
								tablename = XML.Subnode("tablename")
								columnname = XML.Subnode("columnname")
								columnid = XML.Subnode("columnid")
								options = XML.Subnode("options")
								fill = XML.Subnode("fill")
								sql = XML.Subnode("sql")
								ifnot = XML.Subnode("ifnot")
								info = XML.Subnode("info")
								execquery = true
								select case lcase(XML.Subnode("action"))
									case "query"
										'esegue la query solo se la query IFNOT da EOF
										if ifnot <> "" then
											set rs = dbManager.Execute(ifnot)
											execquery = rs.eof
										end if
										if execquery then
											on error resume next
											call dbManager.Execute(sql)
											on error goto 0
										end if
										call reportUpdate("dbquery",info)
									case "addcolumn"
										call dbManager.AddColumn(tablename,columnname,options,fill,true)
										call reportUpdate("dbadd","aggiunta colonna " & tablename & "." & columnname)
									case "modifycolumn"
										call dbManager.ModifyColumn(tablename,columnname,options,true)
										call reportUpdate("dbedit","modificata colonna " & tablename & "." & columnname)
									case "dropcolumn"
										call dbManager.DropColumn(tablename,columnname)
										call reportUpdate("dbdel","eliminata colonna " & tablename & "." & columnname)
									case "createtable"
										call dbManager.CreateTable(tablename,columnid,"",true)
										call reportUpdate("dbadd","creata tabella " & tablename)
									case "droptable"
										call dbManager.DropTable(tablename)
										call reportUpdate("dbdel","eliminata tabella " & tablename)
								end select
						end select
						XML.MoveNextSub
					loop
				end if
				'response.write "<hr/>"
			  XML.MoveNext
			Loop
			XML.Close
			%>Il database &egrave; stato aggiornato automaticamente; ecco di seguito un sunto delle operazioni effettuate:</p><p><small><%
			
			call reportPrint("db")%></small></p>
            <hr/>
            <h2>Aggiornamento manuale file applicazione</h2>
            <p>Ora <strong>&egrave; necessario aggiornare manualmente</strong> i file dell'applicazione; ecco di seguito le operazioni da effettuare.<br />
			<small>Nel caso in cui un file indicato &quot;da eliminare&quot; non si trovi nella vostra installazione  ci&ograve; pu&ograve; essere del tutto normale, dovuto ad aggiornamenti multipli.</small></p><p><%
			call reportPrint("del")%></p><hr/><p><%
			call reportPrint("copy")
			%>
            </p>
            <hr/>
            <h2>Aggiornamento manuale file di configurazione</h2>
            <p>
            <%
			dim configtext
			configtext = generateConfig()
			%>
            <hr/>
            <textarea style="width:100%;height:300px">
            <%=configtext%>
            </textarea>
            </p>
            <p><strong>Controlla che le impostazioni siano corrette e poi copia il contenuto di questa casella di testo all'interno di &quot;includes/inc.config.asp&quot; sovrascrivendolo completamente</strong></p>
        	</p><hr/><p>Solo quando avrai terminato di effettuare le eliminazioni, la copia dei nuovi files e l'aggiornamento del file di configurazione premi su continua.</p>
        <hr/>
        <a href="?p=3" class="button" onclick="workin()"><span>continua <img src="setup/next.gif" alt="" /></span></a></div>
    <script type="text/javascript">/*<![CDATA[*/
	function workin() {
		document.getElementById('workin').innerHTML = '<div class="workin"><img src="setup/workin.gif" /><br/><span>reinizializzazione di carnival</span><br/><small>(la procedura potrebbe durare anche più di un minuto<br/>abbi pazienza e non fermare l\'esecuzione della pagina)</small></div>';
		window.location.href = '?p=3';
	}
	/*]]>*/</script><%
		
		end if
		
		call disconnect()
		set dbManager = Nothing

	case 3
	%>
	<div class="phase">Fase 3/3</div>
    <div class="clear"></div>
	<h2>Aggiornamento completato</h2>
    <%
		
		allright = false
	
		%><p>
        La procedura di aggiornamento &egrave; terminata.<br />
		Vai in amministrazione e verifica che tutto sia funzionante<br />
        Nel caso in cui ci fossero problemi ripristina il backup che hai effettuato all'inizio dell'aggiornamento e ricomincia la procedura dall'inizio; se il problema persiste puoi scrivere sul <a href="http://forum.imente.org/viewforum.php?f=7" class="link">forum di supporto</a>.</p>
        <p>L'aggiornamento si &egrave; anche occupato di aggiornare e sincronizzare tutti le componenti dinamiche installate:</p>
        <%
		
		call execute(IncludeFile("includes\inc.func.common.asp"))
		call execute(IncludeFile("includes\inc.func.common.io.asp"))
		call execute(IncludeFile("includes\inc.func.common.file.asp"))
		call execute(IncludeFile("includes\inc.func.style.asp"))
		call execute(IncludeFile("includes\inc.func.tag.asp"))
		call execute(IncludeFile("includes\inc.func.set.asp"))
		call execute(IncludeFile("includes\inc.func.services.asp"))
		
		on error resume next
		strDatabaseType = "mdb" 'compatibilita con versione < 1.0
		strDatabaseType = CARNIVAL_DATABASE_TYPE
		on error goto 0
	
		call connect(strDatabaseType,CARNIVAL_DATABASE)
		
		set rs = dbManager.Execute("SELECT config_style FROM tba_config")
		
		if not rs.eof then
			call setStyle(cstr(rs("config_style")),true,false)
			%><p class="ok"><img src="setup/tick.gif" alt="" /> Stile ricompilato </p><%
		end if
		
		if aspneton() then
		%><p class="ok"><img src="setup/tick.gif" alt="" /> WBResize ricompilato correttamente</p><%
		else
		%><p class="alert"><img src="setup/cross.gif" alt="" /> Asp.NET non supportato (ridimensionamento automatico non disponibile)</p><%
		end if 
		
		call syncSets()
		%><p class="ok"><img src="setup/tick.gif" alt="" /> Sincronizzati Set</p><%
		call syncTags()
		%><p class="ok"><img src="setup/tick.gif" alt="" /> Sincronizzati Tags</p><%
		
		
		dbManager.Execute("UPDATE tba_config SET config_applicationblock = 0")
		
		call disconnect()
		
		%>
        <p class="alert">Ricorda di cancellare i file <em>setup.asp</em> e <em>update.asp</em> dal tuo sito</p>
    <p>Se hai necessit&agrave; di effettuare una migrazione del database da MDB a MySQL (o viceversa) vai in Strumenti/Migrazione dal tuo pannello di amministrazione</p>
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
