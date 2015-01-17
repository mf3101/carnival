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
' * @version         SVN: $Id: inc.setup.asp 109 2010-10-11 10:37:30Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

sub printError(source)
%>	<div class="error">
		<strong>Errore:</strong><br/>
		<%=err.source%> (<%=err.number%>)<br/>
		<%=err.description%><br/>
        <% if source <> "" then %><a href="<%=source%>" target="_blank" class="link">clicca per aprire la pagina e vedere l'errore nel dettaglio</a><br/><% end if %>
	</div><%
end sub

sub printResult(title, description, error, codeerror, source)
	response.write "<div class=""check"">" & vbcrlf
	if error then
		response.write "<p class=""title alert""><img src=""setup/cross.gif"" alt="""" /> " & title & "</p>" & vbcrlf
		response.write "<p class=""description"">" & description & "</p>" & vbcrlf
		if codeerror then call printError(source)
	else
		response.write "<p class=""title""><img src=""setup/tick.gif"" alt="""" /> " & title & "</p>" & vbcrlf
		response.write "<p class=""description"">" & description & "</p>" & vbcrlf
	end if
	response.write "</div>" & vbcrlf
end sub

function CreateDatabase(db,user,password,options)
	CreateDatabase = true
	if dbManager.CreateNew(db,user,password,options,true) then
	
		call dbManager.Connect(db,user,password,options)
	
		call dbManager.CreateTable("tba_config","config_id","",true)
			call dbManager.AddColumn("tba_config","config_dbversion",			":type=varchar,:size=10",null,true)
			call dbManager.AddColumn("tba_config","config_applicationblock",	":type=byte",null,true)
			call dbManager.AddColumn("tba_config","config_jsactive",			":type=byte",null,true)
			call dbManager.AddColumn("tba_config","config_jsnavigatoractive",	":type=byte",null,true)
			call dbManager.AddColumn("tba_config","config_exifactive",			":type=byte",null,true)
			call dbManager.AddColumn("tba_config","config_aspnetactive",		":type=byte",null,true)
			call dbManager.AddColumn("tba_config","config_title",				":type=varchar,:size=50",null,true)
			call dbManager.AddColumn("tba_config","config_description",			":type=varchar,:size=255",null,true)
			call dbManager.AddColumn("tba_config","config_author",				":type=varchar,:size=50",null,true)
			call dbManager.AddColumn("tba_config","config_start",				":type=date",null,true)
			call dbManager.AddColumn("tba_config","config_password",			":type=char,:size=32",null,true)
			call dbManager.AddColumn("tba_config","config_copyright",			":type=varchar,:size=100",null,true)
			call dbManager.AddColumn("tba_config","config_aboutpage",			":type=memo",null,true)
			call dbManager.AddColumn("tba_config","config_about",				":type=byte",null,true)
			call dbManager.AddColumn("tba_config","config_headadd",				":type=memo",null,true)
			call dbManager.AddColumn("tba_config","config_bodyadd",				":type=memo",null,true)
			call dbManager.AddColumn("tba_config","config_bodyaddwhere",		":type=byte",null,true)
			call dbManager.AddColumn("tba_config","config_mode",				":type=byte",null,true)
			call dbManager.AddColumn("tba_config","config_parent",				":type=varchar,:size=250",null,true)
			call dbManager.AddColumn("tba_config","config_autopub",				":type=long",null,true)
			call dbManager.AddColumn("tba_config","config_mail_component",		":type=varchar,:size=30",null,true)
			call dbManager.AddColumn("tba_config","config_mail_address",		":type=varchar,:size=100",null,true)
			call dbManager.AddColumn("tba_config","config_mail_host",			":type=varchar,:size=100",null,true)
			call dbManager.AddColumn("tba_config","config_mail_port",			":type=short",null,true)
			call dbManager.AddColumn("tba_config","config_mail_user",			":type=varchar,:size=50",null,true)
			call dbManager.AddColumn("tba_config","config_mail_password",		":type=varchar,:size=50",null,true)
			call dbManager.AddColumn("tba_config","config_mail_ssl",			":type=byte",null,true)
			call dbManager.AddColumn("tba_config","config_mail_auth",			":type=byte",null,true)
			call dbManager.AddColumn("tba_config","config_mail_percomment",		":type=byte",null,true)
			call dbManager.AddColumn("tba_config","config_ccv",					":type=byte",null,true)
			call dbManager.AddColumn("tba_config","config_wbresizekey",			":type=char,:size=32",null,true)
			call dbManager.AddColumn("tba_config","config_style",				":type=varchar,:size=50",null,true)
			call dbManager.AddColumn("tba_config","config_style_desc",			":type=memo",null,true)
			call dbManager.AddColumn("tba_config","config_style_output_main",	":type=varchar,:size=50",null,true)
			call dbManager.AddColumn("tba_config","config_style_output_admin",	":type=varchar,:size=50",null,true)
			call dbManager.AddColumn("tba_config","config_style_images",		":type=varchar,:size=50",null,true)
			call dbManager.AddColumn("tba_config","config_style_font",			":type=varchar,:size=50",null,true)
			call dbManager.AddColumn("tba_config","config_style_header_color",	":type=varchar,:size=7",null,true)
			call dbManager.AddColumn("tba_config","config_style_header_backcolor",":type=varchar,:size=7",null,true)
			call dbManager.AddColumn("tba_config","config_style_title_color",	":type=varchar,:size=7",null,true)
			call dbManager.AddColumn("tba_config","config_style_title_margin",	":type=long",null,true)
			call dbManager.AddColumn("tba_config","config_style_text_light_color",":type=varchar,:size=7",null,true)
			call dbManager.AddColumn("tba_config","config_style_text_dark_color", ":type=varchar,:size=7",null,true)
			call dbManager.AddColumn("tba_config","config_style_text_menu_color", ":type=varchar,:size=7",null,true)
			call dbManager.AddColumn("tba_config","config_style_photopage_islight",":type=byte",null,true)
			call dbManager.AddColumn("tba_config","config_style_page_islight",	":type=byte",null,true)
			call dbManager.AddColumn("tba_config","config_style_icons",			":type=varchar,:size=50",null,true)
			call dbManager.AddColumn("tba_config","config_logo_light",			":type=varchar,:size=50",null,true)
			call dbManager.AddColumn("tba_config","config_logo_dark",			":type=varchar,:size=50",null,true)
		
		call dbManager.CreateTable("tba_photo","photo_id","",true)
			call dbManager.AddColumn("tba_photo","photo_title",		":type=varchar,:size=50",null,true)
			call dbManager.AddColumn("tba_photo","photo_description",":type=memo",null,true)
			call dbManager.AddColumn("tba_photo","photo_views",		":type=long",null,true)
			call dbManager.AddColumn("tba_photo","photo_pub",		":type=date",null,true)
			call dbManager.AddColumn("tba_photo","photo_pubqueue",	":type=byte",null,true)
			call dbManager.AddColumn("tba_photo","photo_cropped",	":type=byte",null,true)
			call dbManager.AddColumn("tba_photo","photo_elaborated",":type=byte",null,true)
			call dbManager.AddColumn("tba_photo","photo_active",	":type=byte",null,true)
			call dbManager.AddColumn("tba_photo","photo_downloadable",":type=byte",null,true)
			call dbManager.AddColumn("tba_photo","photo_original",	":type=char,:size=10",null,true)
			call dbManager.AddColumn("tba_photo","photo_set",		":type=double",null,true)
			call dbManager.AddColumn("tba_photo","photo_order",		":type=short,:signed=true",null,true)
		
		call dbManager.CreateTable("tba_comment","comment_id","",true)
			call dbManager.AddColumn("tba_comment","comment_name",	":type=varchar,:size=25",null,true)
			call dbManager.AddColumn("tba_comment","comment_content",":type=memo",null,true)
			call dbManager.AddColumn("tba_comment","comment_date",	":type=date",null,true)
			call dbManager.AddColumn("tba_comment","comment_url",	":type=varchar,:size=250",null,true)
			call dbManager.AddColumn("tba_comment","comment_email",	":type=varchar,:size=250",null,true)
			call dbManager.AddColumn("tba_comment","comment_photo",	":type=long",null,true)
			call dbManager.AddColumn("tba_comment","comment_admin",	":type=byte",null,true)
		
		call dbManager.CreateTable("tba_set","set_id","",true)
			call dbManager.AddColumn("tba_set","set_name",			":type=varchar,:size=50",null,true)
			call dbManager.AddColumn("tba_set","set_description",	":type=memo",null,true)
			call dbManager.AddColumn("tba_set","set_cover",			":type=long",null,true)
			call dbManager.AddColumn("tba_set","set_photos",		":type=long",null,true)
			call dbManager.AddColumn("tba_set","set_order",			":type=short,:signed=true",null,true)
					
		call dbManager.CreateTable("tba_tag","tag_id","",true)
			call dbManager.AddColumn("tba_tag","tag_name",			":type=varchar,:size=50",null,true)
			call dbManager.AddColumn("tba_tag","tag_photos",		":type=long",null,true)
			call dbManager.AddColumn("tba_tag","tag_type",			":type=byte",null,true)
		
		call dbManager.CreateTable("tba_rel","rel_id","",true)
			call dbManager.AddColumn("tba_rel","rel_photo",			":type=long",null,true)
			call dbManager.AddColumn("tba_rel","rel_tag",			":type=long",null,true)
			
		'inizializza tabella CONFIG
			call dbManager.Execute("INSERT INTO tba_config (" & _
				"config_dbversion, config_applicationblock, config_jsactive, config_jsnavigatoractive, config_exifactive, " & _
				"config_aspnetactive, config_title, config_description, config_author, " & _
				"config_start, config_password, config_copyright, config_aboutpage, " & _
				"config_about, config_headadd, config_bodyadd, config_bodyaddwhere, " & _
				"config_mode, config_parent, config_autopub, config_mail_component, " & _
				"config_mail_address, config_mail_host, config_mail_port, config_mail_user, " & _
				"config_mail_password, config_mail_ssl, config_mail_auth, config_mail_percomment, " & _
				"config_ccv, config_wbresizekey, config_style, config_style_desc, " & _
				"config_style_output_main, config_style_output_admin, config_style_images, " & _
				"config_style_font, config_style_header_color, config_style_header_backcolor, " & _
				"config_style_title_color, config_style_title_margin, config_style_text_light_color, " & _
				"config_style_text_dark_color, config_style_text_menu_color, config_style_photopage_islight, config_style_page_islight, " & _
				"config_style_icons, config_logo_light, config_logo_dark" & _
			") VALUES (" & _
				"'1.0.0',1,1,1,1," & _
				"0,'My Photoblog','',''," & _
				"" & formatDBDate("1985/03/12", dbManager.database) & ",'','',''," & _
				"0,'','',0," & _
				"0,'',0,''," & _
				"'','',0,''," & _
				"'',0,0,1," & _
				"1,'','',''," & _
				"'','',''," & _
				"'','',''," & _
				"'',0,''," & _
				"'','',0,0," & _
				"'','',''" & _
			")")
		
		'inizializza tabella SET
		call dbManager.Execute("INSERT INTO tba_set (set_name, set_description, set_cover, set_photos, set_order) VALUES ('Default','',0,0,-1)")
	
	else
		CreateDatabase = false
	end if

end function

%>
