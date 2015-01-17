<%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		inc.config.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------

' ***************************************************************************
' FILE DI CONFIGURAZIONE UTENTE
' ***************************************************************************

' *** PATH DATABASE
'   indica la path dove risiede il database
'   il nome del database standard è CARNIVAL.MDB
'   la cartella dove si trova il database deve possedere
'   permessi di scrittura (per molti hoster è la cartella "mdb-database")
'   se non sei certo di quale cartella utilizzare chiedi al tuo hoster
'	PERCORSO RELATIVO:
'		es: db/carnival.mdb (si trova nella cartella DB presente allo stesso livello di photo.asp)
'	PERCORSO ASSOLUTO:
'		es: /db/carnival.mdb (si trova nella cartella DB presente alla radice del sito)
' 	il percorso assoluto è necessario nel caso in cui Carnival sia installato in una sottocartella del sito
const CARNIVAL_DATABASE = 	"database/carnival.mdb"

' *** CARTELLA PUBBLICA DI CARNIVAL
'   la seguente cartella deve possedere permessi di lettura e scrittura
'   (per molti hoster è la cartella "public")
'   se non sei certo di quale cartella utilizzare chiedi al tuo hoster
'   per questioni di "ordine" il consiglio è quello di utilizzare
'	una sottocartella chiamata CARNIVAL (come nel valore di default)
'	[ LE PATH DEVONO SEMPRE TERMINARE CON IL CARATTERE "/" ]
'	[ SU SERVER WINDOWS 2003 LE PATH NON DEVONO CONTENERE "../" ]
const CARNIVAL_PUBLIC = 	"carnival/"

' *** SOTTOCARTELLE PUBBLICHE
'	le seguenti cartelle si troveranno dentro a CARNIVAL_PUBLIC
'	non è necessario modificare i valori di default se si é copiata
'	la struttura originale
const CARNIVAL_PHOTOS = 	"photos/"
const CARNIVAL_STYLES = 	"styles/"
const CARNIVAL_SERVICES = 	"services/"
const CARNIVAL_FEED = 		"feed/"

' *** CARTELLA DEI LOGHI
'   è la cartella dove dovrai caricare le immagini logo da visualizzare
'   nel layout. non necessita di alcun permesso particolare
const CARNIVAL_LOGOS = "logos/"

' *** POSTFISSI E PREFISSI DELLE IMMAGINI
'   tutte le immagini caricate verranno nominate secondo il seguente schema
'	( si consiglia di mantenere le impostazioni originali ed in ogni caso
'	di non modificarle dopo che si sono caricate delle foto )
'   FOTO ORIGINALE: 		CARNIVAL_PHOTOPREFIX + ID + CARNIVAL_ORIGINALPOSTFIX + testo casuale + ".jpg"
'   FOTO VISUALIZZATA: 		CARNIVAL_PHOTOPREFIX + ID + ".jpg"
'   FOTO THUMBNAIL: 		CARNIVAL_PHOTOPREFIX + ID + CARNIVAL_THUMBPOSTFIX + ".jpg"
'   esempi: photo id 53 -> 	ORIGINALE: 		"photo53_oh58t75f4h5.jpg"
'							VISUALIZZATA:	"photo53.jpg"	
'  							THUMBNAIL:		"photo53_t.jpg"	
const CARNIVAL_PHOTOPREFIX = 		"photo"
const CARNIVAL_THUMBPOSTFIX = 		"_t"
const CARNIVAL_ORIGINALPOSTFIX = 	"_o"


' *** CODICE PHOTOBLOG
'   è un valore alfanumerico (evitare SPAZI e caratteri speciali) che
'   identifica il photoblog. se si installa più di un photoblog all'interno
'   dello stesso dominio le due installazioni dovranno avere due codici
'   differenti. nella maggior parte dei casi non è necessario modificare
'   questo valore
const CARNIVAL_CODE = "carnival"


' *** TIMEOUT SESSIONE AMMINISTRATORE
'   indica il numero di MINUTI per cui la sessione di un amministratore
'   viene considerata valida, scaduti i quali (dall'ultima pagina visualizzata)
'   sarà necessario inserire nuovamente la password
const CARNIVAL_SESSION_ADMIN_PERSIST = 60

' *** TIMEOUT BLOCCO AMMINISTRAZIONE
'   indica il numero di MINUTI per i quali l'accesso all'amministrazione
'   rimane bloccato dall'ultima pagina visualizzata da un amministratore
'   già connesso. (permette di evitare che due utenti si connettano
'   contemporanemente al pannello di amministrazione)
const CARNIVAL_SESSION_ADMIN_LOCKED = 1


' *** TIMEOUT SESSIONE UTENTE
'   indica il numero di MINUTI per cui è attiva la sessione di utente
'   è utilizzata per il calcolo delle visualizzazioni delle foto
'   se l'utente visualizza due volte la stessa foto ed è passato un tempo
'   inferiore al timeout impostato verrà contata una sola visualizzazione
const CARNIVAL_SESSION_TIMEOUT = 10


' *** LINGUA DEL PHOTOBLOG
'   indicare in quale lingua sono fornite le descrizioni delle foto
'   es: "it-it", "en-us"...
const CARNIVAL_LANG = "it-it"


' *** HOME PAGE DEL PHOTOBLOG
'   indicare l'url minimo del photoblog.
'   E' NECESSARIO INDICARE CORRETTAMENTE QUESTO VALORE!!!
'	IMMETTERE LO SLASH "/" AL TERMINE DELL'URL
'   (il setup si occuperà di controllare la validità del valore indicato
'	 e proporrà un valore corretto, se quindi non si sa cosa indicare
'    procedere comunque con il setup e seguire le istruzioni)
'   es: http://www.miophotoblog.it/
'   es: http://www.miosito.it/photoblog/
const CARNIVAL_HOME = "http://demo.carnivals.it/"
%>