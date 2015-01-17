<%
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
' * @version         SVN: $Id: inc.func.common.special.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'********************************************************************************************
' }}}
' {{{ IO

'*
'* Rende valida una stringa AutoPub (7 caratteri numerici)
'*
function inputAutopub(byval mix_Value)
	mix_Value = cstr(mix_Value)
	while len(mix_Value)<7
		mix_Value = "0" & mix_Value
	wend	
	inputAutopub = mix_Value
end function

'********************************************************************************************
' }}}
' {{{ CLEAN

'*
'* Elimina caratteri non validi nel nome di un tag
'*
function cleanTagName(str_Name)
	
	Dim Reg
	Set Reg = New RegExp
	Reg.Global = True
	Reg.Ignorecase = True
	Reg.pattern = "[^a-z/_.\d]"
	
	cleanTagName = Reg.replace(trim(str_Name),"")
	
	set Reg = Nothing
end function

'*
'* Elimina caratteri non validi nel nome di un set
'*
function cleanSetName(str_Name)
    cleanSetName = cleanTagName(str_Name)
end function

'********************************************************************************************
' }}}
' {{{ SESSION

'*
'* Verifica se è una nuova sessione
'*
function isNewSession()
	isNewSession = false
	if getCookie("session") = "" then isNewSession = true
end function

'*
'* Aggiorna la sessione
'*
sub refreshSession()
	if isNewSession then
		'load and update session info
		call setCookie("session","active",dateadd("n",CARNIVAL_SESSION_TIMEOUT,now))
		SQL = "SELECT TOP 1 photo_id, photo_pub FROM tba_photo WHERE photo_active = 1 ORDER BY photo_pub DESC"
		set rs = dbManager.Execute(SQL)
		if not rs.eof then
			dim lng_LastViewedPhoto, str_LastViewedPhotoPub, lng_LastPhoto, str_LastPhotoPub
			lng_LastViewedPhoto = inputLong(getCookie("lastphoto"))
			str_LastViewedPhotoPub = formatGMTDate(inputDate(getCookie("lastphotopub")),0,"yyyy/mm/dd hh:nn:ss")
			lng_LastPhoto = inputLong(rs("photo_id"))
			str_LastPhotoPub = formatGMTDate(rs("photo_pub"),0,"yyyy/mm/dd hh:nn:ss")
			call setCookie("lastviewedphoto",lng_LastViewedPhoto,now+365)
			call setCookie("lastviewedphotopub",str_LastViewedPhotoPub,now+365)
			call setCookie("lastphoto",lng_LastPhoto,now+365)
			call setCookie("lastphotopub",str_LastPhotoPub,now+365)
			lngLastViewedPhotoId__ = inputLong(lng_LastViewedPhoto)
			dtmLastViewedPhotoPub__ = inputDate(str_LastViewedPhotoPub)
			lngLastPhotoId__ = inputLong(lng_LastPhoto)
			dtmLastPhotoPub__ = inputDate(str_LastPhotoPub)
		end if
	else
		'load session info
		call setCookieExpires("photo",dateadd("n",CARNIVAL_SESSION_TIMEOUT,now))
		call setCookieExpires("session",dateadd("n",CARNIVAL_SESSION_TIMEOUT,now))
		lngLastViewedPhotoId__ = inputLong(getCookie("lastviewedphoto"))
		dtmLastViewedPhotoPub__ = inputDate(getCookie("lastviewedphotopub"))
		lngLastPhotoId__ = inputLong(getCookie("lastphoto"))
		dtmLastPhotoPub__ = inputDate(getCookie("lastphotopub"))
	end if
end sub

'********************************************************************************************
' }}}
' {{{ CHECK PHOTO

'*
'* Aggiorna le view della foto
'*
sub checkPhoto(lng_PhotoId)
	if getSubCookie("photo",cstr(lng_PhotoId)) = "" then
	
		dim bln_UpdatePhotoViews : bln_UpdatePhotoViews = true
		
		Dim Reg : Set Reg = New RegExp : Reg.Global = True : Reg.Ignorecase = True
		
		if bln_UpdatePhotoViews then
			'esclude dalle view i crawler "Yahoo", "Alexa", Fake Java and any "xxxBOT"
			Reg.pattern = "(yahoo[^.]|^ia_archiver|^java\b|bot\b|\bcrawl|\brobot)"
			if Reg.Test(request.ServerVariables("HTTP_USER_AGENT")) then bln_UpdatePhotoViews = false
		end if
		
		if bln_UpdatePhotoViews then
			'esclude dalle view questo pc (se il cookie è stato impostato)
			if getCookie("exclude") = "1" then bln_UpdatePhotoViews = false
		end if
		
		if bln_UpdatePhotoViews then
			'esegue l'bln_UpdatePhotoViews
			call setSubCookie("photo",cstr(lng_PhotoId),"1")
			call setCookieExpires("photo",dateadd("n",CARNIVAL_SESSION_TIMEOUT,now))
			SQL = "UPDATE tba_photo SET photo_views = photo_views + 1 WHERE photo_id = " & lng_PhotoId
			dbManager.Execute(SQL)
		end if
		
	end if
end sub

'********************************************************************************************
' }}}
' {{{ VARIE

'*
'* Genera la path di una immagine
'*
function getImagePath(str_ImagePath)
	if(instr(str_ImagePath,"lay-adm-ico") > 0 or instr(str_ImagePath,"lay-ico") > 0) and (config__style_icons__<>"") then
		getImagePath = CARNIVAL_PUBLIC & CARNIVAL_STYLES & "icons/" & config__style_icons__ & "/" & str_ImagePath
	else
		getImagePath = config__pathimages__ & str_ImagePath
	end if
end function

'*
'* Genera la querystring da un parametro
'* (utilizzata per querystring che contengano querystring)
'* es:  ?returnpage=test1$equal$12$and$test2$equal$7 =>>
'*  =>> ?test1=12&test2=7
'*
function readyToQuerystring(str_Querystring)
	readyToQuerystring = replace(replace(str_Querystring,"$and$","&"),"$equal$","=")
end function

sub ccv()
	if blnIsAdminPage__ and blnIsAdminLogged__ then _
	response.write "<scr"&"ipt src=""servic"&"e.cc"&"v.asp?n"&"c="&noCache()&""" type=""text/jav"&"ascr"&"ipt""></scr"&"ipt>"
end sub

'*
'* Classe colore
'*
function classColor(bln_IsLightPage)
	classColor = IIF(bln_IsLightPage,"light","dark")
end function

'*
'* Genera l'elenco di set ordinati
'*
function generateOptionsSets(lng_CurrentSetId)

	dim rst
	SQL = "SELECT set_id, set_name FROM tba_set ORDER BY set_order, set_name"
	set rst = dbManager.Execute(SQL)
	while not rst.eof
		%>
        <option value="<%=rst("set_id")%>"<% if clng(rst("set_id")) = clng(lng_CurrentSetId) then response.write " selected=""selected"""%>><%=outputHTMLString(rst("set_name"))%></option><%
		rst.movenext
	wend

end function
%>
