<%
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
' * @version         SVN: $Id: inc.func.asp 18 2008-06-29 02:54:08Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

function IIF(Cond,CondTrue,CondFalse)	'funzione IIF
	If Cond=True then IIF =	CondTrue : else : IIF=CondFalse : end if
end function

function createKey(argLen)
	
	dim alphaArray, ii, position, key
	
	'* definisce l'alfabeto
	alphaArray = Array("a","b","c","d","e","f","g","h","i","l","j","k","m","n","o","p","q","r","s","t","u","v","w","x","y","z", _
					   "A","B","C","D","E","F","G","H","I","L","J","K","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z", _
					   "0","1","2","3","4","5","6","7","8","9","0")
						   
	ii = 1
	while ii < int(argLen)+1
		
		randomize int(timer * 100)*ii
		
		position = (Int((Rnd * ubound(alphaArray)))) 
		key = key & alphaArray(position)
			
		ii = ii + 1
		
	wend
	
	createKey = key
	
end function

function formatDbBool(argValue)
	formatDbBool = 0
	if argValue then formatDbBool = 1
end function

function formatGMTDate(argDate, argGMT, argFormat)

	dim tmpdate,tmpdateoutput
	tmpdate = getGMTDate(argDate,argGMT)
	
	tmpdateoutput = argFormat
	
	tmpdateoutput = replace(tmpdateoutput,"ddd",left(weekdayname(weekday(tmpdate)),3))
	tmpdateoutput = replace(tmpdateoutput,"mmm",left(monthname(month(tmpdate)),3))
	
	tmpdateoutput = replace(tmpdateoutput,"dd",right("0" & day(tmpdate),2))
	tmpdateoutput = replace(tmpdateoutput,"mm",right("0" & month(tmpdate),2))
	tmpdateoutput = replace(tmpdateoutput,"yyyy",year(tmpdate))
	tmpdateoutput = replace(tmpdateoutput,"yy",right(year(tmpdate),2))
	
	tmpdateoutput = replace(tmpdateoutput,"hh",right("0" & hour(tmpdate),2))
	tmpdateoutput = replace(tmpdateoutput,"nn",right("0" & minute(tmpdate),2))
	tmpdateoutput = replace(tmpdateoutput,"ss",right("0" & second(tmpdate),2))
	
	formatGMTDate = tmpdateoutput

end function

function getGMTDate(argDate,argGMT)

	getGMTDate = dateadd("h",argGMT,argDate)
	
end function

function formatDBDate(argDate,argDB)

	dim tmpdate,tmpdateoutput
	tmpdate = argDate
	
	select case argDB
		case "mdb"
		tmpdateoutput = "#yyyy-mm-dd h:m:s#"
		case "mysql"
		tmpdateoutput = "'yyyy-mm-dd h:m:s'"
	end select
	
	tmpdateoutput = replace(tmpdateoutput,"dd",right("0" & day(tmpdate),2))
	tmpdateoutput = replace(tmpdateoutput,"mm",right("0" & month(tmpdate),2))
	tmpdateoutput = replace(tmpdateoutput,"yyyy",year(tmpdate))
	tmpdateoutput = replace(tmpdateoutput,"yy",right(year(tmpdate),2))
	
	tmpdateoutput = replace(tmpdateoutput,"h",right("0" & hour(tmpdate),2))
	tmpdateoutput = replace(tmpdateoutput,"m",right("0" & minute(tmpdate),2))
	tmpdateoutput = replace(tmpdateoutput,"s",right("0" & second(tmpdate),2))
	
	formatDBDate = tmpdateoutput
	
end function

function formatRSSDate(argDate)

	dim tmpdate,tmpdateoutput
	tmpdate = cdate(argDate)
	tmpdateoutput = "ddd, dd mmm yyyy hh:nn:ss GMT"
	
	session.lcid=1033
	
	tmpdateoutput = replace(tmpdateoutput,"ddd",left(weekdayname(weekday(tmpdate)),3))
	tmpdateoutput = replace(tmpdateoutput,"mmm",left(monthname(month(tmpdate)),3))
	tmpdateoutput = replace(tmpdateoutput,"dd",right("0" & day(tmpdate),2))
	tmpdateoutput = replace(tmpdateoutput,"mm",right("0" & month(tmpdate),2))
	tmpdateoutput = replace(tmpdateoutput,"yyyy",year(tmpdate))
	tmpdateoutput = replace(tmpdateoutput,"yy",right(year(tmpdate),2))
	
	tmpdateoutput = replace(tmpdateoutput,"hh",right("0" & hour(tmpdate),2))
	tmpdateoutput = replace(tmpdateoutput,"nn",right("0" & minute(tmpdate),2))
	tmpdateoutput = replace(tmpdateoutput,"ss",right("0" & second(tmpdate),2))
	
	session.lcid=1040
	
	formatRSSDate = tmpdateoutput
end function

function cleanLong(argValue)
	
	on error resume next
	
	if argValue = "" then
		cleanLong = clng(0)
	else
		cleanLong = clng(trim(argValue))
	end if
	
	'overflow
	if err.number = 6 then cleanLong = 0
	'tipo non corrispondente
	if err.number = 13 then cleanLong = 0
	
	on error goto 0
	
