<!--#include file = "includes/inc.first.asp"--><%
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
' * @version         SVN: $Id: admin.asp 18 2008-06-29 02:54:08Z imente $
' * @home            http://www.carnivals.it
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
			
			case "set-list"
			server.execute("includes/mod.admin.setlist.asp")
			case "set-photo-list"
			server.execute("includes/mod.admin.setphotolist.asp")
			case "set-edit"
			server.execute("includes/mod.admin.setedit.asp")
			case "pro-set"
			server.execute("includes/mod.admin.proset.asp")
			
			case "pro-rss"
			server.execute("includes/mod.admin.prorss.asp")
			
			case else
			server.execute("includes/mod.admin.home.asp")
		end select
		
	end if
	%>
<!--#include file = "includes/inc.bottom.asp"-->