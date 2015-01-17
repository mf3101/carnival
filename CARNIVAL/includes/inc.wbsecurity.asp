<%
'*************************************'
'* WBsecurity 1.01 - (c) imente 2006 *'
'*************************************'
'  distribuito sotto licenza GNU-GPL
'       (vedi allegato gpl.txt)
'*************************************'
' NORME DI SICUREZZA:
'	- non stampare in NESSUNA pagina il valore wbs_SetSeed
'	- non stampare in NESSUNA pagina il valore session("wbsecurity-generator")
'************************************'

dim wbs_SetSeed, wbs_ForegroundColor, wbs_BorderColor, wbs_BackgroundColor

'* indicare un numero casuale di 10 cifre
'* MODIFICARE QUESTO VALORE PRIMA DI INSTALLARE!!!
wbs_SetSeed = 2456123589

'* imposta i colori dell'immagine
wbs_ForegroundColor = "FFFFFF"
wbs_BorderColor = "CCCCCC"
wbs_BackgroundColor = "000000"

'**********************************************************************************
'* NON MODIFICARE QUESTO FILE DA QUESTA LINEA IN POI!!!

function getSecurityCodeGenerator()
	'utilizzo della data per aumentare la dimensione del numero
	'utilizzo del timer per avere un valore realmente casuale
	'utilizzo di un valore pseudocasuale aggiunto per evitare
	'	che un malintenzionato che conosce TIMER (magari il programmatore
	'	lo stampa nella pagina dove c'è wbsecurity) possa risalire
	'	al valore di wbsecurity
	randomize
	getSecurityCodeGenerator = cstr(replace(year(date) & month(date) & day(date) & _
									        hour(time) & minute(time) & second(time) & _
									        timer & int(rnd*1000),",",""))
end function

function getSecurityCode(argGenerator)
	dim securitycode
	
	securitycode = md5(cdbl(wbs_SetSeed + argGenerator))
	securitycode = replace(securitycode,"a",period(clng(right(argGenerator,1)),10))
	securitycode = replace(securitycode,"b",period(clng(right(argGenerator,1))+1,10))
	securitycode = replace(securitycode,"c",period(clng(right(argGenerator,1))+2,10))
	securitycode = replace(securitycode,"d",period(clng(right(argGenerator,1))+3,10))
	securitycode = replace(securitycode,"e",period(clng(right(argGenerator,1))+4,10))
	securitycode = replace(securitycode,"f",period(clng(right(argGenerator,1))+5,10))
	securitycode = mid(securitycode,period(clng(right(argGenerator,2)),26)+1,6)
	
	getSecurityCode = securitycode
	
end function


function period(argValue, argPeriod)

	if argValue >= argPeriod then
		argValue = argValue mod argPeriod
	end if
		
	period = argValue

end function


function period(argValue, argPeriod)

	if argValue >= argPeriod then
		argValue = argValue mod argPeriod
	end if
		
	period = argValue

end function
%>