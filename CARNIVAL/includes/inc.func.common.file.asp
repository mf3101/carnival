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
' * @version         SVN: $Id: inc.func.common.file.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*
'* Verifica l'esistenza di un file
'*
function fileExists(ByVal str_File)
	
	fileExists = false
	str_File = server.MapPath(str_File)
	dim obj_FSO
	Set obj_FSO=Server.CreateObject("Scripting.FileSystemObject")

	If obj_FSO.FileExists(str_File) Then fileExists = true

	set obj_FSO = nothing
		
end function

'*
'* Verifica l'esistenza di una cartella
'*
function folderExists(ByVal str_Folder)
	
	folderExists = false
	str_Folder = server.MapPath(str_Folder)
	dim obj_FSO
	Set obj_FSO=Server.CreateObject("Scripting.FileSystemObject")

	If obj_FSO.FolderExists(str_Folder) Then folderExists = true

	set obj_FSO=nothing
		
end function

'*
'* Verifica i permessi di scrittura su una cartella
'*
function hasWritePermission(ByVal str_Folder)
	
	dim str_FileName
	hasWritePermission = false
	str_FileName = server.MapPath(str_Folder & "file.test")
	dim obj_FSO,obj_File
	Set obj_FSO = Server.CreateObject("Scripting.FileSystemObject")
	
	on error resume next
	Set obj_File = obj_FSO.CreateTextFile(str_FileName, True)
	obj_File.Write "test"
	obj_File.Close
	if err.number <> 0 then 
		hasWritePermission = false
		exit function
	end if
	
	Set obj_File = obj_FSO.OpenTextFile(str_FileName, 1, True)
	if obj_File.ReadAll = "test" then hasWritePermission = true
	obj_File.Close
	
	Set obj_File = obj_FSO.GetFile(str_FileName)
	obj_File.Delete
	
	Set obj_File = Nothing
	set obj_FSO = nothing
		
end function

'*
'* Apre un file e legge tutto il contenuto
'*
function openFile(str_Path)

	on error resume next
	dim obj_FSO,obj_File
	Set obj_FSO=Server.CreateObject("Scripting.FileSystemObject")
	Set obj_File = obj_FSO.OpenTextFile(str_Path, 1, True)
	openFile = obj_File.ReadAll
	obj_File.Close
	Set obj_File = Nothing
	set obj_FSO = nothing
	on error goto 0
	
end function

'*
'* Scrive (o sovrascrive) il contenuto di un file
'*
function writeFile(str_Path, str_Content)

	writeFile = false
	on error resume next
	dim obj_FSO,obj_File
	Set obj_FSO=Server.CreateObject("Scripting.FileSystemObject")
	Set obj_File = obj_FSO.CreateTextFile(str_Path, True)
	obj_File.Write str_Content
	obj_File.Close
	Set obj_File = Nothing
	set obj_FSO = nothing
	if err.number = 0 then writeFile = true
	on error goto 0

end function

'*
'* Aggiunge al contenuto di un file
'*
function appendFile(str_Path, str_AppendContent)

	appendFile = false
	on error resume next
	dim obj_FSO,obj_File
	Set obj_FSO=Server.CreateObject("Scripting.FileSystemObject")
	' Apre il file (1 = ForReading, 2 = For Writing, 8 = For Appendig, True = Create)
	Set obj_File = obj_FSO.OpenTextFile(str_Path, 8, True)
	obj_File.Write str_AppendContent
	obj_File.Close
	Set obj_File = Nothing
	set obj_FSO = nothing
	if err.number = 0 then appendFile = true
	on error goto 0

end function

'*
'* Copia un file
'*
function copyFile(str_Path,str_NewPath)

	copyFile = false
	on error resume next
	dim obj_FSO,obj_File
	Set obj_FSO=Server.CreateObject("Scripting.FileSystemObject")
	obj_FSO.CopyFile str_Path, str_NewPath
	set obj_FSO = nothing
	if err.number = 0 then copyFile = true
	on error goto 0

end function

'*
'* Rinomina un file
'*
function renameFile(str_Path,str_NewPath)

	renameFile = false
	on error resume next
	dim obj_FSO,obj_File
	Set obj_FSO=Server.CreateObject("Scripting.FileSystemObject")
	obj_FSO.MoveFile str_Path, str_NewPath
	set obj_FSO = nothing
	if err.number = 0 then renameFile = true
	on error goto 0

end function

'*
'* Cancella un file
'*
function deleteFile(str_Path)

	deleteFile = false
	on error resume next
	dim obj_FSO,obj_File
	Set obj_FSO=Server.CreateObject("Scripting.FileSystemObject")
	Set obj_File = obj_FSO.GetFile(str_Path)
	obj_File.Delete True
	Set obj_File = Nothing
	set obj_FSO = nothing
	if err.number = 0 then deleteFile = true
	on error goto 0

end function

'*
'* Nome di una cartella da una path (con file)
'*
function getFolderFromPath(str_Path)

	getFolderFromPath = str_Path
	Dim Reg, Matches
	Set Reg = New RegExp
	Reg.Global = True
	Reg.Ignorecase = True
	Reg.pattern = "(.*)\\[^\\]+$"
	if Reg.Test(str_Path) then
		set Matches = reg.Execute(str_Path)
		getFolderFromPath = Matches(0).SubMatches(0)
	end if
	set Matches = nothing
	set Reg = nothing

end function

'*
'* Nome di un file da una path (completa)
'*
function getFileFromPath(str_Path)

	getFileFromPath = str_Path
	Dim Reg, Matches
	Set Reg = New RegExp
	Reg.Global = True
	Reg.Ignorecase = True
	Reg.pattern = "\\([^\\]+)$"
	if Reg.Test(str_Path) then
		set Matches = reg.Execute(str_Path)
		getFileFromPath = Matches(0).SubMatches(0)
	end if
	set Matches = nothing
	set Reg = nothing

end function
%>