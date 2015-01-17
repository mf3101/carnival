/***************************************************************
 *	CARNIVAL CORE 1.0
 *	developed by Simone Cingano (http://www.imente.it)
 ***************************************************************/

/***************************************************************
 VARIABILI DI APPLICAZIONE
 ***************************************************************/

//variabili di applicazione
var coreversion = "1.0"

var photoIdPrev = Number(0); 	var photoTitlePrev = String(''); 
var photoPubPrev = String(''); 	var photoSrcPrev = String('');
var photoId = Number(0); 		var photoTitle = String('');
var photoPub = String(''); 		var photoSrc = String('');
var photoIdNext = Number(0); 	var photoTitleNext = String('');
var photoPubNext = String(''); 	var photoSrcNext = String('');



var s_type = String('');

var arrayPageSize;

var postopimage = 0;

var xmlDoc;
var loadedinfo_det = -1;
var loadedinfo_com = -1;
var transimage = false;
var slideshowactiveflag = false;
var slideshowstart = -1;
var slideshowview = 0;
var slideshowactive = 0;

var photoWidth = 640;
var photoHeight = 480;

//opzioni
var slideshowfirsttime = 1500;
var slideshowtime = 8000;
var loadwidth = 100;
var loadheight = 100;
var xmlUrl = 'service.xml.photo.asp';

var nextBaloon;
var prevBaloon;
var tagcloudBaloon;

//id corrente
var currentimage = -1;



/***************************************************************
 FUNZIONI UTILI
 ***************************************************************/
 
/*** crea un valore univoco da inserire in una richiesta al fine
     di evitare il chaching *///
function getNoCacheId() { var d = new Date(); return d.getTime(); }

/*** preloader per immagini ***/
function preloadImage(image) { var i = new Image(); i.src = image; }

/*** imposta le initinfo ***/
function setInitInfo(info) { Element.setInnerHTML('initinfo',info); }

/*** modifica l'src di una immagine (fix per ie nel cambio src) ***/
function changeSrc(id,src) {
	if (is_ie_max6) {
		var replace = document.createElement('img');
		var parent = $(id).parentElement;
		var node = replace.cloneNode(true);
		node.id = id; node.src = src; node.alt = parent.firstChild.alt;
		parent.replaceChild(node,parent.firstChild);
	} else {
		$(id).src = src;
	}
}



/***************************************************************
 INIZIALIZZAZIONE CARNIVAL
 ***************************************************************/
	
/*** inizializzazione ***/
function initCarnival() {
	
	setInitInfo('- Carnival '+coreversion+'-');
	
	//controlla se è accettato il getElementByTagName
	if (!document.getElementsByTagName){ return false; }
	
	// tutte le <a> con rel="carnival" vengono modificate
	/*var anchors = document.getElementsByTagName('a');
	for (var i=0; i<anchors.length; i++){
		var anchor = anchors[i];
		var anchorRel = anchor.getAttribute('rel');
		if (anchorRel) if (anchorRel.toLowerCase().match('carnival')) anchor.href='javascript:;';
	}*/
	
	//modifica il DOM
	setInitInfo('1/4 editing DOM...');
	editDom();
	
	//carica l'xml ( che eseguirà al termine la funzione startCarnival() )
	loadXML(selected,tag,'start');
}

