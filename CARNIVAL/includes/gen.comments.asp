<%
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
' * @version         SVN: $Id: gen.comments.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "inc.admin.checklogin.asp"--><%
'*****************************************************

dim blnIsAdmin
blnIsAdmin = isAdminLogged()

'se l'id non è impostato usa i commenti di tutte le foto
dim blnWholeComments
blnWholeComments = lngCurrentPhotoId__ = 0

'variabili db
dim lngDBCommentId, strDBCommentName, lngDBCommentPhoto
dim dtmDBCommentDate, strDBCommentContent, strDBCommentEmail, strDBCommentUrl, blnDBCommentAdmin

dim lngCommentCount		'commenti totali
dim lngCommentCounter   'counter per indicare il numero del commento stampato

'conta i commenti
if not blnWholeComments then
	SQL = "SELECT Count(tba_comment.comment_id) AS comments FROM tba_comment WHERE comment_photo = " & lngCurrentPhotoId__
else
	SQL = "SELECT Count(tba_comment.comment_id) AS comments " & _
		  "FROM tba_comment LEFT JOIN tba_photo ON tba_comment.comment_photo = tba_photo.photo_id " & _
		  "WHERE tba_photo.photo_active=1;"
end if
set rs = dbManager.Execute(SQL)
lngCommentCount = inputLong(rs("comments"))
lngCommentCounter = 1
if blnWholeComments then lngCommentCounter = lngCommentCount

%><div class="commentact"><%
if lngCommentCount = 0 then
	%><div class="empty"><%=lang__comments_nocomment__%></div></div><%
else
	%><%=replace(lang__comments_comments__,"%n",lngCommentCount)%><% 
	if not blnWholeComments then 
	%> - <img src="<%=getImagePath("lay-ico-act-comment.gif")%>" alt="" class="icon" /><a <% if not blnViaJavascript then %>href="#commenthere"<% else %>href="javascript:commentFormGo();"<% end if %>><%=lang__comments_postacomment__%></a><%
	end if %></div><%

	if not blnWholeComments then
		SQL = "SELECT comment_id, comment_name, comment_content, comment_email, comment_date, comment_url, comment_photo, comment_admin FROM tba_comment WHERE comment_photo = " & lngCurrentPhotoId__ & " ORDER BY comment_id"
	else
		SQL = "SELECT comment_id, comment_name, comment_content, comment_email, comment_date, comment_url, comment_photo, comment_admin " & _
		  "FROM tba_comment LEFT JOIN tba_photo ON tba_comment.comment_photo = tba_photo.photo_id " & _
		  "WHERE tba_photo.photo_active=1 " & _
		  "ORDER BY comment_id DESC"
	end if
	
	
	set dbPagination = new Class_ASPDbPagination

	if dbPagination.Paginate(dbManager.conn, dbManager.database, IIF(blnWholeComments,10,-1), null, SQL) then
		lngPaginationLooper__ = 0
		if not blnWholeComments then
			lngCommentCounter = dbPagination.Record
		else
			lngCommentCounter = lngCommentCounter-dbPagination.Record+1
		end if
		
		while not dbPagination.recordset.eof and ((lngPaginationLooper__ < dbPagination.RecordsPerPage) or (dbPagination.RecordsPerPage = 0 ))
		
			lngDBCommentId = server.htmlencode(dbPagination.recordset("comment_id"))
			strDBCommentName = server.htmlencode(dbPagination.recordset("comment_name"))
			strDBCommentContent = outBBCode(server.htmlencode(dbPagination.recordset("comment_content")))
			strDBCommentEmail = trim(server.htmlencode(dbPagination.recordset("comment_email")))
			dtmDBCommentDate = formatGMTDate(dbPagination.recordset("comment_date"),0,"dd/mm/yyyy hh:nn:ss")
			strDBCommentUrl = trim(server.htmlencode(dbPagination.recordset("comment_url")))
			lngDBCommentPhoto = dbPagination.recordset("comment_photo")
			blnDBCommentAdmin = inputBoolean(dbPagination.recordset("comment_admin"))
			%><hr /><div class="comment"><%
			if blnWholeComments then
				%><div class="photo"><a href="photo.asp?id=<%=lngDBCommentPhoto%>"><img src="<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & lngDBCommentPhoto & CARNIVAL_THUMBPOSTFIX%>.jpg" alt="photo" /></a></div><%
			end if
		%>	<% if blnIsAdmin then %><div class="delete"><a href="<% if not blnViaJavascript then %>comments_pro.asp?id=<%=lngDBCommentId%>&amp;action=delete<% else %>javascript:;<% end if %>" onclick="if (!confirm('il commento verr&agrave; cancellato definitivamente\nvuoi veramente continuare?')) <% if not blnViaJavascript then %>return false;<% else %>{ return false; } else { deleteComment(<%=lngDBCommentId%>); }<% end if %>"><img src="<%=getImagePath("lay-adm-ico-act-delcomment.gif")%>" alt="<%=lang__comments_delete__%>" class="icon" /><%=lang__comments_delete__%></a></div><% end if %><div class="header<% if blnDBCommentAdmin then %> admin<% end if %>"><span class="id">#<%=lngCommentCounter%></span><img src="<%=getImagePath("lay-ico-comment.gif")%>" alt="" class="icon" /><span class="date"><%=dtmDBCommentDate%></span> - <span class="name"><%
		if strDBCommentUrl <> "" then
		%><a href="<%=strDBCommentUrl%>"><%=strDBCommentName%></a><%
		else
		%><%=strDBCommentName%><%
		end if
		if blnDBCommentAdmin then %><small> [admin]</small><% end if
		
		%><% if blnIsAdmin and not blnDBCommentAdmin then %><small> [<em><a href="mailto:<%=strDBCommentEmail%>"><%=strDBCommentEmail%></a></em>]</small><% end if %></span>:</div><div class="comment"><%=strDBCommentContent%></div></div><div class="clear"></div>
			<%
		if not blnWholeComments then
			lngCommentCounter = lngCommentCounter+1
		else
			lngCommentCounter = lngCommentCounter-1
		end if
			
			dbPagination.recordset.movenext
			lngPaginationLooper__ = lngPaginationLooper__ + 1
		wend
		dbPagination.recordset.close
		
		if blnWholeComments then
		%><hr/><div class="pagenavigator"><div class="title">Pagine</div><div class="box"><%
		
		response.write dbPagination.printNavigator("<div class=""s"">mostra commenti da %RS a %RE di %RT</div><div class=""n"">%PC pagine [ %PN ]</div>",null,IIF(blnWholeComments,"","&amp;id=" & lngCurrentPhotoId__ & "#commentshere"),false)
		
		%></div></div><% 
		end if
	end if
