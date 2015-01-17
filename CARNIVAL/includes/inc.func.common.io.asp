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
' * @version         SVN: $Id: inc.func.common.io.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------


'********************************************************************************************
' }}}
' {{{ OUTPUT FORMAT

'*
'* formatDbBool
'* trasforma un TRUE/FALSE booleano in 1/0
'*
function formatDbBool(mix_Value)
	formatDbBool = 0
	if isnull(mix_Value) then exit function
	if trim(mix_Value) = "" then exit function
	if mix_Value or mix_Value = 1 or mix_Value = "1" then formatDbBool = 1
end function

'*
'* formatDBDate
'* trasforma un DATE in una stringa SQL compatibile (MDB/MYSQL)
'* [necessità di formatGMTDate]
'*
function formatDBDate(mix_Date,str_Db)

	dim str_DateFormat
	
	select case str_Db
		case "mdb" : 	str_DateFormat = "#yyyy-mm-dd hh:nn:ss#"
		case "mysql" : 	str_DateFormat = "'yyyy-mm-dd hh:nn:ss'"
	end select
	
	formatDBDate = formatGMTDate(cdate(mix_Date),0,str_DateFormat)
	
end function

'*
'* formatDBDouble
'* trasforma un DOUBLE in una stringa SQL compatibile
'*
function formatDBDouble(mix_Value)
	formatDBDouble = replace(cstr(cdbl(trim(mix_Value))),",",".")
end function

'*
'* formatDBString
'* trasforma un STRING in una stringa SQL compatibile
'* è possibile indicare una lunghezza massima
'*
function formatDBString(byVal mix_Value, lng_Max)
	
	if isnull(mix_Value) then mix_Value = ""
	mix_Value = cstr(replace(trim(mix_Value),"'","''"))
	
	if not(isnull(lng_Max)) then if clng(len(mix_Value)) > clng(lng_Max) then mix_Value = left(mix_Value,clng(lng_Max))
	
	formatDBString = mix_Value
	
end function

'********************************************************************************************

'*
'* formatGMTDate
'* trasforma un DATE in una stringa secondo il formato impostato
'* [necessità di getGMTDate]
'*
function formatGMTDate(ByVal dtm_Date, byt_GMT, str_DateFormat)

	dim str_FormattedDate
	dtm_Date = getGMTDate(dtm_Date,byt_GMT)
	
	str_FormattedDate = str_DateFormat
	
	str_FormattedDate = replace(str_FormattedDate,"ddd",left(weekdayname(weekday(dtm_Date)),3))
	str_FormattedDate = replace(str_FormattedDate,"mmm",left(monthname(month(dtm_Date)),3))
	
	str_FormattedDate = replace(str_FormattedDate,"dd",right("0" & day(dtm_Date),2))
	str_FormattedDate = replace(str_FormattedDate,"mm",right("0" & month(dtm_Date),2))
	str_FormattedDate = replace(str_FormattedDate,"yyyy",year(dtm_Date))
	str_FormattedDate = replace(str_FormattedDate,"yy",right(year(dtm_Date),2))
	
	str_FormattedDate = replace(str_FormattedDate,"hh",right("0" & hour(dtm_Date),2))
	str_FormattedDate = replace(str_FormattedDate,"nn",right("0" & minute(dtm_Date),2))
	str_FormattedDate = replace(str_FormattedDate,"ss",right("0" & second(dtm_Date),2))
	
	formatGMTDate = str_FormattedDate

end function

'*
'* getGMTDate
'* imposta il GMT su una data (positivo/negativo)
'*
function getGMTDate(dtm_Date,byt_GMT)

	getGMTDate = dateadd("h",byt_GMT,dtm_Date)
	
end function

'*
'* formatRSSDate
'* trasforma un DATE in una stringa compatibile RSS
'* [necessità di formatGMTDate]
'*
function formatRSSDate(mix_Date)
	'imposta lcid su 1033 (RSS compatibile)
	dim int_CurrentLcid : int_CurrentLcid = session.lcid
	session.lcid = 1033
	
	formatRSSDate = formatGMTDate(cdate(mix_Date),0,"ddd, dd mmm yyyy hh:nn:ss GMT")
	
	'ripristina lcid dell'ambiente
	session.lcid = int_CurrentLcid
end function

'********************************************************************************************
' }}}
' {{{ INPUT FROM USER (OR DB)

'*
'* fill
'* riempie una stringa di caratteri
'* "ciao" => fill( 7 , "-", False) => "---ciao"
'* "ciao" => fill( 2 , "-", False) => "ao"
'*
function fill(ByVal str_Value, int_Len, str_Char, bln_Right)

	str_Value = cstr(str_Value)
	
	if len(str_Value) > int_Len then
		if bln_Right then 
			str_Value = left(str_Value,int_Len)
		else 
			str_Value = right(str_Value,int_Len)
		end if
	else
		while not len(str_Value) = int_Len
			if bln_Right then 
				str_Value =  str_Value & str_Char
			else 
				str_Value = str_Char & str_Value
			end if
		wend
	end if
	
	fill = str_Value

