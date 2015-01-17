<%
'-----------------------------------------------------------------
' ******************** HELLO THIS IS CARNIVAL ********************
'-----------------------------------------------------------------
' Copyright (c) 2007-2008 Simone Cingano
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
' * @author          Simone Cingano <simonecingano@imente.org>
' * @copyright       2007-2008 Simone Cingano
' * @license         http://www.opensource.org/licenses/mit-license.php
' * @version         SVN: $Id: inc.info.asp 27 2008-07-04 12:22:52Z imente $
' * @home            http://www.carnivals.it
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
		<strong>aspdbox</strong> by <a href="http://www.imente.org/short/aspdbox">imente</a><br/>
		<strong>prototype</strong> by <a href="http://prototype.conio.net">Sam Stephenso</a><br/>
		<strong>moo.fx</strong> by <a href="http://moofx.mad4milk.net">mad4milk</a><br/>
		<strong>asp upload</strong> by <a href="http://www.aspxnet.it">Baol</a><br/>
		<strong>functions_exif</strong> by <a href="mailto:mike.trinder@millerhare.com">Mike Trinder</a></div>
		<div><span class="title">Stile grafico</span><br /><%
		SQL = "SELECT config_style_desc FROM tba_config"
		set rs = dbManager.conn.execute(SQL)
		response.write rs("config_style_desc")
		%></div>
	</div>