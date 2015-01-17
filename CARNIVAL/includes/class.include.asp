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
' * @version         SVN: $Id: class.include.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
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