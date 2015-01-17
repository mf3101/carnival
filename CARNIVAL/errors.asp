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
' * @version         SVN: $Id: errors.asp 8 2008-05-22 00:26:46Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------
dim crn_errorCode, crn_id, crn_viaJs
crn_errorCode = request.QueryString("c")
crn_id = request.QueryString("id")
if crn_id < 0 then crn_id = 0
crn_viaJs = cleanBool(request.QueryString("js"))

if crn_viaJs then response.Redirect("inner.errors.asp?c=" & crn_errorCode & "&id=" & crn_id)

%><!--#include file = "includes/gen.errors.asp"--><%

crnTitle = crnLang_error_title
crnPageTitle = carnival_title & " ::: " & crnTitle
crnShowTop = 0 

%><!--#include file = "includes/inc.top.asp"-->
		<div id="error" class="dark">
			<div class="title"><%=crn_errTitle%></div>
			<div class="description"><%=crn_errDescription%></div>
			<div class="link"><%=crn_errLink%></div>
		</div>
<!--#include file = "includes/inc.bottom.asp"-->