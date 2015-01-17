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
' * @version         SVN: $Id: mod.admin.photolist.asp 21 2008-06-29 22:05:09Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"-->
	<h2>Gestione foto</h2>
	<div class="clear"></div><%
	
	dim crn_photoActive, crn_photoActiveImg
	dim crn_photoDownloadable, crn_photoDownloadableImg
	
	SQL = "SELECT photo_id, photo_title, photo_pub,photo_active,photo_views,photo_downloadable,photo_original FROM tba_photo  ORDER BY photo_id DESC"
	
	set dbPagination = new Class_ASPDbPagination
	dbPagination.RecordsPerPageDefault = crnPaginationPerPage
	
	if dbPagination.Paginate(dbManager.conn, dbManager.database, null, null, SQL) then
		%>
        <form action="admin.asp?module=pro-photo-edit" method="post" onsubmit="if(!multiValid()) { alert('Impossibile eseguire l\'operazione: nessun elemento selezionato'); return false; }">
        <input type="hidden" name="action" id="action" value="multi" />
        <input type="hidden" name="returnpage" id="returnpage" value="<%=dbPagination.Page%>" />
        <table class="post">
            <tr class="head">
                <td class="act"></td>
                <td class="img"></td>
                <td class="id">ID</td>
                <td class="title">TITOLO</td>
                <td class="pub">DATA PUB</td>
                <td class="view">VIEW</td>
                <td class="act"></td>
                <td class="act"></td>
                <td class="act"></td>
                <td class="act"></td>
                <td class="act"></td>
                <td class="act"><input type="checkbox" onchange="multiselAll(this.checked);" /></td>
            </tr>
        <%
		crnPaginationLooper = 0
		crnCounter = 0
		if dbPagination.recordset.eof then
			%><div class="infobox">nessun post presente, clicca su &quot;nuovo post&quot; per cominciare a pubblicare</div><%
		end if
		
		while not dbPagination.recordset.eof and (crnPaginationLooper < dbPagination.RecordsPerPage)
			
			crnPhotoId = dbPagination.recordset("photo_id")
			crnPhotoTitle = dbPagination.recordset("photo_title")
			crn_photoActive = dbPagination.recordset("photo_active")
			if crn_photoActive = 1 then
				crn_photoActive = "hide"
				crn_photoActiveImg = "show"
			else
				crn_photoActive = "show"
				crn_photoActiveImg = "hide"
			end if
			crn_photoDownloadable  = dbPagination.recordset("photo_downloadable")
			if crn_photoDownloadable = 1 then
				crn_photoDownloadable = "downoff"
				crn_photoDownloadableImg = "downon"
			else
				crn_photoDownloadable = "downon"
				crn_photoDownloadableImg = "downoff"
			end if
			crnPhotoOriginal = dbPagination.recordset("photo_original")
			crnPhotoViews = dbPagination.recordset("photo_views")
			crnPhotoPub = formatGMTDate(dbPagination.recordset("photo_pub"),0,"dd/mm/yyyy")
			crnCounter = crnCounter + 1
			
			%>
			<tr<%if crn_photoActive = "show" then response.write " class=""locked"""%>>
				<td class="act"><a href="<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crnPhotoId & CARNIVAL_ORIGINALPOSTFIX & crnPhotoOriginal & ".jpg"%>" target="_blank" title="visualizza foto alta risoluzione"><img src="<%=carnival_pathimages%>lay-adm-ico-act-download.gif" alt="download" /></a></td>
				<td class="img"><a href="photo.asp?id=<%=crnPhotoId%>" target="_blank" onmouseover="showThumbBaloon('<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & crnPhotoId & CARNIVAL_THUMBPOSTFIX & ".jpg?nc=" & noCache%>',event);" onmouseout="hideThumbBaloon();"><img src="<%=carnival_pathimages%>lay-adm-ico-id-photo.gif" alt="photo" /></a></td>
				<td class="id"><%=crnPhotoId%></td>
				<td class="title"><%=crnPhotoTitle%></td>
				<td class="pub"><%=crnPhotoPub%></td>
				<td class="view"><%=crnPhotoViews%></td>
				<td class="act"><a href="admin.asp?module=pro-photo-edit&amp;id=<%=crnPhotoId%>&amp;action=<%=crn_photoDownloadable%>&amp;returnpage=<%=dbPagination.Page%>" title="permetti/nega download immagine ad alta risoluzione"><img src="<%=carnival_pathimages%>lay-adm-ico-act-<%=crn_photoDownloadableImg%>.gif" alt="" /></a></td>
				<td class="act"><a href="admin.asp?module=pro-photo-edit&amp;id=<%=crnPhotoId%>&amp;action=<%=crn_photoActive%>&amp;returnpage=<%=dbPagination.Page%>" title="visualizza/nascondi"><img src="<%=carnival_pathimages%>lay-adm-ico-act-<%=crn_photoActiveImg%>.gif" alt="" /></a></td>
				<td class="act"><a href="admin.asp?module=photo-edit&amp;id=<%=crnPhotoId%>&amp;action=edit&amp;returnpage=<%=dbPagination.Page%>" title="modifica"><img src="<%=carnival_pathimages%>lay-adm-ico-act-edit.gif" alt="modifica" /></a></td>
				<td class="act"><a href="admin.asp?module=photo-upload&amp;id=<%=crnPhotoId%>&amp;action=edit&amp;returnpage=<%=dbPagination.Page%>" title="carica nuove foto"><img src="<%=carnival_pathimages%>lay-adm-ico-act-upload.gif" alt="upload" /></a></td>
				<td class="act"><a href="admin.asp?module=pro-photo-edit&amp;id=<%=crnPhotoId%>&amp;action=del&amp;returnpage=<%=dbPagination.Page%>" onclick="if (!confirm('la cancellazione di un post &egrave; irreversibile e comporta anche l\'eliminazione delle immagini caricate.\nvuoi veramente cancellare il post?')) return false;" title="cancella"><img src="<%=carnival_pathimages%>lay-adm-ico-act-del.gif" alt="cancella" /></a></td>
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
        <a href="admin.asp?module=photo-new">nuovo post <img src="<%=carnival_pathimages%>/lay-adm-ico-act-new.gif" alt="" class="licon" /></a>
        <div class="hrlight"></div>
        <button type="submit" id="multiaction" name="multiaction" value="show" onclick="if (!confirm('vuoi veramente rendere visibili le foto selezionate?')) return false;">visualizza <img src="<%=carnival_pathimages%>lay-adm-ico-act-show.gif" alt="" class="licon" /></button> / <button type="submit" id="multiaction" name="multiaction" value="hide" onclick="if (!confirm('vuoi veramente rendere invisibili le foto selezionate?')) return false;">nascondi <img src="<%=carnival_pathimages%>lay-adm-ico-act-hide.gif" alt="" class="licon" /></button>
        <div class="hrlight"></div>
        <button type="submit" id="multiaction" name="multiaction" value="downon" onclick="if (!confirm('vuoi veramente permettere il download ad alta risoluzione per le foto selezionate?')) return false;">permetti <img src="<%=carnival_pathimages%>lay-adm-ico-act-downon.gif" alt="" class="licon" /></button> / <button type="submit" id="multiaction" name="multiaction" value="downoff" onclick="if (!confirm('vuoi veramente negare il download ad alta risoluzione per le foto selezionate?')) return false;">nega download <img src="<%=carnival_pathimages%>lay-adm-ico-act-downoff.gif" alt="" class="licon" /></button>
        <div class="hrlight"></div>
        <button type="submit" id="multiaction" name="multiaction" value="moveset" onclick="if (!confirm('vuoi veramente spostare nel set tutte le foto selezionate?')) return false;">sposta nel set <img src="<%=carnival_pathimages%>lay-adm-ico-id-set.gif" alt="" class="licon" /></button> <select style="width:150px;" name="set" id="set"><%=generateOptionsSets(0)%></select>
        <div class="hrlight"></div>
        <button type="submit" id="multiaction" name="multiaction" value="addtag" onclick="if (!confirm('vuoi veramente aggiungere il tag a tutte le foto selezionate?')) return false;">aggiungi tag <img src="<%=carnival_pathimages%>lay-adm-ico-id-tag.gif" alt="" class="licon" /></button> <input type="text" style="width:143px;" name="tagname" id="tagname" />
        <div class="hrlight"></div>
        <button type="submit" id="multiaction" name="multiaction" value="del" onclick="if (!confirm('vuoi veramente eliminare le foto selezionate?')) return false;">elimina selezionati <img src="<%=carnival_pathimages%>lay-adm-ico-act-del.gif" alt="" class="licon" /></button>
        </div></div>
        </form>
		<div class="pagenavigator"><div class="title">Pagine</div><div class="box"><%
		
		response.write dbPagination.printNavigator("<div class=""s"">mostra foto da %RS a %RE di %RT</div><div class=""n"">%PC pagine [ %PN ] [ <a href=""?module=photo-list&amp;perpage=500"">tutti</a> ]</div>",null,"&amp;module=photo-list",true)
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