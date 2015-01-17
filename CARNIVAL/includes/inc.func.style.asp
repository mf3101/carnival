<%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		inc.func.style.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------

function checkStyle(ByRef styleconfig)
	
	checkStyle = false

	if not isnull(styleconfig) then

		dim crn_styleversion
		dim crn_style_vers
		dim crn_carnival_maxvers
		dim crn_carnival_minvers
	
		crn_styleversion = getStyleVar("version",styleconfig)
		
		if not isnull(crn_styleversion) then
		
			Dim Reg,Matches
			Set Reg = New RegExp
			Reg.Global = True
			Reg.Ignorecase = True
			Reg.pattern = "(\d+)(?:\.)?(\d+|)[ab]?(?:\.)?(\d+|)"
			
			if reg.test(crn_styleversion) then
				set Matches = reg.Execute(crn_styleversion)
				crn_style_vers = cdbl(cstr(Matches(0).SubMatches(0)) & formatIntNumber(cstr(Matches(0).SubMatches(1)),1) & formatIntNumber(cstr(Matches(0).SubMatches(2)),3))
			end if
			
			set Matches = reg.Execute(CARNIVAL_STYLECOMPATIBILITY_MAXVERSION)
			crn_carnival_maxvers = cdbl(cstr(Matches(0).SubMatches(0)) & cstr(Matches(0).SubMatches(1)) & formatIntNumber(cstr(Matches(0).SubMatches(2)),3))
			
			set Matches = reg.Execute(CARNIVAL_STYLECOMPATIBILITY_MINVERSION)
			crn_carnival_minvers = cdbl(cstr(Matches(0).SubMatches(0)) & cstr(Matches(0).SubMatches(1)) & formatIntNumber(cstr(Matches(0).SubMatches(2)),3))
			
			if (crn_style_vers >= crn_carnival_minvers and crn_style_vers <= crn_carnival_maxvers) then
				checkStyle = true
			end if
			
			set Matches = Nothing
			
			set Reg = Nothing
		
		end if
	
	end if

end function

function getStyleVar(var,ByRef styleconfig)

	if not isnull(styleconfig) and styleconfig <> "" then
	
		getStyleVar = null
			
		Dim Reg,Mathes
		Set Reg = New RegExp
		Reg.Global = True
		Reg.Ignorecase = True
		Reg.pattern = "(?:[\r\n]|^)[\t\s]*" & var & "[\t\s]*=[\t\s]([^\t\r\n]+)"
		
		if Reg.test(styleconfig) then
		
			dim Matches
			set Matches = reg.Execute(styleconfig)
			getStyleVar = Matches(0).SubMatches(0)
			set Matches = Nothing
		
		end if
		
		set Reg = Nothing
		
	end if
end function

function loadStyle(file)
	Dim objFSO, objFile
	file = Server.MapPath(file)
	Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
	
	on error resume next
	Set objFile = objFSO.OpenTextFile(file, 1, false)
	if err.number <> 0 then
		loadStyle = null
		exit function
	end if
	on error goto 0
	
	If Not objFile.AtEndOfStream Then
		' legge il file
		loadStyle = objFile.ReadAll
	Else
		' se il file non esiste
		loadStyle = null
	End If
	
	objFile.Close
	Set objFile = Nothing
	Set objFSO = Nothing
end function

function formatIntNumber(number,length)

	number = cstr(number)
	
	dim ii
	for ii=0 to length-len(number)-1
		formatIntNumber = formatIntNumber & "0"
	next
	formatIntNumber = left(formatIntNumber & number,length)
	if formatIntNumber = "" then formatIntNumber = 0

end function

sub compileStyle(compress,input,output,outputadmin,font,header_color,header_backcolor,title_color,title_margin,text_light_color,text_dark_color,text_menu_color,photo_width,photo_width_l)

	dim input_style, output_style
	dim output_style_array	
	
	Dim objFSO, objFile
	Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
	
	input = Server.MapPath(input)
	output = Server.MapPath(output)
	outputadmin = Server.MapPath(outputadmin)
	
	'legge l'input
	Set objFile = objFSO.OpenTextFile(input, 1, true)
	input_style = ""
	If Not objFile.AtEndOfStream Then input_style = objFile.ReadAll
	objFile.Close
	
	'modifica l'input
	output_style = input_style
	output_style = replace(output_style,"$font$",font&"")
	output_style = replace(output_style,"$header_color$",header_color&"")
	output_style = replace(output_style,"$header_backcolor$",header_backcolor&"")
	output_style = replace(output_style,"$title_color$",title_color&"")
	output_style = replace(output_style,"$title_margin$",title_margin&"")
	output_style = replace(output_style,"$text_light_color$",text_light_color&"")
	output_style = replace(output_style,"$text_dark_color$",text_dark_color&"")
	output_style = replace(output_style,"$text_menu_color$",text_menu_color&"")
	output_style = replace(output_style,"$photo_width$",photo_width&"")
	output_style = replace(output_style,"$photo_width_l$",photo_width_l&"")
	
	output_style_array = split(output_style,"/*$ADMIN$*/")
	
	'scrive l'output
	Set objFile = objFSO.CreateTextFile(output, True)
	objFile.Write compressStyle(output_style_array(0),compress)
	objFile.Close	
	
	if ubound(output_style_array) = 1 then
		'scrive l'output admin
		Set objFile = objFSO.CreateTextFile(outputadmin, True)
		objFile.Write compressStyle(output_style_array(1),compress)
		objFile.Close
	end if	
	
	Set objFile = Nothing
	Set objFSO = Nothing

end sub

function compressStyle(value,compress)
	dim Reg

	if compress then
	
		'elimina i commenti
		dim inizio, fine
		Do
			inizio = InStr(1, value, "/*")
			If inizio = 0 Then Exit Do
			fine = InStr(inizio, value, "*/")
			If fine = 0 Then Exit Do
			value = Left(value, inizio - 1) & " " & Right(value, Len(value) - fine - 1)
		Loop
		
		Set Reg = New Regexp
		Reg.IgnoreCase = True
		Reg.Global = True
		
		'elimina tabulazione e ritorni
		Reg.Pattern = "[\t\n\r]"
		value = Reg.replace(value,"")
		
		'comprime spazi fra selettori e valori
		Reg.Pattern = "[ ]*([{;])[ ]*"
		value = Reg.replace(value,"$1")
		
		'comprime chiusura valori
		Reg.Pattern = "}[ ]*"
		value = Reg.replace(value,"} ")
	  
	end if
	compressStyle = value

end function
%>