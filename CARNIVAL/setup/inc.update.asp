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
' * @version         SVN: $Id: inc.update.asp 29 2008-07-04 14:03:45Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

dim dbManager
set dbManager = new Class_ASPDbManager
dbManager.debugging = false

function connect(dtype,database)
	dbManager.database = dtype
	connect = dbManager.Connect(database,"","","") 'FALSE ERRORE DI CONNESSIONE
end function

sub disconnect()
	call dbManager.Disconnect()
end sub

function copyFile(path,newpath)

	copyFile = false
	on error resume next
	dim objFSO,objFile
	Set objFSO=Server.CreateObject("Scripting.FileSystemObject")
	objFSO.CopyFile path, newpath
	set objFSO = nothing
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
		case "1.0rc1.0"
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

Class carnival_xmlreader
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

	Dim objFSO, objFile, configcontent
	Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
	
	' Apre il file (1 = ForReading, True = Create)
	Set objFile = objFSO.OpenTextFile(Server.MapPath("setup/inc.config_sample.asp"), 1, false)
	
	' Legge il file (anche se non ti serve, potrebbe esserlo in futuro
	If Not objFile.AtEndOfStream Then
		' legge il file
		configcontent = objFile.ReadAll
	End If
	
	objFile.Close
	Set objFile = Nothing
	
	configcontent = replace(configcontent,"inc.config_sample.asp","inc.config.asp")
	
	Dim Reg
	Set Reg = New RegExp
	Reg.Global = True
	Reg.Ignorecase = True
	Reg.pattern = "(const[ \t]+CARNIVAL_DATABASE[ \t]+=[ \t]+""[^""]+"")"
	configcontent = Reg.replace(configcontent,"const CARNIVAL_DATABASE = """ & CARNIVAL_DATABASE & """")
	
	Reg.pattern = "(const[ \t]+CARNIVAL_MAIN[ \t]+=[ \t]+""[^""]+"")"
	on error resume next
	configcontent = Reg.replace(configcontent,"const CARNIVAL_MAIN = """ & CARNIVAL_MAIN & """")
	if err.number <> 0 then 
		configcontent = Reg.replace(configcontent,"const CARNIVAL_MAIN = ""/""")
		response.write "<img src=""setup/exclamation.gif"" alt="""" /> &egrave; necessario impostare la costante CARNIVAL_MAIN<br/>"
	end if
	on error goto 0
	
	Reg.pattern = "(const[ \t]+CARNIVAL_PUBLIC[ \t]+=[ \t]+""[^""]+"")"
	configcontent = Reg.replace(configcontent,"const CARNIVAL_PUBLIC = """ & CARNIVAL_PUBLIC & """")
	Reg.pattern = "(const[ \t]+CARNIVAL_PHOTOS[ \t]+=[ \t]+""[^""]+"")"
	configcontent = Reg.replace(configcontent,"const CARNIVAL_PHOTOS = """ & CARNIVAL_PHOTOS & """")
	Reg.pattern = "(const[ \t]+CARNIVAL_STYLES[ \t]+=[ \t]+""[^""]+"")"
	configcontent = Reg.replace(configcontent,"const CARNIVAL_STYLES = """ & CARNIVAL_STYLES & """")
	Reg.pattern = "(const[ \t]+CARNIVAL_SERVICES[ \t]+=[ \t]+""[^""]+"")"
	configcontent = Reg.replace(configcontent,"const CARNIVAL_SERVICES = """ & CARNIVAL_SERVICES & """")
	Reg.pattern = "(const[ \t]+CARNIVAL_FEED[ \t]+=[ \t]+""[^""]+"")"
	configcontent = Reg.replace(configcontent,"const CARNIVAL_FEED = """ & CARNIVAL_FEED & """")
	Reg.pattern = "(const[ \t]+CARNIVAL_LOGOS[ \t]+=[ \t]+""[^""]+"")"
	configcontent = Reg.replace(configcontent,"const CARNIVAL_LOGOS = """ & CARNIVAL_LOGOS & """")
	Reg.pattern = "(const[ \t]+CARNIVAL_PHOTOPREFIX[ \t]+=[ \t]+""[^""]+"")"
	configcontent = Reg.replace(configcontent,"const CARNIVAL_PHOTOPREFIX = """ & CARNIVAL_PHOTOPREFIX & """")
	Reg.pattern = "(const[ \t]+CARNIVAL_THUMBPOSTFIX[ \t]+=[ \t]+""[^""]+"")"
	configcontent = Reg.replace(configcontent,"const CARNIVAL_THUMBPOSTFIX = """ & CARNIVAL_THUMBPOSTFIX & """")
	Reg.pattern = "(const[ \t]+CARNIVAL_ORIGINALPOSTFIX[ \t]+=[ \t]+""[^""]+"")"
	configcontent = Reg.replace(configcontent,"const CARNIVAL_ORIGINALPOSTFIX = """ & CARNIVAL_ORIGINALPOSTFIX & """")
	Reg.pattern = "(const[ \t]+CARNIVAL_SESSION_ADMIN_PERSIST[ \t]+=[ \t]+[^ \n\r]+)"
	configcontent = Reg.replace(configcontent,"const CARNIVAL_SESSION_ADMIN_PERSIST = " & CARNIVAL_SESSION_ADMIN_PERSIST)
	Reg.pattern = "(const[ \t]+CARNIVAL_SESSION_ADMIN_LOCKED[ \t]+=[ \t]+[^ \n\r]+)"
	configcontent = Reg.replace(configcontent,"const CARNIVAL_SESSION_ADMIN_LOCKED = " & CARNIVAL_SESSION_ADMIN_LOCKED)
	Reg.pattern = "(const[ \t]+CARNIVAL_SESSION_TIMEOUT[ \t]+=[ \t]+[^ \n\r]+)"
	configcontent = Reg.replace(configcontent,"const CARNIVAL_SESSION_TIMEOUT = " & CARNIVAL_SESSION_TIMEOUT)
	Reg.pattern = "(const[ \t]+CARNIVAL_LANG[ \t]+=[ \t]+""[^""]+"")"
	configcontent = Reg.replace(configcontent,"const CARNIVAL_LANG = """ & CARNIVAL_LANG & """")
	Reg.pattern = "(const[ \t]+CARNIVAL_HOME[ \t]+=[ \t]+""[^""]*"")"
	configcontent = Reg.replace(configcontent,"const CARNIVAL_HOME = """ & CARNIVAL_HOME & """")
	Reg.pattern = "(const[ \t]+CARNIVAL_DEBUGMODE[ \t]+=[ \t]+[^ \n\r]+)"
	on error resume next
	configcontent = Reg.replace(configcontent,"const CARNIVAL_DEBUGMODE = " & CARNIVAL_DEBUGMODE)
	if err.number <> 0 then configcontent = Reg.replace(configcontent,"const CARNIVAL_DEBUGMODE = False")
	on error goto 0
	
	set Reg = nothing
	
	generateConfig = configcontent

end function

%>