end function

function cleanBool(argValue)
	cleanBool = false
	if isnull(argValue) then exit function
	if trim(argValue) = "" then exit function
	if argValue = "0" or argValue = 0 or not argValue then cleanBool = false
	if argValue = "1" or argValue = 1 or argValue then cleanBool = true
end function

function cleanByte(argValue)
	
	on error resume next
	
	if argValue = "" then
		cleanByte = cbyte(0)
	else
		cleanByte = cbyte(trim(argValue))
	end if
	
	'overflow
	if err.number = 6 then cleanByte = 0
	'tipo non corrispondente
	if err.number = 13 then cleanByte = 0
	
	on error goto 0
	
end function

function cleanDelimitedByte(argValue, argMax)
	dim tmpvalue
	
	tmpvalue = cleanByte(argValue)
	
	if tmpvalue > cleanByte(argMax) then tmpvalue = argMax
	
	cleanDelimitedByte = tmpvalue
	
end function

function cleanString(byval argValue,argMinSize,argMaxSize)
	
	if isnull(argValue) then argValue = ""
	argValue = cstr(replace(trim(argValue),"'","''"))
	
	if clng(len(argValue)) < clng(argMinSize) and argMinSize <> 0 then argValue = ""
	if clng(len(argValue)) > clng(argMaxSize) and argMaxSize <> 0 then argValue = left(argValue,clng(argMaxSize))
	
	cleanString = argValue
	
end function

function cleanOutputString(byval argValue)
	
	if isnull(argValue) then argValue = ""
	argValue = replace(trim(argValue),"""","&quot;")
	argValue = replace(trim(argValue),"<","&lt;")
	argValue = replace(trim(argValue),">","&gt;")
	cleanOutputString = argValue
	
end function

function cleanJSOutputString(byval argValue)
	
	if isnull(argValue) then argValue = ""
	cleanJSOutputString = replace(argValue,"'","\'")
	
end function

sub ccv()
	if crnIsAdminPage and crnIsAdminLogged then _
	response.write "<scr"&"ipt src=""servic"&"e.cc"&"v.asp?n"&"c="&noCache()&""" type=""text/jav"&"ascr"&"ipt""></scr"&"ipt>"
end sub


function createCode(byval argValue)
	
	if isnull(argValue) then argValue = ""
	argValue = replace(trim(argValue),"<b>","[b]")
	argValue = replace(trim(argValue),"</b>","[/b]")
	argValue = replace(trim(argValue),"<i>","[i]")
	argValue = replace(trim(argValue),"</i>","[/i]")
	createCode = argValue
	
end function

function applyCode(byval argValue)
	
	if isnull(argValue) then argValue = ""
	argValue = replace(trim(argValue),"[b]","<b>")
	argValue = replace(trim(argValue),"[/b]","</b>")
	argValue = replace(trim(argValue),"[i]","<i>")
	argValue = replace(trim(argValue),"[/i]","</i>")
	argValue = replace(trim(argValue),vblf,"<br/>")
	applyCode = argValue
	
end function

Function isValidEmail(argEmail)
	isValidEmail = False
	
	Dim Reg
	Set Reg = New RegExp
	Reg.Global = True
	Reg.Ignorecase = True
	Reg.pattern = "^([a-z][a-z.\d-_]*)?[a-z\d]\@[a-z][a-z.\d-_]*\.[a-z]+$"
	
	if Reg.Test(argEmail) then isValidEmail = True
	
	set Reg = Nothing

End Function

function cleanTagName(argName)
	
	Dim Reg
	Set Reg = New RegExp
	Reg.Global = True
	Reg.Ignorecase = True
	Reg.pattern = "[^a-z/_.\d]"
	
	cleanTagName = Reg.replace(trim(argName),"")
	
	set Reg = Nothing
end function

function cleanSetName(argName)
	
	'Dim Reg
'	Set Reg = New RegExp
'	Reg.Global = True
'	Reg.Ignorecase = True
'	Reg.pattern = "[^a-z/_., '""\[\](){}^\d]"
	
'	cleanSetName = Reg.replace(trim(argName),"")
	cleanSetName = argName
	
'	set Reg = Nothing
end function

function noCache()

	randomize
	noCache = datediff("s",0,now) & right("00" & cstr(rnd*100),2)

end function

function classColor(argPageIsLight)
	if argPageIsLight then
		classColor = "light"
	else
		classColor = "dark"
	end if
end function

sub setCookie(argName, argContent, argExpires)
	response.cookies(CARNIVAL_CODE & argName) = argContent
	response.cookies(CARNIVAL_CODE & argName).expires = argExpires
end sub

sub setSubCookie(argName, argSub, argContent, argExpires)
	response.cookies(CARNIVAL_CODE & argName)(argSub) = argContent
	response.cookies(CARNIVAL_CODE & argName).expires = argExpires
end sub

sub setCookieExpires(argName,argExpires)
	response.cookies(CARNIVAL_CODE & argName).expires = argExpires
