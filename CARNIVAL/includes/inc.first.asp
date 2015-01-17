<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		inc.first.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------

'* impostazioni di esecuzione
option explicit
response.buffer = true

'* variabili di servizio
dim crnOscillator, crnCounter

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
	
	'// showTop
	dim crnShowTop
	crnShowTop = 20
	'// photo
	dim crnPhotoId, crnPhotoTitle, crnPhotoDescription, crnPhotoPub, crnPhotoViews, crnPhotoUrl
	dim crnPhotoCropped, crnPhotoElaborated,crnPhotoDownloadable,crnPhotoOriginal,crnPhotoActive
	'// tag
	dim crnTagId, crnTagName
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
	dim carnival_copyright,carnival_start,carnival_password,carnival_about,carnival_headadd
	dim carnival_bodyadd, carnival_bodyaddwhere
	dim carnival_style,carnival_style_output_main,carnival_style_output_admin
	dim carnival_style_images, carnival_style_photopage_islight, carnival_style_page_islight
	dim carnival_logo_light, carnival_logo_dark
	dim carnival_wbresizekey, carnival_aspnetactive
	SQL = "SELECT * FROM tba_config WHERE config_id = 1"
	set rs = conn.execute(SQL)
	
	if isnull(rs("config_start")) then
		response.write("setup me please")
		response.End()
	end if
	
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
	carnival_about = cleanBool(rs("config_about"))
	carnival_logo_light = rs("config_logo_light")
	carnival_logo_dark = rs("config_logo_dark")
	carnival_wbresizekey = rs("config_wbresizekey")
	carnival_aspnetactive = cleanBool(rs("config_aspnetactive"))
	
	dim carnival_pathimages
	carnival_pathimages = CARNIVAL_PUBLIC & CARNIVAL_STYLES & carnival_style & "/" & carnival_style_images
%>