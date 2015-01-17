<!--#include file = "inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		mod.admin.config.asp 0 20080312120000
' </IVT>
'
'  >>> QUESTO FILE E' PARTE INTEGRANTE DEL PACCHETTO "CARNIVAL"
'  >>> E' possibile utilizzare, modificare e ridistribuire CARNIVAL
'  >>> liberamente a patto che si mantenga la licenza originale e
'  >>> che non venga utilizzato per scopi commerciali.
'  >>> L'applicazione è inoltre distribuita senza alcun tipo di garanzia.
'
'-----------------------------------------------------------------
%><!--#include file = "inc.admin.check.asp"--><%
dim crnAboutContent
SQL = "SELECT config_aboutpage FROM tba_config WHERE config_id = 1"
set rs = conn.execute(SQL)
crnAboutContent = rs("config_aboutpage")
%>
	<h2>Configurazione</h2>
	<div class="clear"></div>
	<form action="admin.asp?module=pro-config" method="post" class="config">
		
		<hr/>
	
		<div class="help-switch"><a href="javascript:switchDisplay('help-title');"><img src="<%=carnival_pathimages%>lay-adm-ico-act-help.gif" alt="Aiuto" /></a></div>
		<h3>Titolo photoblog</h3>
		<div class="help" id="help-title">il titolo viene visualizzato nel nome della pagina, nel meta-tag TITLE e, s non viene utilizzato un logo, nella parte alta della pagina.<br />
		si consiglia di utilizzare un titolo breve di non più di venti caratteri</div>
		<div><label for="title">titolo</label>
		<input type="text" id="title" name="title" class="text" maxlength="50" value="<%=cleanOutputString(carnival_title)%>" /></div>
		
		<hr/>
		
		<div class="help-switch"><a href="javascript:switchDisplay('help-description');"><img src="<%=carnival_pathimages%>lay-adm-ico-act-help.gif" alt="Aiuto" /></a></div>
		<h3>Descrizione photoblog</h3>
		<div class="help" id="help-description">la descrizione &egrave; un breve testo (non più di 250 caratteri) che viene inserito nel meta-tag DESCRIPTION.</div>
		<div><label for="description">descrizione</label>
		<input type="text" id="description" name="description" class="text" maxlength="250" value="<%=cleanOutputString(carnival_description)%>" /></div>
		
		<hr/>
		
		<div class="help-switch"><a href="javascript:switchDisplay('help-author');"><img src="<%=carnival_pathimages%>lay-adm-ico-act-help.gif" alt="Aiuto" /></a></div>
		<h3>Autore</h3>
		<div class="help" id="help-author">il nome dell'autore o degli autori delle fotografie viene inserito nel meta-tag AUTHOR. (se si indicano più autori separarli con una virgola)</div>
		<div><label for="author">autore</label>
		<input type="text" id="author" name="author" class="text" maxlength="50" value="<%=cleanOutputString(carnival_author)%>" /></div>
		
		<hr/>
		
		<div class="help-switch"><a href="javascript:switchDisplay('help-copyright');"><img src="<%=carnival_pathimages%>lay-adm-ico-act-help.gif" alt="Aiuto" /></a></div>
		<h3>Copyright</h3>
		<div class="help" id="help-copyright">il copyright viene inserito nel meta-tag COPYRIGHT e si indica in formato &quot;<em>(C) data autore</em>&quot;</div>
		<div><label for="copyright">copyright</label>
		<input type="text" id="copyright" name="copyright" class="text" maxlength="100" value="<%=cleanOutputString(carnival_copyright)%>" /></div>
		
		<hr/>
		
		<div class="help-switch"><a href="javascript:switchDisplay('help-headadd');"><img src="<%=carnival_pathimages%>lay-adm-ico-act-help.gif" alt="Aiuto" /></a></div>
		<h3>Headadd</h3>
		<div class="help" id="help-headadd">l'headadd rappresenta del codice html che viene inserito all'interno della HEAD del documento html.<br/>
		pu&ograve; essere utilizzato per inserire tag javascript o css.<br />
		se non si ha idea di cosa rappresenti la HEAD di un documento html si consiglia di lasciare vuoto questo campo</div>
		<div><label for="headadd">head add</label>
		<textarea cols="20" rows="20" name="headadd" id="headadd"><%=cleanOutputString(carnival_headadd)%></textarea></div>
		
		<hr/>
		
		<div class="help-switch"><a href="javascript:switchDisplay('help-bodyadd');"><img src="<%=carnival_pathimages%>lay-adm-ico-act-help.gif" alt="Aiuto" /></a></div>
		<h3>Bodyadd</h3>
		<div class="help" id="help-bodyadd">il bodyadd rappresenta del codice html che viene inserito all'interno del BODY del documento html.<br/>
		viene solitamente utilizzato per inserire div aggiuntivi.<br />
		se non si ha idea di cosa rappresenti il BODY di un documento html si consiglia di lasciare vuoto questo campo</div>
		<div><label for="bodyadd">head add</label>
		<textarea cols="20" rows="20" name="bodyadd" id="bodyadd"><%=cleanOutputString(carnival_bodyadd)%></textarea></div>
		<div><label for="bodyaddwhere">posizione bodyadd</label>
		<select id="bodyaddwhere" name="bodyaddwhere">
			<option value="0"<% if carnival_bodyaddwhere = 0 then %> selected="selected"<% end if %>>inserisci il codice all'inizio del &lt;body&gt;</option>
			<option value="1"<% if carnival_bodyaddwhere = 1 then %> selected="selected"<% end if %>>inserisci il codice alla fine del &lt;body&gt;</option>
		</select></div>
				
		<hr/>
		
		<div class="help-switch"><a href="javascript:switchDisplay('help-jsactive');"><img src="<%=carnival_pathimages%>lay-adm-ico-act-help.gif" alt="Aiuto" /></a></div>
		<h3>Navigazione animata</h3>
		<div class="help" id="help-jsactive">se attivata, la navigazione animata, propone all'utente un sistema di visualizzazione e scorrimento delle foto animato che utilizza javascript per l'esecuzione.<br />
		l'effetto animato &egrave; piacevole ed elegante ed evita di visualizzare molte pagine per scorrere le foto, facendo risparmiare tempo all'utente e banda al server.<br />
		nel caso in cui venga attivata la navigazione animata essa verr&agrave; utilizzata da tutti i browser che consentono l'esecuzione di codice javascript, in caso contrario visualizza la versione statica, mantenendo quindi compatibilit&agrave; con tutti i browser.</div>
		<div><label for="jsactive">navigazione animata via javascript</label>
		<select id="jsactive" name="jsactive">
			<option value="1"<% if carnival_jsactive then %> selected="selected"<% end if %>>navigazione animata attiva</option>
			<option value="0"<% if not carnival_jsactive then %> selected="selected"<% end if %>>navigazione animata non attiva</option>
		</select></div>
				
		<hr/>
		
		<div class="help-switch"><a href="javascript:switchDisplay('help-exifactive');"><img src="<%=carnival_pathimages%>lay-adm-ico-act-help.gif" alt="Aiuto" /></a></div>
		<h3>Visualizzazione exif</h3>
		<div class="help" id="help-exifactive">gli exif sono alcune informazioni sulle fotografie (quali tempi, focali, data di scatto etc.) che le macchine fotografiche digitali inseriscono automaticamente nelle foto scattate<br />
		carnival, se l'opzione &egrave; attiva, permette di visualizzare questi dati nei dettagli delle singole foto in maniera completamente automatica</div>
		<div><label for="exifactive">visualizza exif nei dettagli</label>
		<select id="exifactive" name="exifactive">
			<option value="1"<% if carnival_exifactive then %> selected="selected"<% end if %>>exif attivati</option>
			<option value="0"<% if not carnival_exifactive then %> selected="selected"<% end if %>>exif disattivati</option>
		</select></div>
				
		<hr/>
		
		<div class="help-switch"><a href="javascript:switchDisplay('help-aboutpage');"><img src="<%=carnival_pathimages%>lay-adm-ico-act-help.gif" alt="Aiuto" /></a></div>
		<h3>Pagina informazioni</h3>
		<div class="help" id="help-aboutpage">la pagina di about (informazioni) esiste al fine di offrire agli utenti informazioni circa l'autore del photoblog.<br />
		se si conosce l'html &egrave; possibile scrivere nel campo sottostante codice xhtml come si vuole, ricordando che la larghezza del &lt;div&gt; in cui verr&agrave; inserito questo codice &egrave; di circa 700px; al contrario se non si conosce l'html &egrave; comunque possibile scrivere del testo non formattato.<br />
		<small>(in ogni caso ricordare che per andare a capo è necessario usare il tag &lt;br/&gt;)</small></div>
		<div><label for="aboutpage">pagina di about</label>
		<textarea cols="20" rows="20" name="aboutpage" id="aboutpage"><%=cleanOutputString(crnAboutContent)%></textarea></div>
				
		<hr/>
		
		<div class="help-switch"><a href="javascript:switchDisplay('help-password');"><img src="<%=carnival_pathimages%>lay-adm-ico-act-help.gif" alt="Aiuto" /></a></div>
		<h3>Modifica password</h3>
		<div class="help" id="help-password">la modifica password viene effettuata solo se i due campi vengono valorizzati<br />
		per modificare la password di amministrazione &egrave; necessario indicare la password corrente e una nuova password<br />
		se modificata, la password sar&agrave; attiva dal successivo login</div>
		<div><label for="password">password corrente (lasciare vuoto il campo se non si vuole modificare)</label>
		<input type="text" id="password" name="password" class="text" maxlength="32" value="" /></div>
		<div><label for="newpassword">nuova password</label>
		<input type="text" id="newpassword" name="newpassword" class="text" maxlength="32" value="" /></div>
		
		<div class="nbuttons">
			<a href="admin.asp">
				<span>
				<img src="<%=carnival_pathimages%>/lay-adm-ico-but-prev.gif" alt=""/> 
				indietro
				</span>
			</a>
			<button type="submit">
				<span class="a"><span class="b">
				<img src="<%=carnival_pathimages%>/lay-adm-ico-but-accept.gif" alt=""/> 
				salva
				</span></span>
			</button>
		</div>
	</form>
	
	<script type="text/javascript">/*<![CDATA[*/
	hideElementsByClass('help',0);
	/*]]>*/</script>
	