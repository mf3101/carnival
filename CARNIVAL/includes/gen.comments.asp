<%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		gen.comments.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.checklogin.asp"-->
<%

dim crn_isadmin
crn_isadmin = crnFunc_AdminLoggedIn()

dim crn_commentId, crn_commentName, crn_commentPhoto, crn_commentDate, crn_commentContent, crn_commentEmail, crn_commentUrl
dim crn_commentCount, crn_commentCounter

if crnPhotoId <> 0 then
	SQL = "SELECT Count(tba_comment.comment_id) AS comments FROM tba_comment WHERE comment_photo = " & crnPhotoId
else
	SQL = "SELECT Count(tba_comment.comment_id) AS comments " & _
		  "FROM tba_comment LEFT JOIN tba_photo ON tba_comment.comment_photo = tba_photo.photo_id " & _
		  "WHERE tba_photo.photo_active=1;"
end if
set rs = conn.execute(SQL)
crn_commentCount = rs("comments")
crn_commentCounter = 1
if crnPhotoId = 0 then crn_commentCounter = crn_commentCount

%><div class="commentact"><%
if crn_commentCount = 0 then
	%><div class="empty"><%=crnLang_comments_nocomment%></div></div><%
else
	%><%=replace(crnLang_comments_comments,"%n",crn_commentCount)%><% 
	if crnPhotoId <> 0 then 
	%> - <img src="<%=carnival_pathimages%>lay-ico-act-comment.gif" alt="" class="icon" /><a <% if not crn_viaJs then %>href="#commenthere"<% else %>href="javascript:commentFormGo();"<% end if %>><%=crnLang_comments_postacomment%></a><% 
	else
	%><br/><%=replace(crnLang_comments_lastcomments,"%n",10)%><%
	end if %></div><%

	if crnPhotoId <> 0 then
		SQL = "SELECT comment_id, comment_name, comment_content, comment_email, comment_date, comment_url, comment_photo FROM tba_comment WHERE comment_photo = " & crnPhotoId & " ORDER BY comment_id"
	else
		SQL = "SELECT TOP 10 comment_id, comment_name, comment_content, comment_email, comment_date, comment_url, comment_photo " & _
		  "FROM tba_comment LEFT JOIN tba_photo ON tba_comment.comment_photo = tba_photo.photo_id " & _
		  "WHERE tba_photo.photo_active=1 " & _
		  "ORDER BY comment_id DESC"
	end if
	
	set rs = conn.execute(SQL)
	while not rs.eof
		crn_commentId = server.htmlencode(rs("comment_id"))
		crn_commentName = server.htmlencode(rs("comment_name"))
		crn_commentContent = applyCode(server.htmlencode(rs("comment_content")))
		crn_commentEmail = server.htmlencode(rs("comment_email"))
		crn_commentDate = formatGMTDate(rs("comment_date"),0,"dd/mm/yyyy hh:nn:ss")
		crn_commentUrl = server.htmlencode(rs("comment_url"))
		crn_commentPhoto = rs("comment_photo")
		%><hr /><div class="comment"><%
		if crnPhotoId = 0 then
			%><div class="photo"><a href="photo.asp?id=<%=crn_commentPhoto%>"><img src="<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crn_commentPhoto & CARNIVAL_THUMBPOSTFIX%>.jpg" alt="photo" /></a></div><%
		end if
	%>	<% if crn_isadmin then %><div class="delete"><a href="<% if not crn_viaJs then %>comments_pro.asp?id=<%=crn_commentId%>&amp;action=delete<% else %>javascript:;<% end if %>" onclick="if (!confirm('il commento verr&agrave; cancellato definitivamente\nvuoi veramente continuare?')) <% if not crn_viaJs then %>return false;<% else %>{ return false; } else { deleteComment(<%=crn_commentId%>); }<% end if %>"><img src="<%=carnival_pathimages%>lay-adm-ico-act-delcomment.gif" alt="<%=crnLang_comments_delete%>" class="icon" /><%=crnLang_comments_delete%></a></div><% end if %><div class="header"><span class="id">#<%=crn_commentCounter%></span><img src="<%=carnival_pathimages%>lay-ico-comment.gif" alt="" class="icon" /><span class="date"><%=crn_commentDate%></span> - <span class="name"><%
	if crn_commentUrl <> "" then
	%><a href="<%=crn_commentUrl%>"><%=crn_commentName%></a><%
	else
	%><%=crn_commentName%><%
	end if
	
	%></span>:</div><div class="comment"><%=crn_commentContent%></div></div><div class="clear"></div>
		<%
		if crnPhotoId = 0 then
			crn_commentCounter = crn_commentCounter - 1
		else
			crn_commentCounter = crn_commentCounter + 1
		end if
		rs.movenext
	wend
end if

if crnPhotoId <> 0 then
	'form
	%>
	<div><a id="commenthere"></a></div><hr/>
	<% if crn_viaJs then %><div class="commentact"><a href="javascript:commentForm();"><img src="<%=carnival_pathimages%>lay-ico-act-comment.gif" alt="" class="icon" /><%=crnLang_comments_postacomment%></a></div><% end if %>
	<div id="commentform"<% if crn_viaJs and not crn_showCommentForm then %> style="display:none;"<% end if %>>
	<form id="formcomment" action="comments_pro.asp" class="comment" method="post"<% if crn_viaJs then %> onsubmit="submitComment();return false;"<% end if%>>
		<div class="field"><label for="name"><%=crnLang_comments_form_name%></label><input class="text" type="text" name="name" id="name" value="<%=cleanOutputString(request.Cookies(CARNIVAL_CODE & "comment")("name"))%>" /></div>
		<div class="field"><label for="url"><%=crnLang_comments_form_url%></label><input class="text" type="text" name="url" id="url" value="<%
		if request.Cookies(CARNIVAL_CODE & "comment")("url") = "" then
			response.write "http://"
		else
			response.write cleanOutputString(request.Cookies(CARNIVAL_CODE & "comment")("url"))
		end if%>" /></div>
		<div class="field"><label for="email"><%=crnLang_comments_form_email%></label><input class="text" type="text" name="email" id="email" value="<%=cleanOutputString(request.Cookies(CARNIVAL_CODE & "comment")("email"))%>" /></div>
		<div class="field"><label for="securitycode"><%=crnLang_comments_form_captcha%></label>
		<!-- START WBSECURITY -->
		<img id="wbscode" src="includes/service.wbsecurity.asp?c=<%=noCache%>" style="vertical-align:middle;" alt="code" width="112" height="21" /><br/>
		<input type="text" id="securitycode" name="securitycode" maxlength="6" class="text" />
		</div>
		<!-- END WBSECURITY -->
		<div class="field"><label for="comment"><%=crnLang_comments_form_comment%></label><textarea name="comment" id="comment" rows="10" cols="30"><%
		if request.Cookies(CARNIVAL_CODE & "comment")("id") = crnPhotoId then
			response.write cleanOutputString(request.Cookies(CARNIVAL_CODE & "comment")("comment"))
		end if
		%></textarea>
		<div class="info"><%=crnLang_comments_form_extra%></div>
		<div class="field"><input type="hidden" name="photoid" id="photoid" value="<%=crnPhotoId%>" /><input type="submit" value="<%=crnLang_comments_form_send%>" class="submit" /></div>
		</div>		
	</form>
	</div><%
end if
%>