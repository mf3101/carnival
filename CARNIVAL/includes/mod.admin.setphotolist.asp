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
' * @version         SVN: $Id: mod.admin.setphotolist.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "inc.admin.check.asp"--><%
'*****************************************************

%>
	<div class="admin-minibutton"><img src="<%=getImagePath("lay-adm-ico-id-set.gif")%>" alt="" /><a href="admin.asp?module=set-list&amp;<%=readyToQuerystring(request.QueryString("returnpage"))%>">torna ai set</a></div>
	<h2>Gestione set &raquo; foto</h2>
	<div class="clear"></div>
	<%	
	
	dim strOrderbyQuerystring
	strOrderbyQuerystring = ""
	
	dim lngSetId, strSetName, lngSetPhotos
	lngSetId = inputLong(request.QueryString("id"))
	
	SQL = "SELECT set_name, set_photos FROM tba_set WHERE set_id = " & lngSetId
	set rs = dbManager.Execute(SQL)
	if rs.eof then response.Redirect("admin.asp?module=set-list")
	strSetName = rs("set_name")
	lngSetPhotos = rs("set_photos")
	%>
		<table class="post">
            <tr class="head">
            	<td class="img"><img src="<%=getImagePath("lay-adm-ico-id-set.gif")%>" alt="set" /></td>
                <td class="id"><%=lngSetId%></td>
				<td class="title"><%=strSetName%></td>
				<td class="photos"><%=lngSetPhotos%> foto</td>
            </tr>
        </table>
        
    <%
	
	SQL = "SELECT photo_id, photo_title, photo_active, photo_order FROM tba_photo WHERE photo_set = " & lngSetId & " ORDER BY photo_order, photo_pub DESC"
	
	set dbPagination = new Class_ASPDbPagination
	dbPagination.RecordsPerPageDefault = intRecordsPerPage__
	
	if dbPagination.Paginate(dbManager.conn, dbManager.database, null, null, SQL) then
		%>
        <form action="admin.asp?module=pro-photo-edit" method="post" onsubmit="if(!multiValid()) { alert('Impossibile eseguire l\'operazione: nessun elemento selezionato'); return false; }">
        <input type="hidden" name="action" id="action" value="multi" />
        <input type="hidden" name="setid" id="setid" value="<%=lngSetId%>" />
        <input type="hidden" name="returnpage" id="returnpage" value="page$equal$<%=dbPagination.Page & strOrderbyQuerystring%>" />
		<table class="post">
            <tr class="head">
            	<td class="img"></td>
                <td class="id">ID</td>
				<td class="title">TITOLO</td>
				<td class="order">ORD</td>
                <td class="act"><input type="checkbox" onchange="multiselAll(this.checked);" /></td>
            </tr>
		<%
	
		lngPaginationLooper__ = 0
		lngCounter__ = 0
		if dbPagination.recordset.eof then
			%><div class="infobox">nessuna foto presente nel set</div><%
		end if
	
		dim lngDBPhotoId, strDBPhotoTitle, lngDBPhotoOrder, blnDBPhotoActive
		
		while not dbPagination.recordset.eof and ((lngPaginationLooper__ < dbPagination.RecordsPerPage) or (dbPagination.RecordsPerPage = 0 ))
		
			lngDBPhotoId = dbPagination.recordset("photo_id")
			strDBPhotoTitle = dbPagination.recordset("photo_title")
			blnDBPhotoActive = inputBoolean(dbPagination.recordset("photo_active"))
			lngDBPhotoOrder = inputLong(dbPagination.recordset("photo_order"))
			lngCounter__ = lngCounter__ + 1
			
			%>
			<tr<%if not blnDBPhotoActive then response.write " class=""locked"""%>>
				<td class="img"><a href="photo.asp?id=<%=lngDBPhotoId%>" target="_blank" onmouseover="showThumbBaloon('<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & lngDBPhotoId & CARNIVAL_THUMBPOSTFIX & ".jpg?nc=" & noCache%>',event);" onmouseout="hideThumbBaloon();"><img src="<%=getImagePath("lay-adm-ico-id-photo.gif")%>" alt="photo" /></a></td>
				<td class="id"><%=lngDBPhotoId%></td>
				<td class="title"><%=strDBPhotoTitle%></td>
                <td class="order"><a href="javascript:;" onclick="sendValueToPage('inserisci un valore numerico per l\'ordinamento',<%=lngDBPhotoOrder%>,'admin.asp?module=pro-photo-edit&amp;action=order&amp;id=<%=lngDBPhotoId%>&amp;returnpage=page$equal$<%=dbPagination.Page%>&amp;setid=<%=lngSetId%>&amp;order=')"><%=lngDBPhotoOrder%></a></td>
                <td class="act">
                <input type="hidden" name="multiid<%=lngCounter__%>" id="multiid<%=lngCounter__%>" value="<%=lngDBPhotoId%>" />
                <input type="checkbox" name="multisel<%=lngCounter__%>" id="multisel<%=lngCounter__%>" value="1" />
                </td>
			</tr>
			<%
		
			dbPagination.recordset.movenext
			lngPaginationLooper__ = lngPaginationLooper__ + 1
		wend
		dbPagination.recordset.close
		%></table>
		<div class="massactionbox"><div class="title">Azioni</div><div class="box sbuttons">
        <button type="submit" id="multiaction" name="multiaction" value="order" onclick="if (!confirm('vuoi veramente reimpostare l\'ordine dei set selezionati?')) return false;">imposta ordine <img src="<%=getImagePath("lay-adm-ico-act-order.gif")%>" alt="" class="licon" /></button> <input type="text" value="0" name="order" id="order" style="width:30px;" />
        <div class="hrlight"></div>
        <button type="submit" id="multiaction" name="multiaction" value="moveset" onclick="if (!confirm('vuoi veramente spostare nel set tutte le foto selezionate?')) return false;">sposta nel set <img src="<%=getImagePath("lay-adm-ico-id-set.gif")%>" alt="" class="licon" /></button> <select style="width:150px;" name="set" id="set"><%=generateOptionsSets(lngSetId)%></select>
        <% if lngSetId > 1 then %>
        <div class="hrlight"></div>
        <button type="submit" id="multiaction" name="multiaction" value="removeset" onclick="if (!confirm('vuoi veramente rimuovere le foto selezionate dal set?')) return false;">rimuovi dal set <img src="<%=getImagePath("lay-adm-ico-act-del.gif")%>" alt="" class="licon" /></button><% end if %>
		</div></div>
		<div class="pagenavigator"><div class="title">Pagine</div><div class="box"><%
		
		response.write dbPagination.printNavigator("<div class=""s"">mostra foto da %RS a %RE di %RT</div><div class=""n"">%PC pagine [ %PN ] [ %LA ]</div>",null,"&amp;module=set-photo-list&amp;id=" & lngSetId & readyToQuerystring(strOrderbyQuerystring),true)
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