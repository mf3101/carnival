<!--#include file = "includes/inc.first.asp"--><%
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
' * @version         SVN: $Id: photo.asp 117 2010-10-11 19:22:40Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "includes/inc.func.photo.asp"-->
<!--#include file = "includes/inc.func.rss.asp"--><%
'*****************************************************

dim strPhotoTitle, strPhotoDescription, dtmPhotoPub, strPhotoUrl,lngPhotoOrder
dim strSetName

'Verifica se ci sono foto da pubblicare
call checkPhotoPub()

blnIsPhotosPage__ = true

dim lngPhotoPrevId, lngPhotoNextId
dim strPhotoPrevTitle, strPhotoNextTitle
dim lngPhotoPhotos

lngCurrentPhotoId__ = inputLong(request.QueryString("id"))
if lngCurrentPhotoId__ < 0 then lngCurrentPhotoId__ = 0

strCurrentTagName__ = request.QueryString("tag")
if strCurrentTagName__ = "(NEW)" then strCurrentTagName__ = ""
lngCurrentTagId__ = 0

lngCurrentSetId__ = inputLong(request.QueryString("set"))
strSetName = ""

if strCurrentTagName__ <> "" then
	SQL = "SELECT tag_id, tag_name,tag_photos FROM tba_tag WHERE tag_name = '" & formatDBString(strCurrentTagName__,null) & "'"
	set rs = dbManager.Execute(SQL)
	if rs.eof then response.Redirect("default.asp")
	lngCurrentTagId__ = rs("tag_id")
	strCurrentTagName__ = rs("tag_name")
	lngPhotoPhotos = inputLong(rs("tag_photos"))
	'strPageTitle__ = replace(lang__photo_title_tag__,"%s",strCurrentTagName__) & replace(lang__photo_title_photos__,"%n",lngPhotoPhotos)
elseif lngCurrentSetId__ > 0 then
	SQL = "SELECT set_id,set_name, set_photos FROM tba_set WHERE set_id = " & lngCurrentSetId__
	set rs = dbManager.Execute(SQL)
	if rs.eof then response.Redirect("default.asp")
	lngCurrentSetId__ = rs("set_id")
	strSetName = rs("set_name")
	lngPhotoPhotos = inputLong(rs("set_photos"))
else
	SQL = "SELECT Count(*) AS photos FROM tba_photo WHERE photo_active = 1"
	set rs = dbManager.Execute(SQL)
	lngPhotoPhotos = inputLong(rs("photos"))
	'strPageTitle__ = lang__photo_title_all__ & replace(lang__photo_title_photos__,"%n",lngPhotoPhotos)
end if


SQL = getLastPhotoSQL(lngCurrentPhotoId__,lngCurrentTagId__,lngCurrentSetId__)
set rs = dbManager.Execute(SQL)
if rs.eof then
	if lngCurrentTagId__ = 0 and lngCurrentSetId__ = 0 then response.redirect("errors.asp?c=photo0")
	response.Redirect("default.asp")
end if
lngCurrentPhotoId__ = rs("photo_id")
strPhotoTitle = server.HTMLEncode(rs("photo_title"))
dtmPhotoPub = inputDate(rs("photo_pub"))
lngPhotoOrder = inputLong(rs("photo_order"))

call checkPhoto(lngCurrentPhotoId__)

dim lngPhotoComments
lngPhotoComments = 0
SQL = "SELECT Count(comment_id) AS commentscount FROM tba_comment WHERE comment_photo = " & lngCurrentPhotoId__
set rs = dbManager.Execute(SQL)
lngPhotoComments = rs("commentscount")
strMenuCommentText__ = lang__menu_comments__ & " (" & lngPhotoComments & ")"
	
'***********************************************************************************
'SELEZIONA FOTO PRECEDENTE
SQL = getPrevPhotoSQL(lngCurrentTagId__,lngCurrentSetId__,dtmPhotoPub,lngPhotoOrder)
set rs = dbManager.Execute(SQL)
if rs.eof then
	lngPhotoPrevId = 0 				: strPhotoPrevTitle = "-"
else
	lngPhotoPrevId = rs("photo_id")	: strPhotoPrevTitle = rs("photo_title")
end if
'***********************************************************************************
'SELEZIONA FOTO SUCCESSIVA
SQL = getNextPhotoSQL(lngCurrentTagId__,lngCurrentSetId__,dtmPhotoPub,lngPhotoOrder)
set rs = dbManager.Execute(SQL)
if rs.eof then
	lngPhotoNextId = 0 				: strPhotoNextTitle = "-"
else
	lngPhotoNextId = rs("photo_id") 	: strPhotoNextTitle = rs("photo_title")
end if
'***********************************************************************************

dim strQuerystringAdd
strQuerystringAdd = ""
if lngCurrentTagId__ <> 0 then strQuerystringAdd = strQuerystringAdd & "&amp;tag=" & strCurrentTagName__
if lngCurrentSetId__ <> 0 then strQuerystringAdd = strQuerystringAdd & "&amp;set=" & lngCurrentSetId__

strPhotoUrl = CARNIVAL_PUBLIC & CARNIVAL_PHOTOS & CARNIVAL_PHOTOPREFIX & lngCurrentPhotoId__ & ".jpg"
strPageTitleHead__ = config__title__ '& " ::: " & lang__photo_title__ & " > """ & strPhotoTitle & """"

%><!--#include file = "includes/inc.top.asp"-->
<% if config__jsactive__ then %>
<script type="text/javascript">/* <![CDATA[ */


