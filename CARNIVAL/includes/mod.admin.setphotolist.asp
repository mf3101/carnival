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
' * @version         SVN: $Id: mod.admin.setphotolist.asp 28 2008-07-04 12:27:48Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"-->
	<div class="admin-minibutton"><img src="<%=carnival_pathimages%>/lay-adm-ico-id-set.gif" alt="" /><a href="admin.asp?module=set-list&amp;page=<%=request.QueryString("returnpage")%>">torna ai set</a></div>
	<h2>Gestione set &raquo; foto</h2>
	<div class="clear"></div>
	<%	
	dim crn_id, crn_setName, crn_setPhotos
	crn_id = cleanLong(request.QueryString("id"))
	
	SQL = "SELECT set_name, set_photos FROM tba_set WHERE set_id = " & crn_id
	set rs = dbManager.conn.execute(SQL)
	if rs.eof then response.Redirect("admin.asp?module=set-list")
	crn_setName = rs("set_name")
	crn_setPhotos = rs("set_photos")
	%>
		<table class="post">
            <tr class="head">
            	<td class="img"><img src="<%=carnival_pathimages%>lay-adm-ico-id-set.gif" alt="set" /></td>
                <td class="id"><%=crn_id%></td>
				<td class="title"><%=crn_setName%></td>
				<td class="photos"><%=crn_setPhotos%> foto</td>
            </tr>
        </table>
        
    <%
	dim crn_photoOrder, crn_photoActive
	
	SQL = "SELECT photo_id, photo_title, photo_active, photo_order FROM tba_photo WHERE photo_set = " & crn_id & " ORDER BY photo_order, photo_id DESC"
	
	set dbPagination = new Class_ASPDbPagination
	dbPagination.RecordsPerPageDefault = crnPaginationPerPage
	
	if dbPagination.Paginate(dbManager.conn, dbManager.database, null, null, SQL) then
		%>
        <form action="admin.asp?module=pro-photo-edit" method="post" onsubmit="if(!multiValid()) { alert('Impossibile eseguire l\'operazione: nessun elemento selezionato'); return false; }">
        <input type="hidden" name="action" id="action" value="multi" />
        <input type="hidden" name="setid" id="setid" value="<%=crn_id%>" />
        <input type="hidden" name="returnpage" id="returnpage" value="<%=dbPagination.Page%>" />
		<table class="post">
            <tr class="head">
            	<td class="img"></td>
                <td class="id">ID</td>
				<td class="title">TITOLO</td>
				<td class="order">ORD</td>
                <td class="act"><input type="checkbox" onchange="multiselAll(this.checked);" /></td>
            </tr>
		<%
	
		crnPaginationLooper = 0
		crnCounter = 0
		if dbPagination.recordset.eof then
			%><div class="infobox">nessuna foto presente nel set</div><%
		end if
		
		while not dbPagination.recordset.eof and (crnPaginationLooper < dbPagination.RecordsPerPage)
		
			crnPhotoId = dbPagination.recordset("photo_id")
			crnPhotoTitle = dbPagination.recordset("photo_title")
			crn_photoActive = cleanBool(dbPagination.recordset("photo_active"))
			crn_photoOrder = cleanLong(dbPagination.recordset("photo_order"))
			crnCounter = crnCounter + 1
			
			%>
			<tr<%if not crn_photoActive then response.write " class=""locked"""%>>
				<td class="img"><a href="photo.asp?id=<%=crnPhotoId%>" target="_blank" onmouseover="showThumbBaloon('<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crnPhotoId & CARNIVAL_THUMBPOSTFIX & ".jpg?nc=" & noCache%>',event);" onmouseout="hideThumbBaloon();"><img src="<%=carnival_pathimages%>lay-adm-ico-id-photo.gif" alt="photo" /></a></td>
				<td class="id"><%=crnPhotoId%></td>
				<td class="title"><%=crnPhotoTitle%></td>
                <td class="order"><a href="javascript:;" onclick="sendValueToPage('inserisci un valore numerico per l\'ordinamento',<%=crn_photoOrder%>,'admin.asp?module=pro-photo-edit&amp;action=order&amp;id=<%=crnPhotoId%>&amp;returnpage=<%=dbPagination.Page%>&amp;setid=<%=crn_id%>&amp;order=')"><%=crn_photoOrder%></a></td>
                <td class="act">
                <input type="hidden" name="multiid<%=crnCounter%>" id="multiid<%=crnCounter%>" value="<%=crnPhotoId%>" />
                <input type="checkbox" name="multisel<%=crnCounter%>" id="multisel<%=crnCounter%>" value="1" />
                </td>
			</tr>
			<%
		
			dbPagination.recordset.movenext
			crnPaginationLooper = crnPaginationLooper + 1
		wend
		dbPagination.recordset.close
		%></table>
		<div class="massactionbox"><div class="title">Azioni</div><div class="box sbuttons">
        <button type="submit" id="multiaction" name="multiaction" value="order" onclick="if (!confirm('vuoi veramente reimpostare l\'ordine dei set selezionati?')) return false;">imposta ordine <img src="<%=carnival_pathimages%>lay-adm-ico-act-order.gif" alt="" class="licon" /></button> <input type="text" value="0" name="order" id="order" style="width:30px;" />
        <div class="hrlight"></div>
        <button type="submit" id="multiaction" name="multiaction" value="moveset" onclick="if (!confirm('vuoi veramente spostare nel set tutte le foto selezionate?')) return false;">sposta nel set <img src="<%=carnival_pathimages%>lay-adm-ico-id-set.gif" alt="" class="licon" /></button> <select style="width:150px;" name="set" id="set"><%=generateOptionsSets(crn_id)%></select>
        <% if crn_id > 1 then %>
        <div class="hrlight"></div>
        <button type="submit" id="multiaction" name="multiaction" value="removeset" onclick="if (!confirm('vuoi veramente rimuovere le foto selezionate dal set?')) return false;">rimuovi dal set <img src="<%=carnival_pathimages%>lay-adm-ico-act-del.gif" alt="" class="licon" /></button><% end if %>
		</div></div>
		<div class="pagenavigator"><div class="title">Pagine</div><div class="box"><%
		
		response.write dbPagination.printNavigator("<div class=""s"">mostra foto da %RS a %RE di %RT</div><div class=""n"">%PC pagine [ %PN ] [ <a href=""?module=set-photo-list&amp;id=" & crn_id & "&amp;perpage=500"">tutti</a> ]</div>",null,"&amp;module=set-photo-list&amp;id=" & crn_id,true)
		%></div></div><%
	else
		response.redirect "errors.asp?c=query0"
	end if
	%>
    
	<script type="text/javascript">/*<![CDATA[*/
	var thumbBaloon = new Baloon();
	thumbBaloon.start('thumb','thumbBaloon',null,null,'',0,0,false);
	$('baloonthumbcontent').appendChild(createImg('baloonthumbimg','',''));
	
	function showThumbBaloon(img,event) {
		$('baloonthumbimg').src=img;
		thumbBaloon.forceShow('relative',(is_ie?window.event.clientX:event.clientX)-60,(is_ie?window.event.clientY:event.clientY)+20);
	}
	function hideThumbBaloon() {
		thumbBaloon.forceHide();
	}/*]]>*/
	</script>