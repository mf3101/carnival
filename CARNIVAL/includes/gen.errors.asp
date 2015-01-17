<%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		gen.errors.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------

function commentback()
	if crn_viaJs then
		commentback = "<a href=""javascript:commentErrorBack();"">" & crnLang_error_back & "</a>"
	else
		commentback = "<a href=""comments.asp?id=" & crn_id & "#commenthere"">" & crnLang_error_back & "</a>"
	end if
end function


dim crn_backlink,crn_adminbacklink,crn_stylebacklink
crn_backlink = "<a href=""photo.asp"" onclick=""window.history.back();return false"">" & crnLang_error_back & "</a>"
crn_adminbacklink = "<a href=""admin.asp"" onclick=""window.history.back();return false"">" & crnLang_error_back & "</a>"
crn_stylebacklink = "<a href=""admin.asp?module=styles"">" & crnLang_error_back & "</a>"

dim crn_errTitle, crn_errDescription, crn_errLink

crn_errLink = null

select case lcase(crn_errorCode)

	'**************************************************************
	'interfaccia utente
	
	case "comment0"
		crn_errTitle = crnLang_error_comment_title
		crn_errDescription = crnLang_error_comment_nophoto
		crn_errLink = commentback()
	case "comment1"
		crn_errTitle = crnLang_error_comment_title
		crn_errDescription = crnLang_error_comment_code
		crn_errLink = commentback()
	case "comment2"
		crn_errTitle = crnLang_error_comment_title
		crn_errDescription = crnLang_error_comment_field
		crn_errLink = commentback()
		
	case "photo0"
		crn_errTitle = crnLang_error_photo_title
		crn_errDescription = crnLang_error_photo_nophoto
		crn_errLink = ""
		
	case "login0"
		crn_errTitle = crnLang_error_login_title
		crn_errDescription = crnLang_error_login_password
		crn_errLink = crn_adminbacklink
	case "login1"
		crn_errTitle = crnLang_error_login_title
		crn_errDescription = replace(replace(crnLang_error_login_locked,"%ip",application(CARNIVAL_CODE & "_admin_ip")),"%t",CARNIVAL_SESSION_ADMIN_LOCKED)
		crn_errLink = crn_adminbacklink
		
	'**************************************************************
	'interfaccia admin
	
	case "upload0"
		crn_errTitle = "impossibile caricare la foto"
		crn_errDescription = "non &egrave; stata seleziona alcuna immagine da caricare"
	case "upload1"
		crn_errTitle = "impossibile caricare la foto"
		crn_errDescription = "la dimensione dell'immagine risulta essere 0kb"
	case "upload2"
		crn_errTitle = "impossibile caricare la foto"
		crn_errDescription = "l'unico formato accettato &egrave; ""jpg"""
	case "upload3"
		crn_errTitle = "impossibile caricare la foto"
		crn_errDescription = "non &egrave; stato specificato alcun id e/o alcuna specifica per l'upload"
		
	case "post0"
		crn_errTitle = "post inesistente"
		crn_errDescription = "l'operazione non pu&ograve; essere eseguita poich&egrave; il post indicato non esiste"
	case "post1"
		crn_errTitle = "nessun titolo impostato"
		crn_errDescription = "ogni post deve possedere un titolo"
	case "post2"
		crn_errTitle = "nessun tag impostato"
		crn_errDescription = "ogni post deve possedere almeno un tag"
		
	case "tag0"
		crn_errTitle = "il tag esiste gi&agrave;"
		crn_errDescription = "non &egrave; possibile avere due tag con lo stesso nome"
		
	case "style0"
		crn_errTitle = "lo stile non esiste"
		crn_errDescription = "lo stile indicato non esiste o non possiede un ""cstyleconfig.txt"" valido"
		crn_errLink = crn_stylebacklink
	case "style1"
		crn_errTitle = "lo stile non è compatibile"
		crn_errDescription = "lo stile indicato non è compatibile con questa versione di carnival"
		crn_errLink = crn_stylebacklink
	case "style2"
		crn_errTitle = "lo stile non possiede un cstyle di input"
		crn_errDescription = "è necessario che il cstyle di input sia un file esistente, al fine di compilare uno stile"
		crn_errLink = crn_stylebacklink
		
	case "config0"
		crn_errTitle = "impossibile modificare la password"
		crn_errDescription = "per modificare la password è necessario indicare la password corrente<br/>e una nuova password di almeno 5 caratteri di lunghezza"
		crn_errLink = crn_adminbacklink
	case "config1"
		crn_errTitle = "impossibile modificare la password"
		crn_errDescription = "la password corrente indicata non corrisponde alla password corrente"
		crn_errLink = crn_adminbacklink
		
	case "wbresize0","wbresize1","wbresize2","wbresize5"
		crn_errTitle = "impossibile ridimensionare immagine"
		crn_errDescription = "wbresize ha generato un errore"
		crn_errLink = crn_adminbacklink
		
	case "wbresize3"
		crn_errTitle = "impossibile ridimensionare immagine"
		crn_errDescription = "l'indirizzo base di Carnival non corrisponde a quello indicato rilevato<br/>correggi l'indirizzo nel file <strong>includes/inc.config.asp</strong><br/>e ricompila <strong>wbresize</strong> dalla sezione <strong>strumenti</strong> del pannello di controllo<br/>e dopo essere tornato indietro ricarica la pagina per aggiornare i link"
		crn_errLink = crn_adminbacklink
		
	case "wbresize4"
		crn_errTitle = "impossibile ridimensionare immagine"
		crn_errDescription = "i referrer del tuo browser sono disattivati<br/>per utilizzare il ridimensionamento automatico &egrave; necessario attivarli"
		crn_errLink = crn_adminbacklink
		
	case "wbresize6"
		crn_errTitle = "impossibile ridimensionare immagine"
		crn_errDescription = "wbresize non &egrave; sincronizzato con Carnival<br/>per correggere l'errore ricompila <strong>wbresize</strong> dalla sezione <strong>strumenti</strong> del pannello di controllo<br/>e dopo essere tornato indietro ricarica la pagina per aggiornare i link"
		crn_errLink = crn_adminbacklink
		
	case "wbresize99"
		crn_errTitle = "impossibile ridimensionare immagine"
		crn_errDescription = "wbresize ha generato un errore indefinito.<br/>" & _
							 "una delle probabili cause è l'assenza di permessi di lettura/scrittura nella cartella" & _
							 """<em>" & Server.MapPath(CARNIVAL_PUBLIC & CARNIVAL_PHOTOS) & "</em>"""
		crn_errLink = crn_adminbacklink
		
	case "tools0"
		crn_errTitle = "impossibile comprimere il database"
		crn_errDescription = "si &egrave; verificato un errore durante la compressione"
		crn_errLink = crn_adminbacklink
	case "tools1"
		crn_errTitle = "impossibile eliminare i backup"
		crn_errDescription = "si &egrave; verificato un errore durante l'eliminazione dei database di backup<br/>alcuni dei backup potrebbero non essere stati eliminati poich&eacute; temporaneamente bloccati"
		crn_errLink = crn_adminbacklink
		
	case else
		crn_errTitle = crnLang_error_undefined
		crn_errDescription = ""
end select

if isnull(crn_errLink) then crn_errLink = crn_backlink

%>