end function

'*
'* normalize
'* gestisce stringhe in input
'* permette il passaggio solo di valori predefiniti in values
'* es: normalize(value,"test2|test3","test")
'*     valori accettati test, test2, test3
'*     se il valore è un'altro restituisce "test"
'*
function normalize(mix_Value, mix_Values, str_Default)

	normalize = mix_Value
	
	dim rstr_Values, bln_isPresent
	
	bln_isPresent = false
	rstr_Values = split(mix_Values,"|")
	
	dim ii
	for ii=0 to ubound(rstr_Values)
		if cstr(mix_Value) = cstr(rstr_Values(ii)) then
			bln_isPresent = true
			exit function
		end if
	next
	
	if not bln_isPresent then normalize = str_Default

end function

'*
'* isin
'* verifica se una stringa corrisponde a una serie di valori
'* es: isin(value,"test2|test3")
'*     true > value = "test2" || value = "test3"
'*     false > altre value
'*
function isin(mix_Value, mix_Values)

	isin = false
	
	dim rstr_Values
	
	rstr_Values = split(mix_Values,"|")
	
	dim ii
	for ii=0 to ubound(rstr_Values)
		if cstr(mix_Value) = cstr(rstr_Values(ii)) then
			isin = true
			exit function
		end if
	next

end function

'*
'* inputByte
'* prende un valore e restituisce Byte
'*
function inputByte(mix_Value)
	on error resume next
	
	inputByte = cbyte(trim(mix_Value))
	
	'errore (overflow, tipo non corrispondente)
	if err.number <> 0 then inputByte = cbyte(0)
	
	on error goto 0
end function

'*
'* inputByteD
'* prende un valore e restituisce Byte
'* inoltre delimita i valori possibili tramite un range
'* [necessità di inputByte]
'*
function inputByteD(byVal mix_Value, lng_Min, lng_Max)
	mix_Value = inputByte(mix_Value)
	
	if not(isnull(lng_Min)) then if mix_Value < inputByte(lng_Min) then mix_Value = lng_Min
	if not(isnull(lng_Max)) then if mix_Value > inputByte(lng_Max) then mix_Value = lng_Max
	
	inputByteD = mix_Value
end function

'*
'* inputInteger
'* prende un valore e restituisce Integer
'*
function inputInteger(mix_Value)
	on error resume next
	
	inputInteger = cint(trim(mix_Value))
	
	'errore (overflow, tipo non corrispondente)
	if err.number <> 0 then inputInteger = cint(0)
	
	on error goto 0
end function

'*
'* inputIntegerD
'* prende un valore e restituisce Integer
'* inoltre delimita i valori possibili tramite un range
'* [necessità di inputInteger]
'*
function inputIntegerD(byVal mix_Value, lng_Min, lng_Max)
	mix_Value = inputInteger(mix_Value)
	
	if not(isnull(lng_Min)) then if mix_Value < inputInteger(lng_Min) then mix_Value = lng_Min
	if not(isnull(lng_Max)) then if mix_Value > inputInteger(lng_Max) then mix_Value = lng_Max
	
	inputIntegerD = mix_Value
end function

'*
'* inputLong
'* prende un valore e restituisce Long
'*
function inputLong(mix_Value)
	on error resume next
	
	inputLong = clng(trim(mix_Value))
	
	'errore (overflow, tipo non corrispondente)
	if err.number <> 0 then inputLong = cint(0)
	
	on error goto 0
end function

'*
'* inputLongD
'* prende un valore e restituisce Long
'* inoltre delimita i valori possibili tramite un range
'* [necessità di inputLong]
'*
function inputLongD(byVal mix_Value, lng_Min, lng_Max)
	mix_Value = inputLong(mix_Value)
	
	if not(isnull(lng_Min)) then if mix_Value < inputLong(lng_Min) then mix_Value = lng_Min
	if not(isnull(lng_Max)) then if mix_Value > inputLong(lng_Max) then mix_Value = lng_Max
	
	inputLongD = mix_Value
end function

'*
'* inputDouble
'* prende un valore e restituisce Double
'*
function inputDouble(mix_Value)
	
	on error resume next
	
	inputDouble = cdbl(trim(mix_Value))
	
	'errore (overflow, tipo non corrispondente)
	if err.number <> 0 then inputDouble = cdbl(0)
	
	on error goto 0
	
end function

