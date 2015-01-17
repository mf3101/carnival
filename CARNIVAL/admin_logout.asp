<!--#include file = "includes/inc.first.asp"-->
<%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		admin_logout.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------

'* distrugge i dati contenuti nelle variabili APPLICATION
application(CARNIVAL_CODE & "_admin_lastevent") = ""
application(CARNIVAL_CODE & "_admin_key") = ""
application(CARNIVAL_CODE & "_admin_ip") = ""

'* distrugge il cookie sul computer dell'utente
Response.cookies(CARNIVAL_CODE & "adminkey") = ""

'* rimanda all'admin dove verrà caricato il modulo di login
response.redirect("admin.asp")
%>