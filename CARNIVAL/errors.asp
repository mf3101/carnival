<!--#include file = "includes/inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		errors.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------
dim crn_errorCode, crn_id, crn_viaJs
crn_errorCode = request.QueryString("c")
crn_id = request.QueryString("id")
if crn_id < 0 then crn_id = 0
crn_viaJs = cleanBool(request.QueryString("js"))

if crn_viaJs then response.Redirect("inner.errors.asp?c=" & crn_errorCode & "&id=" & crn_id)

%><!--#include file = "includes/gen.errors.asp"--><%

crnTitle = crnLang_error_title
crnPageTitle = carnival_title & " ::: " & crnTitle
crnShowTop = 0 

%><!--#include file = "includes/inc.top.asp"-->
		<div id="error" class="dark">
			<div class="title"><%=crn_errTitle%></div>
			<div class="description"><%=crn_errDescription%></div>
			<div class="link"><%=crn_errLink%></div>
		</div>
<!--#include file = "includes/inc.bottom.asp"-->