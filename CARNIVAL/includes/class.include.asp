<%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		class.include.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------
Class Class_dinamicInclude

	public Fso
	public WebPath
	
	private sub Class_initialize()
		WebPath = Request.ServerVariables("APPL_PHYSICAL_PATH")
	    Set Fso = CreateObject("Scripting.FileSystemObject")
	end sub

	private function Readfile(rFilename)
		Dim f
		
		on error resume next
		Set f = fso.OpenTextFile(WebPath & rFilename , 1,False, 0)
		
		if err.number<>0 then
			Response.Write("<p style=""font-family:verdana;font-size:11"">Include File not Found [<b>" & lCase(WebPath & rFilename) &"</b>]<p>")
			Response.Write("<p style=""font-family:verdana;font-size:11"">Error <b>"& Err.number  &"</b> [<b>" & Err.Description  &"</b>]<p>")
			Response.end
		end if
		
		on error goto 0
		
		Readfile = f.ReadAll
		
		f.close
		
		Set f=nothing
		
	End Function

	Public Function Include(Filename)
		dim tMp,Fullpath
		tMp = Replace(request.ServerVariables("URL"),"/","\")
		Fullpath = Mid(tMp,2,InStrRev(tMp,"\")-1) & Filename
		
		include = Readfile(Fullpath)
		include = replace(include,"<" & "%","")
		include = replace(include,"%" & ">","")
		
	end function
	
	private sub Class_Terminate()
		set fso = nothing
	end sub
	
end class


'* #######################################
'* ##FUNC_INT##
'* @name		IncludeFile
'* @version		1.0.0
'* @author		imente
'* @description
'*   carica dinamicamente un file sfruttando
'*   le funzionalità della classe Class_dinamicInclude
'* ---------------------------------------
'* @params
'* argFilename		STR		percorso del file da includere
'* ---------------------------------------
'* @return
'* STR	codice da eseguire (tramite Server.Execute)
'* @#####################################
Function IncludeFile(argFilename)

	dim  oIncludeFile
	Set oIncludeFile = new Class_dinamicInclude
	IncludeFile = oIncludeFile.Include(argFilename)
	Set oIncludeFile = nothing
		
End Function
%>