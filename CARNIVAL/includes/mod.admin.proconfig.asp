<!--#include file = "inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		mod.admin.proconfig.asp 0 20080312120000
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
<!--#include file = "inc.md5.asp"--><%

dim crn_title, crn_description, crn_author, crn_copyright, crn_headadd, crn_bodyadd, crn_bodyaddwhere
dim crn_jsactive, crn_about, crn_aboutpage, crn_password, crn_newpassword, crn_exifactive

crn_title = cleanString(request.form("title"),0,50)
crn_description = cleanString(request.form("description"),0,255)
crn_author = cleanString(request.form("author"),0,50)
crn_copyright = cleanString(request.form("copyright"),0,100)
crn_headadd = cleanString(request.form("headadd"),0,2000)
crn_bodyadd = cleanString(request.form("bodyadd"),0,2000)
crn_bodyaddwhere = cleanByte(request.form("bodyaddwhere"))
crn_jsactive = request.form("jsactive")
if crn_jsactive <> 1 then crn_jsactive = 0
crn_exifactive = request.form("exifactive")
if crn_exifactive <> 1 then crn_exifactive = 0
crn_aboutpage = cleanString(request.form("aboutpage"),0,5000)
crn_password = trim(request.form("password"))
crn_newpassword = trim(request.form("newpassword"))

if not(crn_password = "" and crn_newpassword = "") then
	if crn_password <> "" and len(crn_newpassword) >= 5 then
		SQL = "SELECT config_password FROM tba_config WHERE config_id = 1"
		set rs = conn.execute(SQL)
		if rs("config_password") = md5(crn_password) then
			SQL = "UPDATE tba_config SET config_password = '" & md5(crn_newpassword) & "' WHERE config_id = 1"
			conn.execute(SQL)
		else
			Response.Redirect("errors.asp?c=config1")
		end if
	else
		Response.Redirect("errors.asp?c=config0")
	end if
end if

crn_about = 0
if crn_aboutpage <> "" then crn_about = 1

SQL = "UPDATE tba_config SET config_title = '" & crn_title & "', config_description = '" & crn_description & "', config_author = '" & crn_author & "', config_copyright = '" & crn_copyright & "', config_headadd = '" & crn_headadd & "', config_bodyadd = '" & crn_bodyadd & "', config_bodyaddwhere = " & crn_bodyaddwhere & ", config_aboutpage = '" & crn_aboutpage & "', config_about = " & crn_about & ", config_jsactive = " & crn_jsactive & ", config_exifactive = " & crn_exifactive & " WHERE config_id = 1"
conn.execute(SQL)

response.Redirect("admin.asp?module=config")


%>