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
' * @version         SVN: $Id: lang.it.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------
dim lang__temp__
session.LCID = 1040


'*** TOP MENU
const lang__menu_photos__ = "FOTO"
const lang__menu_gallery__ = "GALLERIA"
const lang__menu_comments__ = "COMMENTI"
const lang__menu_tags__ = "TAG"
const lang__menu_about__ = "ABOUT"
const lang__menu_admin__ = "ADMIN &amp; INFO"

const lang__main_yes__ = "si"
const lang__main_no__ = "no"
const lang__main_next__ = "SUCC."
const lang__main_prev__ = "PREC."
const lang__main_details__ = "DETTAGLI"
const lang__main_comments__ = "COMMENTI"
const lang__main_close__ = "CHIUDI"


'*** ABOUT PAGE
const lang__about_title__ = "ABOUT"


'*** COMMENTS PAGE
const lang__comments_title_recent__ = "COMMENTI RECENTI"
const lang__comments_title_details__ = "DETTAGLI E COMMENTI"

const lang__comments_nocomment__ = "NESSUN COMMENTO"
const lang__comments_comments__ = "%n COMMENTI" 				'%n = numero di commenti
const lang__comments_postacomment__ = "LASCIA UN COMMENTO"
const lang__comments_delete__ = "elimina"

const lang__comments_form_name__ = "nome"
const lang__comments_form_url__ = "url (opzionale)"
const lang__comments_form_email__ = "email (non sar&agrave; pubblicata)"
const lang__comments_form_captcha__ = "copia la serie di numeri nello spazio sottostante"
const lang__comments_form_comment__ = "commento"
const lang__comments_form_extra__ = "&lt;b&gt; e &lt;i&gt; accettati"
const lang__comments_form_send__ = "invia"

const lang__details_views__ = "%n visualizzazioni" 	'%n numero di visualizzazioni
const lang__details_tag__ = "tag"
const lang__details_set__ = "set"
const lang__details_download__ = "scarica foto ad alta risoluzione"
const lang__details_exif__ = "dettagli foto"
const lang__details_exif_shot__ = "scatto"
const lang__details_exif_camera__ = "fotocamera"
const lang__details_exif_aperture__ = "apertura"
const lang__details_exif_shutterspeed__ = "esposizione"
const lang__details_exif_focallength__ = "focale"
const lang__details_exif_flash__ = "flash"
const lang__details_exif_meteringmode__ = "campo di misurazione"
const lang__details_exif_orientation__ = "orientamento"
const lang__details_exif_compression__ = "compressione"
const lang__details_exif_cropped__ = "foto tagliata"
const lang__details_exif_elaborated__ = "foto elaborata"


'*** TAGS PAGE
const lang__tags_title__ = "TAG"


'*** PHOTO PAGE
const lang__photo_title__ = "FOTO"
const lang__photo_title_all__ = "tutte le foto"
const lang__photo_title_tag__ = "tag: '%s'" 		'%s nome del tag
const lang__photo_title_photos__ = " ( %n foto )" 	'%n numero di foto
const lang__photo_title_newphotos__ = "nuove foto"
const lang__photo_new__ = "!NEW!"


'*** GALLERY PAGE
const lang__gallery_title__ = "GALLERIA"
const lang__gallery_tag__ = "tag"
const lang__gallery_tag_all__ = "tutte le foto"
const lang__gallery_tag_new__ = "nuove foto"
const lang__gallery_tag_send__ = "visualizza"
const lang__gallery_nophotos__ = "nessuna foto"
const lang__gallery_last_photos__ = "queste sono le ultime %n foto" 	'%n numero di foto
const lang__gallery_last_showall__ = "visualizza tutte le foto"


'*** ERROR PAGE
const lang__error_title__ = "ERRORE"
const lang__error_back__ = "torna indietro"
const lang__error_undefined__ = "errore non definito"

const lang__error_comment_title__ = "impossibile inviare il commento"
const lang__error_comment_nophoto__ = "la foto indicata non esiste"
const lang__error_comment_code__ = "il codice di controllo non corrisponde<br/>(se il codice &egrave; corretto, il problema potrebbe essere causato dai cookie disattivati)"
const lang__error_comment_field__ = "&egrave; necessario indicare un nome, una email valida (che non verr&aacute; pubblicata) e un commento"

const lang__error_photo_title__ = "nessuna foto presente"
const lang__error_photo_nophoto__ = "non &egrave; stata pubblicata ancora nessuna foto<br/>se sei l'amministratore vai alla pagina di <a href=""admin.asp"">admin</a> e comincia a pubblicare :)"

const lang__error_login_title__ = "impossibile eseguire il login"
const lang__error_login_password__ = "la password non corrisponde"
const lang__error_login_locked__ = "un altro admin è già collegato. IP: [ %ip ]<br/>se hai cancellato i cookie aspetta %t minuti e riprova"

%>