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
' * @version         SVN: $Id: inc.func.style.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

function checkStyle(ByRef str_StyleConfigContent)
	
	checkStyle = false

	if not isnull(str_StyleConfigContent) then

		dim str_StyleConfigVersion
		dim dbl_StyleVersion
		dim dbl_CarnivalMaxVersion
		dim dbl_CarnivalMinVersion
	
		str_StyleConfigVersion = getStyleVar("version",str_StyleConfigContent)
		
		if not isnull(str_StyleConfigVersion) then
		
			Dim Reg,Matches
			Set Reg = New RegExp
			Reg.Global = True
			Reg.Ignorecase = True
			Reg.pattern = "(\d+)(?:\.)?(\d+|)(?:a|b|c|rc\d)?(?:\.)?(\d+|)"
			
			if reg.test(str_StyleConfigVersion) then
				set Matches = reg.Execute(str_StyleConfigVersion)
				dbl_StyleVersion = cdbl(cstr(Matches(0).SubMatches(0)) & fill(Matches(0).SubMatches(1),1,"0",false) & fill(Matches(0).SubMatches(2),3,"0",false))
			end if
			
			set Matches = reg.Execute(CARNIVAL_STYLECOMPATIBILITY_MAXVERSION)
			dbl_CarnivalMaxVersion = cdbl(cstr(Matches(0).SubMatches(0)) & cstr(Matches(0).SubMatches(1)) & fill(Matches(0).SubMatches(2),3,"0",false))
			
			set Matches = reg.Execute(CARNIVAL_STYLECOMPATIBILITY_MINVERSION)
			dbl_CarnivalMinVersion = cdbl(cstr(Matches(0).SubMatches(0)) & cstr(Matches(0).SubMatches(1)) & fill(Matches(0).SubMatches(2),3,"0",false))
			
			if (dbl_StyleVersion >= dbl_CarnivalMinVersion and dbl_StyleVersion <= dbl_CarnivalMaxVersion) then
				checkStyle = true
			end if
			
			set Matches = Nothing
			
			set Reg = Nothing
		
		end if
	
	end if

end function

function getStyleVar(str_VarName,ByRef str_StyleConfigContent)

	if not isnull(str_StyleConfigContent) and str_StyleConfigContent <> "" then
	
		getStyleVar = null
			
		Dim Reg,Mathes
		Set Reg = New RegExp
		Reg.Global = True
		Reg.Ignorecase = True
		Reg.pattern = "(?:[\r\n]|^)[\t\s]*" & str_VarName & "[\t\s]*=[\t\s]([^\t\r\n]+)"
		
		if Reg.test(str_StyleConfigContent) then
		
			dim Matches
			set Matches = reg.Execute(str_StyleConfigContent)
			getStyleVar = Matches(0).SubMatches(0)
			set Matches = Nothing
		
		end if
		
		set Reg = Nothing
		
	end if
end function

function loadStyle(str_StyleFile)
	Dim obj_FSO, obj_File
	Set obj_FSO = Server.CreateObject("Scripting.FileSystemObject")
	
	on error resume next
	Set obj_File = obj_FSO.OpenTextFile(Server.MapPath(str_StyleFile), 1, false)
	if err.number <> 0 then
		loadStyle = null
		exit function
	end if
	on error goto 0
	
	If Not obj_File.AtEndOfStream Then
		' legge il file
		loadStyle = obj_File.ReadAll
	Else
		' se il file non esiste
		loadStyle = null
	End If
	
	obj_File.Close
	Set obj_File = Nothing
	Set obj_FSO = Nothing
end function

