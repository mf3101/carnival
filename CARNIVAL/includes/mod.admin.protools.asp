<!--#include file = "inc.first.asp"--><%
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
' * @version         SVN: $Id: mod.admin.protools.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "inc.admin.check.asp"-->
<!--#include file = "inc.func.services.asp"-->
<!--#include file = "inc.func.rss.asp"--><%
'*****************************************************

dim strAction,  strDone
strAction = normalize(request.QueryString("action"),"wbresize|aspneton|aspnetoff|dbclean|dbcompress|statsthison|statsthisoff|ccvon|ccvoff|rss","")

dim strDatabase

dim obj_Fso, obj_Folder, obj_Files, obj_File

select case strAction
	case "wbresize","aspneton"
		
		strDone = "wbresize"
		if not(aspnetOn()) then strDone = "aspnetfail"
		
	case "aspnetoff"
		'call deleteFile(server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_SERVICES & "wbresize.aspx"))
		call aspnetOff()
		strDone = "aspnetoff"
		
	case "rss"
		call compileRss()
		strDone = "rss"
		
	case "dbclean"
		if CARNIVAL_DATABASE_TYPE <> "mdb" then response.Redirect("admin.asp?module=tools")
		strDone = "dbclean"
		
		on error resume next
		
		dim strDatabasefolder
		strDatabasefolder = getFolderFromPath(server.MapPath(CARNIVAL_DATABASE))
		strDatabase = getFileFromPath(server.MapPath(CARNIVAL_DATABASE))
		
		set obj_Fso = CreateObject("Scripting.FileSystemObject")
		Set obj_Folder = obj_Fso.GetFolder(strDatabasefolder)  
		Set obj_Files = obj_Folder.Files 
		
		strDatabase = replace(strDatabase,".mdb","")&"_"		
		For Each obj_File in obj_Files	
		   if left(obj_File.name,len(strDatabase)) = strDatabase then _
			 obj_Fso.DeleteFile(strDatabasefolder & "/" & obj_File.name)
		Next
	
		if err.number <> 0 then response.Redirect("errors.asp?c=tools1")
		on error goto 0
	
	case "dbcompress"
		if CARNIVAL_DATABASE_TYPE <> "mdb" then response.Redirect("admin.asp?module=tools")
		strDone = "dbcompress"
		
		call disconnect()
		
		on error resume next
		dim strDatabaseBackup
		strDatabase = server.MapPath(CARNIVAL_DATABASE)
		strDatabaseBackup = replace(strDatabase,".mdb",formatGMTDate(now,0,"_yyyymmdd_hhnnss") & ".mdb")
		
		' backuppo il db
		Set obj_Fso = Server.CreateObject("Scripting.FileSystemObject")
		call obj_Fso.MoveFile(strDatabase,strDatabaseBackup)
		Set obj_Fso = Nothing

		'comprimo il database 
		dim obj_DAODb
		Set obj_DAODb = CreateObject("DAO.DBEngine.36") 
		call obj_DAODb.CompactDatabase(strDatabaseBackup, strDatabase)
		Set obj_DAODb=Nothing
		
		if err.number <> 0 then response.Redirect("errors.asp?c=tools0")
		
		on error goto 0
		
		call connect()
	
	case "statsthison"
		strDone = "statsthison"
		call setCookie("exclude","0",now+365)
		
	case "statsthisoff"
		strDone = "statsthisoff"
		call setCookie("exclude","1",now+365)
	
	case "ccvon", "ccvoff"
		dim bytCv
		strDone = strAction
		if strAction = "cc"&"von" then
			bytCv = 1
		elseif strAction = "cc"&"voff" then
			bytCv = 0
		end if
		SQL = "UPDATE tba_config SET config_cc"&"v = " & bytCv & ""
		dbManager.Execute(SQL)
		
end select

response.Redirect("admin.asp?module=tools&done=" & strDone)

%>