<%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		lang.it.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------
dim crnLang_temp


'*** TOP MENU
const crnLang_menu_photos = "FOTO"
const crnLang_menu_gallery = "GALLERIA"
const crnLang_menu_comments = "COMMENTI"
const crnLang_menu_tags = "TAG"
const crnLang_menu_about = "ABOUT"
const crnLang_menu_admin = "ADMIN &amp; INFO"

const crnLang_main_yes = "si"
const crnLang_main_no = "no"
const crnLang_main_next = "SUCC."
const crnLang_main_prev = "PREC."
const crnLang_main_details = "DETTAGLI"
const crnLang_main_comments = "COMMENTI"
const crnLang_main_close = "CHIUDI"


'*** ABOUT PAGE
const crnLang_about_title = "ABOUT"


'*** COMMENTS PAGE
const crnLang_comments_title_recent = "COMMENTI RECENTI"
const crnLang_comments_title_details = "DETTAGLI E COMMENTI"

const crnLang_comments_nocomment = "NESSUN COMMENTO"
const crnLang_comments_comments = "%n COMMENTI" 				'%n = numero di commenti
const crnLang_comments_postacomment = "LASCIA UN COMMENTO"
const crnLang_comments_lastcomments = "ultimi %n commenti" 		'%n = numero di commenti
const crnLang_comments_delete = "elimina"

const crnLang_comments_form_name = "nome"
const crnLang_comments_form_url = "url (opzionale)"
const crnLang_comments_form_email = "email (non sar&agrave; pubblicata)"
const crnLang_comments_form_captcha = "copia la serie di numeri nello spazio sottostante"
const crnLang_comments_form_comment = "commento"
const crnLang_comments_form_extra = "&lt;b&gt; e &lt;i&gt; accettati"
const crnLang_comments_form_send = "invia"

const crnLang_details_views = "%n visualizzazioni" 	'%n numero di visualizzazioni
const crnLang_details_tag = "tag"
const crnLang_details_download = "scarica foto ad alta risoluzione"
const crnLang_details_exif = "dettagli foto"
const crnLang_details_exif_shot = "scatto"
const crnLang_details_exif_camera = "fotocamera"
const crnLang_details_exif_aperture = "apertura"
const crnLang_details_exif_shutterspeed = "esposizione"
const crnLang_details_exif_focallength = "focale"
const crnLang_details_exif_flash = "flash"
const crnLang_details_exif_meteringmode = "campo di misurazione"
const crnLang_details_exif_orientation = "orientamento"
const crnLang_details_exif_compression = "compressione"
const crnLang_details_exif_cropped = "foto tagliata"
const crnLang_details_exif_elaborated = "foto elaborata"


'*** TAGS PAGE
const crnLang_tags_title = "TAG"


'*** PHOTO PAGE
const crnLang_photo_title = "FOTO"
const crnLang_photo_title_all = "tutte le foto"
const crnLang_photo_title_tag = "tag: '%s'" 		'%s nome del tag
const crnLang_photo_title_photos = " ( %n foto )" 	'%n numero di foto
const crnLang_photo_title_newphotos = "nuove foto"
const crnLang_photo_new = "!NEW!"


'*** GALLERY PAGE
const crnLang_gallery_title = "GALLERIA"
const crnLang_gallery_tag = "tag"
const crnLang_gallery_tag_all = "tutte le foto"
const crnLang_gallery_tag_new = "nuove foto"
const crnLang_gallery_tag_send = "visualizza"
const crnLang_gallery_nophotos = "nessuna foto"
const crnLang_gallery_last_photos = "queste sono le ultime %n foto" 	'%n numero di foto
const crnLang_gallery_last_showall = "visualizza tutte le foto"


'*** ERROR PAGE
const crnLang_error_title = "ERRORE"
const crnLang_error_back = "torna indietro"
const crnLang_error_undefined = "errore non definito"

const crnLang_error_comment_title = "impossibile inviare il commento"
const crnLang_error_comment_nophoto = "la foto indicata non esiste"
const crnLang_error_comment_code = "il codice di controllo non corrisponde<br/>(se il codice &egrave; corretto, il problema potrebbe essere causato dai cookie disattivati)"
const crnLang_error_comment_field = "&egrave; necessario indicare un nome, una email valida (che non verr&aacute; pubblicata) e un commento"

const crnLang_error_photo_title = "nessuna foto presente"
const crnLang_error_photo_nophoto = "non &egrave; stata pubblicata ancora nessuna foto<br/>se sei l'amministratore vai alla pagina di <a href=""admin.asp"">admin</a> e comincia a pubblicare :)"

const crnLang_error_login_title = "impossibile eseguire il login"
const crnLang_error_login_password = "la password non corrisponde"
const crnLang_error_login_locked = "un altro admin è già collegato. IP: [ %ip ]<br/>se hai cancellato i cookie aspetta %t minuti e riprova"

%>