<!--#include file = "inc.first.asp"--><%
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
' * @version         SVN: $Id: mod.admin.infoapp.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "inc.admin.check.asp"--><%
'*****************************************************
%>
	<h2>Informazioni sull'applicazione</h2>
	<div class="infoapp">
	<table class="info">
		<tr>
			<td class="d">Carnival Engine:</td>
			<td class="c">Carnival <%=CARNIVAL_VERSION%> [<%=CARNIVAL_RELEASE%>]</td>
		</tr>
		<tr>
			<td class="d">Carnival Database:</td>
			<td class="c"><%=config__dbversion__%></td>
		</tr>
		<tr>
			<td class="d">Server:</td>
			<td class="c"><%=Request.ServerVariables("SERVER_SOFTWARE")%> [<%=Request.ServerVariables("SERVER_PROTOCOL")%>] [<%=Request.ServerVariables("SERVER_NAME")%>:<%=Request.ServerVariables("SERVER_PORT")%>]</td>
		</tr>
		<tr>
			<td class="d">ASP Engine:</td>
			<td class="c"><%=ScriptEngine & " " & ScriptEngineMajorVersion & "." & ScriptEngineMinorVersion & "." & ScriptEngineBuildVersion %></td>
		</tr>
		<tr>
			<td class="d">Database:</td>
			<td class="c"><%
				select case CARNIVAL_DATABASE_TYPE
					case "mdb"
						response.write "Access MDB "
					case "mysql"
						response.write "MySQL "
						SQL = "SELECT VERSION() AS dbversion"
						set rs = dbmanager.execute(SQL)
						response.write rs("dbversion")
				end select
			%> [<strong><%=CARNIVAL_DATABASE%></strong>]</td>
		</tr>
		<tr>
			<td class="d">Stile:</td>
			<td class="c"><%=config__style__%></td>
		</tr>
    </table>
	<div class="clear"></div>
    <form>
    <div class="nbuttons">
		<a href="admin.asp?module=tools">
			<span>
			<img src="<%=getImagePath("lay-adm-ico-but-prev.gif")%>" alt=""/> 
			indietro
			</span>
		</a>
	</div>
    </form>
    </div>