/*** inizializzazione ***/
function startCarnival() {
	
	//precarica le immagini necessarie
	preloadImage(pathimages+'lay-photo-nav-slideshow-on.gif');
	preloadImage(pathimages+'lay-photo-but-det-over.gif');
	preloadImage(pathimages+'lay-photo-but-det-over-s.gif');
	preloadImage(pathimages+'lay-photo-but-com-over.gif');
	preloadImage(pathimages+'lay-photo-but-com-over-s.gif');
	
	//nasconde tutti gli oggetti nell'overlay della foto
	Element.hide('photo-info');
	Element.hide('photo-overlay');
	Element.hide('photo-overlay-details');
	Element.hide('photo-overlay-comments');
	Element.hide('photo-overlay-buttons');
	Element.hide('photo-overlay-open');
	Element.hide('photo-loading');
	
	setInitInfo('3/4 loading photo...');
	
	imgPreloader = new Image();
	imgPreloader.onload=function() {
		//ridimensiona la box secondo le dimensioni dell'immagine
		photoWidth = imgPreloader.width; photoHeight = imgPreloader.height;
		resizeInfo(photoWidth,photoHeight);
		resizeImageBox(photoWidth,photoHeight);
		
		//termina l'inizializzazione
		end_init()
	}
	imgPreloader.onerror=function() {
		Element.hide('photo-loading');
		Element.setSrc('photo-img', pathimages+'lay-photo-error.jpg');
		photoWidth = 640; photoHeight = 480;
		resizeInfo(photoWidth,photoHeight);
		resizeImageBox(photoWidth,photoHeight);
		
		//termina l'inizializzazione
		end_init()
	}
	imgPreloader.src = photoSrc;
	
}

function end_init() {
	
	setInitInfo('start!');
	
	//end	
	Element.show('container');
	Element.hide('init');
	
	//toglie overlay senza transizione
	Element.hide('overlay');
	//toglie overlay con transizione
	//Element.fxOpacity('overlay',{ 'duration': 500, 'onComplete': function() { Element.hide('overlay'); } },1).custom(1,0);
	
	//posiziona i baloon
	resizeWin();
	posBaloon();
}



/***************************************************************
 GESTIONE XML
 ***************************************************************/
	
function loadXML(id,tag,type) {
	
	if (type == 'start') setInitInfo('2/4 loading xml...');
	xmlDoc = false;
	if (window.XMLHttpRequest) { // Mozilla, Safari,...
		xmlDoc = new XMLHttpRequest();
		if (xmlDoc.overrideMimeType) { xmlDoc.overrideMimeType('text/xml'); }
	} else if (window.ActiveXObject) { // IE
		try { xmlDoc = new ActiveXObject("Msxml2.XMLHTTP"); } catch (e) {
			try { xmlDoc = new ActiveXObject("Microsoft.XMLHTTP"); } catch (e) {}
		}
	}
	if (!xmlDoc) {
		alert('ERRORE: impossibile istanziare xmlhttp');
		return false;
	}
	s_type = type;
	xmlDoc.onreadystatechange = function() { parseXML(); }
	xmlDoc.open("GET", xmlUrl+"?id="+String(id)+"&tag="+String(tag), true);
    xmlDoc.send('');
	
}

function parseXML(){
	if (xmlDoc.readyState == 4) {
		if (xmlDoc.status == 200) {
			
			
			var xmlobj = xmlDoc.responseXML.documentElement;
			
			//struttura fissa (3 blocchi)
			
			photoIdPrev = Number(xmlobj.childNodes[0].childNodes[0].firstChild.data);
			photoTitlePrev = String(xmlobj.childNodes[0].childNodes[1].firstChild.data);
			photoSrcPrev = String(xmlobj.childNodes[0].childNodes[2].firstChild.data);
			photoPubPrev = String(xmlobj.childNodes[0].childNodes[3].firstChild.data);
			
			photoId = Number(xmlobj.childNodes[1].childNodes[0].firstChild.data);
			photoTitle = String(xmlobj.childNodes[1].childNodes[1].firstChild.data);
			photoSrc = String(xmlobj.childNodes[1].childNodes[2].firstChild.data);
			photoPub = String(xmlobj.childNodes[1].childNodes[3].firstChild.data);
			
			photoIdNext = Number(xmlobj.childNodes[2].childNodes[0].firstChild.data);
			photoTitleNext = String(xmlobj.childNodes[2].childNodes[1].firstChild.data);
			photoSrcNext = String(xmlobj.childNodes[2].childNodes[2].firstChild.data);
			photoPubNext = String(xmlobj.childNodes[2].childNodes[3].firstChild.data);
			
			switch (s_type) {
				case 'next': case 'prev':
					closeBox();
					break;
				case 'start':
					if (baloons) {
						Element.setSrc('baloonnextimg', photoSrcNext);
						Element.setSrc('baloonprevimg', photoSrcPrev);
					}
					startCarnival();
					break;
			}
			
		} else alert('ERRORE: impossibile caricare \''+xmlUrl+'\'');
		
		xmlobj = null;
		xmlDoc = null;
	}
}

