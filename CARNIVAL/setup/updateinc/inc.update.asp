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
' * @version         SVN: $Id: inc.update.asp 109 2010-10-11 10:37:30Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

dim dbManager
set dbManager = new Class_ASPDbManager
dbManager.debugging = false

function connect(dtype,database)	

	on error resume next
	dbManager.database = dtype
	dim str_host, str_user, str_password
	str_host = "" : if dtype = "mysql" then str_host = CARNIVAL_DATABASE_HOST
	str_user = "" : if dtype = "mysql" then str_user = CARNIVAL_DATABASE_USER
	str_password = "" : if dtype = "mysql" then str_password = CARNIVAL_DATABASE_PASSWORD
	on error goto 0
	
	call dbManager.Connect(CARNIVAL_DATABASE,str_user,str_password,"") 'FALSE ERRORE DI CONNESSIONE
end function

sub disconnect()
	call dbManager.Disconnect()
end sub

function IIF(bln_Condition, mix_ExpressionTrue, mix_ExpressionFalse)
	If bln_Condition then IIF =	mix_ExpressionTrue : else : IIF=mix_ExpressionFalse : end if
end function

function copyFile(path,newpath)

	copyFile = false
	on error resume next
	dim obj_FSO,obj_File
	Set obj_FSO=Server.CreateObject("Scripting.FileSystemObject")
	obj_FSO.CopyFile path, newpath
	set obj_FSO = nothing
	if err.number = 0 then copyFile = true
	on error goto 0

end function

function convertVersion(version)
	convertVersion = 0
	select case version
		case "1.0b.0"
			convertVersion = 1
		case "1.0c.0"
			convertVersion = 2
		case "1.0"
		    convertVersion = 3
	end select
end function 

dim reportDB, reportCOPY, reportDEL

sub reportUpdate(action, text)
	select case action
		case "dbadd"
			reportDB = reportDB & "<img src=""setup/dbedit_add.gif"" alt="""" /> " & text & "<br/>"
		case "dbedit"
			reportDB = reportDB & "<img src=""setup/dbedit_edit.gif"" alt="""" /> " & text & "<br/>"
		case "dbdel"
			reportDB = reportDB & "<img src=""setup/dbedit_del.gif"" alt="""" /> " & text & "<br/>"
		case "dbquery"
			reportDB = reportDB & "<img src=""setup/dbedit_query.gif"" alt="""" /> " & text & "<br/>"
		case "copy"
			reportCOPY = reportCOPY & "<img src=""setup/file_copy.gif"" alt="""" /> " & text & "<br/>"
		case "del"
			reportDEL = reportDEL & "<img src=""setup/file_delete.gif"" alt="""" /> " & text & "<br/>"
	end select

end sub

