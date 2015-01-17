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
' * @version         SVN: $Id: mod.admin.prostyles.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "inc.admin.check.asp"-->
<!--#include file = "inc.func.style.asp"--><%
'*****************************************************

dim strFrom
strFrom = request.QueryString("from")

dim strStyleName, strStyleLogoLight, strStyleLogoDark
strStyleName = replace(trim(request.querystring("style")),"\","")
strStyleLogoLight = request.querystring("logo_light")
strStyleLogoDark = request.querystring("logo_dark")

dim blnCompress
blnCompress = inputBoolean(request.querystring("compress"))

select case strFrom
	
	case "stylesstyle", "tools"
	
		if strStyleName = "" then response.Redirect("admin.asp?module=styles")
	
		dim return
		return = setStyle(strStyleName,blnCompress,IIF(strFrom="tools",false,true))
		if return <> "" then response.Redirect("errors.asp?c=" & return)
	
	case "styleslogo"

		if strStyleLogoLight <> "" and strStyleLogoDark <> "" then
		
			if strStyleLogoLight = "$TEXT$" then strStyleLogoLight = ""
			if strStyleLogoDark = "$TEXT$" then strStyleLogoDark = ""
			
			SQL = "UPDATE tba_config SET config_logo_light = '" & formatDBString(strStyleLogoLight,null) & "', " & _
										"config_logo_dark = '" & formatDBString(strStyleLogoDark,null) & "'"
			dbManager.Execute(SQL)
		
		end if

end select

select case strFrom
	case "tools"
	if blnCompress then
		response.Redirect("admin.asp?module=tools&done=styles")
	else
		response.Redirect("admin.asp?module=tools&done=styles-debug")
	end if
	case "stylesstyle","styleslogo"
	response.Redirect("admin.asp?module=styles")
	case else
	response.Redirect("admin.asp")
end select
%>