/***************************************************************
 MODIFICA DOM
 ***************************************************************/

function editDom() {	
	
	//re-id
	Element.setAttribute('photo-box-nojs','id','photo-box');
	Element.setAttribute('photo-img-nojs','id','photo-img');
	Element.setAttribute('photo-header-nojs','id','photo-header');
	Element.setAttribute('photo-nav-nojs','id','photo-nav');
	
	//***** BOTTONI OVERLAY
	
	//#photo-overlay-open > a > img
	$('photo-overlay-open').appendChild(createA('','javascript:;','showOverlayContent(\'details\',0);','')).appendChild(createImg('',pathimages+'lay-photo-but-det-show.gif',lang_details));
	
	//#photo-overlay-open > a > img
	$('photo-overlay-open').appendChild(createA('','javascript:;','showOverlayContent(\'comments\',0);','')).appendChild(createImg('',pathimages+'lay-photo-but-com-show.gif',lang_comments));
	
	//#photo-box > #photo-loading
	$('photo-box').appendChild(createDiv('photo-loading'));
	//#photo-loading > img
	$('photo-loading').appendChild(createImg('l',pathimages+'lay-loading-photo.gif','photo-loading'));
	
	//#photo-slideshow > div#photo-slideshow-box > a > img#slideshowimg
	$('photo-slideshow').appendChild(createDiv('photo-slideshow-box')).appendChild(createA('','javascript:;','slideshow();','')).appendChild(createImg('slideshowimg',pathimages+'lay-photo-nav-slideshow-off.gif',''));
	
	
	//***** BOTTONI OVERLAY
	
	//#photo-overlay-buttons > div#photo-buttons
	$('photo-overlay-buttons').appendChild(createDiv('photo-buttons'));
	
	//div#photo-buttons > a#button-close > img
	$('photo-buttons').appendChild(createA('button-close','javascript:;','hideOverlayContent();',lang_close)).appendChild(createImg('but_close',pathimages+'lay-photo-but-close.gif',lang_close));
	
	//div#photo-buttons > a > img
	$('photo-buttons').appendChild(createA('button-details','javascript:;','showOverlayContent(\'details\',0);',lang_details)).appendChild(createImg('but_details','',lang_details));
	//changeSrc('but_details',pathimages+'lay-photo-but-det-over.gif');
	
	//div#photo-buttons > a > img
	$('photo-buttons').appendChild(createA('button-comments','javascript:;','showOverlayContent(\'comments\',0);',lang_comments)).appendChild(createImg('but_comments','',lang_comments));
	//changeSrc('but_details',pathimages+'lay-photo-but-com-over.gif');
	
	
	//***** BALOONS
	
	if (baloons) {
		nextBaloon = new Baloon();
		prevBaloon = new Baloon();
		tagcloudBaloon = new Baloon();
		
		//next thumb baloon
		nextBaloon.start('next','nextBaloon','next',null,'',0,0,false);
		$('baloonnextcontent').appendChild(createImg('baloonnextimg','','next'));
		
		//prev thumb baloon
		prevBaloon.start('prev','prevBaloon','prev',null,'',0,0,false);
		$('baloonprevcontent').appendChild(createImg('baloonprevimg','','prev'));
		
		
		//tagcloud baloon
		var tagcloudBaloonShow = 'tagcloudBaloon.show(\'relative\','+(is_ie?'window.event.clientX':'event.clientX')+',35);';
		tagcloudBaloon.start('tagcloud','tagcloudBaloon','cloudshow',function(event) {eval(tagcloudBaloonShow);},'balooncloud',0,-100,true);
		ahah('inner.tagcloud.asp?top=15',
			 'baloontagcloudcontent',
			 '',
			 '<div class="loading"><img src="'+pathimages+'lay-loading-bar.gif" alt="loading..." class="loading" /><br/>loading clouds...</div>',
			 '',
			 '');
	
	}
	
	//***** CALLER E RIDEFINIZIONI
	
	//photo overlay caller
	Element.setAttribute('photo','onmouseout','overlayButtons(\'hide\');');
	Element.setAttribute('photo','onmousemove','overlayButtons(\'show\');');
	Element.setAttribute('photo-overlay-open','onmouseover','overlayButtons(\'show\');');
	Element.setAttribute('photo-overlay-open','onmouseout','overlayButtons(\'hide\');');
	
	Element.setAttribute('commentsshow','href','comments.asp');
	Element.setInnerHTML('commentsshow',lang_comments);
	
	Element.setAttribute('previmg','src',pathimages+'lay-photo-nav-prev.gif');
	Element.setAttribute('nextimg','src',pathimages+'lay-photo-nav-next.gif');
	
	//***** SAFARI BUGFIX
	if (is_safari) {
		$('photo-overlay-details').style.overflow = 'visible';
		$('photo-overlay-details').style.backgroundColor = '#000';
		$('photo-overlay-details').style.height = '';
		$('photo-overlay-comments').style.overflow = 'visible';
		$('photo-overlay-comments').style.backgroundColor = '#000';
		$('photo-overlay-comments').style.height = '';
	}

}



