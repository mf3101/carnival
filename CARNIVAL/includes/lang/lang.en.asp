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
' * @version         SVN: $Id: lang.en.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------
dim lang__temp__
session.LCID = 1033


'*** TOP MENU
const lang__menu_photos__ = "PHOTOS"
const lang__menu_gallery__ = "GALLERY"
const lang__menu_comments__ = "COMMENTS"
const lang__menu_tags__ = "TAGS"
const lang__menu_about__ = "ABOUT"
const lang__menu_admin__ = "ADMIN &amp; INFO"

const lang__main_yes__ = "yes"
const lang__main_no__ = "no"
const lang__main_next__ = "NEXT"
const lang__main_prev__ = "PREV"
const lang__main_details__ = "DETAILS"
const lang__main_comments__ = "COMMENTS"
const lang__main_close__ = "CLOSE"


'*** ABOUT PAGE
const lang__about_title__ = "ABOUT"


'*** COMMENTS PAGE
const lang__comments_title_recent__ = "RECENT COMMENTS"
const lang__comments_title_details__ = "DETAILS AND COMMENTS"

const lang__comments_nocomment__ = "NO COMMENTS"
const lang__comments_comments__ = "%n COMMENTS" 				'%n = numero di commenti
const lang__comments_postacomment__ = "LEAVE A COMMENT"
const lang__comments_delete__ = "delete"

const lang__comments_form_name__ = "name"
const lang__comments_form_url__ = "url (optional)"
const lang__comments_form_email__ = "email (will not published)"
const lang__comments_form_captcha__ = "captcha: copy numbers in textbox"
const lang__comments_form_comment__ = "comment"
const lang__comments_form_extra__ = "&lt;b&gt; and &lt;i&gt; accepted"
const lang__comments_form_send__ = "send"

const lang__details_views__ = "%n views" 	'%n numero di visualizzazioni
const lang__details_tag__ = "tag"
const lang__details_set__ = "set"
const lang__details_download__ = "download high resolution version of this photo"
const lang__details_exif__ = "shot details"
const lang__details_exif_shot__ = "shot"
const lang__details_exif_camera__ = "camera"
const lang__details_exif_aperture__ = "aperture"
const lang__details_exif_shutterspeed__ = "shutter speed"
const lang__details_exif_focallength__ = "focal length "
const lang__details_exif_flash__ = "flash"
const lang__details_exif_meteringmode__ = "metering mode"
const lang__details_exif_orientation__ = "orientation"
const lang__details_exif_compression__ = "compression"
const lang__details_exif_cropped__ = "cropped"
const lang__details_exif_elaborated__ = "elaborated"


'*** TAGS PAGE
const lang__tags_title__ = "TAGS"


'*** PHOTO PAGE
const lang__photo_title__ = "PHOTOS"
const lang__photo_title_all__ = "all photos"
const lang__photo_title_tag__ = "tag: '%s'" 		'%s nome del tag
const lang__photo_title_photos__ = " ( %n photos )" 	'%n numero di foto
const lang__photo_title_newphotos__ = "new photos"
const lang__photo_new__ = "!NEW!"


'*** GALLERY PAGE
const lang__gallery_title__ = "GALLERY"
const lang__gallery_tag__ = "tag"
const lang__gallery_tag_all__ = "all photos"
const lang__gallery_tag_new__ = "new photos"
const lang__gallery_tag_send__ = "view"
const lang__gallery_nophotos__ = "no photos"
const lang__gallery_last_photos__ = "last %n photos" 	'%n numero di foto
const lang__gallery_last_showall__ = "show all"


'*** ERROR PAGE
const lang__error_title__ = "ERROR"
const lang__error_back__ = "back"
const lang__error_undefined__ = "undefined error"

const lang__error_comment_title__ = "unable to accept this comment"
const lang__error_comment_nophoto__ = "selected photo doesn't exist"
const lang__error_comment_code__ = "captcha code doesn't match"
const lang__error_comment_field__ = "type a name, a valid email (that will not published) and a comment"

const lang__error_photo_title__ = "no photo"
const lang__error_photo_nophoto__ = "there are no photo in this photoblog<br/>if you are an administrator go to <a href=""admin.asp"">admin</a> and start :)"

const lang__error_login_title__ = "unable to login"
const lang__error_login_password__ = "uncorrect password"
const lang__error_login_locked__ = "another admin is connected. IP: [ %ip ]<br/>wait %t minutes and retry"

%>