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
' * @version         SVN: $Id: inc.func.common.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*
'* IIF
'* Inline IF/ELSE statement
'*
function IIF(bln_Condition, mix_ExpressionTrue, mix_ExpressionFalse)
	If bln_Condition then IIF =	mix_ExpressionTrue : else : IIF=mix_ExpressionFalse : end if
end function

'*
'* createKey
'* Genera una stringa alfanumerica di X caratteri
'*
function createKey(lng_Len)
	
	dim ii, rstr_alphabet, int_position, str_key
	str_key = ""
	
	'* definisce l'alfabeto
	rstr_alphabet = Array("a","b","c","d","e","f","g","h","i","l","j","k","m","n","o","p","q","r","s","t","u","v","w","x","y","z", _
					      "A","B","C","D","E","F","G","H","I","L","J","K","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z", _
					      "0","1","2","3","4","5","6","7","8","9","0")
						   
	ii = 1
	while ii < int(lng_Len)+1
		randomize int(timer * 100)*ii
		int_position = (Int((Rnd * ubound(rstr_alphabet)))) 
		str_key = str_key & rstr_alphabet(int_position)
		ii = ii + 1
	wend
	
	createKey = str_key
	
end function

'********************************************************************************************

'*
'* gestione dei cookie
'*

function getCookieCode()
	getCookieCode = CARNIVAL_CODE
end function

sub setCookie(str_Name, str_Content, byval dtm_Expires)
	if dtm_Expires <=0 then dtm_Expires = now
	response.cookies(getCookieCode & str_Name) = str_Content
	response.cookies(getCookieCode & str_Name).expires = dtm_Expires
end sub

sub setSubCookie(str_Name, str_SubName, str_Content)
	response.cookies(getCookieCode & str_Name)(str_SubName) = str_Content
end sub

sub setCookieExpires(str_Name,byval dtm_Expires)
	if dtm_Expires <=0 then dtm_Expires = now
	response.cookies(getCookieCode & str_Name).expires = dtm_Expires
end sub

function getCookie(str_Name)
	getCookie = request.cookies(getCookieCode & str_Name)
end function

function getSubCookie(str_Name, str_SubName)
	getSubCookie = request.cookies(getCookieCode & str_Name)(str_SubName)
end function

'********************************************************************************************

%>