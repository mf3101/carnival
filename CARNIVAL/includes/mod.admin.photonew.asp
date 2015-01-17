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
' * @version         SVN: $Id: mod.admin.photonew.asp 114 2010-10-11 19:00:34Z imente $
' * @home            http://www.carnivals.it
'-----------------------------------------------------------------

'*****************************************************
'ENVIROMENT AGGIUNTIVO
%><!--#include file = "inc.admin.check.asp"--><%
'***************************************************** %>
<h2>Nuova foto</h2>
	<img src="<%=getImagePath("lay-adm-wizard-new.png")%>" alt="" class="wizard" />
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
				<img src="<%=getImagePath("lay-adm-ico-but-new.gif")%>" alt=""/> 
				crea post
				</span>
			</a>
			<a href="admin.asp">
				<span>
				<img src="<%=getImagePath("lay-adm-ico-but-prev.gif")%>" alt=""/> 
				indietro
				</span>
			</a>
		</div>
		</div>
	</div>
	<div class="clear"></div>