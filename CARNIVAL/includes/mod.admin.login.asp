<!--#include file = "inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		mod.admin.login.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"-->
<!--#include file = "inc.md5.asp"-->
<%

dim appPassword
appPassword = request.form("password")

if appPassword = "" and not(isnull(appPassword)) then %>
	<form action="" method="post" class="login">
		<div class="field"><label for="password">password</label><input type="password" name="password" id="password" class="text" /></div>
		<div class="field"><div class="nbuttons">
			<button type="submit">
				<span class="a"><span class="b">
				<img src="<%=carnival_pathimages%>/lay-adm-ico-but-accept.gif" alt=""/> 
				login
				</span></span>
			</button>
		</div></div>
	</form>
	<!--#include file = "inc.info.asp"-->
<% else 

appPassword = md5(appPassword)

	if appPassword = carnival_password then
	
		if not(isdate(application(CARNIVAL_CODE & "_admin_lastevent"))) then application(CARNIVAL_CODE & "_admin_lastevent") = dateadd("n",now,CARNIVAL_SESSION_ADMIN_PERSIST)
		
		if clng(datediff("n",application(CARNIVAL_CODE & "_admin_lastevent"),now)) < clng(CARNIVAL_SESSION_ADMIN_LOCKED) then
			response.Redirect("errors.asp?c=login1")
		else
			dim newkey
			newkey = createKey(32)
			application.lock
			application(CARNIVAL_CODE & "_admin_key") = newkey
			application(CARNIVAL_CODE & "_admin_lastevent") = now
			application(CARNIVAL_CODE & "_admin_ip") = request.ServerVariables("REMOTE_ADDR")
			application(CARNIVAL_CODE & "_admin_ccv") = true
			application.unlock
			Response.cookies(CARNIVAL_CODE & "adminkey") = newkey
			Response.cookies(CARNIVAL_CODE & "adminkey").Expires = dateadd("d",365,now)
			if carnival_start = cdate("12/03/1985") then
				'controllo primo avvio
				SQL = "UPDATE tba_config SET config_start = " & formatDBDate(now,"mdb") & " WHERE config_id = 1"
				conn.execute(SQL)
				response.redirect "admin.asp?module=config"
			else
				response.redirect "admin.asp?module=home"
			end if
		end if
	
	else
		
		response.Redirect("errors.asp?c=login0")
	
	end if


end if %>