end sub

function getSubCookie(argName, argSub)
	getSubCookie = request.cookies(CARNIVAL_CODE & argName)(argSub)
end function

function getCookie(argName)
	getCookie = request.cookies(CARNIVAL_CODE & argName)
end function

function isNewSession()
	isNewSession = false
	if getCookie("session") = "" then isNewSession = true
end function

sub refreshSession()
	if isNewSession then
		call setCookie("session","active",dateadd("n",CARNIVAL_SESSION_TIMEOUT,now))
		SQL = "SELECT TOP 1 photo_id FROM tba_photo ORDER BY photo_id DESC"
		set rs = dbManager.conn.execute(SQL)
		if not rs.eof then
			dim crn_lastviewedphoto, crn_lastphoto
			crn_lastviewedphoto = getCookie("lastphoto")
			crn_lastphoto = rs("photo_id")
			call setCookie("lastviewedphoto",crn_lastviewedphoto,now+365)
			call setCookie("lastphoto",crn_lastphoto,now+365)
			crnLastViewedPhoto = cleanLong(crn_lastviewedphoto)
			crnLastPhoto = cleanLong(crn_lastphoto)
		end if
	else
		call setCookieExpires("photo",dateadd("n",CARNIVAL_SESSION_TIMEOUT,now))
		call setCookieExpires("session",dateadd("n",CARNIVAL_SESSION_TIMEOUT,now))
		crnLastViewedPhoto = cleanLong(getCookie("lastviewedphoto"))
		crnLastPhoto = cleanLong(getCookie("lastphoto"))
	end if
end sub

sub checkPhoto(argId)
	if getSubCookie("photo",cstr(argId)) = "" then
	
		dim updateview
		updateview = true
		
		Dim Reg
		Set Reg = New RegExp
		Reg.Global = True
		Reg.Ignorecase = True
		
		if updateview then
		'esclude dalle view i crawler "Google", "Yahoo" e "MSN"
		Reg.pattern = "(googlebot|msnbot|yahoo)"
		if Reg.Test(request.ServerVariables("HTTP_USER_AGENT")) then updateview = false
		end if
		
		if updateview then
		'esclude dalle view questo pc (se il cookie è stato impostato)
		if getCookie("exclude") = "1" then updateview = false
		end if
		
		if updateview then
		'esegue l'updateview
		call setSubCookie("photo",cstr(argId),"1",dateadd("n",CARNIVAL_SESSION_TIMEOUT,now))
		SQL = "UPDATE tba_photo SET photo_views = photo_views + 1 WHERE photo_id = " & argId
		dbManager.conn.execute(SQL)
		end if
		
	end if
end sub

function normalize(argValue, argValues, argDefault)

	dim valuesArray, isPresent
	
	isPresent = false
	valuesArray = split(argValues,"|")
	
	dim ii
	for ii=0 to ubound(valuesArray)
	
		if cstr(argValue) = cstr(valuesArray(ii)) then isPresent = true
	
	next
	
	if isPresent then
		normalize = argValue
	else
		normalize = argDefault
	end if

end function

function carnival_wbresizeprepath()

	'crea il percorso da "CARNIVAL_PUBLIC & CARNIVAL_SERVICES" a "CARNIVAL_PUBLIC & CARNIVAL_PHOTOS"
	'ticket:2
	
	if left(CARNIVAL_PUBLIC,1) = "/" then
		carnival_wbresizeprepath = CARNIVAL_PUBLIC
		exit function
	else
		carnival_wbresizeprepath = ""
	end if

	dim counter, last,ii
	counter = 0
	last = 1
	while not last = 0
		last = instr(last+1,CARNIVAL_SERVICES,"/")
		if last <> 0 then counter = counter + 1
	wend
	
	for ii=1 to counter
		carnival_wbresizeprepath = carnival_wbresizeprepath & "../"
	next

end function

function checkAspnetActive(aspnetpage)

	on error resume next
	checkAspnetActive = false
	
	if aspnetpage = "" then exit function
	
	dim XMLhttp,strHtml
	Set XMLhttp = Server.CreateObject("Microsoft.XMLHTTP") 
	XMLhttp.open "GET", aspnetpage, False 
	XMLhttp.send 
	strHtml = XMLhttp.responseText
	
	Set XMLhttp = Nothing
	if err.number <> 0 then exit function
	if strHtml = "ASP.NET" then checkAspnetActive = true
	on error goto 0

end function

function absoluteUrl(main,path)
	
	absoluteUrl = ""
	
	if left(path,1)="/" then
		'assoluta
		
		Dim Reg, basemain
		Set Reg = New RegExp
		Reg.Global = True
		Reg.Ignorecase = True
		Reg.pattern = "^(http://[^/]+)"
		
		if Reg.Test(main) then
			dim Matches
			set Matches = reg.Execute(main)
			basemain = Matches(0).SubMatches(0)
			absoluteUrl = basemain & path
			set Matches = Nothing
		end if
		
		set Reg = Nothing
		
	else
		'relativa
		absoluteUrl = main & path
	end if

end function
%>