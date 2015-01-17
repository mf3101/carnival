<!--#include file = "inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		mod.admin.protools.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"-->
<%
dim crn_action
crn_action = normalize(request.QueryString("action"),"wbresize|aspnet|dbclean|dbcompress|statsthison|statsthisoff|ccvon|ccvoff","")
dim crn_db
dim crn_done

dim crn_objFso, crn_objFolder, crn_objFiles, crn_objFile,aspnetactive

select case crn_action
	case "wbresize"
		
		dim wbresize,wbresizekey
		wbresizekey = createKey(32)
		wbresize = openFile(server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_SERVICES & "wbresize.aspx"))
		
		Dim Reg,Mathes
		Set Reg = New RegExp
		Reg.Global = True
		Reg.Ignorecase = True
		Reg.pattern = "(string baseAddress = ""[^""]+"";)"
		wbresize = Reg.replace(wbresize,"string baseAddress = """ & CARNIVAL_HOME & """;")
		Reg.pattern = "(string keyCheck = ""[^""]+"";)"
		wbresize = Reg.replace(wbresize,"string keyCheck = """ & wbresizekey & """;")
		Reg.pattern = "(string errorRedirect = ""[^""]+"";)"
		wbresize = Reg.replace(wbresize,"string errorRedirect = """ & CARNIVAL_HOME & "errors.asp?c=wbresize"";")
		set Reg = nothing
		
		call writeFile(server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_SERVICES & "wbresize.aspx"),wbresize)
		wbresize = ""
		
		aspnetactive = checkAspnetActive(CARNIVAL_HOME & replace(CARNIVAL_PUBLIC & CARNIVAL_SERVICES,"\","/") & "test.aspx")
		
		SQL = "UPDATE tba_config SET config_wbresizekey = '" & wbresizekey & "', config_aspnetactive = " & formatDbBool(aspnetactive) & " WHERE config_id = 1"
		conn.execute(SQL)
		
		crn_done = "wbresize"
		if not(aspnetactive) then crn_done = "aspnet"
		
	case "aspnet"
		aspnetactive = checkAspnetActive(CARNIVAL_HOME & CARNIVAL_PUBLIC & CARNIVAL_SERVICES & "test.aspx")
		
		if aspnetactive then
			SQL = "UPDATE tba_config SET config_aspnetactive = 1 WHERE config_id = 1"
			conn.execute(SQL)
			response.Redirect("admin.asp?module=pro-tools&action=wbresize")
		else
			crn_done = "aspnet"
		end if
		
	case "dbclean"
		crn_done = "dbclean"
		
		on error resume next
		
		
		
		dim crn_dbfolder
		crn_dbfolder = getFolderFromPath(server.MapPath(CARNIVAL_DATABASE))
		crn_db = getFileFromPath(server.MapPath(CARNIVAL_DATABASE))
		
		set crn_objFso = CreateObject("Scripting.FileSystemObject")
		Set crn_objFolder = crn_objFso.GetFolder(crn_dbfolder)  
		Set crn_objFiles = crn_objFolder.Files 
		
		crn_db = replace(crn_db,".mdb","")&"_"		
		For Each crn_objFile in crn_objFiles	
		   if left(crn_objFile.name,len(crn_db)) = crn_db then _
			 crn_objFso.DeleteFile(crn_dbfolder & "/" & crn_objFile.name)
		Next
	
		if err.number <> 0 then response.Redirect("errors.asp?c=tools1")
		on error goto 0
	
	case "dbcompress"
		crn_done = "dbcompress"
		
		call disconnect()
		
		on error resume next
		dim crn_backupdb
		crn_db = server.MapPath(CARNIVAL_DATABASE)
		crn_backupdb = replace(crn_db,".mdb",formatGMTDate(now,0,"_yyyymmdd_hhnnss") & ".mdb")
		
		' backuppo il db
		Set crn_objFso = Server.CreateObject("Scripting.FileSystemObject")
		call crn_objFso.MoveFile(crn_db,crn_backupdb)
		Set crn_objFso = Nothing

		'comprimo il database 
		dim crn_objDb
		Set crn_objDb = CreateObject("DAO.DBEngine.36") 
		call crn_objDb.CompactDatabase(crn_backupdb, crn_db)
		Set crn_objDb=Nothing
		
		if err.number <> 0 then response.Redirect("errors.asp?c=tools0")
		
		on error goto 0
		
		call connect()
	
	case "statsthison"
		crn_done = "statsthison"
		call setCookie("exclude","0",now+365)
		
	case "statsthisoff"
		crn_done = "statsthisoff"
		call setCookie("exclude","1",now+365)
	
	case "ccvon", "ccvoff"
		dim crn_ccv
		crn_done = crn_action
		if crn_action = "ccvon" then
			crn_ccv = 1
		elseif crn_action = "ccvoff" then
			crn_ccv = 0
		end if
		SQL = "UPDATE tba_config SET config_ccv = " & crn_ccv & " WHERE config_id = 1"
		conn.execute(SQL)
		
end select

response.Redirect("admin.asp?module=tools&done=" & crn_done)

%>