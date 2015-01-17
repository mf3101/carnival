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
' * @version         SVN: $Id: inc.func.file.asp 27 2008-07-04 12:22:52Z imente $
' * @home            http://www.carnivals.it
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

	on error resume next
	dim objFSO,objFile
	Set objFSO=Server.CreateObject("Scripting.FileSystemObject")
	Set objFile = objFSO.OpenTextFile(path, 1, True)
	openFile = objFile.ReadAll
	objFile.Close
	Set objFile = Nothing
	set objFSO = nothing
	on error goto 0
	
end function


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


function writeFile(path, string)

	writeFile = false
	on error resume next
	dim objFSO,objFile
	Set objFSO=Server.CreateObject("Scripting.FileSystemObject")
	Set objFile = objFSO.CreateTextFile(path, True)
	objFile.Write string
	objFile.Close
	Set objFile = Nothing
	set objFSO = nothing
	if err.number = 0 then writeFile = true
	on error goto 0

end function


function renameFile(path,newpath)

	renameFile = false
	on error resume next
	dim objFSO,objFile
	Set objFSO=Server.CreateObject("Scripting.FileSystemObject")
	objFSO.MoveFile path, newpath
	set objFSO = nothing
	if err.number = 0 then renameFile = true
	on error goto 0

end function


function deleteFile(path)

	deleteFile = false
	on error resume next
	dim objFSO,objFile
	Set objFSO=Server.CreateObject("Scripting.FileSystemObject")
	Set objFile = objFSO.GetFile(path)
	objFile.Delete True
	Set objFile = Nothing
	set objFSO = nothing
	if err.number = 0 then deleteFile = true
	on error goto 0

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