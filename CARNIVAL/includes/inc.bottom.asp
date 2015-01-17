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
' * @version         SVN: $Id: inc.bottom.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

if not blnIsPhotosPage__ then %>
		<div class="clear"></div>
		</div>
	</div>
	<div id="footer">
	<div class="content"><%=config__title__ & " " & config__copyright__%></div>
	<div class="border-bl"><div class="border-br"><div class="border"></div></div></div>
	</div><%
end if %>
</div>
<% if config__bodyaddwhere__ = 1 then response.write config__bodyadd__
call ccv()
if CARNIVAL_DEBUGMODE then %>
<div id="debugbox" style="overflow:hidden;overflow:auto;border-top:2px solid #000;background-color:#FFF;position:absolute;bottom:0;left:0;width:100%;height:150px;z-index:300;font-size:0.8em;"><div style="padding:5px;"><strong>DEBUG BOX</strong> [<a href="javascript:;" onclick="debugSwitch();">close</a>] [<a href="javascript:;" onclick="debugClear();">clear</a>]<hr/><div id="debugboxcontent"></div></div></div>
<div id="debugboxopen" style="overflow:hidden;border-top:2px solid #000;background-color:#FFF;position:absolute;bottom:0;left:0;width:100%;height:25px;z-index:299;font-size:0.8em;"><div style="padding:5px;"><strong>DEBUG BOX</strong> [<a href="javascript:;" onclick="debugSwitch();">open</a>]</div></div>
<script type="text/javascript">/*<![CDATA[*/
function debugPrint(value) {
	if (!debugging) return;
	$('debugboxcontent').innerHTML+=value+'<hr/>';
	$('debugbox').scrollTo(0,$('debugbox').getRealHeight());
}
function debugSwitch() {
	switchDisplay('debugbox');
}
function debugClear() {
	$('debugboxcontent').innerHTML = '';
}
debugClear();
/*]]>*/
</script>
<% end if 
%></body>
</html>
<% 
'*****************************************************
'* disconnette al db
call disconnect() 
'*****************************************************
%>