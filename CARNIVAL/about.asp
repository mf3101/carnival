<!--#include file = "includes/inc.first.asp"--><%
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
' * @version         SVN: $Id: about.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "includes/inc.admin.checklogin.asp"--><%
'*****************************************************

strPageTitle__ = lang__about_title__
strPageTitleHead__ = config__title__ & " ::: " & strPageTitle__

dim blnIsAdmin
blnIsAdmin = isAdminLogged()

%><!--#include file = "includes/inc.top.asp"-->
	<div id="about">
	<% 
	dim strAboutContent
	if blnIsAdmin and request.Form("configmode") = "about" then
		'anteprima about
		strAboutContent = request.Form("aboutpage")
		%>
        <div class="infobox">anteprima della pagina di about</div>
		<div class="clear"></div>
		<hr/><%
	else
		'visualizza about
		SQL = "SELECT config_aboutpage FROM tba_config"
		set rs = dbManager.Execute(SQL)
		strAboutContent = rs("config_aboutpage")
	end if
	response.write strAboutContent
	%>
    </div>
<!--#include file = "includes/inc.bottom.asp"-->