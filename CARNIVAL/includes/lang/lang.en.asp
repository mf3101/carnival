<%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		lang.en.asp 0 20080312120000
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
const crnLang_menu_photos = "PHOTOS"
const crnLang_menu_gallery = "GALLERY"
const crnLang_menu_comments = "COMMENTS"
const crnLang_menu_tags = "TAGS"
const crnLang_menu_about = "ABOUT"
const crnLang_menu_admin = "ADMIN &amp; INFO"

const crnLang_main_yes = "yes"
const crnLang_main_no = "no"
const crnLang_main_next = "NEXT"
const crnLang_main_prev = "PREV"
const crnLang_main_details = "DETAILS"
const crnLang_main_comments = "COMMENTS"
const crnLang_main_close = "CLOSE"


'*** ABOUT PAGE
const crnLang_about_title = "ABOUT"


'*** COMMENTS PAGE
const crnLang_comments_title_recent = "RECENT COMMENTS"
const crnLang_comments_title_details = "DETAILS AND COMMENTS"

const crnLang_comments_nocomment = "NO COMMENTS"
const crnLang_comments_comments = "%n COMMENTS" 				'%n = numero di commenti
const crnLang_comments_postacomment = "LEAVE A COMMENT"
const crnLang_comments_lastcomments = "last %n comments" 		'%n = numero di commenti
const crnLang_comments_delete = "delete"

const crnLang_comments_form_name = "name"
const crnLang_comments_form_url = "url (optional)"
const crnLang_comments_form_email = "email (will not published)"
const crnLang_comments_form_captcha = "captcha: copy numbers in textbox"
const crnLang_comments_form_comment = "comment"
const crnLang_comments_form_extra = "&lt;b&gt; and &lt;i&gt; accepted"
const crnLang_comments_form_send = "send"

const crnLang_details_views = "%n views" 	'%n numero di visualizzazioni
const crnLang_details_tag = "tag"
const crnLang_details_download = "download high resolution version of this photo"
const crnLang_details_exif = "shot details"
const crnLang_details_exif_shot = "shot"
const crnLang_details_exif_camera = "camera"
const crnLang_details_exif_aperture = "aperture"
const crnLang_details_exif_shutterspeed = "shutter speed"
const crnLang_details_exif_focallength = "focal length "
const crnLang_details_exif_flash = "flash"
const crnLang_details_exif_meteringmode = "metering mode"
const crnLang_details_exif_orientation = "orientation"
const crnLang_details_exif_compression = "compression"
const crnLang_details_exif_cropped = "cropped"
const crnLang_details_exif_elaborated = "elaborated"


'*** TAGS PAGE
const crnLang_tags_title = "TAGS"


'*** PHOTO PAGE
const crnLang_photo_title = "PHOTOS"
const crnLang_photo_title_all = "all photos"
const crnLang_photo_title_tag = "tag: '%s'" 		'%s nome del tag
const crnLang_photo_title_photos = " ( %n photos )" 	'%n numero di foto
const crnLang_photo_title_newphotos = "new photos"
const crnLang_photo_new = "!NEW!"


'*** GALLERY PAGE
const crnLang_gallery_title = "GALLERY"
const crnLang_gallery_tag = "tag"
const crnLang_gallery_tag_all = "all photos"
const crnLang_gallery_tag_new = "new photos"
const crnLang_gallery_tag_send = "view"
const crnLang_gallery_nophotos = "no photos"
const crnLang_gallery_last_photos = "last %n photos" 	'%n numero di foto
const crnLang_gallery_last_showall = "show all"


'*** ERROR PAGE
const crnLang_error_title = "ERROR"
const crnLang_error_back = "back"
const crnLang_error_undefined = "undefined error"

const crnLang_error_comment_title = "unable to accept this comment"
const crnLang_error_comment_nophoto = "selected photo doesn't exist"
const crnLang_error_comment_code = "captcha code doesn't match"
const crnLang_error_comment_field = "type a name, a valid email (that will not published) and a comment"

const crnLang_error_photo_title = "no photo"
const crnLang_error_photo_nophoto = "there are no photo in this photoblog<br/>if you are an administrator go to <a href=""admin.asp"">admin</a> and start :)"

const crnLang_error_login_title = "unable to login"
const crnLang_error_login_password = "uncorrect password"
const crnLang_error_login_locked = "another admin is connected. IP: [ %ip ]<br/>wait %t minutes and retry"

%>