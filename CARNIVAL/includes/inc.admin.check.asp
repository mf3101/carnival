<%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		inc.admin.check.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione � inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------

'* PATH_INFO contiene il nome della pagina (senza eventuali querystring)
'* se la pagina non � ADMIN.ASP l'utente viene rimandato ad ADMIN.ASP
if instr(request.ServerVariables("PATH_INFO") & "!","/admin.asp!") = 0 then response.redirect "../admin.asp"

'* NOTA:
'* tramite questo sistema si evita che le pagine dei moduli possano essere
'* eseguite stand-alone eludendo quindi il sistema di sicurezza dell'admin
%>