var title = String('<%=outputJSString(config__title__)%>')
var selected = Number(<%=lngCurrentPhotoId__%>);
var tag = Number(<%=lngCurrentTagId__%>);
var set = Number(<%=lngCurrentSetId__%>);
var pathimages = '<%=config__pathimages__%>';
var pathphotos = '<%=CARNIVAL_PUBLIC & CARNIVAL_PHOTOS%>';
var lastviewedphoto = Number(<%=lngLastViewedPhotoId__%>);
var lastviewedphotopub = Date.parse('<%=formatGMTDate(inputDate(dtmLastViewedPhotoPub__),0,"yyyy/mm/dd hh:nn:ss")%>');
var baloons = true;
var navigatorbox = <%=IIF(config__jsnavigatoractive__ and config__jsactive__,"true","false")%>;

var debugging = <%=IIF(CARNIVAL_DEBUGMODE,"true","false")%>;
var mode = <%=config__mode__%>;

var lang_title = String('<%=outputJSString(lang__photo_title__)%>');
var lang_comments = String('<%=outputJSString(lang__main_comments__)%>');
var lang_details = String('<%=outputJSString(lang__main_details__)%>');
var lang_close = String('<%=outputJSString(lang__main_close__)%>');
var lang_new = String('<%=outputJSString(lang__photo_new__)%>');
//overlay
function overlay() {
	//#overlay > div#init
	$('overlay').appendChild(createDiv('init',''));
	
	//#init > img
	$('init').appendChild(createImg('',pathimages+'lay-loading-bar.gif','LOADING...'));
	
	//#init > div#initinfo
	$('init').appendChild(createDiv('initinfo',''));
	
	$('overlay').setHeight(window.getSize().y);
	$('container').hide();
	$('overlay').show();
}
overlay();

//if (!is_ie) window.onresize = function() { eventOnResize(); };
document.onmouseout = function() { eventOnMouseOut(); };
window.addEvent('domready', function() { initCarnival(); });
window.addEvent('resize', function() { eventOnResize(); });

/* ]]> */</script>
<% end if %>
<div id="header" class="photo">
	<div class="content">
        <div id="navigator-toggle-box">
        <span id="photo-category"><% 
			if strCurrentTagName__ <> "" then 
				response.write "<img src=""" & getImagePath("lay-ico-tag.gif") & """ alt=""""  /> " & strCurrentTagName__ 
			elseif strSetName <> "" then 
				response.write "<img src=""" & getImagePath("lay-ico-set.gif") & """ alt=""""  /> " & strSetName 
			else
				response.write "<img src=""" & getImagePath("lay-ico-camera.gif") & """ alt=""""  /> " & "stream"
			end if%></span>
        <span id="navigator-toggle">&nbsp;</span>
        </div>
    	<div id="photo-header-title"><div id="photo-title"><%=strPhotoTitle%>
        
        	<!--<span> <a href="comments.asp?id=<%=lngCurrentPhotoId__%>"><img src="<%=getImagePath("lay-ico-comment.gif")%>" alt="" /></a></span><a href="javascript:switchDisplayNavigator();">aaa</a>-->
        </div>
    	<div id="photo-date"><%=formatGMTDate(dtmPhotoPub,0,"dd/mm/yyyy")%></div>
        <div id="photo-new"><% if dtmLastViewedPhotoPub__ < dtmPhotoPub and lngLastViewedPhotoId__ <> 0 then%><%=lang__photo_new__%><% end if %></div></div>
    </div>
</div>
<div class="clear"></div>
<div id="photo-navigator-box" style="display:none;"></div>
<div class="clear"></div>
<!--<div id="photo-header-nojs" style="display:none;"><div id="photo-date"><%=formatGMTDate(dtmPhotoPub,0,"dd/mm/yyyy")%></div><div id="photo-tag"><% if strCurrentTagName__ <> "" then response.write "( " & strCurrentTagName__ & " )" %><% if strSetName <> "" then response.write "( " & strSetName & " )" %></div></div>-->
<div id="photo-box-nojs">
	<div id="photo-overlay-open"></div>
	<div id="photo-overlay"></div>
	<div id="photo-overlay-comments"></div>
	<div id="photo-overlay-details"></div>
	<div id="photo-overlay-buttons"></div>
	<div id="photo"><img id="photo-img-nojs" src="<%=strPhotoUrl%>" alt="photo" /></div>
</div>
<div id="photo-slideshow"></div>
<div id="photo-nav-nojs">
	<div id="photo-next"<% if lngPhotoNextId = 0 then %> style="display:none;"<% end if %>><a href="?id=<%=lngPhotoNextId%><%=strQuerystringAdd%>" <% if config__jsactive__ then %>onclick="next();return false;" <% end if %>id="next" title="<%=strPhotoNextTitle%>"><img id="nextimg" src="<%=getImagePath("lay-photo-nav-next-nojs.gif")%>" alt="<%=lang__main_next__%>"  /></a></div>
	<div id="photo-prev"<% if lngPhotoPrevId = 0 then %> style="display:none;"<% end if %>><a href="?id=<%=lngPhotoPrevId%><%=strQuerystringAdd%>" id="prev" <% if config__jsactive__ then %>onclick="previous();return false;" <% end if %>title="<%=strPhotoPrevTitle%>"><img id="previmg" src="<%=getImagePath("lay-photo-nav-prev-nojs.gif")%>" alt="<%=lang__main_prev__%>"  /></a></div>
</div>
<!--#include file = "includes/inc.bottom.asp"-->