end if

if not blnWholeComments then
	'form
	%>
	<div><a id="commenthere"></a></div><hr/>
	<% if blnViaJavascript then %><div class="commentact"><a href="javascript:commentForm();"><img src="<%=getImagePath("lay-ico-act-comment.gif")%>" alt="" class="icon" /><%=lang__comments_postacomment__%></a></div><% end if %>
	<div id="commentform"<% if blnViaJavascript and not blnShowCommentForm then %> style="display:none;overflow:hidden;"<% end if %>>
	<form id="formcomment" action="comments_pro.asp" class="comment" method="post"<% if blnViaJavascript then %> onsubmit="submitComment();return false;"<% end if%>>
		<div class="field"><label for="name"><%=lang__comments_form_name__%></label><input class="text" type="text" name="name" id="name" value="<%=outputHTMLString(getSubCookie("comment","name"))%>" /></div>
		<% if not blnIsAdmin then %><div class="field"><label for="url"><%=lang__comments_form_url__%></label><input class="text" type="text" name="url" id="url" value="<%
		if getSubCookie("comment","url") = "" then
			response.write "http://"
		else
			response.write outputHTMLString(getSubCookie("comment","url"))
		end if%>" /></div>
		<div class="field"><label for="email"><%=lang__comments_form_email__%></label><input class="text" type="text" name="email" id="email" value="<%=outputHTMLString(getSubCookie("comment","email"))%>" /></div>
		<div class="field"><label for="securitycode"><%=lang__comments_form_captcha__%></label>
		<!-- START WBSECURITY -->
		<img id="wbscode" src="includes/service.wbsecurity.asp?c=<%=noCache%>" style="vertical-align:middle;" alt="code" width="112" height="21" /><br/>
		<input type="text" id="securitycode" name="securitycode" maxlength="6" class="text" />
		</div>
		<!-- END WBSECURITY -->
        <% else %>
        <input type="hidden" name="url" id="url" value="" />
        <input type="hidden" name="email" id="email" value="" />
        <input type="hidden" name="securitycode" id="securitycode" value="" />
		<% end if %>
		<div class="field"><label for="comment"><%=lang__comments_form_comment__%></label><textarea name="comment" id="comment" rows="10" cols="30"><%
		if inputLong(getSubCookie("comment","id")) = lngCurrentPhotoId__ then
			response.write outputHTMLString(getSubCookie("comment","comment"))
		end if
		%></textarea>
		<div class="info"><%=lang__comments_form_extra__%></div>
		<div class="field"><input type="hidden" name="photoid" id="photoid" value="<%=lngCurrentPhotoId__%>" /><input type="submit" value="<%=lang__comments_form_send__%>" class="submit" /></div>
		</div>
	</form>
	</div><%
end if
%>