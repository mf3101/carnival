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
' * @version         SVN: $Id: mod.admin.setedit.asp 28 2008-07-04 12:27:48Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"--><%

dim crn_action, crn_returnpage
crn_action = normalize(request.QueryString("action"),"edit","new")
crn_returnpage = cleanLong(request.QueryString("returnpage"))

dim crn_setName, crn_setDescription, crn_setOrder, crn_setCover 

dim crn_id
crn_id = cleanLong(request.QueryString("id"))

dim crn_send,crn_subtitle
if crn_action <> "edit" then
	crn_subtitle = "Nuovo set"
	crn_send = "salva"
	
	crn_id = 0
	crn_setName = "!NOME DEL SET!"
	crn_setDescription = ""
	crn_setOrder = 0
	crn_setCover = 0
else
	crn_subtitle = "Modifica set"
	crn_send = "modifica"
	
	SQL = "SELECT set_name, set_description, set_order, set_cover FROM tba_set WHERE set_id = " & crn_id
	set rs = dbManager.conn.execute(SQL)
	if rs.eof then response.Redirect("admin.asp?module=photo-list")
	crn_setName = rs("set_name")
	crn_setDescription = rs("set_description")
	crn_setOrder = cleanLong(rs("set_order"))
	crn_setCover = cleanLong(rs("set_cover"))
end if



%><h2><%=crn_subtitle%></h2>
	<form class="post" action="admin.asp?module=pro-set" method="post">
		<div><input type="hidden" name="action" id="action" value="<%=crn_action%>" />
		<input type="hidden" name="id" id="id" value="<%=crn_id%>" />
		<input type="hidden" name="returnpage" id="returnpage" value="<%=crn_returnpage%>" />
		<label for="name">nome</label>
		<input type="text" id="name" name="name" class="text" maxlength="50" value="<%=cleanOutputString(crn_setName)%>" /></div>
		<div><label for="description">descrizione</label>
		<img id="setCoverimg" src="<%=IIF(crn_setCover=0,carnival_pathimages & "/thumb-set-empty.gif",CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crn_setCover & CARNIVAL_THUMBPOSTFIX & ".jpg?nc=" & noCache)%>" alt="" class="photo-thumb"/><textarea id="description" name="description" cols="20" rows="10" style="width:460px;"><%=cleanOutputString(crn_setDescription)%></textarea></div>
        
		<div>
        <label for="setCover">copertina set</label>
        <select style="width:250px;" name="setCover" id="setCover" onchange="if(this.value==0) { $('setCoverimg').src = '<%=carnival_pathimages & "/thumb-set-empty.gif"%>'} else {$('setCoverimg').src = '<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX%>'+this.value+'<%=CARNIVAL_THUMBPOSTFIX & ".jpg"%>'};">
        	<%
			SQL = "SELECT photo_id, photo_title FROM tba_photo WHERE photo_set = " & crn_id
			set rs = dbManager.conn.execute(SQL)
			%><option value="0">nessuna foto selezionata</option><%
			while not rs.eof
				%><option value="<%=rs("photo_id")%>"<%if clng(crn_setCover) = clng(rs("photo_id")) then response.write " selected=""selected"""%>><%=cleanOutputString(rs("photo_title"))%></option><%
				rs.movenext
			wend
			%>
        </select>
        </div>
        
        <div>
		<label for="order">ordine</label>
		<input type="text" id="order" name="order" class="text" maxlength="7" value="<%=crn_setOrder%>"  />
        </div>
		<div class="nbuttons">
			<% if crn_action = "edit" then %>
			<a href="admin.asp?module=set-list&amp;page=<%=crn_returnpage%>">
				<span>
				<img src="<%=carnival_pathimages%>/lay-adm-ico-but-prev.gif" alt=""/> 
				indietro
				</span>
			</a>
			<% end if %>
			<button type="submit">
				<span class="a"><span class="b">
				<img src="<%=carnival_pathimages%>/lay-adm-ico-but-accept.gif" alt=""/> 
				<%=crn_send%>
				</span></span>
			</button>
		</div>
	</form>
	<div class="clear"></div>