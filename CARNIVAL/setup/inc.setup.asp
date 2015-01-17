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
' * @version         SVN: $Id: inc.setup.asp 28 2008-07-04 12:27:48Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

sub printError(source)
%>	<div class="error">
		<strong>Errore:</strong><br/>
		<%=err.source%> (<%=err.number%>)<br/>
		<%=err.description%><br/>
        <% if source <> "" then %><a href="<%=source%>" target="_blank" class="link">clicca per aprire la pagina e vedere l'errore nel dettaglio</a><br/><% end if %>
	</div><%
end sub

sub printResult(title, description, error, codeerror, source)
	response.write "<div class=""check"">" & vbcrlf
	if error then
		response.write "<p class=""title alert""><img src=""setup/cross.gif"" alt="""" /> " & title & "</p>" & vbcrlf
		response.write "<p class=""description"">" & description & "</p>" & vbcrlf
		if codeerror then call printError(source)
	else
		response.write "<p class=""title""><img src=""setup/tick.gif"" alt="""" /> " & title & "</p>" & vbcrlf
		response.write "<p class=""description"">" & description & "</p>" & vbcrlf
	end if
	response.write "</div>" & vbcrlf
end sub

%>