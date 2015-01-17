<!--#include file = "includes/inc.first.asp"-->
<!--#include file = "includes/inc.admin.checklogin.asp"-->
<%
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
' * @version         SVN: $Id: about.asp 27 2008-07-04 12:22:52Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

crnTitle = crnLang_about_title
crnPageTitle = carnival_title & " ::: " & crnTitle

dim crn_isadmin
crn_isadmin = crnFunc_AdminLoggedIn()

%><!--#include file = "includes/inc.top.asp"-->
	<div id="about">
	<% 
	dim crnAboutContent
	if crn_isadmin and request.Form("configmode") = "about" then
		crnAboutContent = request.Form("aboutpage")
		%>
        <div class="infobox">anteprima della pagina di about</div>
		<div class="clear"></div>
		<hr/><%
	else
		SQL = "SELECT config_aboutpage FROM tba_config"
		set rs = dbManager.conn.execute(SQL)
		crnAboutContent = rs("config_aboutpage")
	end if
	response.write crnAboutContent
	%>
    </div>
<!--#include file = "includes/inc.bottom.asp"-->