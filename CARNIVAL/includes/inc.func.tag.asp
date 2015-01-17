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
' * @version         SVN: $Id: inc.func.tag.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'********************************************************************************************
' }}}
' {{{ AZIONI

sub deleteTag(lng_Id)
	'elimina tutti i riferimenti alle foto
	SQL = "DELETE * FROM tba_rel WHERE rel_tag = " & lng_Id
	dbManager.Execute(SQL)
	'elimina fisicamente il tag
	SQL = "DELETE * FROM tba_tag WHERE tag_id = " & lng_Id
	dbManager.Execute(SQL)
end sub

'********************************************************************************************
' }}}
' {{{ AGGIORNAMENTO SYNC

sub syncTags()
	dim rst,rst2

	SQL = "SELECT tag_id FROM tba_tag"
	set rst = dbManager.Execute(SQL)
	while not rst.eof
		SQL = "SELECT Count(tba_rel.rel_id) AS photos FROM tba_rel INNER JOIN tba_photo ON tba_rel.rel_photo = tba_photo.photo_id WHERE tba_rel.rel_tag = " & rst("tag_id") & " AND tba_photo.photo_active=1"
		set rst2 = dbManager.Execute(SQL)
		SQL = "UPDATE tba_tag SET tag_photos = " & rst2("photos") & " WHERE tag_id = " & rst("tag_id")
		dbManager.Execute(SQL)
		rst.movenext
	wend
	
	set rst = nothing
	set rst2 = nothing
end sub

%>