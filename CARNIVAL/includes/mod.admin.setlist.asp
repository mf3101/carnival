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
' * @version         SVN: $Id: mod.admin.setlist.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "inc.admin.check.asp"--><%
'*****************************************************
%>
    <div class="admin-minibutton"><img src="<%=getImagePath("lay-adm-ico-act-update.gif")%>" alt="" /><a href="admin.asp?module=pro-set&amp;action=update">sincronizza foto/set</a></div>
	<h2>Gestione set</h2>
	<div class="clear"></div>
	<%	
	
	dim strOrderbyQuerystring
	strOrderbyQuerystring = ""
	
	dim lngDBSetId, strDBSetName, lngDBSetPhotos, lngDBSetOrder
	
	SQL = "SELECT set_id, set_name, set_photos, set_order FROM tba_set ORDER BY set_order, set_name"
	set dbPagination = new Class_ASPDbPagination
	dbPagination.RecordsPerPageDefault = intRecordsPerPage__
	
	if dbPagination.Paginate(dbManager.conn, dbManager.database, null, null, SQL) then
		%>
        <form action="admin.asp?module=pro-set" method="post" onsubmit="if(!multiValid()) { alert('Impossibile eseguire l\'operazione: nessun elemento selezionato'); return false; }">
        <input type="hidden" name="action" id="action" value="multi" />
        <input type="hidden" name="returnpage" id="returnpage" value="page$equal$<%=dbPagination.Page & strOrderbyQuerystring%>" />
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
	
		lngPaginationLooper__ = 0
		lngCounter__ = 0
		if dbPagination.recordset.eof then
			%><div class="infobox">nessun set presente, clicca su &quot;nuovo set&quot; per cominciare a pubblicare</div><%
		end if
		
		while not dbPagination.recordset.eof and ((lngPaginationLooper__ < dbPagination.RecordsPerPage) or (dbPagination.RecordsPerPage = 0 ))
		
			lngDBSetId = dbPagination.recordset("set_id")
			strDBSetName = dbPagination.recordset("set_name")
			lngDBSetPhotos = dbPagination.recordset("set_photos")
			lngDBSetOrder = dbPagination.recordset("set_order")
			lngCounter__ = lngCounter__ + 1
			
			%>
			<tr>
				<td class="img"><a href="gallery.asp?set=<%=lngDBSetId%>" target="_blank"><img src="<%=getImagePath("lay-adm-ico-id-set.gif")%>" alt="set" /></a></td>
				<td class="id"><%=lngDBSetId%></td>
				<td class="title"><a href="admin.asp?module=set-photo-list&amp;id=<%=lngDBSetId%>&amp;returnpage=page$equal$<%=dbPagination.Page%><%=strOrderbyQuerystring%>"><%=strDBSetName%></a></td>
				<td class="photos"><%=lngDBSetPhotos%></td>
                <td class="order"><a href="javascript:;" onclick="sendValueToPage('inserisci un valore numerico per l\'ordinamento',<%=lngDBSetOrder%>,'admin.asp?module=pro-set&amp;action=order&amp;id=<%=lngDBSetId%>&amp;returnpage=page$equal$<%=dbPagination.Page%><%=strOrderbyQuerystring%>&amp;order=')"><%=lngDBSetOrder%></a></td>
                <td class="act"><a href="admin.asp?module=set-edit&amp;id=<%=lngDBSetId%>&amp;action=edit&amp;returnpage=page$equal$<%=dbPagination.Page%><%=strOrderbyQuerystring%>" title="modifica"><img src="<%=getImagePath("lay-adm-ico-act-edit.gif")%>" alt="modifica" /></a></td>
				<td class="act"><% if lngDBSetId > 1 then %><a href="admin.asp?module=pro-set&amp;action=del&amp;id=<%=lngDBSetId%>&amp;returnpage=<%=dbPagination.Page%><%=strOrderbyQuerystring%>" onclick="if (!confirm('tutte le foto del set verranno spostate nel set base\nvuoi veramente cancellare il set?')) return false;" title="cancella"><img src="<%=getImagePath("lay-adm-ico-act-del.gif")%>" alt="cancella" /></a><% end if %></td>
                <td class="act">
                <input type="hidden" name="multiid<%=lngCounter__%>" id="multiid<%=lngCounter__%>" value="<%=lngDBSetId%>" />
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
        <a href="admin.asp?module=set-edit">nuovo set <img src="<%=getImagePath("lay-adm-ico-act-new.gif")%>" alt="" class="licon" /></a>
        <div class="hrlight"></div>
        <button type="submit" id="multiaction" name="multiaction" value="order" onclick="if (!confirm('vuoi veramente reimpostare l\'ordine dei set selezionati?')) return false;">imposta ordine <img src="<%=getImagePath("lay-adm-ico-act-order.gif")%>" alt="" class="licon" /></button> <input type="text" value="0" name="order" id="order" style="width:30px;" />
        <div class="hrlight"></div>
        <button type="submit" id="multiaction" name="multiaction" value="del" onclick="if (!confirm('vuoi veramente eliminare i set selezionati?')) return false;">elimina <img src="<%=getImagePath("lay-adm-ico-act-del.gif")%>" alt="" class="licon" /></button>
        </div></div>
        </form>
		<div class="pagenavigator"><div class="title">Pagine</div><div class="box"><%
		
		response.write dbPagination.printNavigator("<div class=""s"">mostra set da %RS a %RE di %RT</div><div class=""n"">%PC pagine [ %PN ] [ %LA ]</div>",null,"&amp;module=set-list" & readyToQuerystring(strOrderbyQuerystring),true)
		%></div></div><%
	else
		response.redirect "errors.asp?c=query0"
	end if
	%>