sub compileStyle(bln_Compress,str_InputFile,str_OutputFileMain,str_OutputFileAdmin,str_Font,str_HeaderColor,str_HeaderBackcolor,str_TitleColor,str_TitleMargin,str_TextLightColor,str_TextDarkColor,str_TextMenuColor,int_PhotoWidth,int_PhotoWidthL)

	dim str_InputFileContent, str_OutputFileContent
	dim rstr_OutputFileContent	
	
	Dim obj_FSO, obj_File
	Set obj_FSO = Server.CreateObject("Scripting.FileSystemObject")
	
	'legge l'str_InputFile
	Set obj_File = obj_FSO.OpenTextFile(Server.MapPath(str_InputFile), 1, true)
	str_InputFileContent = ""
	If Not obj_File.AtEndOfStream Then str_InputFileContent = obj_File.ReadAll
	obj_File.Close
	
	'modifica l'str_InputFile
	str_OutputFileContent = str_InputFileContent
	str_OutputFileContent = replace(str_OutputFileContent,"$font$",str_Font&"")
	str_OutputFileContent = replace(str_OutputFileContent,"$header_color$",str_HeaderColor&"")
	str_OutputFileContent = replace(str_OutputFileContent,"$header_backcolor$",str_HeaderBackcolor&"")
	str_OutputFileContent = replace(str_OutputFileContent,"$title_color$",str_TitleColor&"")
	str_OutputFileContent = replace(str_OutputFileContent,"$title_margin$",str_TitleMargin&"")
	str_OutputFileContent = replace(str_OutputFileContent,"$text_light_color$",str_TextLightColor&"")
	str_OutputFileContent = replace(str_OutputFileContent,"$text_dark_color$",str_TextDarkColor&"")
	str_OutputFileContent = replace(str_OutputFileContent,"$text_menu_color$",str_TextMenuColor&"")
	str_OutputFileContent = replace(str_OutputFileContent,"$photo_width$",int_PhotoWidth&"")
	str_OutputFileContent = replace(str_OutputFileContent,"$photo_width_l$",int_PhotoWidthL&"")
	
	rstr_OutputFileContent = split(str_OutputFileContent,"/*$ADMIN$*/")
	
	'scrive l'str_OutputFileMain
	Set obj_File = obj_FSO.CreateTextFile(Server.MapPath(str_OutputFileMain), True)
	obj_File.Write compressStyle(rstr_OutputFileContent(0),bln_Compress)
	obj_File.Close	
	
	if ubound(rstr_OutputFileContent) = 1 then
		'scrive l'str_OutputFileMain admin
		Set obj_File = obj_FSO.CreateTextFile(Server.MapPath(str_OutputFileAdmin), True)
		obj_File.Write compressStyle(rstr_OutputFileContent(1),bln_Compress)
		obj_File.Close
	end if	
	
	Set obj_File = Nothing
	Set obj_FSO = Nothing

end sub

function compressStyle(str_Value,bln_Compress)
	dim Reg

	if bln_Compress then
	
		'elimina i commenti
		dim inizio, fine
		Do
			inizio = InStr(1, str_Value, "/*")
			If inizio = 0 Then Exit Do
			fine = InStr(inizio, str_Value, "*/")
			If fine = 0 Then Exit Do
			str_Value = Left(str_Value, inizio - 1) & " " & Right(str_Value, Len(str_Value) - fine - 1)
		Loop
		
		Set Reg = New Regexp
		Reg.IgnoreCase = True
		Reg.Global = True
		
		'elimina tabulazione e ritorni
		Reg.Pattern = "[\t\n\r]"
		str_Value = Reg.replace(str_Value,"")
		
		'comprime spazi fra selettori e valori
		Reg.Pattern = "[ ]*([{;])[ ]*"
		str_Value = Reg.replace(str_Value,"$1")
		
		'comprime chiusura valori
		Reg.Pattern = "}[ ]*"
		str_Value = Reg.replace(str_Value,"} ")
	  
	end if
	compressStyle = str_Value
	set Reg = nothing

end function

