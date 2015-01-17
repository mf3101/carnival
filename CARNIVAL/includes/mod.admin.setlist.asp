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
' * @version         SVN: $Id: mod.admin.setlist.asp 28 2008-07-04 12:27:48Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"-->
    <div class="admin-minibutton"><img src="<%=carnival_pathimages%>/lay-adm-ico-act-update.gif" alt="" /><a href="admin.asp?module=pro-set&amp;action=update">sincronizza foto/set</a></div>
	<h2>Gestione set</h2>
	<div class="clear"></div>
	<%	
	dim crn_setId, crn_setName, crn_setPhotos, crn_setOrder
	
	SQL = "SELECT set_id, set_name, set_photos, set_order FROM tba_set ORDER BY set_order, set_name"
	set dbPagination = new Class_ASPDbPagination
	dbPagination.RecordsPerPageDefault = crnPaginationPerPage
	
	if dbPagination.Paginate(dbManager.conn, dbManager.database, null, null, SQL) then
		%>
        <form action="admin.asp?module=pro-set" method="post" onsubmit="if(!multiValid()) { alert('Impossibile eseguire l\'operazione: nessun elemento selezionato'); return false; }">
        <input type="hidden" name="action" id="action" value="multi" />
        <input type="hidden" name="returnpage" id="returnpage" value="<%=dbPagination.Page%>" />
		<table class="post">
			<tr class="head">
				<td class="img"></td>
				<td class="id">ID</td>
				<td class="title">SET</td>
				<td class="photos">PHOTO</td>
				<td class="order">ORD</td>
				<td class="act"></td>
				<td class="act"></td>
                <td class="act"><input type="checkbox" onchange="multiselAll(this.checked);" /></td>
			</tr>
		<%
	
		crnPaginationLooper = 0
		crnCounter = 0
		if dbPagination.recordset.eof then
			%><div class="infobox">nessun set presente, clicca su &quot;nuovo set&quot; per cominciare a pubblicare</div><%
		end if
		
		while not dbPagination.recordset.eof and (crnPaginationLooper < dbPagination.RecordsPerPage)
		
			crn_setId = dbPagination.recordset("set_id")
			crn_setName = dbPagination.recordset("set_name")
			crn_setPhotos = dbPagination.recordset("set_photos")
			crn_setOrder = dbPagination.recordset("set_order")
			crnCounter = crnCounter + 1
			
			%>
			<tr>
				<td class="img"><a href="gallery.asp?set=<%=crn_setId%>" target="_blank"><img src="<%=carnival_pathimages%>lay-adm-ico-id-set.gif" alt="set" /></a></td>
				<td class="id"><%=crn_setId%></td>
				<td class="title"><a href="admin.asp?module=set-photo-list&amp;id=<%=crn_setId%>&amp;returnpage=<%=dbPagination.Page%>"><%=crn_setName%></a></td>
				<td class="photos"><%=crn_setPhotos%></td>
                <td class="order"><a href="javascript:;" onclick="sendValueToPage('inserisci un valore numerico per l\'ordinamento',<%=crn_setOrder%>,'admin.asp?module=pro-set&amp;action=order&amp;id=<%=crn_setId%>&amp;returnpage=<%=dbPagination.Page%>&amp;order=')"><%=crn_setOrder%></a></td>
                <td class="act"><a href="admin.asp?module=set-edit&amp;id=<%=crn_setId%>&amp;action=edit&amp;returnpage=<%=dbPagination.Page%>" title="modifica"><img src="<%=carnival_pathimages%>lay-adm-ico-act-edit.gif" alt="modifica" /></a></td>
				<td class="act"><% if crn_setId > 1 then %><a href="admin.asp?module=pro-set&amp;action=del&amp;id=<%=crn_setId%>&amp;returnpage=<%=dbPagination.Page%>" onclick="if (!confirm('tutte le foto del set verranno spostate nel set base\nvuoi veramente cancellare il set?')) return false;" title="cancella"><img src="<%=carnival_pathimages%>lay-adm-ico-act-del.gif" alt="cancella" /></a><% end if %></td>
                <td class="act">
                <input type="hidden" name="multiid<%=crnCounter%>" id="multiid<%=crnCounter%>" value="<%=crn_setId%>" />
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
        <a href="admin.asp?module=set-edit">nuovo set <img src="<%=carnival_pathimages%>/lay-adm-ico-act-new.gif" alt="" class="licon" /></a>
        <div class="hrlight"></div>
        <button type="submit" id="multiaction" name="multiaction" value="order" onclick="if (!confirm('vuoi veramente reimpostare l\'ordine dei set selezionati?')) return false;">imposta ordine <img src="<%=carnival_pathimages%>lay-adm-ico-act-order.gif" alt="" class="licon" /></button> <input type="text" value="0" name="order" id="order" style="width:30px;" />
        <div class="hrlight"></div>
        <button type="submit" id="multiaction" name="multiaction" value="del" onclick="if (!confirm('vuoi veramente eliminare i set selezionati?')) return false;">elimina <img src="<%=carnival_pathimages%>lay-adm-ico-act-del.gif" alt="" class="licon" /></button>
        </div></div>
        </form>
		<div class="pagenavigator"><div class="title">Pagine</div><div class="box"><%
		
		response.write dbPagination.printNavigator("<div class=""s"">mostra set da %RS a %RE di %RT</div><div class=""n"">%PC pagine [ %PN ] [ <a href=""?module=set-list&amp;perpage=500"">tutti</a> ]</div>",null,"&amp;module=set-list",true)
		%></div></div><%
	else
		response.redirect "errors.asp?c=query0"
	end if
	%>