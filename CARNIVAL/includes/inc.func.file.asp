<%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		inc.func.file.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------

function fileExist(ByVal file)
	
	fileExist = false
	file = server.MapPath(file)
	dim objFSO
	Set objFSO=Server.CreateObject("Scripting.FileSystemObject")

	If objFSO.FileExists(file) Then fileExist = true

	set objFSO=nothing
		
end function

function folderExist(ByVal folder)
	
	folderExist = false
	folder = server.MapPath(folder)
	dim objFSO
	Set objFSO=Server.CreateObject("Scripting.FileSystemObject")

	If objFSO.FolderExists(folder) Then folderExist = true

	set objFSO=nothing
		
end function

function writePermissions(ByVal folder)
	
	dim strFileName
	writePermissions = false
	strFileName = server.MapPath(folder & "test.txt")
	dim objFSO,objFile
	Set objFSO=Server.CreateObject("Scripting.FileSystemObject")
	
	on error resume next
	Set objFile = objFSO.CreateTextFile(strFileName, True)
	objFile.Write "test"
	objFile.Close
	if err.number <> 0 then 
		writePermissions = false
		exit function
	end if
	
	Set objFile = objFSO.OpenTextFile(strFileName, 1, True)
	if objFile.ReadAll = "test" then writePermissions = true
	objFile.Close
	
	Set objFile = objFSO.GetFile(strFileName)
	objFile.Delete
	
	Set objFile = Nothing
	set objFSO = nothing
		
end function

function openFile(path)

	dim objFSO,objFile
	Set objFSO=Server.CreateObject("Scripting.FileSystemObject")
	Set objFile = objFSO.OpenTextFile(path, 1, True)
	openFile = objFile.ReadAll
	objFile.Close
	Set objFile = Nothing
	set objFSO = nothing
	
end function


function writeFile(path, string)

	dim objFSO,objFile
	Set objFSO=Server.CreateObject("Scripting.FileSystemObject")
	Set objFile = objFSO.CreateTextFile(path, True)
	objFile.Write string
	objFile.Close
	Set objFile = Nothing
	set objFSO = nothing

end function


function getFolderFromPath(path)

	getFolderFromPath = path
	Dim Reg, Matches
	Set Reg = New RegExp
	Reg.Global = True
	Reg.Ignorecase = True
	Reg.pattern = "(.*)\\[^\\]+$"
	if Reg.Test(path) then
		set Matches = reg.Execute(path)
		getFolderFromPath = Matches(0).SubMatches(0)
	end if
	set Matches = nothing
	set Reg = nothing

end function


function getFileFromPath(path)

	getFileFromPath = path
	Dim Reg, Matches
	Set Reg = New RegExp
	Reg.Global = True
	Reg.Ignorecase = True
	Reg.pattern = "\\([^\\]+)$"
	if Reg.Test(path) then
		set Matches = reg.Execute(path)
		getFileFromPath = Matches(0).SubMatches(0)
	end if
	set Matches = nothing
	set Reg = nothing

end function


%>