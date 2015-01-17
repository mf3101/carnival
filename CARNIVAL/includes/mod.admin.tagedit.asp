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
' * @version         SVN: $Id: mod.admin.tagedit.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "inc.admin.check.asp"--><%
'*****************************************************

dim strReturnQuerystring
strReturnQuerystring = request.QueryString("returnpage")

dim lngTagId
lngTagId = inputLong(request.QueryString("id"))

dim strTagName, bytTagType
SQL = "SELECT tag_name,tag_type FROM tba_tag WHERE tag_id = " & lngTagId
set rs = dbManager.Execute(SQL)
if rs.eof then response.Redirect("admin.asp?module=tag-list")
strTagName = rs("tag_name")
bytTagType = cbyte(rs("tag_type"))

%><h2>Modifica tag</h2>
	<form class="post" action="admin.asp?module=pro-tag" method="post">
		<div><input type="hidden" name="action" id="action" value="edit" />
		<input type="hidden" name="id" id="id" value="<%=lngTagId%>" />
		<input type="hidden" name="returnpage" id="returnpage" value="<%=strReturnQuerystring%>" />
		<label for="name">nome tag</label>
		<input type="text" id="name" name="name" class="text" maxlength="50" value="<%=outputHTMLString(strTagName)%>" /></div>
		<div><label for="cropped">tipologia di tag</label>
		<select id="type" name="type">
			<option value="0"<% if bytTagType = 0 then %> selected="selected"<% end if %>>Normale</option>
			<option value="1"<% if bytTagType = 1 then %> selected="selected"<% end if %>>Comune</option>
		</select></div>
		
		<div class="nbuttons">
			<a href="admin.asp?module=tag-list&amp;<%=readyToQuerystring(strReturnQuerystring)%>">
				<span>
				<img src="<%=getImagePath("lay-adm-ico-but-prev.gif")%>" alt=""/> 
				indietro
				</span>
			</a>
			<button type="submit">
				<span class="a"><span class="b">
				<img src="<%=getImagePath("lay-adm-ico-but-accept.gif")%>" alt=""/> 
				modifica
				</span></span>
			</button>
		</div>
	</form>
	<div class="clear"></div>