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
' * @version         SVN: $Id: gen.errors.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'-----------------------------------------------------------------
'NOTE: la pagina prende e restituisce i dati a
'      inner.errors.asp e errors.asp
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
' nessun enviroment aggiuntivo
'*****************************************************

'*****************************************************
'FUNZIONI DI PAGINA
function goBack(lng_Id,bln_ViaJavascript)
	if blnViaJavascript then
		goBack = "<a href=""javascript:commentErrorBack();"">" & lang__error_back__ & "</a>"
	else
		goBack = "<a href=""comments.asp?id=" & lng_Id & "#commenthere"">" & lang__error_back__ & "</a>"
	end if
end function
'*****************************************************


dim strBackLink,strBackLinkAdmin,strBackLinkStyle
strBackLink = "<a href=""photo.asp"" onclick=""window.history.back();return false"">" & lang__error_back__ & "</a>"
strBackLinkAdmin = "<a href=""admin.asp"" onclick=""window.history.back();return false"">" & lang__error_back__ & "</a>"
strBackLinkStyle = "<a href=""admin.asp?module=styles"">" & lang__error_back__ & "</a>"

dim strErrorTitle, strErrorDescription, strErrorLink

strErrorLink = null

select case lcase(strErrorCode)

	'**************************************************************
	'interfaccia utente
	
	case "comment0"
		strErrorTitle = lang__error_comment_title__
		strErrorDescription = lang__error_comment_nophoto__
		strErrorLink = goBack(lngId,blnViaJavascript)
	case "comment1"
		strErrorTitle = lang__error_comment_title__
		strErrorDescription = lang__error_comment_code__
		strErrorLink = goBack(lngId,blnViaJavascript)
	case "comment2"
		strErrorTitle = lang__error_comment_title__
		strErrorDescription = lang__error_comment_field__
		strErrorLink = goBack(lngId,blnViaJavascript)
		
	case "photo0"
		strErrorTitle = lang__error_photo_title__
		strErrorDescription = lang__error_photo_nophoto__
		strErrorLink = ""
		
	case "login0"
		strErrorTitle = lang__error_login_title__
		strErrorDescription = lang__error_login_password__
		strErrorLink = strBackLinkAdmin
	case "login1"
		strErrorTitle = lang__error_login_title__
		strErrorDescription = replace(replace(lang__error_login_locked__,"%ip",application(CARNIVAL_CODE & "_admin_ip")),"%t",CARNIVAL_SESSION_ADMIN_LOCKED)
		strErrorLink = strBackLinkAdmin
		
	'**************************************************************
	'interfaccia admin
	
	case "query0"
		strErrorTitle = "impossibile eseguire la query"
		strErrorDescription = "la query richiesta contiene un errore. si consiglia di segnalare un bug"
	
	case "stats0"
		strErrorTitle = "impossibile visualizzare le statistiche"
		strErrorDescription = "&egrave; necessario pubblicare almeno una foto per visionare le statistiche"
	
	case "upload0"
		strErrorTitle = "impossibile caricare la foto"
		strErrorDescription = "non &egrave; stata seleziona alcuna immagine da caricare"
	case "upload1"
		strErrorTitle = "impossibile caricare la foto"
		strErrorDescription = "la dimensione dell'immagine risulta essere 0kb"
	case "upload2"
		strErrorTitle = "impossibile caricare la foto"
		strErrorDescription = "l'unico formato accettato &egrave; ""jpg"""
	case "upload3"
		strErrorTitle = "impossibile caricare la foto"
		strErrorDescription = "non &egrave; stato specificato alcun id e/o alcuna specifica per l'upload"
		
	case "post0"
		strErrorTitle = "post inesistente"
		strErrorDescription = "l'operazione non pu&ograve; essere eseguita poich&egrave; il post indicato non esiste"
	case "post1"
		strErrorTitle = "nessun titolo impostato"
		strErrorDescription = "ogni post deve possedere un titolo"
	case "post2"
		strErrorTitle = "nessun tag impostato"
		strErrorDescription = "ogni post deve possedere almeno un tag"
		
	case "tag0"
		strErrorTitle = "il tag esiste gi&agrave;"
		strErrorDescription = "non &egrave; possibile avere due tag con lo stesso nome"
		
	case "set0"
		strErrorTitle = "il set esiste gi&agrave;"
		strErrorDescription = "non &egrave; possibile avere due set con lo stesso nome"
		
	case "style0"
		strErrorTitle = "lo stile non esiste"
		strErrorDescription = "lo stile indicato non esiste o non possiede un ""cstyleconfig.txt"" valido"
		strErrorLink = strBackLinkStyle
	case "style1"
		strErrorTitle = "lo stile non è compatibile"
		strErrorDescription = "lo stile indicato non è compatibile con questa versione di carnival"
		strErrorLink = strBackLinkStyle
	case "style2"
		strErrorTitle = "lo stile non possiede un cstyle di input"
		strErrorDescription = "è necessario che il cstyle di input sia un file esistente, al fine di compilare uno stile"
		strErrorLink = strBackLinkStyle
		
	case "config0"
		strErrorTitle = "impossibile modificare la password"
		strErrorDescription = "per modificare la password è necessario indicare la password corrente<br/>e una nuova password di almeno 5 caratteri di lunghezza"
		strErrorLink = strBackLinkAdmin
	case "config1"
		strErrorTitle = "impossibile modificare la password"
		strErrorDescription = "la password corrente indicata non corrisponde alla password corrente"
		strErrorLink = strBackLinkAdmin
		
	case "wbresize0","wbresize1","wbresize2","wbresize5"
		strErrorTitle = "impossibile ridimensionare immagine"
		strErrorDescription = "wbresize ha generato un errore"
		strErrorLink = strBackLinkAdmin
		
	case "wbresize3"
		strErrorTitle = "impossibile ridimensionare immagine"
		strErrorDescription = "l'indirizzo base di Carnival non corrisponde a quello indicato rilevato<br/>correggi l'indirizzo nel file <strong>includes/inc.config.asp</strong><br/>e ricompila <strong>wbresize</strong> dalla sezione <strong>strumenti</strong> del pannello di controllo<br/>e dopo essere tornato indietro ricarica la pagina per aggiornare i link"
		strErrorLink = strBackLinkAdmin
		
	case "wbresize4"
		strErrorTitle = "impossibile ridimensionare immagine"
		strErrorDescription = "i referrer del tuo browser sono disattivati<br/>per utilizzare il ridimensionamento automatico &egrave; necessario attivarli"
		strErrorLink = strBackLinkAdmin
		
	case "wbresize6"
		strErrorTitle = "impossibile ridimensionare immagine"
		strErrorDescription = "wbresize non &egrave; sincronizzato con Carnival<br/>per correggere l'errore ricompila <strong>wbresize</strong> dalla sezione <strong>strumenti</strong> del pannello di controllo<br/>e dopo essere tornato indietro ricarica la pagina per aggiornare i link"
		strErrorLink = strBackLinkAdmin
		
	case "wbresize99"
		strErrorTitle = "impossibile ridimensionare immagine"
		strErrorDescription = "wbresize ha generato un errore indefinito.<br/>" & _
							 "una delle probabili cause è l'assenza di permessi di lettura/scrittura nella cartella" & _
							 """<em>" & Server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS) & "</em>"""
		strErrorLink = strBackLinkAdmin
		
	case "tools0"
		strErrorTitle = "impossibile comprimere il database"
		strErrorDescription = "si &egrave; verificato un errore durante la compressione"
		strErrorLink = strBackLinkAdmin
	case "tools1"
		strErrorTitle = "impossibile eliminare i backup"
		strErrorDescription = "si &egrave; verificato un errore durante l'eliminazione dei database di backup<br/>alcuni dei backup potrebbero non essere stati eliminati poich&eacute; temporaneamente bloccati"
		strErrorLink = strBackLinkAdmin
		
	case else
		strErrorTitle = lang__error_undefined__
		strErrorDescription = ""
end select

if isnull(strErrorLink) then strErrorLink = strBackLink

%>