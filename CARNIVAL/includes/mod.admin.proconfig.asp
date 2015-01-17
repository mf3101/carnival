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
' * @version         SVN: $Id: mod.admin.proconfig.asp 27 2008-07-04 12:22:52Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"-->
<!--#include file = "inc.md5.asp"--><%

dim crn_title, crn_description, crn_author, crn_copyright, crn_headadd, crn_bodyadd, crn_bodyaddwhere
dim crn_jsactive, crn_parent, crn_about, crn_aboutpage, crn_password, crn_newpassword, crn_exifactive
dim crn_mode
dim crn_configmode

crn_configmode = normalize(request.form("configmode"),"full|navigation|about|code|password","general")

if crn_configmode = "general" or crn_configmode = "full" then 
	crn_title = cleanString(request.form("title"),0,50)
	crn_description = cleanString(request.form("description"),0,255)
	crn_author = cleanString(request.form("author"),0,50)
	crn_copyright = cleanString(request.form("copyright"),0,100)
end if
if crn_configmode = "navigation" or crn_configmode = "full" then 
	crn_jsactive = request.form("jsactive")
	if crn_jsactive <> 1 then crn_jsactive = 0
	crn_exifactive = request.form("exifactive")
	if crn_exifactive <> 1 then crn_exifactive = 0
	crn_mode = cleanByte(request.Form("mode"))
end if
if crn_configmode = "about" or crn_configmode = "full" then 
	crn_aboutpage = cleanString(request.form("aboutpage"),0,5000)
	crn_parent = cleanString(request.form("parent"),0,250)
end if
if crn_configmode = "code" or crn_configmode = "full" then 
	crn_headadd = cleanString(request.form("headadd"),0,2000)
	crn_bodyadd = cleanString(request.form("bodyadd"),0,2000)
	crn_bodyaddwhere = cleanByte(request.form("bodyaddwhere"))
end if
if crn_configmode = "password" or crn_configmode = "full" then 
	crn_password = trim(request.form("password"))
	crn_newpassword = trim(request.form("newpassword"))
end if

'-------------------------------------------------------------------------------

if crn_configmode = "password" or crn_configmode = "full" then 
	if not(crn_password = "" and crn_newpassword = "") or crn_configmode <> "full" then
		if crn_password <> "" and len(crn_newpassword) >= 5 then
			SQL = "SELECT config_password FROM tba_config"
			set rs = dbManager.conn.execute(SQL)
			if rs("config_password") = md5(crn_password) then
				SQL = "UPDATE tba_config SET config_password = '" & md5(crn_newpassword) & "'"
				dbManager.conn.execute(SQL)
			else
				Response.Redirect("errors.asp?c=config1")
			end if
		else
			Response.Redirect("errors.asp?c=config0")
		end if
	end if
end if

'-------------------------------------------------------------------------------
if crn_configmode <> "password" then
	SQL = "UPDATE tba_config SET "
	
	if crn_configmode = "general" or crn_configmode = "full" then
		SQL = SQL & ",config_title = '" & crn_title & "', " & _
					 "config_description = '" & crn_description & "', " & _
					 "config_author = '" & crn_author & "', " & _
					 "config_copyright = '" & crn_copyright & "'"
	end if
	if crn_configmode = "navigation" or crn_configmode = "full" then 
		SQL = SQL & ", config_jsactive = " & crn_jsactive & ", " & _
					 "config_exifactive = " & crn_exifactive & ", " & _
					 "config_mode = " & crn_mode
	end if
	if crn_configmode = "about" or crn_configmode = "full" then 
		crn_about = 0
		if crn_aboutpage <> "" then crn_about = 1
		SQL = SQL & ",config_aboutpage = '" & crn_aboutpage & "', " & _
					 "config_about = " & crn_about & ", " & _
					 "config_parent = '" & crn_parent & "'"
	end if
	if crn_configmode = "code" or crn_configmode = "full" then 
		SQL = SQL & ",config_headadd = '" & crn_headadd & "', " & _
					 "config_bodyadd = '" & crn_bodyadd & "', " & _
					 "config_bodyaddwhere = " & crn_bodyaddwhere
	end if
	SQL = replace(SQL,"SET ,","SET ") & ""
	
	dbManager.conn.execute(SQL)
end if

response.Redirect("admin.asp?module=config&mode="&crn_configmode&"&action=done")


%>