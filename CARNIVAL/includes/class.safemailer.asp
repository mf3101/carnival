<%
'$******************************$ 
'$  Classe: Safe Mailer v 1.0   $		'1.0.1 by imente (added authsmtp e ssl)
'$  Autore: kluster 			$
'$  Email:  kluster@imente.org	$       	
'$  Data:   lunedì 27/09/2005	$       
'$******************************$
'La classe SafeMailer con a corredo il file componente.xml permette di scansionare il server su cui è in esecuzione
'ed istanziare almeno un oggetto com smtp in grado di poter inviare email. 
'La lista di com su cui effettuare la scansione puo' essere aggiornata semplicemente aggiungento un nodo padre 
'components e seguendo la struttura dei precedenti nodi, inserendo opportuni metodi e proprieta' dell'oggetto aggiunto
'i metodi sono tutti monoparametro, nel caso vogliate operare + di un azione per metodo separate i comandi da : (carattere divisione)


	Const XML_FILE						= "includes/class.safemailer.xml"
	Const MSG_ERR_XMLDOC_CREATION		= "Impossibile inizializzare un oggetto valido Xml Document"
	Const XMLDOC_PROGID					= "MSXML4.DOMDocument,MSXML3.DOMDocument,MSXML2.DOMDocument,MSXML.DOMDocument,Microsoft.XmlDom"
	Class SafeMailer
		Public objMail					'Oggetto contenitore per instanziare il COM
		Public XmlDom					'Oggetto xml dom per lavorare con i nodi del file components.xml
		Private arrClassID() 			'Array che conterra' tutti i classid pescati dal file xml
		'Variabili per i comandi su cui fare il porting
		Private commandMailTo,commandMailFrom,commandCC,commandBCC,commandSubject,commandBodyhtml,commandBodyText
		Private commandPriority,commandSend,commandAttach,commandMailServer,commandMailPort,commandUser,commandPassword
		Private commandSsl, commandAuth
		'Variabili private per restituire le proprieta' impostate
		Private pMailTo,pMailFrom,pCC,pBCC,pSubject,pBodyhtml,pBodyText
		Private pPriority,pSend,pAttach,pMailServer,pMailPort,pUser,pPassword
		Private pSsl, pAuth
		Private pClassID				'Variabile che restituisce il classid in uso
		Private opt_debug				
		Private Sub Class_Initialize()
			Dim nodeCount, XmlNodelist,i,arrXmlDom,w
			opt_debug					= false
			arrXmlDom					= Split(XMLDOC_PROGID,",")
			for w=0 to ubound(arrXmlDom)'Cerco un oggetto xml document installato, e se trovato lo inizializzo
				if IsComInstalled(arrXmlDom(w)) then
					Set XmlDom			= Server.CreateObject(arrXmlDom(w))					
					exit for
				end if 
			next
			if not isObject(XmlDom) then Response.Write(MSG_ERR_XMLDOC_CREATION):Response.End()
			dim fileXML
			fileXML						= Server.MapPath(XML_FILE)
			XmlDom.ValidateOnParse		= False
			XmlDom.PreserveWhiteSpace	= False
			XmlDom.Load					fileXML
			Set XmlNodelist 			= XmlDom.GetElementsByTagName("component")
			nodeCount					= XmlNodelist.Length-1
			Redim arrClassID(nodeCount)
			for i=0 to nodeCount
				arrClassID(i)			= XmlNodelist(i).GetAttribute("classid")
			next
		End Sub
		Public property Let debug(value)
			opt_debug					= value
		End Property
		'Metodo: CreateObjectIfExist(classID) Crea l'oggetto specificato da classID (es. CDONTS.NewMail)
		'se è istallato restituisce true ed inizializza il DOM dell'oggetto di riferimento
		Public Function CreateObjectIfExist(classId)
			Set objMail					= Nothing 'Nel caso di creazioni multiple in caso di test annullo prima l'oggetto
			if IsComInstalled(classId) then
				set objMail				= Server.CreateObject(classId)'Se istallato inizializza l'oggetto
				pClassID				= classID
				LoadComponentDOM		classId 'e carico nella variabili command tutti i metodi e proprieta' rispettive
				CreateObjectIfExist		= true
			else
				CreateObjectIfExist		= false 'Altrimenti restituisce false
			end if 
		End Function
		'Metodo: LoadAvailableCom 		'Cicla i componente conosciuti e cerca di instanziarne almeno uno
		Public Function LoadAvailableCom()	
			Dim iLoop
			for iLoop=LBound(arrClassId) to uBound(arrClassId)
				if IsComInstalled(arrClassId(iLoop)) then 
					set objMail  		= Server.CreateObject(arrClassId(iLoop))
					pClassID			= arrClassId(iLoop)
					LoadComponentDOM 	arrClassId(iLoop)
					exit for 
				end if 
			next
		End Function
		'Proprieta': ClassID			: Classid del com in funzione
		Public Property Get ClassId()
			ClassId						= pClassId
		End Property
		'Proprieta': MailFrom			: Mittente della email
		Public Property Let MailFrom(value)
			ExecuteCommand				commandMailFrom,"$mailfrom$",value
			pMailFrom					= value
		End Property
		Public Property Get MailFrom()
			MailFrom					= pMailFrom
		End Property
		'Proprieta': MailTo				: Destinatario della mail
		Public Property Let MailTo(value)
			ExecuteCommand				commandMailTo,"$mailto$",value
			pMailTo						= value
		End Property
		Public Property Get MailTo()
			MailTo						= pMailFrom
		End Property
		'Proprieta': CC					: Indirizzo Copia Carbone
		Public Property Let CC(value)
			ExecuteCommand				commandCC,"$cc$",value
			pCC							= value
		End Property
		Public Property Get CC()
			CC							= pCC
		End Property
		'Proprieta': BCC: 				' Copia Carbone Nascosta 
		Public Property Let BCC(value)
			ExecuteCommand				commandBCC,"$bcc$",value
			pBCC						= value
		End Property
		Public Property Get BCC()
			BCC							= pBCC
		End Property
		'Proprieta': Subject			: Oggetto della Email
		Public Property Let subject(value)
			ExecuteCommand				commandSubject,"$subject$",value
			pSubject					= value
		End Property
		Public Property Get subject()
			subject						= pSubject
		End Property		
		'Proprieta': BodyText			: Corpo del messaggio in formato testo
		Public Property Let BodyText(value)
			ExecuteCommand				commandBodyText,"$bodytext$",value
			pBodyText					= value
		End Property
		Public Property Get BodyText()
			BodyText					= pBodyText
		End Property
		'Proprieta': BodyHtml			: Corpo del messaggio formato html
		Public Property Let BodyHtml(value)
			Dim tmp
			tmp							= Replace(value&"",vbcrlf,"") 'Nel caso provenga da textarea e non venga filtrato dall'utente
			ExecuteCommand				commandBodyHtml,"$bodyhtml$",tmp
			pBodyHtml					= value
		End Property
		Public Property Get BodyHtml()
			BodyHtml					= pBodyHtml
		End Property
		'Proprieta': Priority			: Priorita' del messaggio
		Public Property Let Priority(value)
			ExecuteCommand				commandPriority,"$priority$",value
			pPriority					= value
		End Property
		Public Property Get Priority()
			Priority					= pPriority
		End Property
		'Proprieta': MailServer			: Indirizzo del Server di autenticazione SMTP
		Public Property Let MailServer(value)
			ExecuteCommand				commandMailServer,"$mailserver$",value
			pmailserver					= value
		End Property
		Public Property Get Mailserver()
			Mailserver					= pmailserver
		End Property
		'Proprieta': MailPort			: Porta del server di  autenticazione SMTP
		Public Property Let MailPort(value)
			ExecuteCommand				commandMailPort,"$mailport$",value
			pMailPort					= value
		End Property
		Public Property Get MailPort()
			MailPort					= pMailPort
		End Property
		'Proprieta': User				: Utente per l'autenticazione
		Public Property Let User(value)
			ExecuteCommand				commandUser,"$user$",value
			pUser						= value
		End Property
		Public Property Get User()
			User						= pUser
		End Property
		'Proprieta': Password			: Password per l'autenticazione		
		Public Property Let Password(value)
			ExecuteCommand				commandPassword,"$password$",value
			pPassword					= value
		End Property
		Public Property Get Password()
			Password					= pPassword
		End Property
		'Proprieta': Auth				: Tipo di autenticazione '0 = Do not authenticate ' 1=basic (clear-text) ' 2=NTLM (Windows) [CDO]
		Public Property Let Auth(value)
			ExecuteCommand				commandAuth,"$auth$",value
			pAuth					    = value
		End Property
		Public Property Get Auth()
			Auth					    = pAuth
		End Property
		'Proprieta': Ssl				: SSL '0 = False / 1 = True
		Public Property Let Ssl(value)
			ExecuteCommand				commandSsl,"$ssl$",value
			pSsl					    = value
		End Property
		Public Property Get Ssl()
			Ssl					        = pSsl
		End Property
		
		'Metodo: Attach					: Allega un file alla Email
		Public Sub Attach(strFile)
			ExecuteCommand				commandAttach,"$attach$",strFile
		End Sub
		'Metodo: Send					: Invia la Email
		Public Function Send()
			Send = ExecuteCommand(commandSend,"","")
		End Function
		
		'Metodo:IsComInstalled(class_id): Prende il parametro class_id e tenta di creare l'oggetto
		'restituisce True se è possibile crearlo, False nel caso contrario
		Public function IsComInstalled(class_id)
			On Error Resume Next
			Dim objCom
			IsComInstalled				= False
			Set objCom					= Server.CreateObject(class_id)
			IsComInstalled				= (Err.Number = 0)
			Set objCom=Nothing:Err.Clear()
		End function
		'Metodo private:ExecuteCommand(stringAction,pattern,replaceValue): Funzione help per il redirect dei comandi
		'Prende la stringa contente il codice (string),sostituisce il marcatore (codes), con il parametro (parameter) ed esegue il comando
		Private function ExecuteCommand(stringAction,pattern,replaceValue)
			On Error Resume Next
			ExecuteCommand = ""
			Dim command,Log : Log=""
			if opt_debug then Log = "<hr/>Esecuzione <strong>"&pattern&"</strong><br />Action=<strong>"&stringAction&"</strong><br />Value=<strong>"&replaceValue&"</strong><br />"
			with objMail
				if stringAction <> "" then
					if pattern <> "" then 
						command			= Replace(Trim(stringAction),pattern,EscapeQuote(replaceValue))
						'Bugfix per il testo in formato text/plain per la sostituzione dei vbcrlf da carattere a comando stringa
						if pattern = "$bodytext$" then command = Replace(command,vbcrlf, """ & vbcrlf &  """) 'era ACTION=
					else 
						command 			= stringAction 
					end if
					if opt_debug then Log = Log & "Output:<strong><br />" & Server.HTMLEncode(command) & "</strong><br />"

					'eseguo il comando
					Execute(command)
					
					if err.number <> 0 then
						if opt_debug then Response.Write("ERRORE:" & Err.number & "<br />DESCRIZIONE:" & Err.Description)
						ExecuteCommand = Err.Description
					end if 
					if opt_debug then Response.Write(Log)
				end if 
			end with
		End function
		'Metodo privato: LoadComponentDOM(classId)'Funzione che carica il dom dell'oggetto
		Private Function LoadComponentDOM(classId)
			commandMailTo 				= XmlDom.SelectSingleNode("//component[@classid='" & classId & "']/mailto").text
			commandMailFrom				= XmlDom.SelectSingleNode("//component[@classid='" & classId & "']/mailfrom").text
			commandCC					= XmlDom.SelectSingleNode("//component[@classid='" & classId & "']/cc").text
			commandBCC					= XmlDom.SelectSingleNode("//component[@classid='" & classId & "']/bcc").text
			commandSubject				= XmlDom.SelectSingleNode("//component[@classid='" & classId & "']/subject").text
			commandBodyText				= XmlDom.SelectSingleNode("//component[@classid='" & classId & "']/bodytext").text
			commandBodyhtml				= XmlDom.SelectSingleNode("//component[@classid='" & classId & "']/bodyhtml").text
			commandPriority				= XmlDom.SelectSingleNode("//component[@classid='" & classId & "']/priority").text
			commandSend					= XmlDom.SelectSingleNode("//component[@classid='" & classId & "']/send").text
			commandAttach				= XmlDom.SelectSingleNode("//component[@classid='" & classId & "']/attach").text
			commandMailServer			= XmlDom.SelectSingleNode("//component[@classid='" & classId & "']/mailserver").text
			commandMailPort				= XmlDom.SelectSingleNode("//component[@classid='" & classId & "']/mailport").text
			commandUser					= XmlDom.SelectSingleNode("//component[@classid='" & classId & "']/user").text
			commandPassword				= XmlDom.SelectSingleNode("//component[@classid='" & classId & "']/password").text
			commandSsl					= XmlDom.SelectSingleNode("//component[@classid='" & classId & "']/ssl").text
			commandAuth					= XmlDom.SelectSingleNode("//component[@classid='" & classId & "']/auth").text
			if opt_debug then
				Response.Write			(	"<hr/>DETTAGLIO COMPONENTE:<br /><strong>Classid<br /></strong>" 			& classId& "</b><br />"  _ 
										&	"<b>Mailto</b><br />"		& commandMailTo			& "<br />" _
										&	"<b>MailFrom</b><br />"		& commandMailFrom		& "<br />" _
										&	"<b>cc</b><br />"			& commandCC				& "<br />" _
										&	"<b>bbc</b><br />"			& commandBCC			& "<br />" _
										&	"<b>subject</b><br />"		& commandSubject		& "<br />" _
										&	"<b>bodytext</b><br />"		& commandBodyText		& "<br />" _
										&	"<b>bodyhtml</b><br />"		& commandbodyhtml		& "<br />" _
										&	"<b>priority</b><br />"		& commandPriority		& "<br />" _
										&	"<b>send</b><br />"			& commandSend			& "<br />" _
										&	"<b>attach</b><br />"		& commandAttach			& "<br />" _
										&	"<b>mailserver</b><br /> "	& commandMailServer		& "<br />" _
										&	"<b>mailPort</b><br />"		& commandMailPort		& "<br />" _
										&	"<b>user</b><br />" 		& commanduser			& "<br />" _
										&	"<b>password</b><br />" 	& commandPassword		& "<br />" _
										&	"<b>ssl</b><br />" 			& commandSsl			& "<br />" _
										&	"<b>auth</b><br />" 		& commandAuth			& "<br />")
			end if 
		End Function

		'Metodo privato:EscapeQuote		'Le stringhe passate al comando execute eseguono l'escape del quote (")
		Private Function EscapeQuote(string)
			Dim tmp
			EscapeQuote					= Replace(string&"","""","""""")
		End Function
		'Metodo: GetListComponent		: Funzione che restituisce i classid del file xml, utile per eseguire un loop con CreateObjectIfExist
		Public Function GetListComponent()
			GetListComponent			= arrClassID
		End Function
		'Pulizia degli oggetti
		Private Sub Class_Terminate()
			Set XmlDom					= nothing
			if isObject(objMail) then set ObjMail	= nothing
		End Sub
	End Class
%>