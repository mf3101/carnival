<!--#include file = "inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		mod.admin.prostyles.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"-->
<!--#include file = "inc.func.style.asp"--><%

dim crn_from
crn_from = request.QueryString("from")

dim crn_style, crn_logo_light, crn_logo_dark
crn_logo_light = request.querystring("logo_light")
crn_logo_dark = request.querystring("logo_dark")
crn_style = request.querystring("style")

dim crn_compress
crn_compress = cstr(request.querystring("compress"))
if crn_compress = "1" then : crn_compress = true : else : crn_compress = false : end if



select case crn_from
	
	case "stylesstyle", "tools"
	
		if crn_style = "" then response.Redirect("admin.asp?module=styles")
	
		dim crn_stylecontent
		crn_stylecontent = loadStyle(CARNIVAL_PUBLIC & CARNIVAL_STYLES & crn_style & "/cstyleconfig.txt")
		if isnull(crn_stylecontent) or crn_stylecontent = "" then response.Redirect("errors.asp?c=style0")
		
		dim crn_input_style,crn_output_style_main,crn_output_style_admin,crn_compatible, crn_images
		dim crn_desc
		crn_input_style = getStyleVar("css_input",crn_stylecontent)
		crn_output_style_main = getStyleVar("css_output_main",crn_stylecontent)
		crn_output_style_admin = getStyleVar("css_output_admin",crn_stylecontent)
		
		dim crn_font,crn_header_color,crn_header_backcolor,crn_title_color, crn_title_margin
		dim crn_text_light_color, crn_text_dark_color, crn_text_menu_color,crn_photo_width,crn_photo_width_l
		dim crn_photopage_islight,crn_page_islight
		
		if crn_from = "tools" then
			SQL = "SELECT config_style_font, config_style_header_color, config_style_header_backcolor, config_style_title_color,config_style_title_margin, config_style_text_light_color, config_style_text_dark_color, config_style_text_menu_color FROM tba_config WHERE config_id = 1"
			set rs = conn.execute(SQL)
			crn_font = rs("config_style_font")
			crn_header_color = rs("config_style_header_color")
			crn_header_backcolor = rs("config_style_header_backcolor")
			crn_title_color = rs("config_style_title_color")
			crn_title_margin = cleanLong(rs("config_style_title_margin"))
			crn_text_light_color = rs("config_style_text_light_color")
			crn_text_dark_color = rs("config_style_text_dark_color")
			crn_text_menu_color = rs("config_style_text_menu_color")
		else
			crn_font = cleanString(request.QueryString("style-font-family"),0,50)
			crn_header_color = cleanString(request.QueryString("style-header-color"),0,7)
			crn_header_backcolor = cleanString(request.QueryString("style-header-backcolor"),0,7)
			crn_title_color = cleanString(request.QueryString("style-title-color"),0,7)
			crn_title_margin = cleanLong(request.QueryString("style-title-margin"))
			crn_text_light_color = cleanString(request.QueryString("style-text-light-color"),0,7)
			crn_text_dark_color = cleanString(request.QueryString("style-text-dark-color"),0,7)
			crn_text_menu_color = cleanString(request.QueryString("style-text-menu-color"),0,7)
		end if
		
		
		crn_photopage_islight = cleanBool(getStyleVar("page_photo_islight",crn_stylecontent))
		crn_page_islight = cleanBool(getStyleVar("page_islight",crn_stylecontent))
		
		crn_photo_width = cleanLong(getStyleVar("photo_width",crn_stylecontent))
		if crn_photo_width = 0 then crn_photo_width = 640
		
		dim crn_get_temp
		crn_photo_width_l = crn_photo_width
		crn_get_temp = getStyleVar("photo_margin",crn_stylecontent)
		if isnumeric(crn_get_temp) then
			crn_get_temp = clng(crn_get_temp)*2
		else
			crn_get_temp = 5*2
		end if
		crn_photo_width = crn_photo_width+crn_get_temp
		crn_photo_width_l = crn_photo_width-crn_get_temp
		
		crn_compatible = checkStyle(crn_stylecontent)
		crn_images = getStyleVar("images_path",crn_stylecontent)
		if not crn_compatible then response.Redirect("errors.asp?c=style1")
		if not fileExist(CARNIVAL_PUBLIC & CARNIVAL_STYLES & crn_style & "/" & crn_input_style) then response.Redirect("errors.asp?c=style2")
		
		call compileStyle(crn_compress,CARNIVAL_PUBLIC & CARNIVAL_STYLES & crn_style & "/" & crn_input_style,CARNIVAL_PUBLIC & CARNIVAL_STYLES & crn_style & "/" & crn_output_style_main,CARNIVAL_PUBLIC & CARNIVAL_STYLES & crn_style & "/" & crn_output_style_admin,crn_font,crn_header_color, crn_header_backcolor, crn_title_color, crn_title_margin, crn_text_light_color,crn_text_dark_color,crn_text_menu_color,crn_photo_width,crn_photo_width_l)
		
		if crn_from <> "tools" then
			crn_desc = "<strong>" & getStyleVar("name",crn_stylecontent) & "</strong> ( " & getStyleVar("author",crn_stylecontent) & " " & getStyleVar("date",crn_stylecontent) & " )<br/>" & getStyleVar("note",crn_stylecontent)
			
			SQL = "UPDATE tba_config SET config_style = '" & crn_style & "', config_style_output_main = '" & crn_output_style_main & "', config_style_output_admin = '" & crn_output_style_admin & "', config_style_font = '" & crn_font & "', config_style_images = '" & crn_images & "', config_style_header_color = '" & crn_header_color & "', config_style_header_backcolor = '" & crn_header_backcolor & "', config_style_title_color = '" & crn_title_color & "', config_style_title_margin = " & crn_title_margin & ", config_style_text_light_color = '" & crn_text_light_color & "', config_style_text_dark_color = '" & crn_text_dark_color & "', config_style_text_menu_color = '" & crn_text_menu_color & "', config_style_photopage_islight = " & formatDbBool(crn_photopage_islight) & ", config_style_page_islight = " & formatDbBool(crn_page_islight) & ", config_style_desc = '" & cleanString(crn_desc,0,0) & "' WHERE config_id = 1"
			conn.execute(SQL)
		end if
	
	case "styleslogo"

		if crn_logo_light <> "" and crn_logo_dark <> "" then
		
			if crn_logo_light = "$TEXT$" then crn_logo_light = ""
			if crn_logo_dark = "$TEXT$" then crn_logo_dark = ""
			
			SQL = "UPDATE tba_config SET config_logo_light = '" & crn_logo_light & "', config_logo_dark = '" & crn_logo_dark & "' WHERE config_id = 1"
			conn.execute(SQL)
		
		end if

end select

select case crn_from
	case "tools"
	if crn_compress then
		response.Redirect("admin.asp?module=tools&done=styles")
	else
		response.Redirect("admin.asp?module=tools&done=styles-debug")
	end if
	case "stylesstyle","styleslogo"
	response.Redirect("admin.asp?module=styles")
	case else
	response.Redirect("admin.asp")
end select

%>