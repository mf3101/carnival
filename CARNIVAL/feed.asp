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
' * @version         SVN: $Id: feed.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

Option Explicit
'*****************************************************
'ENVIROMENT BASE (senza inc.config.lang.asp)
%><!--#include file = "includes/inc.config.asp"-->
<!--#include file = "includes/inc.set.asp"-->
<!--#include file = "includes/inc.dba.asp"-->
<!--#include file = "includes/inc.func.common.asp"-->
<!--#include file = "includes/inc.func.common.io.asp"-->
<!--#include file = "includes/inc.func.common.math.asp"-->
<!--#include file = "includes/inc.func.common.file.asp"-->
<!--#include file = "includes/inc.func.common.special.asp"--><%
'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "includes/inc.func.photo.asp"-->
<!--#include file = "includes/inc.func.rss.asp"--><%
'*****************************************************

'connette al db
call connect()

'verifica se ci sono foto da Pubblicare
call checkPhotoPub()

'disconnette
call disconnect()

'***********************************************************************************

dim strFeedContent
strFeedContent = trim(openFile(server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_FEED & "feed.xml")))
if strFeedContent <> "" then
	response.ContentType = "application/xml+rss"
	response.Write strFeedContent
else
	response.Redirect("default.asp")
end if

'***********************************************************************************

%>