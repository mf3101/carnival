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
' * @version         SVN: $Id: mod.admin.taglist.asp 21 2008-06-29 22:05:09Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"-->
	<div class="admin-minibutton"><img src="<%=carnival_pathimages%>/lay-adm-ico-act-update.gif" alt="" /><a href="admin.asp?module=pro-tag&amp;action=update">sincronizza foto/tag</a></div>
	<h2>Gestione tag</h2>
	<div class="clear"></div>
	<%	
	dim crn_tagId, crn_tagName, crn_tagType, crn_tagTypeImg, crn_tagPhotos
	
	SQL = "SELECT tag_id, tag_name, tag_type, tag_photos FROM tba_tag ORDER BY tag_name"
	
	set dbPagination = new Class_ASPDbPagination
	dbPagination.RecordsPerPageDefault = crnPaginationPerPage
	
	if dbPagination.Paginate(dbManager.conn, dbManager.database, null, null, SQL) then
		%>
        <form action="admin.asp?module=pro-tag" method="post" onsubmit="if(!multiValid()) { alert('Impossibile eseguire l\'operazione: nessun elemento selezionato'); return false; }">
        <input type="hidden" name="action" id="action" value="multi" />
        <input type="hidden" name="returnpage" id="returnpage" value="<%=dbPagination.Page%>" />
		<table class="post">
			<tr class="head">
				<td class="img"></td>
				<td class="id">ID</td>
				<td class="title">TAG</td>
				<td class="photos">PHOTO</td>
				<td class="act">T</td>
				<td class="act"></td>
				<td class="act"></td>
                <td class="act"><input type="checkbox" onchange="multiselAll(this.checked);" /></td>
			</tr>
		<%
	
		crnPaginationLooper = 0
		crnCounter = 0
		if dbPagination.recordset.eof then
			%><div class="infobox">nessun tag presente</div><%
		end if
		
		while not dbPagination.recordset.eof and (crnPaginationLooper < dbPagination.RecordsPerPage)
		
			crn_tagId = dbPagination.recordset("tag_id")
			crn_tagName = dbPagination.recordset("tag_name")
			crn_tagType = cbyte(dbPagination.recordset("tag_type"))
			if crn_tagType = 1 then
				crn_tagType = "typenormal"
				crn_tagTypeImg = "typecommon"
			else
				crn_tagType = "typecommon"
				crn_tagTypeImg = "typenormal"
			end if
			crn_tagPhotos = dbPagination.recordset("tag_photos")
			crnCounter = crnCounter + 1
			
			%>
			<tr>
				<td class="img"><a href="gallery.asp?tag=<%=crn_tagName%>" target="_blank"><img src="<%=carnival_pathimages%>lay-adm-ico-id-tag.gif" alt="tag" /></a></td>
				<td class="id"><%=crn_tagId%></td>
				<td class="title"><%=crn_tagName%></td>
				<td class="photos"><%=crn_tagPhotos%></td>
				<td class="act"><a href="admin.asp?module=pro-tag&amp;id=<%=crn_tagId%>&amp;action=<%=crn_tagType%>&amp;returnpage=<%=dbPagination.Page%>" title="normale/comune"><img src="<%=carnival_pathimages%>lay-adm-ico-act-<%=crn_tagTypeImg%>.gif" alt="" /></a></td>
				<td class="act"><a href="admin.asp?module=tag-edit&amp;id=<%=crn_tagId%>&amp;returnpage=<%=dbPagination.Page%>" title="modifica"><img src="<%=carnival_pathimages%>lay-adm-ico-act-edit.gif" alt="modifica" /></a></td>
				<td class="act"><a href="admin.asp?module=pro-tag&amp;action=del&amp;id=<%=crn_tagId%>&amp;returnpage=<%=dbPagination.Page%>" onclick="if (!confirm('vuoi veramente cancellare il tag?')) return false;" title="cancella"><img src="<%=carnival_pathimages%>lay-adm-ico-act-del.gif" alt="cancella" /></a></td>
                <td class="act">
                <input type="hidden" name="multiid<%=crnCounter%>" id="multiid<%=crnCounter%>" value="<%=crn_tagId%>" />
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
        <button type="submit" id="multiaction" name="multiaction" value="del" onclick="if (!confirm('vuoi veramente cancellare i tag selezionati?')) return false;">elimina selezionati <img src="<%=carnival_pathimages%>lay-adm-ico-act-del.gif" alt="" class="licon" /></button>
        </div></div>
        </form>
		<div class="pagenavigator"><div class="title">Pagine</div><div class="box"><%
		
		response.write dbPagination.printNavigator("<div class=""s"">mostra tags da %RS a %RE di %RT</div><div class=""n"">%PC pagine [ %PN ] [ <a href=""?module=tag-list&amp;perpage=500"">tutti</a> ]</div>",null,"&amp;module=tag-list",true)
		
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