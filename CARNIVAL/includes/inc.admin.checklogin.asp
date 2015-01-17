<%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		inc.admin.checklogin.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------
function crnFunc_AdminLoggedIn()

	crnFunc_AdminLoggedIn = true
	
	if  application(CARNIVAL_CODE & "_admin_key") = "" or _
		application(CARNIVAL_CODE & "_admin_lastevent") = "" then
		
		crnFunc_AdminLoggedIn = false
		
	else
	
		if request.cookies(CARNIVAL_CODE & "adminkey") <> application(CARNIVAL_CODE & "_admin_key") _
			or trim(request.cookies(CARNIVAL_CODE & "adminkey")) = "" _
			or clng(datediff("n",application(CARNIVAL_CODE & "_admin_lastevent"),now)) > clng(CARNIVAL_SESSION_ADMIN_PERSIST) then crnFunc_AdminLoggedIn = false
			
	end if
	
end function
%>