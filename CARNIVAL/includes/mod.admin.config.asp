<!--#include file = "inc.first.asp"--><%
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
' * @version         SVN: $Id: mod.admin.config.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "inc.admin.check.asp"-->
<!--#include file = "class.safemailer.asp"--><%
'*****************************************************

dim strConfigMode
strConfigMode = normalize(request.QueryString("mode"),"full|navigation|automation|mail-component|" & _
													  "mail-notifications|about|code|password" ,"general")

dim strAboutContent
SQL = "SELECT config_aboutpage FROM tba_config"
set rs = dbManager.Execute(SQL)
strAboutContent = rs("config_aboutpage")

%>

	<h2>Configurazione</h2>
	<div class="clear"></div>
	<% if strConfigMode <> "full" then %>
    <div style="float:left;">
        <ul class="tabmenu">
            <li<% if strConfigMode = "general" then %> class="selected"<% end if %>><a href="?module=config&amp;mode=general">Generale</a></li>
            <li<% if strConfigMode = "navigation" then %> class="selected"<% end if %>><a href="?module=config&amp;mode=navigation">Navigazione</a></li>
            <li<% if strConfigMode = "automation" then %> class="selected"<% end if %>><a href="?module=config&amp;mode=automation">Automazione</a></li>
            <li<% if strConfigMode = "mail-component" or strConfigMode = "mail-notifications" then %> class="selected"<% end if %>><a href="?module=config&amp;mode=mail-notifications">Email</a></li>
            <li<% if strConfigMode = "about" then %> class="selected"<% end if %>><a href="?module=config&amp;mode=about">Informazioni</a></li>
            <li<% if strConfigMode = "code" then %> class="selected"<% end if %>><a href="?module=config&amp;mode=code">Codice</a></li>
            <li<% if strConfigMode = "password" then %> class="selected"<% end if %>><a href="?module=config&amp;mode=password">Password</a></li>
        </ul>
    </div>
    <div class="hrtabmenu"></div>
    <% if strConfigMode = "mail-component" or strConfigMode = "mail-notifications" then %>
	<div class="clear"></div>
    <div style="float:left;">
        <ul class="tabmenu mini">
            <li<% if strConfigMode = "mail-notifications" then %> class="selected"<% end if %>><a href="?module=config&amp;mode=mail-notifications">Notifiche via mail</a></li>
            <li<% if strConfigMode = "mail-component" then %> class="selected"<% end if %>><a href="?module=config&amp;mode=mail-component">Impostazioni SMTP</a></li>
        </ul>
    </div>
    <div class="hrtabmenu mini"></div>
    <% end if %> 
    <% end if
	   if request.QueryString("action") = "done" then %>
    <div class="infobox">configurazione salvata correttamente</div><%
	   end if
	   if request.QueryString("mailtest") = "done" then %>
    <div class="infobox">mail di test inviata correttamente<br/>fra qualche minuto dovresti riceverla nella casella di email indicata</div><% 
	   elseif request.QueryString("mailtest") = "none" then %>
    <div class="infobox">errore nell'invio mail di test. controlla i parametri inseriti<br/><small><%=outputHTMLString(request.QueryString("mailtestinfo"))%></small></div><%
	   end if %>
	<form action="admin.asp?module=pro-config" method="post" class="config" id="configform">
    	<input type="hidden" id="configmode" name="configmode" value="<%=strConfigMode%>" />
        <% 
		if strConfigMode = "general" or strConfigMode = "full" then 
		%>        
		<div class="help-switch"><a href="javascript:switchDisplay('help-title');"><img src="<%=getImagePath("lay-adm-ico-act-help.gif")%>" alt="Aiuto" /></a></div>
		<h3>Titolo photoblog</h3>
		<div class="help-box"><div class="help" id="help-title">il titolo viene visualizzato nel nome della pagina, nel meta-tag TITLE e, s non viene utilizzato un logo, nella parte alta della pagina.<br />
		si consiglia di utilizzare un titolo breve di non più di venti caratteri</div></div>
		<div><label for="title">titolo</label>
		<input type="text" id="title" name="title" class="text" maxlength="50" value="<%=outputHTMLString(config__title__)%>" /></div>
		
		<hr/>
		
		<div class="help-switch"><a href="javascript:switchDisplay('help-description');"><img src="<%=getImagePath("lay-adm-ico-act-help.gif")%>" alt="Aiuto" /></a></div>
		<h3>Descrizione photoblog</h3>
		<div class="help-box"><div class="help" id="help-description">la descrizione &egrave; un breve testo (non più di 250 caratteri) che viene inserito nel meta-tag DESCRIPTION.</div></div>
		<div><label for="description">descrizione</label>
		<input type="text" id="description" name="description" class="text" maxlength="250" value="<%=outputHTMLString(config__description__)%>" /></div>
		
		<hr/>
		
		<div class="help-switch"><a href="javascript:switchDisplay('help-author');"><img src="<%=getImagePath("lay-adm-ico-act-help.gif")%>" alt="Aiuto" /></a></div>
		<h3>Autore</h3>
        <div class="help-box"><div class="help" id="help-author">il nome dell'autore o degli autori delle fotografie viene inserito nel meta-tag AUTHOR. (se si indicano più autori separarli con una virgola)</div></div>
		<div><label for="author">autore</label>
		<input type="text" id="author" name="author" class="text" maxlength="50" value="<%=outputHTMLString(config__author__)%>" /></div>
		
		<hr/>
		
		<div class="help-switch"><a href="javascript:switchDisplay('help-copyright');"><img src="<%=getImagePath("lay-adm-ico-act-help.gif")%>" alt="Aiuto" /></a></div>
		<h3>Copyright</h3>
		<div class="help-box"><div class="help" id="help-copyright">il copyright viene inserito nel meta-tag COPYRIGHT e si indica in formato &quot;<em>(C) data autore</em>&quot;</div></div>
		<div><label for="copyright">copyright</label>
		<input type="text" id="copyright" name="copyright" class="text" maxlength="100" value="<%=outputHTMLString(config__copyright__)%>" /></div>
		
		<hr/>
        <% 
		end if
		if strConfigMode = "automation" or strConfigMode = "full" then 
		%>    
		<div class="help-switch"><a href="javascript:switchDisplay('help-autopub');"><img src="<%=getImagePath("lay-adm-ico-act-help.gif")%>" alt="Aiuto" /></a></div>
		<h3>Pubblicazione automatica</h3>
		<div class="help-box"><div class="help" id="help-autopub">E' possibile selezionare un intervallo di pubblicazione automatica.<br />
		Le foto configurate per essere pubblicate periodicamente verranno intervallate a seconda delle impostazioni indicate.</div></div>
		<div><label for="autopub_mode">intervallo di pubblicazione</label>
        	<fieldset>
            <input type="radio" name="autopub_mode" value="0"<% if inputByte(mid(config__autopub__,1,1)) = 0 then response.write " checked=""checked"""%> /> Giornaliero...
            </fieldset>
        	<fieldset>
			<input type="radio" name="autopub_mode" value="1"<% if inputByte(mid(config__autopub__,1,1)) = 1 then response.write " checked=""checked"""%> /> Settimanale, ogni <select name="autopub1_day" style="width:100px;">
            <%
				for ii=1 to 7
					%><option value="<%=ii%>"<% if inputByte(mid(config__autopub__,2,2)) = ii and inputByte(mid(config__autopub__,1,1)) = 1 then response.write " selected=""selected"""%>><%=WeekDayName(ii)%></option><%
				next
			%>
            </select> ...
            </fieldset>
        	<fieldset>
			<input type="radio" name="autopub_mode" value="2"<% if inputByte(mid(config__autopub__,1,1)) = 2 then response.write " checked=""checked"""%> /> Mensile, il <select name="autopub2_day" style="width:50px;">
            <%
				for ii=1 to 31
					%><option value="<%=ii%>"<% if inputByte(mid(config__autopub__,2,2)) = ii and inputByte(mid(config__autopub__,1,1)) = 2 then response.write " selected=""selected"""%>><%=ii%></option><%
				next
			%>
            </select> ...
            </fieldset>
            <div class="clear"></div>
        	<fieldset>...alle ore <select name="autopub_hours" style="width:50px;">
            <%
				for ii=0 to 23
					%><option value="<%=ii%>"<% if inputByte(mid(config__autopub__,4,2)) = ii then response.write " selected=""selected"""%>><%=(ii)%></option><%
				next
			%>
            </select>&nbsp;:&nbsp;
			<select name="autopub_minutes" style="width:50px;">
            <%
				for ii=0 to 59
					%><option value="<%=ii%>"<% if inputByte(mid(config__autopub__,6,2)) = ii then response.write " selected=""selected"""%>><%=(ii)%></option><%
				next
			%>
            </select></fieldset>
            <div class="clear"></div>
            
            

        </div>
		<hr/>
        <% 
		end if
		if strConfigMode = "navigation" or strConfigMode = "full" then 
		%>        
		<div class="help-switch"><a href="javascript:switchDisplay('help-jsactive');"><img src="<%=getImagePath("lay-adm-ico-act-help.gif")%>" alt="Aiuto" /></a></div>
		<h3>Navigazione animata</h3>
		<div class="help-box"><div class="help" id="help-jsactive">se attivata, la navigazione animata, propone all'utente un sistema di visualizzazione e scorrimento delle foto animato che utilizza javascript per l'esecuzione.<br />
		l'effetto animato &egrave; piacevole ed elegante ed evita di visualizzare molte pagine per scorrere le foto, facendo risparmiare tempo all'utente e banda al server.<br />
		nel caso in cui venga attivata la navigazione animata essa verr&agrave; utilizzata da tutti i browser che consentono l'esecuzione di codice javascript, in caso contrario visualizza la versione statica, mantenendo quindi compatibilit&agrave; con tutti i browser.</div></div>
		<div><label for="jsactive">navigazione animata via javascript</label>
		<select id="jsactive" name="jsactive">
			<option value="1"<% if config__jsactive__ then %> selected="selected"<% end if %>>navigazione animata attiva</option>
			<option value="0"<% if not config__jsactive__ then %> selected="selected"<% end if %>>navigazione animata non attiva</option>
		</select></div>
				
		<hr/>  
        
		<div class="help-switch"><a href="javascript:switchDisplay('help-jsnavigatoractive');"><img src="<%=getImagePath("lay-adm-ico-act-help.gif")%>" alt="Aiuto" /></a></div>
		<h3>Pannello di navigazione</h3>
		<div class="help-box"><div class="help" id="help-jsnavigatoractive">se attivo (solo se attiva anche la navigazione animata) visualizza un pannello a scomparsa nella pagina principale che permette la navigazione delle categorie (tag e set) in maniera interattiva.</div></div>
		<div><label for="jsnavigatoractive">pannello di navigazione via javascript</label>
		<select id="jsnavigatoractive" name="jsnavigatoractive">
			<option value="1"<% if config__jsnavigatoractive__ then %> selected="selected"<% end if %>>pannello di navigazione attivo</option>
			<option value="0"<% if not config__jsnavigatoractive__ then %> selected="selected"<% end if %>>pannello di navigazione non attivo</option>
		</select></div>
				
		<hr/>
		
		<div class="help-switch"><a href="javascript:switchDisplay('help-exifactive');"><img src="<%=getImagePath("lay-adm-ico-act-help.gif")%>" alt="Aiuto" /></a></div>
		<h3>Visualizzazione exif</h3>
		<div class="help-box"><div class="help" id="help-exifactive">gli exif sono alcune informazioni sulle fotografie (quali tempi, focali, data di scatto etc.) che le macchine fotografiche digitali inseriscono automaticamente nelle foto scattate<br />
		carnival, se l'opzione &egrave; attiva, permette di visualizzare questi dati nei dettagli delle singole foto in maniera completamente automatica</div></div>
		<div><label for="exifactive">visualizza exif nei dettagli</label>
		<select id="exifactive" name="exifactive">
			<option value="1"<% if config__exifactive__ then %> selected="selected"<% end if %>>exif attivati</option>
			<option value="0"<% if not config__exifactive__ then %> selected="selected"<% end if %>>exif disattivati</option>
		</select></div>
				
		<hr/>
		
		<div class="help-switch"><a href="javascript:switchDisplay('help-mode');"><img src="<%=getImagePath("lay-adm-ico-act-help.gif")%>" alt="Aiuto" /></a></div>
		<h3>Modalit&agrave; Carnival</h3>
        <div class="help-box"><div class="help" id="help-mode">selezionare la modalit&agrave; di utilizzo di Carnival che pi&ugrave; si preferisce<br />
        <strong>blog</strong> la pagina di inizio è quella delle foto<br />
        <strong>galleria</strong> la pagina di inizio è quella dei set (galleria)<br/>
        <strong>photoblog puro</strong> nella galleria non vengono visualizzati i set</div></div>
		<div><label for="mode">modalit&agrave; carnival</label>
		<select id="mode" name="mode">
			<option value="0"<% if config__mode__ = 0 then %> selected="selected"<% end if %>>blog (photoblog)</option>
			<option value="1"<% if config__mode__ = 1 then %> selected="selected"<% end if %>>galleria (photogallery)</option>
			<option value="2"<% if config__mode__ = 2 then %> selected="selected"<% end if %>>blog (photoblog puro)</option>
		</select></div>
				
		<hr/>
        <% 
		end if
		if strConfigMode = "mail-component" or strConfigMode = "full" then 
		
		
		Dim objMailer,rstrMailComList(6,1),blnMailComAvailable,strMailComSelectTag,strMailComOutput
		blnMailComAvailable = 0
		strMailComSelectTag = ""
		Set objMailer = new SafeMailer
		rstrMailComList(0,0) = "CDO.Message" : 			rstrMailComList(0,1) = "CDOSYS"
		rstrMailComList(1,0) = "CDONTS.NewMail" : 		rstrMailComList(1,1) = "CDONTS"
		rstrMailComList(2,0) = "Jmail.smtpmail" : 		rstrMailComList(2,1) = "Jmail"
		rstrMailComList(3,0) = "SoftArtisans.SMTPMail" : rstrMailComList(3,1) = "SoftArtisans SMTPMail"
		rstrMailComList(4,0) = "Persits.MailSender" : 	rstrMailComList(4,1) = "AspEMail"
		rstrMailComList(5,0) = "IPWorksASP.SMTP" : 		rstrMailComList(5,1) = "IPWorks"
		rstrMailComList(6,0) = "SMTPsvg.Mailer" : 		rstrMailComList(6,1) = "AspMail"
		
		strMailComOutput = strMailComOutput & "<table style=""margin-top:10px;width:100%;"">" &  vbcrlf
		strMailComOutput = strMailComOutput & "<tr><td colspan=""2"" style=""font-weight:bold;text-align:right;"">Componenti SMTP supportati</td></tr>"
		
		dim ii
		for ii = 0 to Ubound(rstrMailComList)
			strMailComOutput = strMailComOutput & "<tr><td style=""width:120px;text-align:right;"">" & rstrMailComList(ii,1) & " <b>&raquo;</b></td><td>"
			if objMailer.IsComInstalled(rstrMailComList(ii,0)) then 
				blnMailComAvailable = blnMailComAvailable + 1
				strMailComSelectTag = strMailComSelectTag & "<option value=""" & rstrMailComList(ii,0) & """"
				if config__mail_component__ = rstrMailComList(ii,0) then strMailComSelectTag = strMailComSelectTag & " selected = ""selected"""
				strMailComSelectTag = strMailComSelectTag & ">" & rstrMailComList(ii,1) & "</option>" & vbcrlf
				strMailComOutput = strMailComOutput & "<span style=""color:green;font-weight:bold;"">installato</span>"
			else
				strMailComOutput = strMailComOutput & "<span style=""color:red;"">non installato</span>"
			end if 
			strMailComOutput = strMailComOutput & "</td></tr>" & vbcrlf
		next
		strMailComOutput = strMailComOutput & "</table>"
		
		if strMailComSelectTag = "" then strMailComSelectTag = "<option value="""">nessun componente installato</option>"
		
		%>
		<h3>Componente SMTP</h3>
        <div style="float:right;font-size:0.8em;"><%=strMailComOutput%></div>
		<small>Determina il componente utilizzato per l'invio di email.<br/>
		Normalmente Windows 2000 / 2003 / XP offrono CDOSYS preinstallato<br />
		Windows NT4 / 2000 offrono invece CDONTS.</small>
		<div>
        <label for="mailcomponent">componente per l'invio email</label>
		<select id="mailcomponent" name="mailcomponent">
			<%=strMailComSelectTag%>
		</select><div class="clear"></div></div>
				
		<hr/>
        
        <% if blnMailComAvailable = 0 then %>
    		<div class="infobox">impossibile utilizzare le funzioni di invio email<br/>nessun componente installato</div>
        <% else %>
        
		<div class="help-switch"><a href="javascript:switchDisplay('help-mail-host');"><img src="<%=getImagePath("lay-adm-ico-act-help.gif")%>" alt="Aiuto" /></a></div>
		<h3>Host</h3>
		<div class="help-box"><div class="help" id="help-mail-host">E' l'host del mail server (indirizzo logico o indirizzo IP)<br />
		Per molti componenti SMTP è necessario indicare l'host del mailserver.<br />
		es: localhost, 127.0.0.1<br />
		<small><strong>utilizzando CDONTS non è necessario indicare l'host</strong></small></div></div>
		<div><label for="mailhost">host server smtp</label>
		<input type="text" id="mailhost" name="mailhost" class="text" maxlength="100" value="<%=outputHTMLString(config__mail_host__)%>" /></div>
				
		<hr/>
        
		<div class="help-switch"><a href="javascript:switchDisplay('help-mail-port');"><img src="<%=getImagePath("lay-adm-ico-act-help.gif")%>" alt="Aiuto" /></a></div>
		<h3>Porta</h3>
		<div class="help-box"><div class="help" id="help-mail-port">E' la porta SMTP del mail server (di default la <strong>25</strong>) [ per non indicare alcuna porta utilizzare <strong>0</strong> ]
		Per molti componenti SMTP è necessario indicare l'host del mailserver.<br />
		<small><strong>utilizzando CDONTS non è necessario indicare l'host</strong></small></div></div>
		<div><label for="mailport">porta server smtp</label>
		<input type="text" id="mailport" name="mailport" class="text" maxlength="5" value="<%=config__mail_port__%>" /></div>
				
		<hr/>
        
		<div class="help-switch"><a href="javascript:switchDisplay('help-mail-user');"><img src="<%=getImagePath("lay-adm-ico-act-help.gif")%>" alt="Aiuto" /></a></div>
		<h3>Utente</h3>
		<div class="help-box"><div class="help" id="help-mail-user">E' l'username per l'autenticazione sul mail server<br />
		Se il mail server necessita di autenticazione per l'invio di email indicare qui il nome utente.</div></div>
		<div><label for="mailuser">utente server smtp</label>
		<input type="text" id="mailuser" name="mailuser" class="text" maxlength="50" value="<%=outputHTMLString(config__mail_user__)%>" /></div>
				
		<hr/>
        
		<div class="help-switch"><a href="javascript:switchDisplay('help-mail-password');"><img src="<%=getImagePath("lay-adm-ico-act-help.gif")%>" alt="Aiuto" /></a></div>
		<h3>Password</h3>
		<div class="help-box"><div class="help" id="help-mail-password">E' la password per l'autenticazione sul mail server<br />
		Se il mail server necessita di autenticazione per l'invio di email indicare qui la password.</div></div>
		<div><label for="mailpassword">password server smtp</label>
		<input type="password" id="mailpassword" name="mailpassword" class="text" maxlength="50" value="<% if (config__mail_password__ <> "") then response.write "imentecarnival"%>" /></div>
				
		<hr/>
        
		<div class="help-switch"><a href="javascript:switchDisplay('help-mail-ssl');"><img src="<%=getImagePath("lay-adm-ico-act-help.gif")%>" alt="Aiuto" /></a></div>
		<h3>Utilizza TSL/SSL</h3>
		<div class="help-box"><div class="help" id="help-mail-ssl">Il protocollo SSL è un meccanismo di invio protetto da crittazione; si rende necessario solo se il server richiede/supporta il protocollo.</div></div>
		<div><label for="mailssl">utilizza protocollo tsl/ssl per inviare mail</label>
		<select id="mailssl" name="mailssl">
			<option value="1"<% if config__mail_ssl__ = 1 then %> selected="selected"<% end if %>>attivo</option>
			<option value="0"<% if config__mail_ssl__ = 0 then %> selected="selected"<% end if %>>disattivo</option>
		</select></div>
				
		<hr/>
        
		<div class="help-switch"><a href="javascript:switchDisplay('help-mail-auth');"><img src="<%=getImagePath("lay-adm-ico-act-help.gif")%>" alt="Aiuto" /></a></div>
		<h3>Autenticazione</h3>
		<div class="help-box"><div class="help" id="help-mail-auth">La tipologia di autenticazione dipende direttamente dal server che si utilizza.</div></div>
		<div><label for="mailauth">meccanismo di autenticazione</label>
		<select id="mailauth" name="mailauth">
			<option value="0"<% if config__mail_auth__ = 0 then %> selected="selected"<% end if %>>accesso anonimo</option>
			<option value="1"<% if config__mail_auth__ = 1 then %> selected="selected"<% end if %>>autenticazione standard</option>
			<option value="2"<% if config__mail_auth__ = 2 then %> selected="selected"<% end if %>>autenticazione integrata</option>
		</select></div>
				
		<hr/>
        <% 
		   end if
		end if
		if strConfigMode = "mail-notifications" or strConfigMode = "full" then 
		%>
        
		<div class="help-switch"><a href="javascript:switchDisplay('help-mail-address');"><img src="<%=getImagePath("lay-adm-ico-act-help.gif")%>" alt="Aiuto" /></a></div>
		<h3>Indirizzo email</h3>
		<div class="help-box"><div class="help" id="help-mail-address">E' l'indirizzo a cui ti verranno recapitate le notifiche (indica il tuo indirizzo email personale)</div></div>
		<div><label for="mailpassword">indirizzo email personale</label>
		<input type="text" id="mailaddress" name="mailaddress" class="text" maxlength="100" value="<%=outputHTMLString(config__mail_address__)%>" /></div>
				
		<hr/>
        
		<div class="help-switch"><a href="javascript:switchDisplay('help-mail-percomment');"><img src="<%=getImagePath("lay-adm-ico-act-help.gif")%>" alt="Aiuto" /></a></div>
		<h3>Notifica commenti</h3>
		<div class="help-box"><div class="help" id="help-mail-percomment">Invio notifiche inserimento nuovi commenti via email.</div></div>
		<div><label for="mailpercomment">notifica nuovi commenti via email</label>
		<select id="mailpercomment" name="mailpercomment">
			<option value="1"<% if config__mail_percomment__ = 1 then %> selected="selected"<% end if %>>attivo</option>
			<option value="0"<% if config__mail_percomment__ = 0 then %> selected="selected"<% end if %>>disattivo</option>
		</select></div>
				
		<hr/>
        <% 
		end if
		if strConfigMode = "about" or strConfigMode = "full" then 
		%> 
		<div class="help-switch"><a href="javascript:switchDisplay('help-aboutpage');"><img src="<%=getImagePath("lay-adm-ico-act-help.gif")%>" alt="Aiuto" /></a></div>
		<h3>Pagina informazioni</h3>
		<div class="help-box"><div class="help" id="help-aboutpage">la pagina di about (informazioni) esiste al fine di offrire agli utenti informazioni circa l'autore del photoblog.<br />
		se si conosce l'html &egrave; possibile scrivere nel campo sottostante codice xhtml come si vuole, ricordando che la larghezza del &lt;div&gt; in cui verr&agrave; inserito questo codice &egrave; di circa 700px; al contrario se non si conosce l'html &egrave; comunque possibile scrivere del testo non formattato.<br />
		<small>(in ogni caso ricordare che per andare a capo è necessario usare il tag &lt;br/&gt;)</small></div></div>
		<div><label for="aboutpage">pagina di about</label>
		<textarea cols="20" rows="20" name="aboutpage" id="aboutpage"><%=outputHTMLString(strAboutContent)%></textarea></div>
				
		<hr/>
		
		<div class="help-switch"><a href="javascript:switchDisplay('help-parent');"><img src="<%=getImagePath("lay-adm-ico-act-help.gif")%>" alt="Aiuto" /></a></div>
		<h3>Pagina Home</h3>
		<div class="help-box"><div class="help" id="help-parent">se il photoblog &egrave; solo una parte del tuo sito, indica qui l'url alla home (nella forma <strong>http://www.miosito.it</strong>).<br/>(<strong>Attenzione:</strong> indicando un url in questo campo il link alla pagina di about non verr&agrave; visualizzato; lasciare il campo vuoto per visualizzarlo nuovamente)</div></div>
		<div><label for="parent">url alla home page (<span style="color:red;">se indicato esclude la visualizzazione della pagina di about</span>)</label>
		<input type="text" id="parent" name="parent" class="text" maxlength="250" value="<%=outputHTMLString(config__parent__)%>" /></div>
		
		<hr/>
        <% 
		end if
		if strConfigMode = "code" or strConfigMode = "full" then 
		%> 
		<div class="help-switch"><a href="javascript:switchDisplay('help-headadd');"><img src="<%=getImagePath("lay-adm-ico-act-help.gif")%>" alt="Aiuto" /></a></div>
		<h3>Headadd</h3>
		<div class="help-box"><div class="help" id="help-headadd">l'headadd rappresenta del codice html che viene inserito all'interno della HEAD del documento html.<br/>
		pu&ograve; essere utilizzato per inserire tag javascript o css.<br />
		se non si ha idea di cosa rappresenti la HEAD di un documento html si consiglia di lasciare vuoto questo campo</div></div>
		<div><label for="headadd">head add</label>
		<textarea cols="20" rows="20" name="headadd" id="headadd"><%=outputHTMLString(config__headadd__)%></textarea></div>
		
		<hr/>
		
		<div class="help-switch"><a href="javascript:switchDisplay('help-bodyadd');"><img src="<%=getImagePath("lay-adm-ico-act-help.gif")%>" alt="Aiuto" /></a></div>
		<h3>Bodyadd</h3>
		<div class="help-box"><div class="help" id="help-bodyadd">il bodyadd rappresenta del codice html che viene inserito all'interno del BODY del documento html.<br/>
		viene solitamente utilizzato per inserire div aggiuntivi.<br />
		se non si ha idea di cosa rappresenti il BODY di un documento html si consiglia di lasciare vuoto questo campo</div></div>
		<div><label for="bodyadd">head add</label>
		<textarea cols="20" rows="20" name="bodyadd" id="bodyadd"><%=outputHTMLString(config__bodyadd__)%></textarea></div>
		<div><label for="bodyaddwhere">posizione bodyadd</label>
		<select id="bodyaddwhere" name="bodyaddwhere">
			<option value="0"<% if config__bodyaddwhere__ = 0 then %> selected="selected"<% end if %>>inserisci il codice all'inizio del &lt;body&gt;</option>
			<option value="1"<% if config__bodyaddwhere__ = 1 then %> selected="selected"<% end if %>>inserisci il codice alla fine del &lt;body&gt;</option>
		</select></div>
				
		<hr/>
        <% 
		end if
		if strConfigMode = "password" or strConfigMode = "full" then 
		%> 
		<div class="help-switch"><a href="javascript:switchDisplay('help-password');"><img src="<%=getImagePath("lay-adm-ico-act-help.gif")%>" alt="Aiuto" /></a></div>
		<h3>Modifica password</h3>
		<div class="help-box"><div class="help" id="help-password">la modifica password viene effettuata solo se i due campi vengono valorizzati<br />
		per modificare la password di amministrazione &egrave; necessario indicare la password corrente e una nuova password<br />
		se modificata, la password sar&agrave; attiva dal successivo login</div></div>
		<div><label for="password">password corrente (lasciare vuoto il campo se non si vuole modificare)</label>
		<input type="text" id="password" name="password" class="text" maxlength="32" value="" /></div>
		<div><label for="newpassword">nuova password</label>
		<input type="text" id="newpassword" name="newpassword" class="text" maxlength="32" value="" /></div>
        
		<hr/>
        <% end if %>
		<div class="nbuttons">
			<a href="admin.asp">
				<span>
				<img src="<%=getImagePath("lay-adm-ico-but-prev.gif")%>" alt=""/> 
				indietro
				</span>
			</a><%
			if strConfigMode = "about" then %>
			<button type="button" onclick="$('configform').action='about.asp';$('configform').submit()">
				<span class="a"><span class="b">
				<img src="<%=getImagePath("lay-adm-ico-act-preview.gif")%>" alt=""/> 
				anteprima
				</span></span>
			</button><%
			elseif strConfigMode = "mail-component" then %>
			<button type="submit" name="mailtest" id="mailtest" value="1">
				<span class="a"><span class="b">
				<img src="<%=getImagePath("lay-adm-ico-but-next.gif")%>" alt=""/> 
				invia mail di test
				</span></span>
			</button>
            <%
			end if %>
			<button type="submit"<% if strConfigMode = "about" then %> onclick="$('configform').action='admin.asp?module=pro-config'"<% end if %>>
				<span class="a"><span class="b">
				<img src="<%=getImagePath("lay-adm-ico-but-accept.gif")%>" alt=""/> 
				salva
				</span></span>
			</button>
		</div>
	</form>
	
	<script type="text/javascript">/*<![CDATA[*/
	hideElementsByClass('help',0);
	/*]]>*/</script>
	