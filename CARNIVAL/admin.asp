<!--#include file = "includes/inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		admin.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------
%>
<!--#include file = "includes/inc.admin.checklogin.asp"--><%
crnTitle = "ADMIN"
crnPageTitle = carnival_title & " ::: " & crnTitle
crnIsAdminPage = true
%><!--#include file = "includes/inc.top.asp"-->
	<%
	'* riceve il nome del modulo richiesto
	dim crnModule
	crnModule = request.QueryString("module")
	'* se nessun modulo è richiesto, imposta quello di default
	if crnModule = "" then crnModule = "home"
	
	'* LOGIN
	'* se non è stato effettuato il login impone
	'* il caricamento del modulo di login
	crnIsAdminLogged = crnFunc_AdminLoggedIn
	if not crnIsAdminLogged then crnModule = "login"
	
	if crnModule = "login" then

		'* esegue il modulo di login
		server.execute("includes/mod.admin.login.asp")

	else
		
		'* LOGIN
		'* aggiorna la data dell'ultima azione del login corrente
		application.lock
		application(CARNIVAL_CODE & "_admin_lastevent") = now
		application.unlock
	
		'* esegue il modulo richiesto
		select case crnModule
		
		
			case "photo-new"
			server.execute("includes/mod.admin.photonew.asp")
			case "photo-edit"
			server.execute("includes/mod.admin.photoedit.asp")
			case "pro-photo-edit"
			server.execute("includes/mod.admin.prophotoedit.asp")
			case "pro-photo-upload"
			server.execute("includes/mod.admin.prophotoupload.asp")
			case "photo-upload"
			server.execute("includes/mod.admin.photoupload.asp")
			case "photo-resize"
			server.execute("includes/mod.admin.photoresize.asp")
			case "photo-thumb"
			server.execute("includes/mod.admin.photothumb.asp")
			case "photo-check"
			server.execute("includes/mod.admin.photocheck.asp")
			
			case "photo-list"
			server.execute("includes/mod.admin.photolist.asp")
			
			case "info"
			server.execute("includes/mod.admin.info.asp")
			
			case "tools"
			server.execute("includes/mod.admin.tools.asp")
			case "pro-tools"
			server.execute("includes/mod.admin.protools.asp")
			case "pro-db"
			call disconnect() : server.execute("includes/mod.admin.protools.asp") : call connect()
			
			case "config"
			server.execute("includes/mod.admin.config.asp")
			case "pro-config"
			server.execute("includes/mod.admin.proconfig.asp")
			
			case "styles"
			server.execute("includes/mod.admin.styles.asp")
			case "styles-style"
			server.execute("includes/mod.admin.stylesstyle.asp")
			case "styles-logo"
			server.execute("includes/mod.admin.styleslogo.asp")
			case "pro-styles"
			server.execute("includes/mod.admin.prostyles.asp")
			
			case "tag-list"
			server.execute("includes/mod.admin.taglist.asp")
			case "tag-edit"
			server.execute("includes/mod.admin.tagedit.asp")
			case "pro-tag"
			server.execute("includes/mod.admin.protag.asp")
			
			case "pro-rss"
			server.execute("includes/mod.admin.prorss.asp")
			
			case else
			server.execute("includes/mod.admin.home.asp")
		end select
		
	end if
	%>
<!--#include file = "includes/inc.bottom.asp"-->