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
' * @version         SVN: $Id: mod.admin.stats.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "inc.admin.check.asp"--><%
'*****************************************************

dim strStatsMode
strStatsMode = normalize(request.QueryString("mode"),"views-full|views-day|popularity|comments","general")

%>

	<h2>Statistiche</h2>
	<div class="clear"></div>
    <div style="float:left;">
        <ul class="tabmenu">
            <li<% if strStatsMode = "general" then %> class="selected"<% end if %>><a href="?module=stats&amp;mode=general">Generale</a></li>
            <li<% if strStatsMode = "popularity" then %> class="selected"<% end if %>><a href="?module=stats&amp;mode=popularity">Popolarit&agrave;</a></li>
            <li<% if strStatsMode = "views-full" or strStatsMode = "views-day" then %> class="selected"<% end if %>><a href="?module=stats&amp;mode=views-full">Visualizzazioni</a></li>
            <li<% if strStatsMode = "comments" then %> class="selected"<% end if %>><a href="?module=stats&amp;mode=comments">Commenti</a></li>
        </ul>
    </div>
    <div class="hrtabmenu"></div>
    <% if strStatsMode = "views-full" or strStatsMode = "views-day" then %>
	<div class="clear"></div>
    <div style="float:left;">
        <ul class="tabmenu mini">
            <li<% if strStatsMode = "views-full" then %> class="selected"<% end if %>><a href="?module=stats&amp;mode=views-full">Complessive</a></li>
            <li<% if strStatsMode = "views-day" then %> class="selected"<% end if %>><a href="?module=stats&amp;mode=views-day">Medie giornaliere</a></li>
        </ul>
    </div>
    <div class="hrtabmenu mini"></div>
    <% end if %> 
    <% if strStatsMode = "comments" or strStatsMode = "views-full" or strStatsMode = "views-day" or strStatsMode = "popularity" then %>
    <table class="stats">
    <tr class="head">
    	<td></td>
    	<td></td>
     	<td>titolo</td>
     	<td>view</td>
     	<td>comm.</td>
        <% if strStatsMode = "popularity" then %><td>pop.</td><% end if %>
        <% if strStatsMode = "views-day" then %><td>media</td><% end if %>
        <td></td>
    </tr>
    <%
	if strStatsMode = "comments" then
		'ordina per commenti
		SQL = "SELECT photo_id, photo_pub, photo_title, photo_views, Count(tba_comment.comment_id) AS photo_comments " & _
			  "FROM tba_comment RIGHT JOIN tba_photo ON tba_comment.comment_photo = tba_photo.photo_id " & _
			  "WHERE photo_active = 1 " & _
			  "GROUP BY photo_id, photo_title, photo_views, photo_pub ORDER BY Count(tba_comment.comment_id) DESC, photo_views DESC"
	elseif strStatsMode = "views-full" then
		'ordina per views
		SQL = "SELECT photo_id, photo_pub, photo_title, photo_views, Count(tba_comment.comment_id) AS photo_comments " & _
			  "FROM tba_comment RIGHT JOIN tba_photo ON tba_comment.comment_photo = tba_photo.photo_id " & _
			  "WHERE photo_active = 1 " & _
			  "GROUP BY photo_id, photo_title, photo_views, photo_pub ORDER BY photo_views DESC, Count(tba_comment.comment_id) DESC"
	elseif strStatsMode = "views-day" then
		'ordina per realviews
		SQL = "SELECT photo_id, photo_title, photo_views, photo_pub, ((photo_views/(" & IIF(CARNIVAL_DATABASE_TYPE="mdb","now()-photo_pub","DATEDIFF(NOW(),photo_pub)") & "))) AS photo_rviews, (" & IIF(CARNIVAL_DATABASE_TYPE="mdb","now()-photo_pub","DATEDIFF(NOW(),photo_pub)") & ") AS photo_pubdiff, Count(tba_comment.comment_id) AS photo_comments " & _
			  "FROM tba_comment RIGHT JOIN tba_photo ON tba_comment.comment_photo = tba_photo.photo_id " & _
			  "WHERE photo_active = 1 " & _
			  "GROUP BY photo_id, photo_title, photo_views, photo_pub " & _
			  "ORDER BY ((photo_views/(" & IIF(CARNIVAL_DATABASE_TYPE="mdb","now()-photo_pub","DATEDIFF(NOW(),photo_pub)") & "))) DESC"
	elseif strStatsMode = "popularity" then
		SQL = "SELECT TOP " & intRecordsPerPage__ & " tba_photo.photo_id, tba_photo.photo_title, tba_photo.photo_views, tba_photo.photo_pub, (((((photo_views/(" & IIF(CARNIVAL_DATABASE_TYPE="mdb","now()-photo_pub","DATEDIFF(NOW(),photo_pub)") & "))*(Log((" & IIF(CARNIVAL_DATABASE_TYPE="mdb","now()-photo_pub","DATEDIFF(NOW(),photo_pub)") & "+1)/2)*2)))+((((photo_views/(" & IIF(CARNIVAL_DATABASE_TYPE="mdb","now()-photo_pub","DATEDIFF(NOW(),photo_pub)") & "))*(Log((" & IIF(CARNIVAL_DATABASE_TYPE="mdb","now()-photo_pub","DATEDIFF(NOW(),photo_pub)") & "+1))/2)))/100*Count(tba_comment.comment_id)*5))*100) AS photo_rviews, Count(tba_comment.comment_id) AS photo_comments, (" & IIF(CARNIVAL_DATABASE_TYPE="mdb","now()-photo_pub","DATEDIFF(NOW(),photo_pub)") & ") AS photo_pubdiff " & _
			  "FROM tba_comment RIGHT JOIN tba_photo ON tba_comment.comment_photo = tba_photo.photo_id " & _
			  "WHERE tba_photo.photo_active=1 " & _
			  "GROUP BY tba_photo.photo_id, tba_photo.photo_title, photo_views, photo_pub " & _
			  "ORDER BY ((((photo_views/(" & IIF(CARNIVAL_DATABASE_TYPE="mdb","now()-photo_pub","DATEDIFF(NOW(),photo_pub)") & "))*(Log((" & IIF(CARNIVAL_DATABASE_TYPE="mdb","now()-photo_pub","DATEDIFF(NOW(),photo_pub)") & "+1)/2)*2)))+((((photo_views/(" & IIF(CARNIVAL_DATABASE_TYPE="mdb","now()-photo_pub","DATEDIFF(NOW(),photo_pub)") & "))*(Log((" & IIF(CARNIVAL_DATABASE_TYPE="mdb","now()-photo_pub","DATEDIFF(NOW(),photo_pub)") & "+1))/2)))/100*Count(tba_comment.comment_id)*5)) DESC"
	
	end if
	
	
	
	set dbPagination = new Class_ASPDbPagination
	dbPagination.RecordsPerPageDefault = intRecordsPerPage__

	if dbPagination.Paginate(dbManager.conn, dbManager.database, IIF(strStatsMode="popularity",0,null), null, SQL) then
		lngPaginationLooper__ = 0
	
		dim lngPhotoId, strPhotoTitle, dblPhotoViewsPerday,lngPhotoDays,lngPhotoViews,dblPhotoRViews,lngPhotoComments, dblPhotoPubdiff
		dim intPhotoMax, intPhotoValue, dtmPhotoPub
		intPhotoMax = 0
		while not dbPagination.recordset.eof and ((lngPaginationLooper__ < dbPagination.RecordsPerPage) or (dbPagination.RecordsPerPage = 0 ))
		
			lngPhotoId = inputLong(dbPagination.recordset("photo_id"))
			dtmPhotoPub = inputDate(dbPagination.recordset("photo_pub"))
			strPhotoTitle = outputHTMLString(dbPagination.recordset("photo_title"))
			lngPhotoViews = inputLong(dbPagination.recordset("photo_views"))
			lngPhotoComments = inputLong(dbPagination.recordset("photo_comments"))
			if strStatsMode = "views-day" or strStatsMode = "popularity" then
				dblPhotoRViews = inputDouble(dbPagination.recordset("photo_rviews"))
				dblPhotoPubdiff = inputDouble(dbPagination.recordset("photo_pubdiff"))
				if dblPhotoPubdiff < 1 then dblPhotoRViews =0
			end if
			
			select case strStatsMode
				case "comments"
					intPhotoValue = lngPhotoComments
				case "views-day", "popularity"
					intPhotoValue = dblPhotoRViews
				case "views-full"
					intPhotoValue = lngPhotoViews
			end select
			if (intPhotoValue) > intPhotoMax then intPhotoMax = intPhotoValue
			
			'evita di stampare le foto con media 0
			
			
		%>
		<tr<% if (intPhotoValue = 0 and strStatsMode = "views-day") then %> class="locked"<% end if %>>
        	<td class="ordinal"><%=lngPaginationLooper__+dbPagination.Record%></td>
			<td class="thumb"><img src="<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & lngPhotoId & CARNIVAL_THUMBPOSTFIX & ".jpg"%>" /></td>
			<td class="title"><a href="photo.asp?id=<%=lngPhotoId%>" target="_blank"><span class="id"><%=formatGMTDate(dtmPhotoPub,0,"dd/mm/yyyy")%></span><br/><span class="title"><%=outputHTMLString(strPhotoTitle)%></span></a></td>
			<td class="value<% if strStatsMode = "views-full" then %> sel<% end if %>"><%=formatNumber(lngPhotoViews,0)%></td>
			<td class="value<% if strStatsMode = "comments" then %> sel<% end if %>"><%=lngPhotoComments%></td>
			<% select case strStatsMode
				case "popularity"%>
				<td class="value sel"><%=formatNumber(prop(intPhotoValue,intPhotoMax,100),1) & "%"%></td><%
				case "views-day"%>
				<td class="value sel"><%=IIF(intPhotoValue=0,"<strong>new</strong>",formatNumber(intPhotoValue,2))%></td><%
			end select %>
			<td class="graph"><div style="width:<%=int(prop(intPhotoValue,intPhotoMax,200))%>px"></div>
		</tr>
		<% 
			dbPagination.recordset.movenext
			lngPaginationLooper__ = lngPaginationLooper__ + 1
		wend
		dbPagination.recordset.close
		
		%>
    </table>
    <% if strStatsMode<>"popularity" then %>
		<div class="pagenavigator"><div class="title">Pagine</div><div class="box"><%
		
		response.write dbPagination.printNavigator("<div class=""s"">mostra dati da %RS a %RE di %RT</div><div class=""n"">%PC pagine [ %PN ] [ %LA ]</div>",null,"&amp;module=stats&amp;mode=" & strStatsMode & "",true)
		
		%></div></div><% 
	end if
		if strStatsMode = "views-day" then %>
    <small>le visualizzazioni giornaliere sono il totale della visualizzazione diviso per il numero di giorni in cui la foto &egrave; stata online.</small>
    <% end if
	end if
	%>
    <% else
	dim lngPhotoCount, lngPhotoViewsSum, lngPhotoCommentsCount, dblDatediff
	dim lngPhotoCount_tag, lngPhotoCount_set
	SQL = "SELECT Count(tba_photo.photo_id) AS photo_count, Sum(tba_photo.photo_views) AS photo_sum_views FROM tba_photo WHERE photo_active = 1"
		set rs = dbManager.Execute(SQL)
		lngPhotoCount = inputLong(rs("photo_count"))
		lngPhotoViewsSum = inputLong(rs("photo_sum_views"))
		
	if lngPhotoCount = 0 then response.Redirect("errors.asp?c=stats0")
	
	SQL = "SELECT Count(tba_comment.comment_id) AS comment_count FROM tba_comment"
		set rs = dbManager.execute(SQL)
		lngPhotoCommentsCount = inputLong(rs("comment_count"))
		dblDatediff = datediff("d",config__start__,now)
	SQL = "SELECT Count(tba_tag.tag_id) AS tag_count FROM tba_tag"
		set rs = dbManager.execute(SQL)
		lngPhotoCount_tag = inputLong(rs("tag_count"))
	SQL = "SELECT Count(tba_set.set_id) AS set_count FROM tba_set"
		set rs = dbManager.execute(SQL)
		lngPhotoCount_set = inputLong(rs("set_count"))
		
	%>
    <div class="stats">
        <div class="statsbox">
            <div class="title">foto caricate</div>
            <div class="value"><%=lngPhotoCount%></div>
            <div class="valueadd"><%=formatNumber(lngPhotoCount/dblDatediff,2)%> per giorno</div>
        </div>
        <div class="statsbox">
            <div class="title">visualizzazioni</div>
            <div class="value"><%=lngPhotoViewsSum%></div>
            <div class="valueadd"><%=formatNumber(lngPhotoViewsSum/dblDatediff,2)%> per giorno</div>
    	</div>
        <div class="statsbox">
            <div class="title">commenti</div>
            <div class="value"><%=lngPhotoCommentsCount%></div>
            <div class="valueadd"><%=formatNumber(lngPhotoCommentsCount/dblDatediff,2)%> per giorno</div>
        </div>
        <div class="statsbox">
            <div class="title">tag</div>
            <div class="value"><%=lngPhotoCount_tag%></div>
            <div class="valueadd"><%=formatNumber(lngPhotoCount/lngPhotoCount_tag,2)%> foto per tag</div>
        </div>
        <div class="statsbox">
            <div class="title">set</div>
            <div class="value"><%=lngPhotoCount_set%></div>
            <div class="valueadd"><%=formatNumber(lngPhotoCount/lngPhotoCount_set,2)%> foto per set</div>
        </div>
        <div class="statsbox">
            <div class="title">in attivit&agrave; dal</div>
            <div class="value longtext"><%=formatGMTDate(config__start__,0,"dd/mm/yyyy")%></div>
            <div class="valueadd"><%=formatNumber(datediff("d",config__start__,now),0)%> giorni di attivit&agrave;</div>
        </div>
        <div class="clear"></div>
    </div>
    <%
	end if %>	