/***************************************************************
 PHOTO OVERLAY
 ***************************************************************/
 
/*** gestisce la visualizzazione dei bottoni in overlay ("dettagli" e "commenti") ***/
function overlayButtons(action) {
	if (action == 'show') {
		//visualizza i bottoni in overlay
		if (!(slideshowactiveflag) && !(transimage)) Element.show('photo-overlay-open');
	} else {
		//nasconde i bottoni in overlay
		Element.hide('photo-overlay-open');
	}
}

/*** gestione contenuti nell'overlay (scheda "dettagli" e scheda "commenti" ***/
									  
function hideOverlayContent() {
	//nasconde tutte le schede e l'overlay di sfondo semi-trasparente
	if (Element.isVisible('photo-overlay')) {
		Element.fxOpacity('photo-overlay', { 'duration': 500,
											 'transition': fx.quadOut,
											 'onComplete':function(){ Element.hide('photo-overlay'); }
										   },0.7).custom(0.7,0);
		Element.hide('photo-overlay-details');
		Element.hide('photo-overlay-comments');
		Element.hide('photo-overlay-buttons');
	}
}

function showOverlayContent(what,showall) {
	//visualizza la scheda richiesta
	
	//carica la pagina dei contenuti (dettagli o commenti)
	loadOverlayContent(what,showall);
	if (!(Element.isVisible('photo-overlay'))) {
		//se lo sfondo semi-trasparente non è visibile lo rende visibile (nessuna scheda aperta)
		if (!is_safari) Element.fxOpacity('photo-overlay').setOpacity(0.7);
		else Element.fxOpacity('photo-overlay').setOpacity(1);
		Element.show('photo-overlay');
		Element.show('photo-overlay-buttons');
		overlayButtons('hide');
	}
	
	if (what == 'details') {
		Element.hide('photo-overlay-comments');
		Element.show('photo-overlay-details');
	} else if (what == 'comments') {
		Element.hide('photo-overlay-details');
		Element.show('photo-overlay-comments');
	}
	updateButtons(what);
}

function updateButtons(what) {
	if (what == 'details') {
		changeSrc('but_comments',pathimages+'lay-photo-but-com-over-s.gif');
		changeSrc('but_details', pathimages+'lay-photo-but-det-over.gif');
	} else if (what == 'comments') {
		changeSrc('but_details', pathimages+'lay-photo-but-det-over-s.gif');
		changeSrc('but_comments',pathimages+'lay-photo-but-com-over.gif');
	}
}

