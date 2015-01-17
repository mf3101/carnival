<%
'-----------------------------------------------------------------
' ******************** HELLO THIS IS CARNIVAL ********************
'-----------------------------------------------------------------
' Copyright (c) 2007-2008 Simone Cingano
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
' * @author          Simone Cingano <simonecingano@imente.org>
' * @copyright       2007-2008 Simone Cingano
' * @license         http://www.opensource.org/licenses/mit-license.php
' * @version         SVN: $Id: inc.config_sample.asp 29 2008-07-04 14:03:45Z imente $
' * @home            http://www.carnivals.it
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
const CARNIVAL_DATABASE = 	"/db/carnival.mdb"

' *** CARTELLA DI CARNIVAL
'   se hai installato carnival direttamente nella root indica "/"
'	se l'hai installato in una sottocartella (es: "carnival") indica "/carnival"
'   (ti consiglio in questo caso di indicare percorsi assoluti)
'	[ LE PATH DEVONO SEMPRE TERMINARE CON IL CARATTERE "/" ]
'	[ INDICA IL PERCORSO ASSOLUTO COMINCIANDO CON "/" ]
const CARNIVAL_MAIN = 	"/"

' *** CARTELLA PUBBLICA DI CARNIVAL
'   la seguente cartella deve possedere permessi di lettura e scrittura
'   (per molti hoster è la cartella "public")
'   se non sei certo di quale cartella utilizzare chiedi al tuo hoster
'   per questioni di "ordine" il consiglio è quello di utilizzare
'	una sottocartella chiamata CARNIVAL (come nel valore di default)
'	[ LE PATH DEVONO SEMPRE TERMINARE CON IL CARATTERE "/" ]
'	[ SU SERVER WINDOWS 2003 LE PATH NON DEVONO CONTENERE "../" ]
const CARNIVAL_PUBLIC = 	"/public/carnival/"

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
const CARNIVAL_LOGOS = "/logos/"

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
const CARNIVAL_HOME = ""


' *** VERSIONE IN DEBUG
'	ti consiglio di lasciare a FALSE la seguente costante
'	è necessaria a me mentre sviluppo
const CARNIVAL_DEBUGMODE = false

%>