<!--#include file = "inc.first.asp"--><%
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
' * @version         SVN: $Id: mod.admin.login.asp 29 2008-07-04 14:03:45Z imente $
' * @home            http://www.carnivals.it
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
				SQL = "UPDATE tba_config SET config_start = " & formatDBDate(now,CARNIVAL_DATABASETYPE) & ""
				dbManager.conn.execute(SQL)
				response.redirect "admin.asp?module=config&mode=full"
			else
				response.redirect "admin.asp?module=home"
			end if
		end if
	
	else
		
		response.Redirect("errors.asp?c=login0")
	
	end if


end if %>