<!--#include file = "includes/inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		about.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------
crnTitle = crnLang_about_title
crnPageTitle = carnival_title & " ::: " & crnTitle
%><!--#include file = "includes/inc.top.asp"-->
	<div id="about">
	<% 
	dim crnAboutContent
	SQL = "SELECT config_aboutpage FROM tba_config WHERE config_id = 1"
	set rs = conn.execute(SQL)
	crnAboutContent = rs("config_aboutpage")
	response.write crnAboutContent
	%>
<!--#include file = "includes/inc.bottom.asp"-->