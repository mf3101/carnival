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
' * @version         SVN: $Id: comments_pro.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "includes/inc.admin.checklogin.asp"-->
<!--#include file = "includes/class.safemailer.asp"-->
<!--#include file = "includes/inc.md5.asp"-->
<!--#include file = "includes/inc.wbsecurity.asp"--><%
'*****************************************************
	
dim blnIsAdmin : blnIsAdmin = isAdminLogged()

dim blnViaJavascript
blnViaJavascript = false
if cstr(request.form("js")) = "1" then blnViaJavascript = true
if cstr(request.querystring("js")) = "1" then blnViaJavascript = true

dim strErrorPage, strErrorUrl
strErrorUrl = "" : strErrorPage = "errors.asp"
if blnViaJavascript then strErrorPage = "inner.errors.asp"

dim lngCommentId, strCommentName, strCommentContent, strCommentEmail, strCommentUrl,lngCommentPhoto,dtmCommentDate,bytCommentAdmin

'**** START WBSECURITY ****************************************************
dim wbs_securitycode, wbs_currentsecuritycode, wbs_isvalid
wbs_securitycode = request.form("securitycode")
if session("wbsecurity-generator") = "" then
	'cookie non attivi
	wbs_isvalid = false
else
	wbs_currentsecuritycode = getSecurityCode(session("wbsecurity-generator"))
	session("wbsecurity-generator") = getSecurityCodeGenerator()
	wbs_isvalid = (wbs_currentsecuritycode = wbs_securitycode)
end if
'**** END WBSECURITY ******************************************************

dim strAction
strAction = normalize(request.QueryString("action"),"delete","post")

select case strAction
	case "post"
		lngCommentPhoto = inputLong(request.form("photoid"))
		
		SQL = "SELECT photo_id FROM tba_photo WHERE photo_id = " & lngCommentPhoto & " AND photo_active = 1"
		set rs = dbManager.Execute(SQL)
		if rs.eof then
			strErrorUrl = strErrorPage & "?c=comment0" & "&id=" & lngCommentPhoto & "&js=" & cbyte(blnViaJavascript)
			if blnViaJavascript then
				response.write("redirect>" & strErrorUrl)
				response.end
			else
				response.Redirect(strErrorUrl)
			end if
		end if
		
		call setSubCookie("comment","name",request.form("name"))
		call setSubCookie("comment","email",request.form("email"))
		call setSubCookie("comment","url",request.form("url"))
		call setSubCookie("comment","id",lngCommentPhoto)
		call setSubCookie("comment","comment",request.form("comment"))
		call setCookieExpires("comment",now + 365)
		
		if wbs_isvalid or blnIsAdmin then
			strCommentName = inputStringD(request.form("name"),0,25)
			strCommentContent = inBBCode(inputStringD(request.form("comment"),0,5000))
			strCommentEmail = inputStringD(request.form("email"),0,250)
			strCommentUrl = inputStringD(request.form("url"),0,250)
			if strCommentUrl = "http://" then strCommentUrl = ""
			dtmCommentDate = formatDBDate(now,CARNIVAL_DATABASE_TYPE)
			bytCommentAdmin = IIF(blnIsAdmin,1,0)
			
			if (strCommentName = "") or (strCommentContent = "") or ((not isValidEmail(strCommentEmail)) and not blnIsAdmin) then 
				strErrorUrl = strErrorPage & "?c=comment2" & "&id=" & lngCommentPhoto & "&js=" & cbyte(blnViaJavascript)
				if blnViaJavascript then
					response.write("redirect>" & strErrorUrl)
					response.end
				else
					response.Redirect(strErrorUrl)
				end if
			end if
			
			SQL = "INSERT INTO tba_comment (comment_name, comment_email, comment_url, comment_content, comment_photo, comment_date, comment_admin) VALUES " & _
				  "('" & formatDBString(strCommentName,null) & "','" & formatDBString(strCommentEmail,null) & "','" & formatDBString(strCommentUrl,null) & "','" & formatDBString(strCommentContent,null) & "'," & lngCommentPhoto & "," & dtmCommentDate & "," & bytCommentAdmin & ")"
			dbManager.Execute(SQL)
			call setSubCookie("comment","id",0)
			call setSubCookie("comment","comment","")
			
			'invia mail
			if not blnIsAdmin and config__mail_component__ <> "" and config__mail_percomment__ then
			
				Dim obj_Mailer
				Set obj_Mailer = new SafeMailer
				if obj_Mailer.CreateObjectIfExist(config__mail_component__) then				
					obj_Mailer.MailFrom = strCommentEmail
					obj_Mailer.MailTo = config__mail_address__
					obj_Mailer.subject = "Nuovo commento su '" & config__title__ & "'"
					obj_Mailer.BodyText = CARNIVAL_HOME & "photo.asp?id=" & lngCommentPhoto & vbcrlf & _
										  "--------------------------------------------------------------------" & vbcrlf & _
										  "Commento da " & strCommentName & " <" & strCommentEmail & "> " & vbcrlf & _
										  strCommentContent
					obj_Mailer.BodyHtml = "<p>Hai ricevuto un nuovo commento sul tuo photoblog &quot;" & config__title__ & "&quot;<br/><a href=""" & CARNIVAL_HOME & "photo.asp?id=" & lngCommentPhoto & """>vai alla foto commentata</a></p>" & vbcrlf & _
										  "<hr/>" & vbcrlf & _
										  "<p><strong>Commento da &quot;" & strCommentName & "&quot; &lt;" & strCommentEmail & "&gt;</strong></p>" & vbcrlf & _
										  "<p>" & outBBCode (server.htmlencode(strCommentContent)) & "</p>"
					obj_Mailer.MailServer = config__mail_host__
					if config__mail_port__ > 0 then obj_Mailer.MailPort = config__mail_port__
					if config__mail_user__ <> "" or config__mail_password__ <> "" then
						obj_Mailer.User = config__mail_user__
						obj_Mailer.Password = config__mail_password__
						obj_Mailer.Ssl = config__mail_ssl__
						obj_Mailer.Auth = config__mail_auth__
					end if
					
					call obj_Mailer.Send()
				end if	
				
			end if
			
		else
			strErrorUrl = strErrorPage & "?c=comment1" & "&id=" & lngCommentPhoto & "&js=" & cbyte(blnViaJavascript)
			if blnViaJavascript then
				response.write("redirect>" & strErrorUrl)
				response.end
			else
				response.Redirect(strErrorUrl)
			end if
		end if
	case "delete"
	
		lngCommentId = inputLong(request.QueryString("id"))
	
		SQL = "SELECT comment_photo FROM tba_comment WHERE comment_id = " & lngCommentId
		set rs = dbManager.Execute(SQL)
		
		if not rs.eof then
			lngCommentPhoto = rs("comment_photo")
		end if
		
		if blnIsAdmin then
			SQL = "DELETE * FROM tba_comment WHERE comment_id = " & lngCommentId
			dbManager.Execute(SQL)
		end if
	
end select

if blnViaJavascript then
	response.write("redirect>" & "inner.comments.asp?id=" & lngCommentPhoto & "&js=1")
	response.end
else
	response.redirect("comments.asp?id=" & lngCommentPhoto)
end if
%>