function setStyle(byval str_StyleName,bln_Compress,bln_FullCompile)
	dim str_StyleContent
	str_StyleContent = loadStyle(CARNIVAL_PUBLIC & CARNIVAL_STYLES & str_StyleName & "/cstyleconfig.txt")
	if isnull(str_StyleContent) or str_StyleContent = "" then 
		setStyle = "style0"
		exit function
	end if
	
	dim str_InputFile,str_OutputFileMain,str_OutputFileAdmin,bln_Compatible, str_Images
	dim str_Description
	str_InputFile = getStyleVar("css_input",str_StyleContent)
	str_OutputFileMain = getStyleVar("css_output_main",str_StyleContent)
	str_OutputFileAdmin = getStyleVar("css_output_admin",str_StyleContent)
	
	dim str_Font,str_HeaderColor,str_HeaderBackcolor,str_TitleColor, lng_TitleMargin
	dim str_TextLightColor, str_TextDarkColor, str_TextMenuColor,str_PhotoWidth,str_PhotoWidthL
	dim bln_PhotoPageIsLight,bln_PageIsLight, str_Icons
	
	if not bln_FullCompile then
		SQL = "SELECT config_style_font, config_style_header_color, config_style_header_backcolor, config_style_title_color,config_style_title_margin, config_style_text_light_color, config_style_text_dark_color, config_style_text_menu_color FROM tba_config"
		set rs = dbManager.Execute(SQL)
		str_Font = rs("config_style_font")
		str_HeaderColor = rs("config_style_header_color")
		str_HeaderBackcolor = rs("config_style_header_backcolor")
		str_TitleColor = rs("config_style_title_color")
		lng_TitleMargin = inputLong(rs("config_style_title_margin"))
		str_TextLightColor = rs("config_style_text_light_color")
		str_TextDarkColor = rs("config_style_text_dark_color")
		str_TextMenuColor = rs("config_style_text_menu_color")
		str_Icons = config__style_icons__
	else
		str_Font = inputStringD(request.QueryString("style-font-family"),0,50)
		if str_Font = "" then str_Font = inputStringD(getStyleVar("font",str_StyleContent),0,50)
		str_HeaderColor = inputStringD(request.QueryString("style-header-color"),0,7)
		if str_HeaderColor = "" then str_HeaderColor = inputStringD(getStyleVar("header_color",str_StyleContent),0,7)
		str_HeaderBackcolor = inputStringD(request.QueryString("style-header-backcolor"),0,7)
		if str_HeaderBackcolor = "" then str_HeaderBackcolor = inputStringD(getStyleVar("header_backcolor",str_StyleContent),0,7)
		str_TitleColor = inputStringD(request.QueryString("style-title-color"),0,7)
		if str_TitleColor = "" then str_TitleColor = inputStringD(getStyleVar("title_color",str_StyleContent),0,7)
		lng_TitleMargin = inputLong(request.QueryString("style-title-margin"))
		if lng_TitleMargin = 0 then lng_TitleMargin = inputLong(getStyleVar("title_margin",str_StyleContent))
		str_TextLightColor = inputStringD(request.QueryString("style-text-light-color"),0,7)
		if str_TextLightColor = "" then str_TextLightColor = inputStringD(getStyleVar("text_light_color",str_StyleContent),0,7)
		str_TextDarkColor = inputStringD(request.QueryString("style-text-dark-color"),0,7)
		if str_TextDarkColor = "" then str_TextDarkColor = inputStringD(getStyleVar("text_dark_color",str_StyleContent),0,7)
		str_TextMenuColor = inputStringD(request.QueryString("style-text-menu-color"),0,7)
		if str_TextMenuColor = "" then str_TextMenuColor = inputStringD(getStyleVar("text_menu_color",str_StyleContent),0,7)
		str_Icons = inputStringD(request.QueryString("style-icons"),0,50)
	end if
	
	bln_PhotoPageIsLight = inputBoolean(getStyleVar("page_photo_islight",str_StyleContent))
	bln_PageIsLight = inputBoolean(getStyleVar("page_islight",str_StyleContent))
	
	str_PhotoWidth = inputLong(getStyleVar("int_PhotoWidth",str_StyleContent))
	if str_PhotoWidth = 0 then str_PhotoWidth = 640
	
	dim lng_Margin
	str_PhotoWidthL = str_PhotoWidth
	lng_Margin = getStyleVar("photo_margin",str_StyleContent)
	if isnumeric(lng_Margin) then
		lng_Margin = clng(lng_Margin)*2
	else
		lng_Margin = 5*2
	end if
	str_PhotoWidth = str_PhotoWidth+lng_Margin
	str_PhotoWidthL = str_PhotoWidth-lng_Margin
	set lng_Margin = nothing
	
	bln_Compatible = checkStyle(str_StyleContent)
	str_Images = getStyleVar("images_path",str_StyleContent)
	if not bln_Compatible then 
		setStyle = "style1"
		exit function
	end if
	if not fileExists(CARNIVAL_PUBLIC & CARNIVAL_STYLES & str_StyleName & "/" & str_InputFile) then 
		setStyle = "style2"
		exit function
	end if
	
	call compileStyle(bln_Compress,CARNIVAL_PUBLIC & CARNIVAL_STYLES & str_StyleName & "/" & str_InputFile,CARNIVAL_PUBLIC & CARNIVAL_STYLES & str_StyleName & "/" & str_OutputFileMain,CARNIVAL_PUBLIC & CARNIVAL_STYLES & str_StyleName & "/" & str_OutputFileAdmin,str_Font,str_HeaderColor, str_HeaderBackcolor, str_TitleColor, lng_TitleMargin, str_TextLightColor,str_TextDarkColor,str_TextMenuColor,str_PhotoWidth,str_PhotoWidthL)
	
	str_Description = "<strong>" & getStyleVar("name",str_StyleContent) & "</strong> ( " & getStyleVar("author",str_StyleContent) & " " & getStyleVar("date",str_StyleContent) & " )<br/>" & getStyleVar("note",str_StyleContent)
		
	if bln_FullCompile then
		
		SQL = "UPDATE tba_config SET config_style = '" & formatDBString(str_StyleName,null) & "', " & _
									"config_style_output_main = '" & formatDBString(str_OutputFileMain,null) & "', " & _
									"config_style_output_admin = '" & formatDBString(str_OutputFileAdmin,null) & "', " & _
									"config_style_font = '" & formatDBString(str_Font,null) & "', " & _
									"config_style_images = '" & formatDBString(str_Images,null) & "', " & _
									"config_style_header_color = '" & formatDBString(str_HeaderColor,null) & "', " & _
									"config_style_header_backcolor = '" & formatDBString(str_HeaderBackcolor,null) & "', " & _
									"config_style_title_color = '" & formatDBString(str_TitleColor,null) & "', " & _
									"config_style_title_margin = " & lng_TitleMargin & ", " & _
									"config_style_text_light_color = '" & formatDBString(str_TextLightColor,null) & "', " & _
									"config_style_text_dark_color = '" & formatDBString(str_TextDarkColor,null) & "', " & _
									"config_style_text_menu_color = '" & formatDBString(str_TextMenuColor,null) & "', " & _
									"config_style_photopage_islight = " & formatDbBool(bln_PhotoPageIsLight) & ", " & _
									"config_style_page_islight = " & formatDbBool(bln_PageIsLight) & ", " & _
									"config_style_desc = '" & formatDBString(str_Description,null) & "', " & _
									"config_style_icons = '" & formatDBString(str_Icons,null) & "'"
		dbManager.Execute(SQL)
	else
		
		'aggiorna solo il titolo e la descrizione
		SQL = "UPDATE tba_config SET config_style = '" & formatDBString(str_StyleName,null) & "', " & _
									"config_style_desc = '" & formatDBString(str_Description,null) & "'"
		dbManager.Execute(SQL)
	end if
end function
%>