sub reportPrint(action)

	select case action
		case "db"
			if reportDB = "" then reportDB = "<img src=""setup/file_dbedit.gif"" alt="""" /> nessuna operazione sul database necessaria"
			response.write reportDB
		case "copy"
			if reportCOPY = "" then reportCOPY = "<img src=""setup/file_copy.gif"" alt="""" /> nessun file da copiare"
			response.write reportCOPY
		case "del"
			if reportDEL = "" then reportDEL = "<img src=""setup/file_delete.gif"" alt="""" /> nessun file da cancellare"
			response.write reportDEL
	end select

end sub

function convertPath(path)
	dim ret
	ret = path
	ret = replace(ret,"$zipCarnival$","ZIP/carnival/")
	'ret = replace(ret,"$zipDatabase$","ZIP/database/")
	ret = replace(ret,"$zipPublicStyles$","ZIP/public/styles/")
	ret = replace(ret,"$zipPublicServices$","ZIP/public/services/")
	ret = replace(ret,"$Carnival$","/")
	'ret = replace(ret,"$Database$","/")
	ret = replace(ret,"$PublicStyles$",CARNIVAL_PUBLIC&CARNIVAL_STYLES)
	ret = replace(ret,"$PublicServices$",CARNIVAL_PUBLIC&CARNIVAL_SERVICES)
	convertPath = ret
end function

'*******************************************************************************

Class Class_XmlReader
	Private xmlfile 		'l'oggetto xml
	Private xmlrecord		'un dictionary per gli attributi del nodo corrente
	Private xmlsubrecord	'un dictionary per gli attributi dei figli del nodo corrente
	Private xmlpointer		'il puntatore del nodo
	Private xmlsubpointer	'il puntatore dei figli del nodo corrente
	Private xmlversionfrom  'la versione
	Private xmlversionto  	'la versione
	Private xmleof			'la proprietà EOF del nodo
	Private xmlsubeof		'la proprietà EOF dei figli del nodo corrente
	Private reqversion, reqfile
	Private active
	
	Public default Property get Item(key)
		'*** Restituisce il valore dell'attributo del nodo corrente (record)
		'*** se non esiste un nodo corrente (EOF) restituisce NULL
		if xmleof then
			Item = null
		else
			Item = xmlrecord(key)
		end if
	End Property
	
	Public Property get Subnode(key)
		'*** Restituisce il valore dell'attributo del nodo corrente (record)
		'*** se non esiste un nodo corrente (EOF) restituisce NULL
		if xmlsubeof then
			Subnode = null
		else
			Subnode = xmlsubrecord(key)
		end if
	End Property
	
	Public Property Get EOF()
		'*** Restituisce la proprietà EOF
		EOF = xmleof
	End Property
	
	Public Property Get SUBEOF()
		'*** Restituisce la proprietà EOF
		SUBEOF = xmlsubeof
	End Property
	
	Public Property Get Versionfrom()
		Versionfrom = xmlversionfrom
	End Property
	
	Public Property Get Versionto()
		Versionto = xmlversionto
	End Property
	
	Public function Open(file,version)
		'*** RESET VARIABILI DI LAVORO
		active = false
		xmlpointer = -1
		xmlsubpointer = -1
		xmleof = false
		xmlsubeof = false
		xmlversionfrom = ""
		xmlversionto = ""
		reqversion = version
		reqfile = file
		Set xmlrecord = CreateObject("Scripting.Dictionary")
		xmlrecord.CompareMode = 1
		Set xmlfile = Server.CreateObject("Microsoft.XMLDOM")
		xmlfile.async = False
		'*** CARICA IL FILE INDICATO
		on error resume next
		xmlfile.load file
		if err.number <> 0 then
			Open = false
			exit function
		end if
		on error goto 0
		'*** CARICA LE PROPRIETA' DELLA SPECIFICA
		dim attributes,attr
		on error resume next
		Set attributes = xmlfile.documentElement.attributes
		if err.number <> 0 then 
			Open = false
			exit function
		end if
		on error goto 0
		For Each attr in attributes
			select case attr.name
				case "versionto" : xmlversionto = attr.value
				case "versionfrom" : xmlversionfrom = attr.value
			end select
		Next
		'*** CARICA IL PRIMO RECORD
		call movenext()
		Open = true
	End function
	
	Public Sub MoveNext()
		'*** IMPOSTA IL PUNTATORE AL NODO SUCCESSIVO
		xmlpointer = xmlpointer + 1
	
		Set xmlrecord = Nothing
		Set xmlrecord = CreateObject("Scripting.Dictionary")
		xmlrecord.CompareMode = 1
		'*** CARICA GLI ATTRIBUTI DAL NODO CORRENTE
		dim attr,attributes
		on error resume next
		Set attributes = xmlfile.documentElement.childNodes(xmlpointer).attributes
		if err.number <> 0 then 'nessun nodo -> EOF (end of file)
			xmleof = true
			xmlsubeof = true
			exit sub
		end if 
		on error goto 0
		'*** COPIA GLI ATTRIBUTI NEL DICTIONARY
		For Each attr in attributes : xmlrecord(attr.name) = attr.value : Next
		xmlrecord("nodeName") = xmlfile.documentElement.childNodes(xmlpointer).nodeName
		xmlrecord("nodeValue") = xmlfile.documentElement.childNodes(xmlpointer).text
		
		xmlsubpointer = -1
		xmlsubeof = false
		
		call MoveNextSub()
		
	End Sub
	
	public sub MoveNextSub()
		'*** IMPOSTA IL PUNTATORE AL NODO SUCCESSIVO
		xmlsubpointer = xmlsubpointer + 1
	
		Set xmlsubrecord = Nothing
		Set xmlsubrecord = CreateObject("Scripting.Dictionary")
		xmlsubrecord.CompareMode = 1
		'*** CARICA GLI ATTRIBUTI DAL NODO CORRENTE
		dim attr,attributes
		on error resume next
		Set attributes = xmlfile.documentElement.childNodes(xmlpointer).childNodes(xmlsubpointer).attributes
		if err.number <> 0 then xmlsubeof = true : exit sub 'nessun nodo -> EOF (end of file)
		on error goto 0
		'*** COPIA GLI ATTRIBUTI NEL DICTIONARY
		
		For Each attr in attributes : xmlsubrecord(attr.name) = attr.value : Next
		xmlsubrecord("nodeName") = xmlfile.documentElement.childNodes(xmlpointer).childNodes(xmlsubpointer).nodeName
		xmlsubrecord("nodeValue") = xmlfile.documentElement.childNodes(xmlpointer).childNodes(xmlsubpointer).text
		
	end sub
	
	Public Sub Close()
		'*** IMPOSTA EOF E ELIMINA GLI OGGETTI
		xmleof = true
		Set xmlrecord = Nothing : Set xmlfile = Nothing
	End Sub
	
End Class

function generateConfig()

	Dim obj_FSO, obj_File, configcontent
	Set obj_FSO = Server.CreateObject("Scripting.FileSystemObject")
	
	' Apre il file (1 = ForReading, True = Create)
	Set obj_File = obj_FSO.OpenTextFile(Server.MapPath("setup/inc.config_sample.asp"), 1, false)
	
	' Legge il file (anche se non ti serve, potrebbe esserlo in futuro
	If Not obj_File.AtEndOfStream Then
		' legge il file
		configcontent = obj_File.ReadAll
	End If
	
	obj_File.Close
	Set obj_File = Nothing
	
	configcontent = replace(configcontent,"inc.config_sample.asp","inc.config.asp")
	
	configcontent = configConstReplace(configcontent, "CARNIVAL_DATABASE", "string", "carnival.mdb")		'*** v1.0c ***
	configcontent = configConstReplace(configcontent, "CARNIVAL_DATABASE_TYPE", "string", "mdb")			'*** v1.0 ***
	configcontent = configConstReplace(configcontent, "CARNIVAL_DATABASE_HOST", "string", "localhost")		'*** v1.0 ***
	configcontent = configConstReplace(configcontent, "CARNIVAL_DATABASE_USER", "string", "root")			'*** v1.0 ***
	configcontent = configConstReplace(configcontent, "CARNIVAL_DATABASE_PASSWORD", "string", "")			'*** v1.0 ***
	configcontent = configConstReplace(configcontent, "CARNIVAL_MAIN", "string", "/")
	configcontent = configConstReplace(configcontent, "CARNIVAL_PUBLIC", "string", "public/")
	configcontent = configConstReplace(configcontent, "CARNIVAL_PHOTOS", "string", "photos/")
	configcontent = configConstReplace(configcontent, "CARNIVAL_STYLES", "string", "styles/")
	configcontent = configConstReplace(configcontent, "CARNIVAL_SERVICES", "string", "services/")
	configcontent = configConstReplace(configcontent, "CARNIVAL_FEED", "string", "feed/")
	configcontent = configConstReplace(configcontent, "CARNIVAL_LOGOS", "string", "logos/")
	configcontent = configConstReplace(configcontent, "CARNIVAL_PHOTOPREFIX", "string", "photo")
	configcontent = configConstReplace(configcontent, "CARNIVAL_THUMBPOSTFIX", "string", "_t")
	configcontent = configConstReplace(configcontent, "CARNIVAL_ORIGINALPOSTFIX", "string", "_o")
	configcontent = configConstReplace(configcontent, "CARNIVAL_CODE", "string", "carnival")
	configcontent = configConstReplace(configcontent, "CARNIVAL_SESSION_ADMIN_PERSIST", "number", 0)
	configcontent = configConstReplace(configcontent, "CARNIVAL_SESSION_ADMIN_LOCKED", "number", 1)
	configcontent = configConstReplace(configcontent, "CARNIVAL_SESSION_TIMEOUT", "number", 10)
	configcontent = configConstReplace(configcontent, "CARNIVAL_LANG", "string", "it-it")
	configcontent = configConstReplace(configcontent, "CARNIVAL_HOME", "string", "")
	configcontent = configConstReplace(configcontent, "CARNIVAL_DEBUGMODE", "boolean", "False")				'*** v1.0c ***
	
	generateConfig = trim(configcontent)

end function

function configConstReplace(str_Config, str_Constant, str_Type, str_Default)
	Dim Reg, strPattern, strReplace, strDefault, blnError, strValue
	blnError = false
	select case str_Type
		case "string"
			strPattern = "(const[ \t]+" & str_Constant & "[ \t]+=[ \t]+""[^""]*"")"
			strReplace = "const " & str_Constant & " = ""%VALUE%"""
			strDefault = "const " & str_Constant & " = """ & str_Default & """"
		case "boolean", "number"
			strPattern = "(const[ \t]+" & str_Constant & "[ \t]+=[ \t]+[^ \n\r]+)"
			strReplace = "const " & str_Constant & " = %VALUE%"
			strDefault = "const " & str_Constant & " = " & str_Default
	end select
	Set Reg = New RegExp
	Reg.Global = True
	Reg.Ignorecase = True
	Reg.Pattern = strPattern
	on error resume next
		Execute("strValue = " & str_Constant)
		if err.number <> 0 then strValue = ""
		blnError = strValue = ""
	on error goto 0
	if blnError then 
		str_Config = Reg.replace(str_Config,strDefault)
		response.write "<img src=""setup/exclamation.gif"" alt="""" /> verifica l'impostazione della costante " & str_Constant & "<br/>"
	else
		if str_Type = "boolean" then strValue = IIF(strValue,"True","False")
		strReplace = replace(strReplace,"%VALUE%",strValue)
		str_Config = Reg.replace(str_Config,strReplace)
	end if
	configConstReplace = str_Config
	set Reg = Nothing
end function

'**************************************************************************************************

'FUNZIONI DA 1.0 [non presenti in release precedenti]

function inputBoolean(argValue)
	inputBoolean = false
	if isnull(argValue) then exit function
	if trim(argValue) = "" then exit function
	if argValue or argValue = 1 or argValue = "1" then inputBoolean = true
end function

function getCookieCode()
	getCookieCode = CARNIVAL_CODE
end function

function getCookie(str_Name)
	getCookie = request.cookies(getCookieCode & str_Name)
end function

function isAdminLogged()

	isAdminLogged = true
	
	if  application(CARNIVAL_CODE & "_admin_key") = "" or _
		application(CARNIVAL_CODE & "_admin_lastevent") = "" then
		
		isAdminLogged = false
		
	else
	
		if getCookie("adminkey") <> application(CARNIVAL_CODE & "_admin_key") _
			or trim(getCookie("adminkey")) = "" _
			or (clng(datediff("n",application(CARNIVAL_CODE & "_admin_lastevent"),now)) > clng(CARNIVAL_SESSION_ADMIN_PERSIST) _
				and CARNIVAL_SESSION_ADMIN_PERSIST > 0) then isAdminLogged = false
			
	end if
	
end function

'**************************************************************************************************

%>
