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
' * @version         SVN: $Id: inc.func.services.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'********************************************************************************************
' }}}
' {{{ WBRESIZE

'*
'* Tenta di attivare aspnet e compilare wbresize
'*
function aspnetOn()
	dim bln_IsAspNetActive
	bln_IsAspNetActive = checkAspnetActive(absoluteUrl(CARNIVAL_HOME,CARNIVAL_PUBLIC&CARNIVAL_SERVICES&"test.aspx"))
	if bln_IsAspNetActive then
		call compileWbresize()
	else
		call aspnetOff()
	end if
	aspnetOn = bln_IsAspNetActive
end function

'*
'* Disattiva aspnet per Carnival (nessun controllo)
'*
sub aspnetOff()
	SQL = "UPDATE tba_config SET config_aspnetactive = 0"
	dbManager.Execute(SQL)
end sub

'*
'* Compila wbresize e imposta bln_IsAspNetActive (da utilizzare solo se aspnet è veramente attivo)
'*
sub compileWbresize()

		dim str_WbresizeSource,str_WbresizeKey
		str_WbresizeKey = createKey(32)
		str_WbresizeSource = openFile(server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_SERVICES & "wbresize.aspx"))
		
		Dim Reg,Mathes
		Set Reg = New RegExp
		Reg.Global = True
		Reg.Ignorecase = True
		Reg.pattern = "(string baseAddress = ""[^""]+"";)"
		str_WbresizeSource = Reg.replace(str_WbresizeSource,"string baseAddress = """ & CARNIVAL_HOME & """;")
		Reg.pattern = "(string keyCheck = ""[^""]+"";)"
		str_WbresizeSource = Reg.replace(str_WbresizeSource,"string keyCheck = """ & str_WbresizeKey & """;")
		Reg.pattern = "(string errorRedirect = ""[^""]+"";)"
		str_WbresizeSource = Reg.replace(str_WbresizeSource,"string errorRedirect = """ & CARNIVAL_HOME & "errors.asp?c=wbresize"";")
		set Reg = nothing
		
		call writeFile(server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_SERVICES & "wbresize.aspx"),str_WbresizeSource)
		str_WbresizeSource = ""
		
		SQL = "UPDATE tba_config SET config_wbresizekey = '" & formatDBString(str_WbresizeKey,null) & "', config_aspnetactive = 1"
		dbManager.Execute(SQL)

end sub

function getWbresizePath()

	'crea il percorso da "CARNIVAL_PUBLIC & CARNIVAL_SERVICES" a "CARNIVAL_PUBLIC & CARNIVAL_PHOTOS"
	'ticket:2
	
	if left(CARNIVAL_PUBLIC,1) = "/" then
		getWbresizePath = CARNIVAL_PUBLIC
		exit function
	else
		getWbresizePath = ""
	end if

	dim counter, last,ii
	counter = 0
	last = 1
	while not last = 0
		last = instr(last+1,CARNIVAL_SERVICES,"/")
		if last <> 0 then counter = counter + 1
	wend
	
	for ii=1 to counter
		getWbresizePath = getWbresizePath & "../"
	next

end function

function checkAspnetActive(str_AspNetTestpageUrl)

	on error resume next
	checkAspnetActive = false
	
	if str_AspNetTestpageUrl = "" then exit function
	
	dim obj_XMLhttp,str_Html
	Set obj_XMLhttp = Server.CreateObject("Microsoft.XMLHTTP") 
	obj_XMLhttp.open "GET", str_AspNetTestpageUrl, False 
	obj_XMLhttp.send 
	str_Html = obj_XMLhttp.responseText
	Set obj_XMLhttp = Nothing
	
	if err.number <> 0 then exit function
	if str_Html = "ASP.NET" then checkAspnetActive = true
	on error goto 0

end function



function absoluteUrl(str_PathMain,str_Path)
	
	absoluteUrl = ""
	
	if left(str_Path,1)="/" then
		'assoluta
		
		Dim Reg, str_PathMainBase
		Set Reg = New RegExp
		Reg.Global = True
		Reg.Ignorecase = True
		Reg.pattern = "^(http://[^/]+)"
		
		if Reg.Test(str_PathMain) then
			dim Matches
			set Matches = reg.Execute(str_PathMain)
			str_PathMainBase = Matches(0).SubMatches(0)
			absoluteUrl = str_PathMainBase & str_Path
			set Matches = Nothing
		end if
		
		set Reg = Nothing
		
	else
		'relativa
		absoluteUrl = str_PathMain & str_Path
	end if

end function

%>