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
' * @version         SVN: $Id: inc.admin.checklogin.asp 8 2008-05-22 00:26:46Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------
function crnFunc_AdminLoggedIn()

	crnFunc_AdminLoggedIn = true
	
	if  application(CARNIVAL_CODE & "_admin_key") = "" or _
		application(CARNIVAL_CODE & "_admin_lastevent") = "" then
		
		crnFunc_AdminLoggedIn = false
		
	else
	
		if request.cookies(CARNIVAL_CODE & "adminkey") <> application(CARNIVAL_CODE & "_admin_key") _
			or trim(request.cookies(CARNIVAL_CODE & "adminkey")) = "" _
			or clng(datediff("n",application(CARNIVAL_CODE & "_admin_lastevent"),now)) > clng(CARNIVAL_SESSION_ADMIN_PERSIST) then crnFunc_AdminLoggedIn = false
			
	end if
	
end function
%>