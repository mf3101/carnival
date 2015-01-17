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
' * @version         SVN: $Id: tags.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
' nessun enviroment aggiuntivo
'*****************************************************

strPageTitle__ = lang__tags_title__
strPageTitleHead__ = config__title__ & " ::: " & strPageTitle__
dim blnViaJavascript
blnViaJavascript = false
dim intTagsCount
intTagsCount = 0 
%><!--#include file = "includes/inc.top.asp"-->
		<div class="tags cloud">
		<!--#include file = "includes/gen.tagcloud.asp"-->
		<%
		SQL = "SELECT tag_name FROM tba_tag WHERE tag_type = 1 AND tag_photos <> 0 ORDER BY tag_name"
		set rs = dbManager.Execute(SQL)
		%>
		</div><%
		if not rs.eof then %>
		<hr />
		<div class="tags common">
		<div class="title">tag comuni</div>
		<div class="tags">
		<%
		while not rs.eof
			%>
			<a href="photo.asp?tag=<%=rs("tag_name")%>"><%=rs("tag_name")%></a>&nbsp;
			<%
			rs.movenext
		wend
		%></div>
		</div><%
		end if
		%>
<!--#include file = "includes/inc.bottom.asp"-->