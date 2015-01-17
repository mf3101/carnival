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
' * @version         SVN: $Id: mod.admin.proconfig.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "inc.admin.check.asp"-->
<!--#include file = "class.safemailer.asp"-->
<!--#include file = "inc.md5.asp"-->
<!--#include file = "inc.func.photo.asp"--><%
'*****************************************************
'* - safemailer per emailtest
'* - func.photo per il ricalcolo delle date autopub
'*****************************************************

dim strConfigTitle, strConfigDescription, strConfigAuthor, strConfigCopyright, strConfigHeadAdd, strConfigBodyAdd, strConfigBodyAddwhere
dim blnConfigJSActive, blnConfigJSNavigatorActive, strConfigParent, blnConfigAbout, strConfigAboutContent, strConfigPassword, strConfigNewPassword, blnConfigExifActive
dim strConfigAutopub, strConfigAutopubtemp, bytConfigMode
dim strConfigMailComponent, strConfigMailAddress, strConfigMailHost, intConfigMailPort
dim strConfigMailUser, strConfigMailPassword, bytConfigMailSsl, bytConfigMailAuth
dim strConfigMailPercomment

dim strMode
dim blnTestMail

strMode = normalize(request.form("configmode"),"full|navigation|automation|mail-component|mail-notifications|about|code|password","general")
blnTestMail = inputBoolean(request.Form("mailtest"))

if strMode = "general" or strMode = "full" then 
	strConfigTitle = inputStringD(request.form("title"),0,50)
	strConfigDescription = inputStringD(request.form("description"),0,255)
	strConfigAuthor = inputStringD(request.form("author"),0,50)
	strConfigCopyright = inputStringD(request.form("copyright"),0,100)
end if
if strMode = "navigation" or strMode = "full" then 
	blnConfigJSActive = inputBoolean(request.form("jsactive"))
	blnConfigJSNavigatorActive = inputBoolean(request.form("jsnavigatoractive"))
	blnConfigExifActive = inputBoolean(request.form("exifactive"))
	bytConfigMode = inputByte(request.Form("mode"))
end if
if strMode = "automation" or strMode = "full" then 
	'---
	strConfigAutopubtemp = inputByte(request.form("autopub_mode"))
	strConfigAutopub = cstr(strConfigAutopubtemp)
	select case strConfigAutopubtemp
		case 0
			strConfigAutopub = strConfigAutopub & "00"
		case 1
			'giorno della settimana
			strConfigAutopubtemp = inputByte(request.form("autopub1_day"))
			if strConfigAutopubtemp < 1 or strConfigAutopubtemp > 7 then strConfigAutopubtemp = 1
			strConfigAutopub = strConfigAutopub & right("00"&strConfigAutopubtemp,2)
		case 2
			'giorno del mese
			strConfigAutopubtemp = inputByte(request.form("autopub2_day"))
			if strConfigAutopubtemp < 1 or strConfigAutopubtemp > 31 then strConfigAutopubtemp = 1
			strConfigAutopub = strConfigAutopub & right("00"&strConfigAutopubtemp,2)
	end select
	'ora
	strConfigAutopubtemp = inputByte(request.form("autopub_hours"))
	if strConfigAutopubtemp < 0 or strConfigAutopubtemp > 23 then strConfigAutopubtemp = 0
	strConfigAutopub = strConfigAutopub & right("00"&strConfigAutopubtemp,2)
	'minuto
	strConfigAutopubtemp = inputByte(request.form("autopub_minutes"))
	if strConfigAutopubtemp < 0 or strConfigAutopubtemp > 59 then strConfigAutopubtemp = 0
	strConfigAutopub = strConfigAutopub & right("00"&strConfigAutopubtemp,2)
	'---
end if
if strMode = "mail-component" or strMode = "full" then 
	strConfigMailComponent = trim(inputStringD(request.form("mailcomponent"),0,30))
	strConfigMailHost = inputStringD(request.form("mailhost"),0,100)
	intConfigMailPort = inputInteger(request.form("mailport"))
	if intConfigMailPort < 0 or intConfigMailPort > 32000 then intConfigMailPort = 0
	strConfigMailUser = inputStringD(request.form("mailuser"),0,50)
	strConfigMailPassword = inputStringD(request.form("mailpassword"),0,50)
	bytConfigMailSsl = inputByte(request.form("mailssl"))
	bytConfigMailAuth = inputByte(request.form("mailauth"))
end if
if strMode = "mail-notifications" or strMode = "full" then
	strConfigMailAddress = inputStringD(request.form("mailaddress"),0,100)
	strConfigMailPercomment = inputByte(request.form("mailpercomment"))
end if
if strMode = "about" or strMode = "full" then 
	strConfigAboutContent = inputStringD(request.form("aboutpage"),0,5000)
	strConfigParent = inputStringD(request.form("parent"),0,250)
end if
if strMode = "code" or strMode = "full" then 
	strConfigHeadAdd = inputStringD(request.form("headadd"),0,2000)
	strConfigBodyAdd = inputStringD(request.form("bodyadd"),0,2000)
	strConfigBodyAddwhere = inputByte(request.form("bodyaddwhere"))
end if
if strMode = "password" or strMode = "full" then 
	strConfigPassword = trim(request.form("password"))
	strConfigNewPassword = trim(request.form("newpassword"))
end if

'-------------------------------------------------------------------------------

