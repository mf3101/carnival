<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
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
' * @version         SVN: $Id: inc.first.asp 27 2008-07-04 12:22:52Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'* impostazioni di esecuzione
option explicit
response.buffer = true

'* variabili di servizio
dim crnOscillator, crnCounter, crnPaginationLooper

'* variabili per il calcolo del tempo impiegato
'* per l'esecuzione della pagina
'* START = inizio, END = fine, VALUE = differenza fine-inizio [intero in secondi]
dim crnTimerStart, crnTimerEnd, crnTimerValue
crnTimerStart = timer

'* inclusioni comuni
%><!--#include file = "class.include.asp"-->
<!--#include file = "inc.config.asp"-->
<!--#include file = "inc.config.lang.asp"-->
<!--#include file = "inc.set.asp"-->
<!--#include file = "inc.dba.asp"-->
<!--#include file = "inc.func.asp"-->
<!--#include file = "inc.utils.asp"-->
<!--#include file = "inc.func.file.asp"--><%

'* connette al db
	call connect()

'* variabili d'ambiente
	'// definisce se i tag cloud in popup devono essere visualizzati
	dim crnPopupTagCloud 		
	crnPopupTagCloud = false
	'// titolo della pagina (<title>)
	dim crnPageTitle
	crnPageTitle = ""
	'// titolo nella pagina
	dim crnTitle
	crnTitle = ""
	
	'// recordsperpage
	dim crnPaginationPerPage
	crnPaginationPerPage = 20
	
	'// showTop
	dim crnShowTop
	crnShowTop = 20
	'// photo
	dim crnPhotoId, crnPhotoTitle, crnPhotoDescription, crnPhotoPub, crnPhotoViews, crnPhotoUrl,crnPhotoOrder
	dim crnPhotoCropped, crnPhotoElaborated,crnPhotoDownloadable,crnPhotoOriginal,crnPhotoActive,crnPhotoSet
	'// tag
	dim crnTagId, crnTagName
	'// set
	dim crnSetId, crnSetName
	dim crnIsPhotoPage, crnIsCommentPage
	crnIsPhotoPage = false
	crnIsCommentPage = false
	
	dim crnMenuComment
	crnMenuComment = crnLang_menu_comments
	
	dim crnIsAdminPage
	crnIsAdminPage = false
	
	dim crnIsAdminLogged
	crnIsAdminLogged = false
	
	dim crnIsLightPage
	crnIsLightPage = false
	
	dim crnLastViewedPhoto, crnLastPhoto
	crnLastViewedPhoto = 0
	crnLastPhoto = 0
	call refreshSession()
	
	'// config
	dim carnival_jsactive,carnival_exifactive,carnival_author,carnival_title,carnival_description
	dim carnival_copyright,carnival_start,carnival_password,carnival_parent,carnival_about,carnival_headadd
	dim carnival_bodyadd, carnival_bodyaddwhere
	dim carnival_style,carnival_style_output_main,carnival_style_output_admin
	dim carnival_style_images, carnival_style_photopage_islight, carnival_style_page_islight
	dim carnival_logo_light, carnival_logo_dark
	dim carnival_wbresizekey, carnival_aspnetactive
	dim carnival_mode
	SQL = "SELECT * FROM tba_config"
	set rs = dbManager.conn.execute(SQL)
	
	if isnull(rs("config_start")) then response.Redirect("critical.asp?c=03") 'setup me please
	if trim(rs("config_dbversion")&"") <> CARNIVAL_VERSION then  response.Redirect("critical.asp?c=02") 'corrispondenza versioni
	if cleanBool(rs("config_applicationblock")) then  response.Redirect("critical.asp?c=01") 'blocco applicazione
	
	carnival_style = rs("config_style")
	carnival_style_output_main = rs("config_style_output_main")
	carnival_style_output_admin = rs("config_style_output_admin")
	carnival_style_images = rs("config_style_images")
	carnival_style_photopage_islight = cleanBool(rs("config_style_photopage_islight"))
	carnival_style_page_islight = cleanBool(rs("config_style_page_islight"))
	carnival_jsactive = cleanBool(rs("config_jsactive"))
	carnival_exifactive =  cleanBool(rs("config_exifactive"))
	carnival_author = rs("config_author")
	carnival_title = rs("config_title")
	carnival_description = rs("config_description")
	carnival_copyright = rs("config_copyright")
	carnival_start = cdate(rs("config_start"))
	carnival_password = rs("config_password")
	carnival_headadd = rs("config_headadd")
	carnival_bodyadd = rs("config_bodyadd")
	carnival_bodyaddwhere = cleanByte(rs("config_bodyaddwhere"))
	carnival_parent = trim(rs("config_parent"))
	carnival_about = cleanBool(rs("config_about"))
	carnival_logo_light = rs("config_logo_light")
	carnival_logo_dark = rs("config_logo_dark")
	carnival_wbresizekey = rs("config_wbresizekey")
	carnival_aspnetactive = cleanBool(rs("config_aspnetactive"))
	carnival_mode = cleanByte(rs("config_mode"))
	
	dim carnival_pathimages
	carnival_pathimages = CARNIVAL_PUBLIC & CARNIVAL_STYLES & carnival_style & "/" & carnival_style_images
%>