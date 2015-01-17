<!--#include file = "inc.first.asp"--><%
'-----------------------------------------------------------------
' <IVT>
' IVT@package		Carnival
' IVT@packver		1.0b.0 <20080312>
' IVT@author		Simone Cingano <simonecingano@imente.org>
' IVT@copyright		(c) 2008 Simone Cingano
' IVT@licence		GNU GPL v2 <http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>
' IVT@version		mod.admin.photonew.asp 0 20080312120000
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
<% crnPhotoId = request.QueryString("id") %>
<h2>Nuovo post</h2>
	<img src="<%=carnival_pathimages%>lay-adm-wizard-new.png" alt="" class="wizard" />
	<div class="wizard">
		<p>Proseguendo verr&agrave; creato un <strong>nuovo post</strong> che non verr&agrave; visualizzato ai visitatori del photoblog fino al termine della procedura di creazione.</p>
		<p>Inizialmente verr&agrave; richiesto di <strong>caricare la foto</strong> originale collegata al post e di crearne (o caricarne) la versione da visualizzare sul photoblog e la miniatura.</p>
		<p>Al termine della procedura di upload verr&agrave; poi proposta una pagina dove sar&agrave; possibile <strong>dare un titolo, una descrizione e altre opzioni</strong> al post.</p>
		<p>Se, per un qualsiasi motivo, la procedura non andasse a buon fine, sar&agrave; possibile modificare il post dalla pagina di &quot;modifica post&quot; raggiungibile tramite la pagina di amministrazione caricando nuove immagini o modificandone le opzioni, compresa la visualizzazione sul photoblog</p>
		<p><em>Per iniziare la procedura di creazione del post clicca su &quot;crea post&quot;</em></p>
		<div class="cnbuttons">
		<div class="nbuttons">
			<a href="admin.asp?module=pro-photo-edit&amp;action=new">
				<span>
				<img src="<%=carnival_pathimages%>lay-adm-ico-but-new.gif" alt=""/> 
				crea post
				</span>
			</a>
			<a href="admin.asp">
				<span>
				<img src="<%=carnival_pathimages%>/lay-adm-ico-but-prev.gif" alt=""/> 
				indietro
				</span>
			</a>
		</div>
		</div>
	</div>
	<div class="clear"></div>