if strMode = "password" or strMode = "full" then 
	if not(strConfigPassword = "" and strConfigNewPassword = "") or strMode <> "full" then
		if strConfigPassword <> "" and len(strConfigNewPassword) >= 5 then
			SQL = "SELECT config_password FROM tba_config"
			set rs = dbManager.Execute(SQL)
			if rs("config_password") = md5(strConfigPassword) then
				SQL = "UPDATE tba_config SET config_password = '" & md5(strConfigNewPassword) & "'"
				dbManager.Execute(SQL)
			else
				Response.Redirect("errors.asp?c=config1")
			end if
		else
			Response.Redirect("errors.asp?c=config0")
		end if
	end if
end if

'-------------------------------------------------------------------------------
if strMode <> "password" then
	SQL = "UPDATE tba_config SET "
	
	if strMode = "general" or strMode = "full" then
		SQL = SQL & ",config_title = '" & formatDBString(strConfigTitle,null) & "', " & _
					 "config_description = '" & formatDBString(strConfigDescription,null) & "', " & _
					 "config_author = '" & formatDBString(strConfigAuthor,null) & "', " & _
					 "config_copyright = '" & formatDBString(strConfigCopyright,null) & "'"
	end if
	if strMode = "navigation" or strMode = "full" then 
		SQL = SQL & ", config_jsactive = " & formatDbBool(blnConfigJSActive) & ", " & _
					 "config_jsnavigatoractive = " & formatDbBool(blnConfigJSNavigatorActive) & ", " & _
					 "config_exifactive = " & formatDbBool(blnConfigExifActive) & ", " & _
					 "config_mode = " & bytConfigMode
	end if
	if strMode = "automation" or strMode = "full" then 
		SQL = SQL & ", config_autopub = " & strConfigAutopub
	end if
	if strMode = "mail-component" or strMode = "full" then 
		SQL = SQL & ", config_mail_component = '" & formatDBString(strConfigMailComponent,null) & "', " & _
					 "config_mail_host = '" & formatDBString(strConfigMailHost,null) & "', " & _
					 "config_mail_port = " & intConfigMailPort & ", " & _
					 "config_mail_user = '" & formatDBString(strConfigMailUser,null) & "', "
	if strConfigMailPassword <> "imentecarnival" then SQL = SQL & "config_mail_password = '" & formatDBString(strConfigMailPassword,null) & "', "
		SQL = SQL &  "config_mail_ssl = " & bytConfigMailSsl & ", " & _
					 "config_mail_auth = " & bytConfigMailAuth
	end if
	if strMode = "mail-notifications" or strMode = "full" then 
		SQL = SQL & ", config_mail_percomment = " & strConfigMailPercomment & ", " & _
					 "config_mail_address = '" & formatDBString(strConfigMailAddress,null) & "'"
	end if
	if strMode = "about" or strMode = "full" then 
		blnConfigAbout = 0
		if strConfigAboutContent <> "" then blnConfigAbout = 1
		SQL = SQL & ",config_aboutpage = '" & formatDBString(strConfigAboutContent,null) & "', " & _
					 "config_about = " & blnConfigAbout & ", " & _
					 "config_parent = '" & formatDBString(strConfigParent,null) & "'"
	end if
	if strMode = "code" or strMode = "full" then 
		SQL = SQL & ",config_headadd = '" & formatDBString(strConfigHeadAdd,null) & "', " & _
					 "config_bodyadd = '" & formatDBString(strConfigBodyAdd,null) & "', " & _
					 "config_bodyaddwhere = " & strConfigBodyAddwhere
	end if
	SQL = replace(SQL,"SET ,","SET ") & ""
	
	dbManager.Execute(SQL)
end if

if (strMode = "automation" or strMode = "full") and (config__autopub__ <> strConfigAutopub) then 
	'alla modifica 
	config__autopub__ = strConfigAutopub
	call syncAutoPub()
end if


if blnTestMail and strMode = "mail-component" then
	
	Dim objMailer,strTestmailInfo
	blnTestMail = "none"
	Set objMailer = new SafeMailer
	objMailer.debug = true
	if objMailer.CreateObjectIfExist(strConfigMailComponent) then
		blnTestMail = "done"
	
		objMailer.MailFrom = config__mail_address__
		objMailer.MailTo = config__mail_address__
		objMailer.subject = "Carnival Mail Test"
		objMailer.BodyText = "l'invio mail da Carnival funziona correttamente."
		objMailer.MailServer = strConfigMailHost
		if intConfigMailPort > 0 then objMailer.MailPort = intConfigMailPort
		if strConfigMailUser <> "" or strConfigMailPassword <> "" then
			objMailer.User = strConfigMailUser
			objMailer.Password = IIF(strConfigMailPassword="imentecarnival",config__mail_password__,strConfigMailPassword)
			objMailer.Ssl = bytConfigMailSsl
			objMailer.Auth = bytConfigMailAuth
		end if
		
		strTestmailInfo = objMailer.Send()
		if strTestmailInfo <> "" then blnTestMail = "none"
		
	end if

	response.Redirect("admin.asp?module=config&mode="&strMode&"&action=done&mailtest=" & blnTestMail & "&mailtestinfo=" & server.URLEncode(strTestmailInfo))
else
	response.Redirect("admin.asp?module=config&mode="&strMode&"&action=done")
end if




%>