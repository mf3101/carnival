<%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		inc.info.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------
%>	<hr/>
	<div class="carnival-logo">
		<img class="carnival-logo" src="images/carnival-logo150.gif" alt="[logo]" />
		<img class="carnival-title" src="images/carnival-title200.gif" alt="CARNIVAL" />
	</div>
	<div class="carnival-info">
		<div><span class="title">Versione</span><br />carnival <%=CARNIVAL_VERSION%> (<%=CARNIVAL_RELEASE%>)</div>
		<div><span class="title">Idea e Sviluppo</span><br />Simone Cingano (imente)</div>
		<div><span class="title">VUOI UN PHOTOBLOG COME QUESTO?</span><br />
		<a href="http://www.carnivals.it">http://www.carnivals.it</a></div>
		<div><span class="title">Componenti di terze parti</span><br />
		<strong>wbsecurity</strong> by <a href="http://www.imente.org/short/wbsecurity">imente</a><br/>
		<strong>wbclouds</strong> by <a href="http://www.imente.org/short/wbclouds">imente</a><br/>
		<strong>wbresize</strong> by <a href="http://www.imente.org/short/wbresize">imente</a><br/>
		<strong>prototype</strong> by <a href="http://prototype.conio.net">Sam Stephenso</a><br/>
		<strong>moo.fx</strong> by <a href="http://moofx.mad4milk.net">mad4milk</a><br/>
		<strong>asp upload</strong> by <a href="http://www.aspxnet.it">Baol</a><br/>
		<strong>functions_exif</strong> by <a href="mailto:mike.trinder@millerhare.com">Mike Trinder</a></div>
		<div><span class="title">Stile grafico</span><br /><%
		SQL = "SELECT config_style_desc FROM tba_config WHERE config_id = 1"
		set rs = conn.execute(SQL)
		response.write rs("config_style_desc")
		%></div>
	</div>