<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
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
' * @version         SVN: $Id: inc.first.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'* impostazioni di esecuzione
option explicit
response.buffer = true

'*****************************************************
'ENVIROMENT BASE
%><!--#include file = "inc.config.asp"-->
<!--#include file = "inc.config.lang.asp"-->
<!--#include file = "inc.set.asp"-->
<!--#include file = "inc.dba.asp"-->
<!--#include file = "inc.func.common.asp"-->
<!--#include file = "inc.func.common.io.asp"-->
<!--#include file = "inc.func.common.math.asp"-->
<!--#include file = "inc.func.common.file.asp"-->
<!--#include file = "inc.func.common.special.asp"--><%
'*****************************************************


'*****************************************************
'* connette al db

	call connect()

'*****************************************************
'* variabili d'ambiente

	dim lngCounter__, lngPaginationLooper__					'// variabili di servizio
	
	dim strPageTitleHead__ : strPageTitleHead__ = "" 		'// titolo della pagina (<title>)
	dim strPageTitle__ : strPageTitle__ = "" 				'// titolo nella pagina
	
	dim intRecordsPerPage__ : intRecordsPerPage__ = 20		'// paginazione: record per pagina
	dim intRecordsOnce__ : intRecordsOnce__ = 20			'// record visualizzati in pagina unica
	
	dim blnIsPhotosPage__ : blnIsPhotosPage__ = false		'// pagina delle foto
	dim blnIsCommentsPage__ : blnIsCommentsPage__ = false	'// pagina dei commenti
	
	dim blnIsAdminPage__ : blnIsAdminPage__ = false			'// pagina di amministrazione
	dim blnIsAdminLogged__ : blnIsAdminLogged__ = false		'// admin collegato
	
	dim blnIsLightPage__ : blnIsLightPage__ = false			'// pagina con interfaccia chiara
	
	dim strMenuCommentText__ : strMenuCommentText__ = lang__menu_comments__

	dim lngCurrentPhotoId__, lngCurrentSetId__				'// current photo/tag/set
	dim lngCurrentTagId__, strCurrentTagName__
	
'*****************************************************
'* verifica sessione
	
	dim lngLastViewedPhotoId__ : lngLastViewedPhotoId__ = 0		'// ultima foto nella precedente visita
	dim dtmLastViewedPhotoPub__ : dtmLastViewedPhotoPub__ = now	'// data ultima foto nella precedente visita
	dim lngLastPhotoId__ : lngLastPhotoId__ = 0					'// ultima foto nella visita corrente
	dim dtmLastPhotoPub__ : dtmLastPhotoPub__ = now				'// data ultima foto nella visita corrente
	call refreshSession()
	
'*****************************************************
'* config

	dim config__jsactive__, config__jsnavigatoractive__,config__exifactive__,config__author__,config__title__,config__description__
	dim config__copyright__,config__start__,config__password__,config__parent__,config__about__,config__headadd__
	dim config__bodyadd__, config__bodyaddwhere__
	dim config__style__,config__style_output_main__,config__style_output_admin__, config__style_icons__
	dim config__style_images__, config__style_photopage_islight__, config__style_page_islight__
	dim config__logo_light__, config__logo_dark__
	dim config__wbresizekey__, config__aspnetactive__
	dim config__mail_component__, config__mail_address__, config__mail_host__, config__mail_port__
	dim config__mail_user__, config__mail_password__, config__mail_ssl__, config__mail_auth__, config__mail_percomment__
	dim config__mode__, config__autopub__, config__dbversion__
	
	SQL = "SELECT * FROM tba_config"
	set rs = dbManager.Execute(SQL)
	
	'blocco applicazione
	if isnull(rs("config_start")) then response.Redirect("critical.asp?c=03") 'setup me please
	if trim(rs("config_dbversion")&"") <> CARNIVAL_VERSION then  response.Redirect("critical.asp?c=02") 'corrispondenza versioni
	if inputBoolean(rs("config_applicationblock")) then  response.Redirect("critical.asp?c=01") 'blocco applicazione
	
	config__dbversion__ = rs("config_dbversion")
	config__style__ = rs("config_style")
	config__style_output_main__ = rs("config_style_output_main")
	config__style_output_admin__ = rs("config_style_output_admin")
	config__style_images__ = rs("config_style_images")
	config__style_photopage_islight__ = inputBoolean(rs("config_style_photopage_islight"))
	config__style_page_islight__ = inputBoolean(rs("config_style_page_islight"))
	config__style_icons__ = rs("config_style_icons")
	config__jsactive__ = inputBoolean(rs("config_jsactive"))
	config__jsnavigatoractive__ = inputBoolean(rs("config_jsnavigatoractive"))
	config__exifactive__ =  inputBoolean(rs("config_exifactive"))
	config__author__ = rs("config_author")
	config__title__ = rs("config_title")
	config__description__ = rs("config_description")
	config__copyright__ = rs("config_copyright")
	config__start__ = cdate(rs("config_start"))
	config__password__ = rs("config_password")
	config__headadd__ = rs("config_headadd")
	config__bodyadd__ = rs("config_bodyadd")
	config__bodyaddwhere__ = inputByte(rs("config_bodyaddwhere"))
	config__parent__ = trim(rs("config_parent"))
	config__about__ = inputBoolean(rs("config_about"))
	config__logo_light__ = rs("config_logo_light")
	config__logo_dark__ = rs("config_logo_dark")
	config__wbresizekey__ = rs("config_wbresizekey")
	config__aspnetactive__ = inputBoolean(rs("config_aspnetactive"))
	config__mode__ = inputByte(rs("config_mode"))
	config__mail_component__ = rs("config_mail_component")
	config__mail_address__ = rs("config_mail_address")
	config__mail_host__ = rs("config_mail_host")
	config__mail_port__ = rs("config_mail_port")
	config__mail_user__ = rs("config_mail_user")
	config__mail_password__ = rs("config_mail_password")
	config__mail_ssl__ = inputByte(rs("config_mail_ssl"))
	config__mail_auth__ = inputByte(rs("config_mail_auth"))
	config__mail_percomment__ = inputBoolean(rs("config_mail_percomment"))
	config__autopub__ = inputAutopub(rs("config_autopub"))
	
	dim config__pathimages__
	config__pathimages__ = CARNIVAL_PUBLIC & CARNIVAL_STYLES & config__style__ & "/" & config__style_images__
%>