function loadOverlayContent(what,showall) {
	//carica la pagina dei contenuti (dettagli o commenti)
	var done = (is_ie_max6)?'updateButtons(\''+what+'\');':'';
	if (what == 'details') {
		//carica i dettagli
		if (loadedinfo_det!=photoId) {
			ahah('inner.photoinfo.asp?id='+photoId+'&c='+getNoCacheId()+'&js=1',
				 'photo-overlay-details',
				 '',
				 '<div class="loading"><img src="'+pathimages+'lay-loading-bar.gif" alt="loading..." class="loading" /><br/>loading details...</div>',
				 '',
				 done);
			loadedinfo_det = photoId;
		}
	} else if (what == 'comments') {
		//carica i commenti
		if (loadedinfo_com!=photoId) {
			ahah('inner.comments.asp?id='+photoId+'&c='+getNoCacheId()+'&js=1&showall='+showall,
				 'photo-overlay-comments',
				 '',
				 '<div class="loading"><img src="'+pathimages+'lay-loading-bar.gif" alt="loading..." class="loading" /><br/>loading comments...</div>',
				 '',
				 done);
			loadedinfo_com = photoId;
		}
	}
}



/***************************************************************
 SLIDESHOW
 ***************************************************************/

/*** toggle per lo slideshow ***/
function slideshow() {
	if(slideshowactiveflag) {
		//ferma lo slideshow
		if (!transimage) Element.fxOpacity('photo-nav',{ 'duration': 200 },0).custom(0,1);	
		changeSrc('slideshowimg',pathimages+'lay-photo-nav-slideshow-off.gif');
		slideshowactiveflag = false;
	} else {
		//avvia lo slideshow
		Element.fxOpacity('photo-nav',{ 'duration': 200 },1).custom(1,0);	
		changeSrc('slideshowimg',pathimages+'lay-photo-nav-slideshow-on.gif');
		overlayButtons('hide');
		hideOverlayContent();
		slideshowactiveflag = true;
		slideshowview = 0;
		if (slideshowstart == -1) { slideshowstart = photoId; }
		slideshowactive++;
		setTimeout(slideshownext,slideshowfirsttime);
	}
}

/*** passa alla prossima immagine ***/
function slideshownext() {
	if (slideshowactive>1) {
		slideshowactive--;
	} else {
		if (slideshowactiveflag) { previous(); slideshowview++; } 
		else { slideshowactive--; }
	}
}



/***************************************************************
 NAVIGAZIONE
 ***************************************************************/

/*** avvia le procedure di passaggio all'immagine successiva ***/
function next() {
	if (photoIdNext != 0) { loadXML(photoIdNext,tag,'next'); }
}
	
/*** avvia le procedure di passaggio all'immagine precedente ***/
function previous() {
	/*if (photoIdPrev != 0) {	loadXML(photoIdPrev,tag,'prev'); }
	else {
		//se lo slideshow è attivo e sono finite le foto lo ferma
		if (slideshowactiveflag) slideshow();
	}*/
	loadXML(photoIdPrev,tag,'prev');
	
}

function closeBox() {
	//loading part 1
	transimage = true;
	hideOverlayContent();
	overlayButtons('hide');
	
	if (baloons) {
		nextBaloon.forceHide();
		prevBaloon.forceHide();
	}
	
	Element.hide('photo-overlay-open');
	Element.fxOpacity('photo-header',{ 'duration': 200 },1).custom(1,0);
	Element.fxOpacity('photo-slideshow-box',{ 'duration': 200 },1).custom(1,0);
	if (!(slideshowactiveflag)) {
	Element.fxOpacity('photo-nav',{ 'duration': 200,
					  		  'onComplete': function() { hideImage(); }
							},1).custom(1,0);
	} else hideImage();
}

