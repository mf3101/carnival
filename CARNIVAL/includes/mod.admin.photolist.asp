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
' * @version         SVN: $Id: mod.admin.photolist.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "inc.admin.check.asp"--><%
'*****************************************************

%>
	<h2>Gestione foto</h2>
	<div class="clear"></div><%
	
	dim strOrderbyField, strOrderbyDirection, strOrderbyQuerystring
	strOrderbyField = normalize(request.QueryString("orderby"),"title|views|pub","")
	if strOrderbyField = "" then
		strOrderbyField = "pub"
		strOrderbyDirection = "DESC"
		strOrderbyQuerystring = ""
	else
		strOrderbyDirection = normalize(request.QueryString("orderbydir"),"DESC","ASC")
		strOrderbyQuerystring = "$and$orderby$equal$" & strOrderbyField & "$and$orderbydir$equal$" & strOrderbyDirection
	end if
	
	
	dim lngDBPhotoId, strDBPhotoTitle, dtmDBPhotoPub, lngDBPhotoViews, strDBPhotoOriginal
	dim blnDBPhotoActive, strPhotoActiveImg, strPhotoActiveAct
	dim blnDBPhotoDownloadable, strPhotoDownloadableImg, strPhotoDownloadableAct
	dim bytDBPhotoPubqueue, strPhotoPubqueueImg
	
	SQL = "SELECT photo_id, photo_title, photo_pub, photo_active, photo_views, photo_downloadable, photo_original, photo_pubqueue FROM tba_photo ORDER BY photo_" & strOrderbyField & " " & strOrderbyDirection
	
	set dbPagination = new Class_ASPDbPagination
	dbPagination.RecordsPerPageDefault = intRecordsPerPage__
	
	if dbPagination.Paginate(dbManager.conn, dbManager.database, null, null, SQL) then
		%>
        <form action="admin.asp?module=pro-photo-edit" method="post" onsubmit="if(!multiValid()) { alert('Impossibile eseguire l\'operazione: nessun elemento selezionato'); return false; }">
        <input type="hidden" name="action" id="action" value="multi" />
        <input type="hidden" name="returnpage" id="returnpage" value="page$equal$<%=dbPagination.Page & strOrderbyQuerystring%>" />
        <table class="post">
            <tr class="head">
                <td class="act"></td>
                <td class="img"></td>
                <td class="id">ID</td>
                <td class="title"><a href="?module=photo-list&amp;page=<%=dbPagination.Page%>&amp;orderby=title&amp;orderbydir=<%=IIF(strOrderbyDirection="DESC" or strOrderbyField <> "title","ASC","DESC")%>">TITOLO</a></td>
                <td class="act"></td>
                <td class="act"></td>
                <td class="pub"><a href="?module=photo-list&amp;page=<%=dbPagination.Page%>&amp;orderby=pub&amp;orderbydir=<%=IIF(strOrderbyDirection="ASC" or strOrderbyField <> "pub","DESC","ASC")%>">DATA PUB</a></td>
                <td class="view"><a href="?module=photo-list&amp;page=<%=dbPagination.Page%>&amp;orderby=views&amp;orderbydir=<%=IIF(strOrderbyDirection="ASC" or strOrderbyField <> "views","DESC","ASC")%>">VIEW</a></td>
                <td class="act"></td>
                <td class="act"></td>
                <td class="act"></td>
                <td class="act"></td>
                <td class="act"></td>
                <td class="act"><input type="checkbox" onchange="multiselAll(this.checked);" /></td>
            </tr>
        <%
		lngPaginationLooper__ = 0
		lngCounter__ = 0
		if dbPagination.recordset.eof then
			%><div class="infobox">nessun post presente, clicca su &quot;nuovo post&quot; per cominciare a pubblicare</div><%
		end if
		
		while not dbPagination.recordset.eof and ((lngPaginationLooper__ < dbPagination.RecordsPerPage) or (dbPagination.RecordsPerPage = 0 ))
			lngDBPhotoId = dbPagination.recordset("photo_id")
			strDBPhotoTitle = dbPagination.recordset("photo_title")
			blnDBPhotoActive = inputBoolean(dbPagination.recordset("photo_active"))
			blnDBPhotoDownloadable  = inputBoolean(dbPagination.recordset("photo_downloadable"))
			bytDBPhotoPubqueue = inputByte(dbPagination.recordset("photo_pubqueue"))
			strDBPhotoOriginal = dbPagination.recordset("photo_original")
			lngDBPhotoViews = dbPagination.recordset("photo_views")
			dtmDBPhotoPub = formatGMTDate(dbPagination.recordset("photo_pub"),0,"dd/mm/yyyy")
			
			if blnDBPhotoActive then
				strPhotoActiveAct = "hide" : strPhotoActiveImg = "show"
			else
				strPhotoActiveAct = "show" : strPhotoActiveImg = "hide"
			end if
			if blnDBPhotoDownloadable then
				strPhotoDownloadableAct = "downoff" : strPhotoDownloadableImg = "downon"
			else
				strPhotoDownloadableAct = "downon"  : strPhotoDownloadableImg = "downoff"
			end if
			select case bytDBPhotoPubqueue
				case 0
				strPhotoPubqueueImg = "quelock"
				case 1
				strPhotoPubqueueImg = "queauto"
				case 2
				strPhotoPubqueueImg = "queperiod"
			end select
			
			lngCounter__ = lngCounter__ + 1
			
			%>
			<tr<%if not blnDBPhotoActive then response.write " class=""locked"""%>>
				<td class="act"><a href="<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & lngDBPhotoId & CARNIVAL_ORIGINALPOSTFIX & strDBPhotoOriginal & ".jpg"%>" target="_blank" title="visualizza foto alta risoluzione"><img src="<%=getImagePath("lay-adm-ico-act-download.gif")%>" alt="download" /></a></td>
				<td class="img"><a href="<% if blnDBPhotoActive then %>photo.asp?id=<%=lngDBPhotoId%><% else %><%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & lngDBPhotoId & strDBPhotoOriginal & ".jpg"%><% end if %>" target="_blank" onmouseover="showThumbBaloon('<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & lngDBPhotoId & CARNIVAL_THUMBPOSTFIX & IIF(not blnDBPhotoActive,strDBPhotoOriginal,"") & ".jpg?nc=" & noCache%>',event);" onmouseout="hideThumbBaloon();"><img src="<%=getImagePath("lay-adm-ico-id-photo.gif")%>" alt="photo" /></a></td>
				<td class="id"><%=lngDBPhotoId%></td>
				<td class="title"<% if not(bytDBPhotoPubqueue = 2  and strOrderbyField = "pub" and strOrderbyDirection = "DESC") then response.write " colspan=""3"""%>><%=strDBPhotoTitle%></td>
                <% if bytDBPhotoPubqueue = 2 and strOrderbyField = "pub" and strOrderbyDirection = "DESC" then %>
				<td class="act"><a href="admin.asp?module=pro-photo-edit&amp;id=<%=lngDBPhotoId%>&amp;action=pubup"><img src="<%=getImagePath("lay-adm-ico-act-plus.gif")%>" alt="" class="icon" /></a></td>
				<td class="act"><a href="admin.asp?module=pro-photo-edit&amp;id=<%=lngDBPhotoId%>&amp;action=pubdown"><img src="<%=getImagePath("lay-adm-ico-act-minus.gif")%>" alt="" class="icon" /></a></td>
				<% end if %>
				<td class="pub"><%=dtmDBPhotoPub%> <img src="<%=getImagePath("lay-adm-ico-act-" & strPhotoPubqueueImg & ".gif")%>" alt="" class="icon" /></td>
				<td class="view"><%=lngDBPhotoViews%></td>
				<td class="act"><a href="admin.asp?module=pro-photo-edit&amp;id=<%=lngDBPhotoId%>&amp;action=<%=strPhotoDownloadableAct%>&amp;returnpage=page$equal$<%=dbPagination.Page%><%=strOrderbyQuerystring%>" title="permetti/nega download immagine ad alta risoluzione"><img src="<%=getImagePath("lay-adm-ico-act-" & strPhotoDownloadableImg & ".gif")%>" alt="" /></a></td>
				<td class="act"><a href="admin.asp?module=pro-photo-edit&amp;id=<%=lngDBPhotoId%>&amp;action=<%=strPhotoActiveAct%>&amp;returnpage=page$equal$<%=dbPagination.Page%><%=strOrderbyQuerystring%>" title="visualizza/nascondi"><img src="<%=getImagePath("lay-adm-ico-act-" & strPhotoActiveImg & ".gif")%>" alt="" /></a></td>
				<td class="act"><a href="admin.asp?module=photo-edit&amp;id=<%=lngDBPhotoId%>&amp;action=edit&amp;returnpage=page$equal$<%=dbPagination.Page%><%=strOrderbyQuerystring%>" title="modifica"><img src="<%=getImagePath("lay-adm-ico-act-edit.gif")%>" alt="modifica" /></a></td>
				<td class="act"><a href="admin.asp?module=photo-upload&amp;id=<%=lngDBPhotoId%>&amp;action=edit&amp;returnpage=page$equal$<%=dbPagination.Page%><%=strOrderbyQuerystring%>" title="carica nuove foto"><img src="<%=getImagePath("lay-adm-ico-act-upload.gif")%>" alt="upload" /></a></td>
				<td class="act"><a href="admin.asp?module=pro-photo-edit&amp;id=<%=lngDBPhotoId%>&amp;action=del&amp;returnpage=page$equal$<%=dbPagination.Page%><%=strOrderbyQuerystring%>" onclick="if (!confirm('la cancellazione di un post &egrave; irreversibile e comporta anche l\'eliminazione delle immagini caricate.\nvuoi veramente cancellare il post?')) return false;" title="cancella"><img src="<%=getImagePath("lay-adm-ico-act-del.gif")%>" alt="cancella" /></a></td>
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
        <a href="admin.asp?module=photo-new">nuovo post <img src="<%=getImagePath("lay-adm-ico-act-new.gif")%>" alt="" class="licon" /></a>
        <div class="hrlight"></div>
        <button type="submit" id="multiaction" name="multiaction" value="show" onclick="if (!confirm('vuoi veramente rendere visibili le foto selezionate?')) return false;">visualizza <img src="<%=getImagePath("lay-adm-ico-act-show.gif")%>" alt="" class="licon" /></button> / <button type="submit" id="multiaction" name="multiaction" value="hide" onclick="if (!confirm('vuoi veramente rendere invisibili le foto selezionate?')) return false;">nascondi <img src="<%=getImagePath("lay-adm-ico-act-hide.gif")%>" alt="" class="licon" /></button>
        <div class="hrlight"></div>
        <button type="submit" id="multiaction" name="multiaction" value="downon" onclick="if (!confirm('vuoi veramente permettere il download ad alta risoluzione per le foto selezionate?')) return false;">permetti <img src="<%=getImagePath("lay-adm-ico-act-downon.gif")%>" alt="" class="licon" /></button> / <button type="submit" id="multiaction" name="multiaction" value="downoff" onclick="if (!confirm('vuoi veramente negare il download ad alta risoluzione per le foto selezionate?')) return false;">nega download <img src="<%=getImagePath("lay-adm-ico-act-downoff.gif")%>" alt="" class="licon" /></button>
        <div class="hrlight"></div>
        <button type="submit" id="multiaction" name="multiaction" value="moveset" onclick="if (!confirm('vuoi veramente spostare nel set tutte le foto selezionate?')) return false;">sposta nel set <img src="<%=getImagePath("lay-adm-ico-id-set.gif")%>" alt="" class="licon" /></button> <select style="width:150px;" name="set" id="set"><%=generateOptionsSets(0)%></select>
        <div class="hrlight"></div>
        <button type="submit" id="multiaction" name="multiaction" value="addtag" onclick="if (!confirm('vuoi veramente aggiungere il tag a tutte le foto selezionate?')) return false;">aggiungi tag <img src="<%=getImagePath("lay-adm-ico-id-tag.gif")%>" alt="" class="licon" /></button> <input type="text" style="width:143px;" name="tagname" id="tagname" />
        <div class="hrlight"></div>
        <button type="submit" id="multiaction" name="multiaction" value="del" onclick="if (!confirm('vuoi veramente eliminare le foto selezionate?')) return false;">elimina selezionati <img src="<%=getImagePath("lay-adm-ico-act-del.gif")%>" alt="" class="licon" /></button>
        </div></div>
        </form>
		<div class="pagenavigator"><div class="title">Pagine</div><div class="box"><%
		
		response.write dbPagination.printNavigator("<div class=""s"">mostra foto da %RS a %RE di %RT</div><div class=""n"">%PC pagine [ %PN ] [ %LA ]</div>",null,"&amp;module=photo-list" & readyToQuerystring(strOrderbyQuerystring),true)
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