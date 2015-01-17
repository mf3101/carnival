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
' * @version         SVN: $Id: mod.admin.taglist.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "inc.admin.check.asp"--><%
'*****************************************************
%>
	<div class="admin-minibutton"><img src="<%=getImagePath("lay-adm-ico-act-update.gif")%>" alt="" /><a href="admin.asp?module=pro-tag&amp;action=update">sincronizza foto/tag</a></div>
	<h2>Gestione tag</h2>
	<div class="clear"></div>
	<%	
	
	dim strOrderbyField, strOrderbyDirection, strOrderbyQuerystring
	strOrderbyField = normalize(request.QueryString("orderby"),"type|photos|name","")
	if strOrderbyField = "" then
		strOrderbyField = "name"
		strOrderbyDirection = "ASC"
		strOrderbyQuerystring = ""
	else
		strOrderbyDirection = normalize(request.QueryString("orderbydir"),"DESC","ASC")
		strOrderbyQuerystring = "$and$orderby$equal$" & strOrderbyField & "$and$orderbydir$equal$" & strOrderbyDirection
	end if
	
	dim lngDBTagId, strDBTagName, bytDBTagType, lngDBTagPhotos
	dim strTagTypeImg, strTagTypeAction
	
	SQL = "SELECT tag_id, tag_name, tag_type, tag_photos FROM tba_tag ORDER BY tag_" & strOrderbyField & " " & strOrderbyDirection
	
	set dbPagination = new Class_ASPDbPagination
	dbPagination.RecordsPerPageDefault = intRecordsPerPage__
	
	if dbPagination.Paginate(dbManager.conn, dbManager.database, null, null, SQL) then
		%>
        <form action="admin.asp?module=pro-tag" method="post" onsubmit="if(!multiValid()) { alert('Impossibile eseguire l\'operazione: nessun elemento selezionato'); return false; }">
        <input type="hidden" name="action" id="action" value="multi" />
        <input type="hidden" name="returnpage" id="returnpage" value="page$equal$<%=dbPagination.Page & strOrderbyQuerystring%>" />
		<table class="post">
			<tr class="head">
				<td class="img"></td>
				<td class="id">ID</td>
				<td class="title"><a href="?module=tag-list&amp;page=<%=dbPagination.Page%>&amp;orderby=name&amp;orderbydir=<%=IIF(strOrderbyDirection="DESC" or strOrderbyField <> "name","ASC","DESC")%>">TAG</a></td>
				<td class="photos"><a href="?module=tag-list&amp;page=<%=dbPagination.Page%>&amp;orderby=photos&amp;orderbydir=<%=IIF(strOrderbyDirection="ASC" or strOrderbyField <> "tag","DESC","ASC")%>">PHOTO</a></td>
				<td class="act"><a href="?module=tag-list&amp;page=<%=dbPagination.Page%>&amp;orderby=type&amp;orderbydir=<%=IIF(strOrderbyDirection="ASC" or strOrderbyField <> "type","DESC","ASC")%>">T</a></td>
				<td class="act"></td>
				<td class="act"></td>
                <td class="act"><input type="checkbox" onchange="multiselAll(this.checked);" /></td>
			</tr>
		<%
	
		lngPaginationLooper__ = 0
		lngCounter__ = 0
		if dbPagination.recordset.eof then
			%><div class="infobox">nessun tag presente</div><%
		end if
		
		while not dbPagination.recordset.eof and ((lngPaginationLooper__ < dbPagination.RecordsPerPage) or (dbPagination.RecordsPerPage = 0 ))
		
			lngDBTagId = dbPagination.recordset("tag_id")
			strDBTagName = dbPagination.recordset("tag_name")
			bytDBTagType = inputByte(dbPagination.recordset("tag_type"))
			if bytDBTagType = 1 then
				strTagTypeAction = "typenormal"
				strTagTypeImg = "typecommon"
			else
				strTagTypeAction = "typecommon"
				strTagTypeImg = "typenormal"
			end if
			lngDBTagPhotos = dbPagination.recordset("tag_photos")
			lngCounter__ = lngCounter__ + 1
			
			%>
			<tr>
				<td class="img"><a href="gallery.asp?tag=<%=strDBTagName%>" target="_blank"><img src="<%=getImagePath("lay-adm-ico-id-tag.gif")%>" alt="tag" /></a></td>
				<td class="id"><%=lngDBTagId%></td>
				<td class="title"><%=strDBTagName%></td>
				<td class="photos"><%=lngDBTagPhotos%></td>
				<td class="act"><a href="admin.asp?module=pro-tag&amp;id=<%=lngDBTagId%>&amp;action=<%=strTagTypeAction%>&amp;returnpage=page$equal$<%=dbPagination.Page%><%=strOrderbyQuerystring%>" title="normale/comune"><img src="<%=getImagePath("lay-adm-ico-act-" & strTagTypeImg & ".gif")%>" alt="" /></a></td>
				<td class="act"><a href="admin.asp?module=tag-edit&amp;id=<%=lngDBTagId%>&amp;returnpage=page$equal$<%=dbPagination.Page%><%=strOrderbyQuerystring%>" title="modifica"><img src="<%=getImagePath("lay-adm-ico-act-edit.gif")%>" alt="modifica" /></a></td>
				<td class="act"><a href="admin.asp?module=pro-tag&amp;action=del&amp;id=<%=lngDBTagId%>&amp;returnpage=page$equal$<%=dbPagination.Page%><%=strOrderbyQuerystring%>" onclick="if (!confirm('vuoi veramente cancellare il tag?')) return false;" title="cancella"><img src="<%=getImagePath("lay-adm-ico-act-del.gif")%>" alt="cancella" /></a></td>
                <td class="act">
                <input type="hidden" name="multiid<%=lngCounter__%>" id="multiid<%=lngCounter__%>" value="<%=lngDBTagId%>" />
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
        <button type="submit" id="multiaction" name="multiaction" value="del" onclick="if (!confirm('vuoi veramente cancellare i tag selezionati?')) return false;">elimina selezionati <img src="<%=getImagePath("lay-adm-ico-act-del.gif")%>" alt="" class="licon" /></button>
        </div></div>
        </form>
		<div class="pagenavigator"><div class="title">Pagine</div><div class="box"><%
		
		response.write dbPagination.printNavigator("<div class=""s"">mostra tags da %RS a %RE di %RT</div><div class=""n"">%PC pagine [ %PN ] [ %LA ]</div>",null,"&amp;module=tag-list" & readyToQuerystring(strOrderbyQuerystring),true)
		
		%></div></div><%
	else
		response.redirect "errors.asp?c=query0"
	end if
	%>
    
	<script type="text/javascript">/* <![CDATA[ */
	function quest(question,value,goto) {
		var result = prompt(question,value);
		if (result != null) {
			document.location.href = String(goto) + String(result);
		}
	}
	/* ]]> */</script>