function hideImage() {
	//loading part 2
	Element.fxOpacity('photo-img',{ 'duration': 200,
							'onComplete': function() { minBox(); }
						  },1).custom(1,0);	
}

function minBox() {
	//loading part 3
	Element.fxHeight('photo-box', { 'duration': 500, 'transition': fx.quadOut }).custom(Element.getHeight('photo-box'),loadheight); 
	Element.fxWidth('photo-box', { 'duration': 500, 
							   'transition': fx.quadOut, 
							   'onComplete': function() {
												Element.setSrc('photo-img', pathimages+'lay-loading-photo.gif');
												Element.show('photo-loading');
												loadimage();
											 }
							 }).custom(Element.getWidth('photo-box'),loadwidth);
}
	
function loadimage() {
	//loading part 4
	imgPreloader = new Image();
	imgPreloader.onload=function() {
		Element.hide('photo-loading');
		Element.setSrc('photo-img', photoSrc);
		photoWidth = imgPreloader.width; photoHeight = imgPreloader.height;
		resizeBox(photoWidth,photoHeight);
		posBaloon();
	}
	imgPreloader.onerror=function() {
		Element.hide('photo-loading');
		Element.setSrc('photo-img', pathimages+'lay-photo-error.jpg');
		photoWidth = 640; photoHeight = 480;
		resizeBox(photoWidth,photoHeight);
		posBaloon();
	}
	imgPreloader.src = photoSrc;
	
	//document.title = title+' ::: '+lang_title+' > "'+photoTitle+'"';
	
	$('next').title = photoTitleNext;
	$('prev').title = photoTitlePrev;
	if (baloons) {
		$('baloonnextimg').src=photoSrcNext;
		$('baloonprevimg').src=photoSrcPrev;
	}
	if (lastviewedphoto<photoId && lastviewedphoto!=0) Element.setInnerHTML('photo-new',lang_new);
	else Element.setInnerHTML('photo-new','');
	
	Element.setInnerHTML('photo-title','<span class="number">#' + photoId + '</span> ' + photoTitle);
	Element.setInnerHTML('photo-date',photoPub);
}
	
function resizeBox(width,height,slideshowid) {
	//loading part 5
	resizeInfo(width,height);
	Element.fxWidth('photo-box',
				    {'duration': 200,
					 'transition': fx.quadOut,
					 'onComplete': function() {
								    Element.fxHeight('photo-box',
													 {'duration': 200,
													 'transition': fx.quadOut,
													 'onComplete': function() {
																	fxalert = true;
																	Element.fxOpacity('photo-img',
																					  {'duration': 300,
																					   'onComplete': function() {
																									  checkNav();
																									  Element.setWidth('photo-nav',Element.getWidth('photo-box')-10);
																									  resizeWin()
																									  if (!(slideshowactiveflag)) {
																										  Element.fxOpacity('photo-nav',
																														    {'duration': 300},
																															0).custom(0,1);}
																										  Element.fxOpacity('photo-header',
																														    {'duration': 300},
																															0).custom(0,1);
																										  Element.fxOpacity('photo-slideshow-box',
																															{'duration': 300},
																															0).custom(0,1);
																										  
																										  transimage = false;
																										  
																										  if (slideshowactiveflag) {
																											if (photoId == slideshowstart) slideshow();
																											else {
																										  	  if (photoId == slideshowstart)
																											    slideshownext();
																											  else 
																											    setTimeout(slideshownext,slideshowtime);
																											}
																										  }
																									 }
																									},
																					0).custom(0,1);
																	}
													}).custom(Element.getHeight('photo-box'),height);
									}
					}).custom(Element.getWidth('photo-box'),width);
}


function resizeWin() {
	postopimage = Element.getTop('photo-img');
	arrayPageSize = getPageSize();
	posBaloon();
}

/***** FUNZIONI AUSILIARIE PER LA NAVIGAZIONE *****/