'*
'* inputDoubleD
'* prende un valore e restituisce Double
'* inoltre delimita i valori possibili tramite un range
'* [necessità di inputDouble]
'*
function inputDoubleD(byVal mix_Value, lng_Min, lng_Max)
	mix_Value = inputDouble(mix_Value)
	
	if not(isnull(lng_Min)) then if mix_Value < inputDouble(lng_Min) then mix_Value = lng_Min
	if not(isnull(lng_Max)) then if mix_Value > inputDouble(lng_Max) then mix_Value = lng_Max
	
	inputDoubleD = mix_Value
end function

'*
'* inputBoolean
'* prende un valore e restituisce Boolean
'*
function inputBoolean(mix_Value)
	inputBoolean = false
	if isnull(mix_Value) then exit function
	if trim(mix_Value) = "" then exit function
	if mix_Value or mix_Value = 1 or mix_Value = "1" then inputBoolean = true
end function

'*
'* inputDate
'* prende un valore e restituisce Date
'*
function inputDate(mix_Value)
	on error resume next
	
	inputDate = cdate(mix_Value)
	
	'errore (overflow, tipo non corrispondente)
	if err.number <> 0 then inputDate = cdate(now)
	
	on error goto 0
end function

'*
'* inputString
'* prende un valore e restituisce String
'*
function inputString(byVal mix_Value)

	if isnull(mix_Value) then mix_Value = ""
	inputString = cstr(mix_Value)

end function

'*
'* inputStringD
'* prende un valore e restituisce String
'* inoltre delimita la lunghezza minima e massima tramite un range
'* [necessità di inputString]
'*
function inputStringD(byVal mix_Value, lng_Min, lng_Max)
	
	mix_Value = inputString(mix_Value)
	
	if not(isnull(lng_Min)) then if clng(len(mix_Value)) < clng(lng_Min) then mix_Value = null
	if not(isnull(lng_Max)) then if clng(len(mix_Value)) > clng(lng_Max) then mix_Value = left(mix_Value,clng(lng_Max))
	
	inputStringD = mix_Value
	
end function

'********************************************************************************************
' }}}
' {{{ OUTPUT

'*
'* outputHTMLString
'* restituisce una stringa HTML compatibile
'*
function outputHTMLString(byVal mix_Value)
	
	if isnull(mix_Value) then mix_Value = ""
	mix_Value = trim(mix_Value)
	mix_Value = replace(mix_Value,"&","&amp;")
	mix_Value = replace(mix_Value,"""","&quot;")
	mix_Value = replace(mix_Value,"<","&lt;")
	mix_Value = replace(mix_Value,">","&gt;")
	'mix_Value = replace(mix_Value,vbcrlf,"<br/>")
	outputHTMLString = mix_Value
	
end function

'*
'* outputJSString
'* restituisce una stringa JavaScript compatibile
'*
function outputJSString(byVal mix_Value)
	
	if isnull(mix_Value) then mix_Value = ""
	mix_Value = trim(mix_Value)
	mix_Value = replace(mix_Value,"'","\'")
	outputJSString = mix_Value
	
end function

'********************************************************************************************
' }}}
' {{{ INPUT CHECKS

'*
'* isValidEmail
'* controlla la validità formale di una email
'*
function isValidEmail(str_Email)
	isValidEmail = False
	
	Dim Reg
	Set Reg = New RegExp
	Reg.Global = True
	Reg.Ignorecase = True
	Reg.pattern = "^([a-z][a-z.\d-_]*)?[a-z\d]\@[a-z][a-z.\d-_]*\.[a-z]+$"
	
	if Reg.Test(str_Email) then isValidEmail = True
	
	set Reg = Nothing

end function

'********************************************************************************************
' }}}
' {{{ NOCACHE

'*
'* noCache
'* restituisce una stringa univoca da aggiungere in querystring
'* per evitare il caching del browser
'*
function noCache()

	randomize
	noCache = datediff("s",0,now) & right("00" & cstr(rnd*100),2)

end function

'********************************************************************************************
' }}}
' {{{ BBCODE

'*
'* inBBCode
'* trasforma i tag html definiti di una stringa in tag bbcode
'*
function inBBCode(byval str_Value)
	
	if isnull(str_Value) then str_Value = ""
	str_Value = replace(trim(str_Value),"<b>","[b]")
	str_Value = replace(trim(str_Value),"</b>","[/b]")
	str_Value = replace(trim(str_Value),"<i>","[i]")
	str_Value = replace(trim(str_Value),"</i>","[/i]")
	inBBCode = str_Value
	
end function

'*
'* inBBCode
'* trasforma i tag bbcode di una stringa in tag html
'*
function outBBCode(byval str_Value)
	
	if isnull(str_Value) then str_Value = ""
	str_Value = replace(trim(str_Value),"[b]","<b>")
	str_Value = replace(trim(str_Value),"[/b]","</b>")
	str_Value = replace(trim(str_Value),"[i]","<i>")
	str_Value = replace(trim(str_Value),"[/i]","</i>")
	str_Value = replace(trim(str_Value),vblf,"<br/>")
	outBBCode = str_Value
	
end function
%>