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
' * @version         SVN: $Id: inc.func.set.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'********************************************************************************************
' }}}
' {{{ AZIONI

sub deleteSet(lng_Id)
	dim rst
	if lng_Id > 1 then 'non si può eliminare il set 1
		'elimina tutti i riferimenti alle foto
		SQL = "UPDATE tba_photo SET photo_set = 1 WHERE photo_set = " & lng_Id
		dbManager.Execute(SQL)
		'aggiorna quantità foto
		SQL = "SELECT set_photos FROM tba_set WHERE set_id = " & lng_Id
		set rst = dbManager.Execute(SQL)
		if not rst.eof then
			SQL = "UPDATE tba_set SET set_photos = set_photos + " & rs("set_photos") & " WHERE set_id = 1"
			dbManager.Execute(SQL)
		end if
		'elimina fisicamente il tag
		SQL = "DELETE * FROM tba_set WHERE set_id = " & lng_Id
		dbManager.Execute(SQL)
	end if
	set rst = nothing
end sub

sub orderSet(lng_Id,sng_Order)
	SQL = "UPDATE tba_set SET set_order = " & sng_Order & " WHERE set_id = " & lng_Id
	dbManager.Execute(SQL)
end sub

'********************************************************************************************
' }}}
' {{{ AGGIORNAMENTO SYNC

sub syncSets()
	dim rst, rst2

	SQL = "SELECT set_id FROM tba_set"
	set rst = dbManager.Execute(SQL)
	while not rst.eof
		SQL = "SELECT Count(photo_id) AS photos FROM tba_photo WHERE photo_set = " & rst("set_id") & " AND photo_active=1"
		set rst2 = dbManager.Execute(SQL)
		SQL = "UPDATE tba_set SET set_photos = " & rst2("photos") & " WHERE set_id = " & rst("set_id")
		dbManager.Execute(SQL)
		rst.movenext
	wend
	
	set rst = nothing
	set rst2 = nothing
end sub

'********************************************************************************************
' }}}
' {{{ AGGIORNAMENTO SYNC

%>