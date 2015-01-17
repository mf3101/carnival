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
' * @version         SVN: $Id: inc.func.common.math.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'********************************************************************************************
' }}}
' {{{ GENERALI

'*
'* Val
'* equivalente di Val in Visual Basic
'* recupera tutte le cifre valide di una stringa
'*
function Val(mix_Value)
	
	dim return
	return = trim(mix_Value&"")
	if return = "" then return = 0
	while not(isnumeric(return))
		return = left(return,len(return)-1)
	wend
	Val = cdbl(return)
	
end function

'*
'* Sign
'* Restituisce il segno di un numero (1/-1)
'*
function Sign(num_Value)
	Sign = 1 : if num_Value < 0 then Sign = -1
end function

'*
'* Prop
'* Esegue una proporzione
'*
function Prop(num_Value,byVal num_MaxValue,num_MaxProp)
	if num_MaxValue = 0 then num_MaxValue = 1
	Prop = int(num_Value*num_MaxProp/num_MaxValue)
end function


'********************************************************************************************
' }}}
' {{{ ARROTONDAMENTO

'*
'* Round
'* Disponibile in VBSCRIPT
'* arrotondamento per eccesso >=5 or per difetto <5
'*
'function Round(num_Value, byt_Decimal)


'*
'* Floor
'* Arrotondamento per difetto
'*
function Floor(byval num_Value, byval byt_Decimal)
	dim int_Sign
	int_Sign = Sign(num_Value)
	byt_Decimal = 10^byt_Decimal
	num_Value = abs(num_Value * byt_Decimal)
	num_Value = Fix(num_Value)
	num_Value = num_Value / byt_Decimal
	Floor = num_Value*int_Sign
end function

'*
'* Ceil
'* Arrotondamento per eccesso
'*
function Ceil(byval num_Value, byval byt_Decimal)
	dim int_Sign
	int_Sign = Sign(num_Value)
	byt_Decimal = 10^byt_Decimal
	num_Value = abs(num_Value * byt_Decimal)
	num_Value = (num_Value+0.49)\1
	num_Value = num_Value / byt_Decimal
	Ceil = num_Value*int_Sign
end function


'********************************************************************************************
' }}}
' {{{ PERCENTUALI

'*
'* getPerc
'* Restituisce il valore di una percentuale di un numero
'*
function getPerc(dbl_Price,dbl_Perc,bln_Round)
	dim return
	return = cdbl(dbl_Price)
	return = cdbl(((return*(dbl_Perc))/100))
	if bln_Round then return = Ceil(return,2)
	getPerc = return
end function

'*
'* addPerc
'* Restituisce il valore di una percentuale di un numero sommato al numero
'*
function addPerc(dbl_Price,dbl_Perc,bln_Round)
	dim return
	return = cdbl(dbl_Price)
	return = cdbl(((return*(100+dbl_Perc))/100))
	if bln_Round then return = Ceil(return,2)
	addperc = return
end function

'*
'* applyPerc
'* Applica percentuali a un valore
'* es: "+20+5+-20" => valore+20%+5%-20%
'*
function applyPerc(byVal dbl_Price,byVal str_Reduction)
	dim rstr_Reduction, jj, return
	
	rstr_Reduction = split(str_Reduction,"+")
	return = cdbl(dbl_Price)
	
	for jj=0 to ubound(rstr_Reduction)
		return = cdbl(return-((return*cdbl(rstr_Reduction(jj)))/100))
	next
	
	applyPerc = return
end function
%>