function posBaloon() {
	if (baloons) {
		nextBaloon.top = postopimage+photoHeight-96;
		prevBaloon.top = postopimage+photoHeight-96;
		nextBaloon.left = Math.round(arrayPageSize[0]/2)+Math.round(photoWidth/2)-128;
		prevBaloon.left = Math.round(arrayPageSize[0]/2)-Math.round(photoWidth/2)-5;
	}
}

function resizeImageBox(width,height) {
	if (width <= 0) width = 640;
	if (height <= 0) height = 480;
	Element.setWidth('photo-box',width)
	Element.setWidth('photo-nav',width)
}

function resizeInfo(width,height) {
	if (width <= 0) width = 640;
	if (height <= 0) height = 480;	
	Element.setWidth('photo-header',width)
	Element.setWidth('photo-overlay-comments',width-50)
	if (!is_safari) Element.setHeight('photo-overlay-comments',height-20)
	Element.setWidth('photo-overlay-details',width-50)
	if (!is_safari) Element.setHeight('photo-overlay-details',height-20)
	Element.setWidth('photo-overlay',width)
	Element.setHeight('photo-overlay',height)
}

function checkNav() {
	if (photoIdNext == 0) { Element.hide('photo-next'); } 
	else { Element.show('photo-next'); }
	if (photoIdPrev == 0) { Element.hide('photo-prev'); } 
	else { Element.show('photo-prev'); }	
}



/***************************************************************
 GESTIONE COMMENTI
 ***************************************************************/

/*** invia un commento ***/
function submitComment() {
	//invia la richiesta per il posting di un commento
	ahah('comments_pro.asp?c='+getNoCacheId(),
		 'photo-overlay-comments',
		 'photoid=' + escape(document.getElementById('formcomment').photoid.value) + '&' + 
			   'name=' + escape(document.getElementById('formcomment').name.value) + '&' +
			   'email=' + escape(document.getElementById('formcomment').email.value) + '&' +
			   'url=' + escape(document.getElementById('formcomment').url.value) + '&' +
			   'securitycode=' + escape(document.getElementById('formcomment').securitycode.value) + '&' +
			   'comment=' + escape(document.getElementById('formcomment').comment.value) + '&' +
			   'js=1',
		 '<div class="loading"><img src="'+pathimages+'lay-loading-bar.gif" alt="loading..." class="loading" /><br/>sending comment...</div>',
		 '',
		 '');
}

/*** elimina un commento ***/
function deleteComment(id) {
	//invia la richiesta per la cancellazione
	ahah('comments_pro.asp?id=' + id + '&action=delete&js=1&c='+getNoCacheId(),
		 'photo-overlay-comments',
		 '',
		 '<div class="loading"><img src="'+pathimages+'lay-loading-bar.gif" alt="loading..." class="loading" /><br/>deleting comment...</div>',
		 '',
		 '');
}

/*** visualizza/nasconde la form dei commenti (a scomparsa) ***/
function commentForm() {
	if (Element.isVisible('commentform')) {
		//nasconde la form
		Element.fxHeight('commentform', { 'duration': 1000, 'transition': fx.quadOut, 'onComplete': function(){ Element.hide('commentform'); }}).custom(Element.getRealHeight('commentform')+20,0);
	} else {
		//visualizza la form
		Element.setHeight('commentform',0);
		Element.show('commentform');
		Element.fxHeight('commentform', { 'duration': 1000, 'transition': fx.quadOut}).custom(0,Element.getRealHeight('commentform')+20);
	}
}

/*** visualizza la form dei commenti e vi punta ***/
function commentFormGo() {
	Element.show('commentform');
	Element.setHeight('commentform',Element.getRealHeight('commentform')+20)
	document.location.href = '#commenthere';	
}

/*** visualizza i commenti e vi punta ***/
function commentErrorBack() {
	loadedinfo_com=-1;
	showOverlayContent('comments',1)
}


/***************************************************************
 E' FINITO, COSA VOLEVATE ANCORA?
 ***************************************************************/

function makeCoffee() { alert('un espresso buono come al bar'); }