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
' * @version         SVN: $Id: mod.admin.setedit.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "inc.admin.check.asp"--><%
'*****************************************************

dim strAction, strReturnQuerystring
strAction = normalize(request.QueryString("action"),"edit","new")
strReturnQuerystring = request.QueryString("returnpage")

dim lngSetId
lngSetId = inputLong(request.QueryString("id"))

dim strSetName, strSetDescription, lngSetOrder, lngSetCover 

dim strButtonCaption,strSubTitle
if strAction <> "edit" then
	strSubTitle = "Nuovo set"
	strButtonCaption = "salva"
	
	lngSetId = 0
	strSetName = "!NOME DEL SET!"
	strSetDescription = ""
	lngSetOrder = 0
	lngSetCover = 0
else
	strSubTitle = "Modifica set"
	strButtonCaption = "modifica"
	
	SQL = "SELECT set_name, set_description, set_order, set_cover FROM tba_set WHERE set_id = " & lngSetId
	set rs = dbManager.Execute(SQL)
	if rs.eof then response.Redirect("admin.asp?module=photo-list")
	strSetName = rs("set_name")
	strSetDescription = rs("set_description")
	lngSetOrder = inputLong(rs("set_order"))
	lngSetCover = inputLong(rs("set_cover"))
end if



%><h2><%=strSubTitle%></h2>
	<form class="post" action="admin.asp?module=pro-set" method="post">
		<div><input type="hidden" name="action" id="action" value="<%=strAction%>" />
		<input type="hidden" name="id" id="id" value="<%=lngSetId%>" />
		<input type="hidden" name="returnpage" id="returnpage" value="<%=strReturnQuerystring%>" />
		<label for="name">nome</label>
		<input type="text" id="name" name="name" class="text" maxlength="50" value="<%=outputHTMLString(strSetName)%>" /></div>
		<div><label for="description">descrizione</label>
		<img id="setCoverimg" src="<%=IIF(lngSetCover=0,config__pathimages__ & "/thumb-set-empty.gif",CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & lngSetCover & CARNIVAL_THUMBPOSTFIX & ".jpg?nc=" & noCache)%>" alt="" class="photo-thumb"/><textarea id="description" name="description" cols="20" rows="10" style="width:460px;"><%=outputHTMLString(strSetDescription)%></textarea></div>
        
		<div>
        <label for="setCover">copertina set</label>
        <select style="width:250px;" name="setCover" id="setCover" onchange="if(this.value==0) { $('setCoverimg').src = '<%=config__pathimages__ & "/thumb-set-empty.gif"%>'} else {$('setCoverimg').src = '<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX%>'+this.value+'<%=CARNIVAL_THUMBPOSTFIX & ".jpg"%>'};">
        	<%
			SQL = "SELECT photo_id, photo_title FROM tba_photo WHERE photo_set = " & lngSetId
			set rs = dbManager.Execute(SQL)
			%><option value="0">nessuna foto selezionata</option><%
			while not rs.eof
				%><option value="<%=rs("photo_id")%>"<%if clng(lngSetCover) = clng(rs("photo_id")) then response.write " selected=""selected"""%>><%=outputHTMLString(rs("photo_title"))%></option><%
				rs.movenext
			wend
			%>
        </select>
        </div>
        
        <div>
		<label for="order">ordine</label>
		<input type="text" id="order" name="order" class="text" maxlength="7" value="<%=lngSetOrder%>"  />
        </div>
		<div class="nbuttons">
			<% if strAction = "edit" then %>
			<a href="admin.asp?module=set-list&amp;<%=readyToQuerystring(strReturnQuerystring)%>">
				<span>
				<img src="<%=getImagePath("lay-adm-ico-but-prev.gif")%>" alt=""/> 
				indietro
				</span>
			</a>
			<% end if %>
			<button type="submit">
				<span class="a"><span class="b">
				<img src="<%=getImagePath("lay-adm-ico-but-accept.gif")%>" alt=""/> 
				<%=strButtonCaption%>
				</span></span>
			</button>
		</div>
	</form>
	<div class="clear"></div>