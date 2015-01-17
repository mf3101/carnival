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
' * @version         SVN: $Id: mod.admin.tagedit.asp 18 2008-06-29 02:54:08Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"--><%

dim crn_id, crn_tagName, crn_tagType, crn_returnpage
crn_id = cleanLong(request.QueryString("id"))
crn_returnpage = cleanLong(request.QueryString("returnpage"))

SQL = "SELECT tag_name,tag_type FROM tba_tag WHERE tag_id = " & crn_id
set rs = dbManager.conn.execute(SQL)
if rs.eof then response.Redirect("admin.asp?module=tag-list")
crn_tagName = rs("tag_name")
crn_tagType = cbyte(rs("tag_type"))

%><h2>Modifica tag</h2>
	<form class="post" action="admin.asp?module=pro-tag" method="post">
		<div><input type="hidden" name="action" id="action" value="edit" />
		<input type="hidden" name="id" id="id" value="<%=crn_id%>" />
		<input type="hidden" name="returnpage" id="returnpage" value="<%=crn_returnpage%>" />
		<label for="name">nome tag</label>
		<input type="text" id="name" name="name" class="text" maxlength="50" value="<%=cleanOutputString(crn_tagName)%>" /></div>
		<div><label for="cropped">tipologia di tag</label>
		<select id="type" name="type">
			<option value="0"<% if crn_tagType = 0 then %> selected="selected"<% end if %>>Normale</option>
			<option value="1"<% if crn_tagType = 1 then %> selected="selected"<% end if %>>Comune</option>
		</select></div>
		
		<div class="nbuttons">
			<a href="admin.asp?module=tag-list&amp;page=<%=crn_returnpage%>">
				<span>
				<img src="<%=carnival_pathimages%>/lay-adm-ico-but-prev.gif" alt=""/> 
				indietro
				</span>
			</a>
			<button type="submit">
				<span class="a"><span class="b">
				<img src="<%=carnival_pathimages%>/lay-adm-ico-but-accept.gif" alt=""/> 
				modifica
				</span></span>
			</button>
		</div>
	</form>
	<div class="clear"></div>