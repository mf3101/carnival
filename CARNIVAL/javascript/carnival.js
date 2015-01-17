/****************************************************************************
 *	CARNIVAL CORE 1.1 [20080812]
 *	developed by Simone Cingano (http://www.imente.it)
 ****************************************************************************
 * @license         http://www.opensource.org/licenses/mit-license.php
 * @version         SVN: $Id: carnival.js 117 2010-10-11 19:22:40Z imente $
 ****************************************************************************/


  
/***************************************************************
 CLASSI
 ***************************************************************/
 
 
var Photos = new Class({
					   
	photos:Array(),
	
	initialize: function() {},
	
	add: function(id,title,pub,src,addafter) { 
		var keys = new Array('id','title','pub','src');
		pub = (pub==0)?(0):(new Date(Date.parse(pub)));
		var photo = new Array(id,title,pub,src);
		photo = photo.associate(keys);
		if (addafter) this.photos.push(photo);
		else this.photos.unshift(photo);
	},
	
	clean: function() { 
		this.photos = new Array();
	},
	
	debug: function() { 
		var output = '';
		var line = '<br/>';
		for (var ii=0;ii<this.photos.length;ii++) {
			output=output+'photos['+ii+'][id]='+this.photos[ii]['id']+line+'photos['+ii+'][title]='+this.photos[ii]['title']+line+'photos['+ii+'][pub]='+this.photos[ii]['pub']+line+'photos['+ii+'][src]='+this.photos[ii]['src']+line+line;
		}
		return output;
	},
	
	end: function() {}
});

/***************************************************************
 VARIABILI DI APPLICAZIONE
 ***************************************************************/
 
var coreversion = "1.0",
	
	photomanager = new Photos(),
	
	photonavmanager = new Photos(),
	
	/*a full transition is (intervalOpacity*2)+(intervalSize*2)*/
    intervalOpacity = 300, intervalSize = 750, 

    s_type = String(''),
	
    pageSize,
	
    postopimage = 0,
	
    xmlDoc,
	xmlDocBusy = false,
    loadedinfo_det = -1,
    loadedinfo_com = -1,
    transimage = false,
	transnavigator = false,
    slideshowactiveflag = false,
    slideshowstart = -1,
    slideshowview = 0,
    slideshowactive = 0,
	
	debugging = false,

    photoWidth = 640,
    photoHeight = 480,

	/*opzioni*/
    slideshowfirsttime = 1500,
    slideshowtime = 8000,
    loadwidth = 100,
    loadheight = 100,
    xmlUrl = 'service.xml.photo.asp',
	xmlNavUrl = 'service.xml.navigator.asp',
	
	/*navigator*/
	navtag = -1,
	navset = -1,
	navid = 0,

    nextBaloon,
    prevBaloon,
    tagcloudBaloon,

	/*id corrente*/
    currentimage = -1;


/*-----------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------*/
  

/***************************************************************
 FUNZIONI UTILI
 ***************************************************************/
 
/*** crea un valore univoco da inserire in una richiesta al fine
     di evitare il chaching *///
function getNoCacheId() { var d = new Date(); return d.getTime(); }

/*** preloader per immagini ***/
function preloadImage(_image) { var i = new Image(); i.src = _image; }

function calldebugPrint(_value) { if (debugging) debugPrint(_value); }

/*** imposta le initinfo ***/
function setInitInfo(_info) { $('initinfo').setInnerHTML(_info); }

function printnumber(_value,_len) { return _value.substr(_value.length-_len,_len); }

function loadingBox(_id,_info,_top) { if (_top==null) _top = 60; $(_id).setInnerHTML('<div class="loading" style="margin-top:'+_top+'px;"><img src="'+pathimages+'lay-loading-bar.gif" alt="loading..." class="loading" /><br/>'+_info+'</div>'); }

/*** modifica l'src di una immagine (fix per ie nel cambio src) ***/
function changeSrc(_id,_src) {
	if (is_ie_max6) {
		var replace = document.createElement('img');
		var parent = $(_id).parentElement;
		var node = replace.cloneNode(true);
		node.id = _id; node.src = _src; node.alt = parent.firstChild.alt;
		parent.replaceChild(node,parent.firstChild);
	} else {
		$(_id).src = _src;
	}
}

/***************************************************************
 GESTIONE XML
 ***************************************************************/

function loadXML(_url,_parser) {
	
	if (xmlDocBusy) {
		setTimeout("loadXML(\""+_url+"\",\""+_parser+"\");",250);
		return;
	}
	
	xmlDocBusy = true;
	xmlDoc = false;
	if (window.XMLHttpRequest) { // Mozilla, Safari,...
		xmlDoc = new XMLHttpRequest(); if (xmlDoc.overrideMimeType) { xmlDoc.overrideMimeType('text/xml'); }
	} else if (window.ActiveXObject) { // IE
		try { xmlDoc = new ActiveXObject("Msxml2.XMLHTTP"); } catch (e) {
			try { xmlDoc = new ActiveXObject("Microsoft.XMLHTTP"); } catch (e) {}
		}
	}
	if (!xmlDoc) { alert('ERRORE: impossibile istanziare xmlhttp'); return false; }
	xmlDoc.onreadystatechange = function() { parseXML(_url,_parser); };
	xmlDoc.open("GET", _url, true);
    xmlDoc.send('');
	
}

function parseXML(_url,_parser){
	if (xmlDoc.readyState == 4) {
		if (xmlDoc.status == 200) eval(_parser);
		else alert('ERRORE: impossibile caricare \''+_url+'\'');
		xmlDoc = null;
		xmlDocBusy = false;
	}
}


/*-----------------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------  INIZIALIZZAZIONE  ------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------*/


  
/***************************************************************
 INIZIALIZZAZIONE CARNIVAL
 ***************************************************************/
	

/*** inizializzazione [ pass 1/6 ] ***/
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
	
	//inizializza variabili
	navtag = tag;
	navset = set;
	
	//modifica il DOM
	setInitInfo('1/4 editing DOM...');
	initDom();
	
	//carica l'xml ( che eseguirà al termine la funzione startCarnival() )
	setInitInfo('2/4 loading xml...');
	loadPhoto(selected,'start');
}


/*** inizializzazione [ pass 2/6 ] ***/
function initDom() {	
	
	//re-id
	$('photo-box-nojs').setProperty('id','photo-box');
	$('photo-img-nojs').setProperty('id','photo-img');
	$('photo-nav-nojs').setProperty('id','photo-nav');
	
	//***** BOTTONI OVERLAY
	
	//#photo-overlay-open > a > img
	$('photo-overlay-open').appendChild(createA('','javascript:;',function() { showOverlayContent('details',0); },'')).appendChild(createImg('',pathimages+'lay-photo-but-det-show.gif',lang_details));
	
	//#photo-overlay-open > a > img
	$('photo-overlay-open').appendChild(createA('','javascript:;',function() { showOverlayContent('comments',0); },'')).appendChild(createImg('',pathimages+'lay-photo-but-com-show.gif',lang_comments));
	
	//#photo-box > #photo-loading
	$('photo-box').appendChild(createDiv('photo-loading',''));
	//#photo-loading > img
	$('photo-loading').appendChild(createImg('l',pathimages+'lay-loading-photo.gif','photo-loading'));
	
	//#photo-slideshow > div#photo-slideshow-box > a > img#slideshowimg
	$('photo-slideshow').appendChild(createDiv('photo-slideshow-box','')).appendChild(createA('','javascript:;',function() { slideshow(); },'')).appendChild(createImg('slideshowimg',pathimages+'lay-photo-nav-slideshow-off.gif',''));
	
	
	//***** BOTTONI OVERLAY
	
	//#photo-overlay-buttons > div#photo-buttons
	$('photo-overlay-buttons').appendChild(createDiv('photo-buttons',''));
	
	//div#photo-buttons > a#button-close > img
	$('photo-buttons').appendChild(createA('button-close','javascript:;',function() { hideOverlayContent();},lang_close)).appendChild(createImg('but_close',pathimages+'lay-photo-but-close.gif',lang_close));
	
	//div#photo-buttons > a > img
	$('photo-buttons').appendChild(createA('button-details','javascript:;',function() { showOverlayContent('details',0); },lang_details)).appendChild(createImg('but_details','',lang_details));
	//changeSrc('but_details',pathimages+'lay-photo-but-det-over.gif');
	
	//div#photo-buttons > a > img
	$('photo-buttons').appendChild(createA('button-comments','javascript:;',function() { showOverlayContent('comments',0); },lang_comments)).appendChild(createImg('but_comments','',lang_comments));
	//changeSrc('but_details',pathimages+'lay-photo-but-com-over.gif');
	
	//***** NAVIGATOR																																										  
	if (navigatorbox) {	
		//div#photo-navigator-box > div#navigator-directory
		$('photo-navigator-box').appendChild(createDiv('navigator-directory',''));	
		//div#photo-navigator-box > div#navigator-photos
		$('photo-navigator-box').appendChild(createDiv('navigator-browser','')).appendChild(createDiv('navigator-photos',''));
		
		//div#navigator-toggle-box > a#navigator-toggle > img
		$('navigator-toggle').appendChild(createImg('but_navigator',pathimages+'lay-ico-act-down.gif',''));
		
		$('navigator-toggle-box').addEvent('click',function() { switchDisplayNavigator(); });
		$('navigator-toggle-box').addClass('selectable');
		
		var navigatorboxdirgenerator;
		navigatorboxdirgenerator= '<div class="menu">'+
								  '<ul class="tabmenu">'+
								  '<li id="tab-stream"><a href="javascript:;" onclick="loadNavDir(2,0,navtag);">Stream</a></li>';
		if (mode != 2) navigatorboxdirgenerator=navigatorboxdirgenerator+
								  '<li id="tab-set"><a href="javascript:;" onclick="loadNavDir(3,navset,0);">Set</a></li>';
		navigatorboxdirgenerator=navigatorboxdirgenerator+
								  '</ul>'+
								  '</div>'+
								  '<div class="hrtabmenu"></div>'+
								  '<div id="navigator-directory-content"></div>'
											  
		
		$('navigator-directory').setInnerHTML(navigatorboxdirgenerator);
		
		$('navigator-photos').addEvent('mousewheel', function(event) { moveNavPhotoWheel(event) });
		
	}
	
	
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
		var tagcloudBaloonShow = 'if (!slideshowactiveflag) tagcloudBaloon.show(\'relative\','+(is_ie?'window.event.clientX':'event.clientX')+',35);';
		tagcloudBaloon.start('tagcloud','tagcloudBaloon','cloudshow',function(event) {eval(tagcloudBaloonShow);},'balooncloud',0,-150,true);
		ahah('inner.tagcloud.asp?top=15',
			 'baloontagcloudcontent',
			 '',
			 '<div class="loading"><img src="'+pathimages+'lay-loading-bar.gif" alt="loading..." class="loading" /><br/>loading clouds...</div>',
			 '',
			 '');
	
	}
	
	//***** CALLER E RIDEFINIZIONI
	
	//photo overlay caller
	$('photo').addEvents({ 'mouseout' : function() { overlayButtons('hide'); },
						   'mousemove' : function() { overlayButtons('show'); }
						});
	$('photo-overlay-open').addEvents({ 'mouseover' : function() { overlayButtons('show'); },
						   				'mouseout' : function() { overlayButtons('hide'); }
									 });
	
	$('commentsshow').setProperty('href','comments.asp');
	$('commentsshow').setInnerHTML(lang_comments);
	
	$('previmg').setProperty('src',pathimages+'lay-photo-nav-prev.gif');
	$('nextimg').setProperty('src',pathimages+'lay-photo-nav-next.gif');
	
	$('prev').setProperty('href','javascript:;');
	$('next').setProperty('href','javascript:;');
	
	/***** SAFARI 3.0win BUGFIX
	if (is_safari) {
		$('photo-overlay-details').style.overflow = 'visible';
		$('photo-overlay-details').style.backgroundColor = '#000';
		$('photo-overlay-details').style.height = '';
		$('photo-overlay-comments').style.overflow = 'visible';
		$('photo-overlay-comments').style.backgroundColor = '#000';
		$('photo-overlay-comments').style.height = '';
	}*/

}


/*** inizializzazione [ pass 3/6 ] ***/
/* il passaggio 3 è il caricamento delle foto tramite LOADPHOTO */


/*** inizializzazione [ pass 4/6 ] ***/
function startCarnival() {
	
	//precarica le immagini necessarie
	preloadImage(pathimages+'lay-photo-nav-slideshow-on.gif');
	preloadImage(pathimages+'lay-photo-but-det-over.gif');
	preloadImage(pathimages+'lay-photo-but-det-over-s.gif');
	preloadImage(pathimages+'lay-photo-but-com-over.gif');
	preloadImage(pathimages+'lay-photo-but-com-over-s.gif');
	
	//nasconde tutti gli oggetti nell'overlay della foto
	$('photo-overlay').hide();
	$('photo-overlay-details').hide();
	$('photo-overlay-comments').hide();
	$('photo-overlay-buttons').hide();
	$('photo-overlay-open').hide();
	$('photo-loading').hide();
	
	setInitInfo('3/4 loading photo...');
	
	imgPreloader = new Image();
	imgPreloader.onload=function() {
		//ridimensiona la box secondo le dimensioni dell'immagine
		photoWidth = imgPreloader.width; photoHeight = imgPreloader.height;
		resizeInfo(photoWidth,photoHeight);
		resizeImageBox(photoWidth,photoHeight);
		
		//termina l'inizializzazione
		initEnd();
	}
	imgPreloader.onerror=function() {
		$('photo-loading').hide();
		$('photo-img').setSrc(pathimages+'lay-photo-error.jpg');
		photoWidth = 640; photoHeight = 480;
		resizeInfo(photoWidth,photoHeight);
		resizeImageBox(photoWidth,photoHeight);
		
		//termina l'inizializzazione
		initEnd();
	}
	imgPreloader.src = pathphotos+photomanager.photos[1]['src'];
	
}


/*** inizializzazione [ pass 5/6 ] ***/
function initEnd() {
	
	setInitInfo('start!');
	initFinally();
}


/*** inizializzazione [ pass 6/6 ] ***/
function initFinally() {
	
	//end	
	$('container').show();
	$('init').hide();
	
	$('photo-navigator-box').hide();
	$('photo-navigator-box').setHeight(0);
	
	$('overlay').hide();	
	
	//posiziona i baloon
	eventOnResize();
	posBaloon();
}


/*-----------------------------------------------------------------------------------------------------------------------------
  -------------------------------------------------------  GESTIONE  ----------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------*/

/***************************************************************
 GESTIONE XML CARNIVALPHOTO
 ***************************************************************/
 
function loadPhoto(_id,_type) {
	s_type = _type;
	loadXML(xmlUrl+"?id="+String(_id)+"&tag="+String(tag)+"&set="+String(set),'parsePhoto(xmlDoc.responseXML.documentElement);');
}

function parsePhoto(_xmlobj) {
	//struttura fissa (3 blocchi)
	
	photomanager.clean();
	photomanager.add(Number(_xmlobj.childNodes[0].childNodes[0].firstChild.data),
		      String(_xmlobj.childNodes[0].childNodes[1].firstChild.data),
			  String(_xmlobj.childNodes[0].childNodes[3].firstChild.data),
			  String(_xmlobj.childNodes[0].childNodes[2].firstChild.data),
			  true);
	photomanager.add(Number(_xmlobj.childNodes[1].childNodes[0].firstChild.data),
		      String(_xmlobj.childNodes[1].childNodes[1].firstChild.data),
			  String(_xmlobj.childNodes[1].childNodes[3].firstChild.data),
			  String(_xmlobj.childNodes[1].childNodes[2].firstChild.data),
			  true);
	photomanager.add(Number(_xmlobj.childNodes[2].childNodes[0].firstChild.data),
		      String(_xmlobj.childNodes[2].childNodes[1].firstChild.data),
			  String(_xmlobj.childNodes[2].childNodes[3].firstChild.data),
			  String(_xmlobj.childNodes[2].childNodes[2].firstChild.data),
			  true);
	
	switch (s_type) {
		case 'next': case 'prev': case 'nav':
			closeBox();
			break;
		case 'start':
			if (baloons) {
				$('baloonnextimg').setSrc(pathphotos+photomanager.photos[2]['src']);
				$('baloonprevimg').setSrc(pathphotos+photomanager.photos[0]['src']);
			}
			startCarnival();
			break;
	}
	_xmlobj = null;
}


/***************************************************************
 PHOTO OVERLAY
 ***************************************************************/
 
/*** gestisce la visualizzazione dei bottoni in overlay ("dettagli" e "commenti") ***/
function overlayButtons(_action) {
	if (_action == 'show') {
		//visualizza i bottoni in overlay
		if (!(slideshowactiveflag) && !(transimage)) $('photo-overlay-open').show();
	} else {
		//nasconde i bottoni in overlay
		$('photo-overlay-open').hide();
	}
}

/*** gestione contenuti nell'overlay (scheda "dettagli" e scheda "commenti" ***/					  
function hideOverlayContent() {
	//nasconde tutte le schede e l'overlay di sfondo semi-trasparente
	if ($('photo-overlay').isVisible()) {
		$('photo-overlay').fxTween({ 'duration': intervalOpacity*2,
											 'transition': Fx.Transitions.Quad.easeOut,
											 'onComplete':function(){ $('photo-overlay').hide(); }
										   }).start('opacity',0.7,0);
		$('photo-overlay-details').hide();
		$('photo-overlay-comments').hide();
		$('photo-overlay-buttons').hide();
	}
}

function showOverlayContent(_what,_showall) {
	//visualizza la scheda richiesta
	
	//carica la pagina dei contenuti (dettagli o commenti)
	loadOverlayContent(_what,_showall);
	if (!($('photo-overlay').isVisible())) {
		//se lo sfondo semi-trasparente non è visibile lo rende visibile (nessuna scheda aperta)
		/*if (!is_safari)*/ $('photo-overlay').setOpacity(0.7);
		/*else $('photo-overlay').setOpacity(1); //SAFARI 3.0win BUGFIX*/
		$('photo-overlay').show();
		$('photo-overlay-buttons').show();
		overlayButtons('hide');
	}
	
	if (_what == 'details') {
		$('photo-overlay-comments').hide();
		$('photo-overlay-details').show();
	} else if (_what == 'comments') {
		$('photo-overlay-details').hide();
		$('photo-overlay-comments').show();
	}
	updateButtons(_what);
}

function updateButtons(_what) {
	if (_what == 'details') {
		changeSrc('but_comments',pathimages+'lay-photo-but-com-over-s.gif');
		changeSrc('but_details', pathimages+'lay-photo-but-det-over.gif');
	} else if (_what == 'comments') {
		changeSrc('but_details', pathimages+'lay-photo-but-det-over-s.gif');
		changeSrc('but_comments',pathimages+'lay-photo-but-com-over.gif');
	}
}

function loadOverlayContent(_what,_showall) {
	//carica la pagina dei contenuti (dettagli o commenti)
	var done = (is_ie_max6)?'updateButtons(\''+_what+'\');':'';
	if (_what == 'details') {
		//carica i dettagli
		if (loadedinfo_det!=photomanager.photos[1]['id']) {
			ahah('inner.photoinfo.asp?id='+photomanager.photos[1]['id']+'&c='+getNoCacheId()+'&js=1',
				 'photo-overlay-details',
				 '',
				 '<div class="loading"><img src="'+pathimages+'lay-loading-bar.gif" alt="loading..." class="loading" /><br/>loading details...</div>',
				 '',
				 done);
			loadedinfo_det = photomanager.photos[1]['id'];
		}
	} else if (_what == 'comments') {
		//carica i commenti
		if (loadedinfo_com!=photomanager.photos[1]['id']) {
			ahah('inner.comments.asp?id='+photomanager.photos[1]['id']+'&c='+getNoCacheId()+'&js=1&showall='+_showall,
				 'photo-overlay-comments',
				 '',
				 '<div class="loading"><img src="'+pathimages+'lay-loading-bar.gif" alt="loading..." class="loading" /><br/>loading comments...</div>',
				 '',
				 done);
			loadedinfo_com = photomanager.photos[1]['id'];
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
		if (!transimage) {
			$('photo-nav').fxTween({ 'duration': intervalOpacity }).start('opacity',1);
			$('navigator-toggle-box').show();
		}
		changeSrc('slideshowimg',pathimages+'lay-photo-nav-slideshow-off.gif');
		slideshowactiveflag = false;
	} else if (photomanager.photos[0]['id'] != 0) {
		//avvia lo slideshow
			$('photo-nav').fxTween({ 'duration': intervalOpacity }).start('opacity',0);	
			$('navigator-toggle-box').hide();
			if ($('photo-navigator-box').isVisible()&&!transnavigator) switchDisplayNavigator();
		changeSrc('slideshowimg',pathimages+'lay-photo-nav-slideshow-on.gif');
		overlayButtons('hide');
		hideOverlayContent();
		slideshowactiveflag = true;
		slideshowview = 0;
		if (slideshowstart == -1) { slideshowstart = photomanager.photos[1]['id']; }
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


/*-----------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------  NAVIGAZIONE  ---------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------*/

/***************************************************************
 NAVIGAZIONE
 ***************************************************************/

/*** avvia le procedure di passaggio all'immagine successiva ***/
function next() {
	if (transimage) return;
	if (photomanager.photos[2]['id'] != 0) { loadPhoto(photomanager.photos[2]['id'],'next'); }
}
	
/*** avvia le procedure di passaggio all'immagine precedente ***/
function previous() {
	if (transimage) return;
	if (photomanager.photos[0]['id'] != 0) {	loadPhoto(photomanager.photos[0]['id'],'prev'); }
	else {
		//se lo slideshow è attivo e sono finite le foto lo ferma
		if (slideshowactiveflag) { slideshowactive--; slideshow(); }
	}
	
}

/* LOADING [ pass 1/5 ] */
function closeBox() {
	transimage = true;
	hideOverlayContent();
	overlayButtons('hide');
	
	if (baloons) {
		nextBaloon.forceHide();
		prevBaloon.forceHide();
	}
	
	if ($('photo-navigator-box').isVisible()&&!transnavigator) switchDisplayNavigator();
	
	$('photo-overlay-open').hide();
	$('photo-header-title').fxTween({ 'duration': intervalOpacity }).start('opacity',0);
	$('photo-slideshow-box').fxTween({ 'duration': intervalOpacity }).start('opacity',0);
	if (!(slideshowactiveflag)) {
	$('photo-nav').fxTween({ 'duration': intervalOpacity,
					  		  'onComplete': function() { hideImage(); }
							}).start('opacity',0);
	} else hideImage();
}

/* LOADING [ pass 2/5 ] */
function hideImage() {
	$('photo-img').fxTween({ 'duration': intervalOpacity,
							'onComplete': function() { minBox(); }
						  },1).start('opacity',0);	
}

/* LOADING [ pass 3/5 ] */
function minBox() {
	$('photo-box').fxTween({ 'duration': intervalSize, 'transition': Fx.Transitions.Bounce.easeOut }).start('height',loadheight); 
	$('photo-box').fxTween({ 'duration': intervalSize, 
							   'transition': Fx.Transitions.Bounce.easeOut, 
							   'onComplete': function() {
												$('photo-img').setSrc(pathimages+'lay-loading-photo.gif');
												$('photo-loading').show();
												loadimage();
											 }
							 }).start('width',loadwidth);
}
	
/* LOADING [ pass 4/5 ] */
function loadimage() {
	imgPreloader = new Image();
	imgPreloader.onload=function() {
		$('photo-loading').hide();
		$('photo-img').setSrc(pathphotos+photomanager.photos[1]['src']);
		photoWidth = imgPreloader.width; photoHeight = imgPreloader.height;
		resizeBox(photoWidth,photoHeight);
		posBaloon();
	}
	imgPreloader.onerror=function() {
		$('photo-loading').hide();
		$('photo-img').setSrc(pathimages+'lay-photo-error.jpg');
		photoWidth = 640; photoHeight = 480;
		resizeBox(photoWidth,photoHeight);
		posBaloon();
	}
	imgPreloader.src = pathphotos+photomanager.photos[1]['src'];
	
	//document.title = title+' ::: '+lang_title+' > "'+photomanager.photos[1]['title']+'"';
	
	$('next').title = photomanager.photos[2]['title'];
	$('prev').title = photomanager.photos[0]['title'];
	if (baloons) {
		$('baloonnextimg').src=pathphotos+photomanager.photos[2]['src'];
		$('baloonprevimg').src=pathphotos+photomanager.photos[0]['src'];
	}
	if (lastviewedphotopub<photomanager.photos[1]['pub'] && lastviewedphoto!=0) $('photo-new').setInnerHTML(lang_new);
	else $('photo-new').setInnerHTML('');
	
	$('photo-title').setInnerHTML(photomanager.photos[1]['title']);
	$('photo-date').setInnerHTML(printnumber('0'+photomanager.photos[1]['pub'].getDate(),2)+'/'+
								printnumber('0'+(photomanager.photos[1]['pub'].getMonth()+1),2)+'/'+
								 photomanager.photos[1]['pub'].getFullYear());
}
	
/* LOADING [ pass 5/5 ] */
function resizeBox(_width,_height) {
	resizeInfo(_width,_height);
	$('photo-box').fxTween(
				    {'duration': intervalSize/2,
					 'transition': Fx.Transitions.Expo.easeOut,
					 'onComplete': function() {
								    $('photo-box').fxTween(
													 {'duration': intervalSize/2,
													 'transition': Fx.Transitions.Expo.easeOut,
													 'onComplete': function() {
																	fxalert = true;
																	$('photo-img').fxTween(
																					  {'duration': intervalOpacity,
																					   'onComplete': function() {
																									  checkNav();
																									  $('photo-nav').setWidth($('photo-box').getWidth()-10);
																									  eventOnResize()
																									  if (!(slideshowactiveflag)) {
																										  $('photo-nav').fxTween(
																														    {'duration': intervalOpacity}).start('opacity',1);}
																										  $('photo-header-title').fxTween(
																														    {'duration': intervalOpacity}).start('opacity',1);
																										  $('photo-slideshow-box').fxTween(
																															{'duration': intervalOpacity}).start('opacity',1);
																										  
																										  transimage = false;
																										  
																										  if (slideshowactiveflag) {
																											if (photomanager.photos[1]['id'] == slideshowstart) slideshow();
																											else {
																										  	  if (photomanager.photos[1]['id'] == slideshowstart)
																											    slideshownext();
																											  else 
																											    setTimeout(slideshownext,slideshowtime);
																											}
																										  }
																									 }
																									}
																						).start('opacity',1);
																	}
													}).start('height',_height);
									}
					}).start('width',_width);
}


function eventOnResize() {
	pageSize = window.getSize();
	if ($('photo-navigator-box').isVisible()) resizeNavigator();
	postopimage = $('photo-img').getTop();
	posBaloon();
}

/***** FUNZIONI AUSILIARIE PER LA NAVIGAZIONE *****/

function posBaloon() {
	if (baloons) {
		nextBaloon.top = postopimage+photoHeight-96;
		prevBaloon.top = postopimage+photoHeight-96;
		nextBaloon.left = Math.round(pageSize.x/2)+Math.round(photoWidth/2)-128;
		prevBaloon.left = Math.round(pageSize.x/2)-Math.round(photoWidth/2)-5;
	}
}

function resizeImageBox(_width,_height) {
	if (_width <= 0) _width = 640;
	if (_height <= 0) _height = 480;
	$('photo-box').setWidth(_width)
	$('photo-nav').setWidth(_width)
}

function resizeInfo(_width,_height) {
	if (_width <= 0) _width = 640;
	if (_height <= 0) _height = 480;	
	$('photo-overlay-comments').setWidth(_width-50)
	/*if (!is_safari)*/ $('photo-overlay-comments').setHeight(_height-20) //SAFARI 3.0win BUGFIX
	$('photo-overlay-details').setWidth(_width-50)
	/*if (!is_safari)*/ $('photo-overlay-details').setHeight(_height-20) //SAFARI 3.0win BUGFIX
	$('photo-overlay').setWidth(_width)
	$('photo-overlay').setHeight(_height)
}

function checkNav() {
	if (photomanager.photos[2]['id'] == 0) { $('photo-next').hide(); } 
	else { $('photo-next').show(); }
	if (photomanager.photos[0]['id'] == 0) { $('photo-prev').hide(); } 
	else { $('photo-prev').show(); }	
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
	if ($('commentform').isVisible()) {
		//nasconde la form
		$('commentform').fxTween({ 'duration': 1000, 'transition': Fx.Transitions.Quad.easeOut, 'onComplete': function(){ $('commentform').hide(); }}).start('height',0);
	} else {
		//visualizza la form
		$('commentform').setHeight(0);
		$('commentform').show();
		$('commentform').fxTween({ 'duration': 1000, 'transition': Fx.Transitions.Quad.easeOut}).start('height',$('commentform').getRealHeight()+20);
	}
}

/*** visualizza la form dei commenti e vi punta ***/
function commentFormGo() {
	$('commentform').show();
	$('commentform').setHeight($('commentform').getRealHeight()+20)
	document.location.href = '#commenthere';	
}

/*** visualizza i commenti e vi punta ***/
function commentErrorBack() {
	loadedinfo_com=-1;
	showOverlayContent('comments',1)
}



/***************************************************************
 GESTIONE NAVIGATOR
 ***************************************************************/
 
function callNavigator(_set,_tag,_id) {
	if (!$('photo-navigator-box').isVisible()) {
		switchDisplayNavigator(_set,_tag,_id);
	}
	else{
		navtag = _tag; navset = _set; navid = _id;
		loadNavDir(0,navset,navtag);
		loadNavPhoto(navtag,navset,navid);
	}
}

function switchDisplayNavigator(_set,_tag,_id) {
	if (transnavigator) return;
	transnavigator = true;
	var el = 'photo-navigator-box';
	if (!$(el).isVisible()) {
		$(el).show();
		
		resizeNavigator();
		
		$(el).fxTween({ 'duration': 750, 
				 	  	'transition': Fx.Transitions.Bounce.easeOut,
						'onComplete': function() { transnavigator = false; }
					 }).start('height',200);
		
		navtag = (_tag==null)?(tag):(_tag);
		navset = (_set==null)?(set):(_set);
		navid = (_id==null)?(photomanager.photos[1]['id']):(_id); //seleziona foto corrente
		
		loadNavDir(0,navset,navtag);
		loadNavPhoto(navtag,navset,navid);
		
		$('but_navigator').setSrc(pathimages+'lay-ico-act-up.gif');
		$('navigator-toggle-box').addClass('active');
	} else {
		
		$(el).fxTween({ 'duration': 1000, 
						'transition': Fx.Transitions.Quad.easeInOut,
						'onComplete': function() { 
										$(el).hide();
										resetNavPhoto();
										transnavigator = false;
									  }
					 }).start('height',0);
		$('but_navigator').setSrc(pathimages+'lay-ico-act-down.gif');
		$('navigator-toggle-box').removeClass('active');
	}
}

function resizeNavigator() {
	var width = pageSize.x-$('navigator-directory').getRealWidth()-15;
	spacep = width;
	$('navigator-photos').setWidth(width);
	if($('progressiveloading')) $('progressiveloading').setWidth(width);
	if($('navigator-photos-title1')) $('navigator-photos-title1').setWidth(width);
	if($('navigator-photos-title2')) $('navigator-photos-title2').setWidth(width);
	var range = parseInt(width/(basew+distancep*2))-1;
	if (range % 2 != 0) range = range - 1;
	range = range / 2;
	if (range > 3) range = 3;
	if (range < 1) range = 1;
	setRange(range);
	moveNavPhotoPos('i');
}

function activePhoto(id) {
	if (transimage || transnavigator) return;
	if (navset>0) {
		setPhotoCategory('set',navset);
	}
	else if (navtag>=0) {
		setPhotoCategory('stream',navtag);
	}
	
	tag = navtag;
	set = navset;
	loadPhoto(id,'nav');	
}

function setPhotoCategory(_type,_id) {
	var title = '', type;
	if (_id == 0) { title = "stream"; type = "camera"; }
	else { title = $('dir-'+_type+_id).getElement('.title').innerHTML; type = (_type=='set')?(_type='set'):(_type='tag'); }
	
	$('photo-category').setInnerHTML('<img alt="" src="'+pathimages+'lay-ico-'+type+'.gif"/>'+title);	
	
	var gallerylink = 'gallery.asp';
	switch (type) {
		case "set": gallerylink = 'gallery.asp?mode=sets&set='+navset; break;
		case "tag": gallerylink = 'gallery.asp?mode=stream&tag='+title; break;
	}
	$('gallerylink').href = gallerylink;
}

/***************************************************************/
/* Gestione Navigator Directory */

function loadNavDir(_mode,_set,_tag) {
	if (_mode==0) {
		if (_set>0) _mode = 3;
		if (_tag>0) _mode = 2;
	}
	$('tab-stream').removeClass('selected');
	if (mode!=2) $('tab-set').removeClass('selected');
	
	if (_mode==3 && mode!=2) $('tab-set').addClass('selected');
	else $('tab-stream').addClass('selected');
	loadingBox('navigator-directory-content','loading...',50);
	loadXML(xmlNavUrl+"?mode="+String(_mode)+"&tag="+String(_tag)+"&set="+String(_set),"parseNavDir(xmlDoc.responseXML.documentElement,"+(_mode==3?"'set'":"'stream'")+");");
}

function parseNavDir(_xmlobj,_type) {
	var output = '',divlcass,id,type;
	for (ii=0; ii<_xmlobj.childNodes.length; ii++) {
		if (_type=='set') { type = 'set' }
		else {
			if (ii>0) type = 'tag';
			else type = 'camera';
		}
		divclass='';
		id = _xmlobj.childNodes[ii].childNodes[0].firstChild.data;
		if (_xmlobj.childNodes[ii].attributes[0]) {
			if (String(_xmlobj.childNodes[ii].attributes[0].value)=='1') divclass = "selected";
		}
		output=output+'<a href="javascript:;" onclick="setNavDir(\''+_type+'\','+id+');"><div id="dir-'+_type+id+'"'+((divclass!='')?(' class="'+divclass+'"'):(''))+'><span class="photos">'+_xmlobj.childNodes[ii].childNodes[2].firstChild.data+'</span><img src="'+pathimages+'lay-ico-'+type+'.gif" alt="" /><span class="title">'+_xmlobj.childNodes[ii].childNodes[1].firstChild.data+'</span></div></a>';
	}
	$('navigator-directory-content').setInnerHTML(output);
	var selected = $('navigator-directory-content').getElement('.selected');
	if (selected) {
		var selectedy = selected.getPosition().y-$('navigator-directory-content').getPosition().y-63;
		if (selectedy > 0) $('navigator-directory-content').scrollTo(0,selectedy);
	}
	_xmlobj = null;
}

function setNavDir(_type,_id) {
	if (_type=='stream') {
		if (_id==navtag) return;
		if (navtag>=0) $('dir-stream'+navtag).removeClass('selected');
		$('dir-stream'+_id).addClass('selected');
		navtag = _id;
		navset = -1;
	}
	else if (_type=='set') {
		if (_id==navset) return;
		if (navset>0) $('dir-set'+navset).removeClass('selected');
		$('dir-set'+_id).addClass('selected');
		navset = _id;
		navtag = -1;
	}
	loadNavPhoto(navtag,navset,0);
}

/***************************************************************/
/* Gestione Navigator Photos */

function loadNavPhoto(_tag,_set,_id) {
	loadingBox('navigator-photos','loading...',50);
	loadXML(xmlUrl+"?tag="+String(_tag)+"&set="+String(_set)+'&range='+rangept+'&thumbs=1&id='+_id,'parseNavPhoto(xmlDoc.responseXML.documentElement,\'full\');');
}

function loadNavPhotoNext() {
	if (nothingafter) return;
	showNavProgressiveLoading();
	loadXML(xmlUrl+"?tag="+String(navtag)+"&set="+String(navset)+'&range='+(rangept+1)+'&thumbs=1&id='+photonavmanager.photos[photonavmanager.photos.length-1]['id']+'&dir=next','parseNavPhoto(xmlDoc.responseXML.documentElement,\'next\');');
}

function loadNavPhotoPrev() {
	if (nothingbefore) return;
	showNavProgressiveLoading();
	loadXML(xmlUrl+"?tag="+String(navtag)+"&set="+String(navset)+'&range='+(rangept+1)+'&thumbs=1&id='+photonavmanager.photos[0]['id']+'&dir=prev','parseNavPhoto(xmlDoc.responseXML.documentElement,\'prev\');');
}

var transprogressiveloading = false;
var progressiveloadingdone = false;

function checkNavPhotoProgressiveLoading() {
	if (transprogressiveloading) return;
	if (totalp-currentp<=rangept-1) setTimeout(function() { loadNavPhotoNext(); },durationp+100);
	if (currentp<=rangept-1) { setTimeout(function() { loadNavPhotoPrev(); },durationp+100); }
}

function showNavProgressiveLoading() {
	if (!$('progressiveloading').isVisible() && !transprogressiveloading) { 
		transprogressiveloading = true;
		$('progressiveloading').show(); 
		$('progressiveloading').fxMorph({'duration': 200, 
										 'onComplete':function() { 
																	if (progressiveloadingdone) {
																		transprogressiveloading = false;
																		hideNavProgressiveLoading();
																	}
																 }}).start({'opacity':1})
	}
}

function hideNavProgressiveLoading() {
	if ($('progressiveloading').isVisible()) {
		if (transprogressiveloading) {
			progressiveloadingdone = true;
		}
		else {
			progressiveloadingdone = false;
			$('progressiveloading').fxMorph({'duration': 200, 'onComplete': function() { 
																						  transprogressiveloading = false;
																					 	  $('progressiveloading').hide();
																						  checkNavPhotoProgressiveLoading();
																					   }}).start({'opacity':0});
		}
	}
}

function parseNavPhoto(_xmlobj,_type) {
	var before = true;
	if (_type=='full') {
		photonavmanager.clean();
		currentp=null;
		nothingbefore = false; nothingafter = false;
		var realii=0;
		for (var ii=0;ii<_xmlobj.childNodes.length;ii++) {
			if (Number(_xmlobj.childNodes[ii].childNodes[0].firstChild.data)>0) {
				if (before) before = false;
				photonavmanager.add(Number(_xmlobj.childNodes[ii].childNodes[0].firstChild.data),
									String(_xmlobj.childNodes[ii].childNodes[1].firstChild.data),
									String(_xmlobj.childNodes[ii].childNodes[3].firstChild.data),
									String(_xmlobj.childNodes[ii].childNodes[2].firstChild.data),
									true);
				if (_xmlobj.childNodes[ii].attributes[0]) {
					if (String(_xmlobj.childNodes[ii].attributes[0].value)=='1') currentp = realii;
				}
				realii++;
			} else {
				if (before) { nothingbefore = true; }
				else { nothingafter = true; }
			}
		}
		
		totalp = photonavmanager.photos.length;
		currentstartp = 1000;
		if (currentp==null) currentp = totalp-1;
		
		//setup navigator
		$('navigator-photos').setInnerHTML('<div id="progressiveloading"><img src="'+pathimages+'lay-loading-circle.gif" alt="loading..." /></div><div id="navigator-photos-title1" class="navigator-photos-title"></div><div id="navigator-photos-title2" class="navigator-photos-title"></div><div class="navigator-photos-moves base left" onclick="moveNavPhotoPrev();">&#8249;</div>\n<div class="navigator-photos-moves base right" onclick="moveNavPhotoNext();">&#8250;</div><div class="navigator-photos-moves left speed" onclick="moveNavPhotoPrev(rangept);">&laquo;</div>\n<div class="navigator-photos-moves right speed" onclick="moveNavPhotoNext(rangept);">&raquo;</div>');
		$('navigator-photos-title1').setOpacity(1).setWidth($('navigator-photos').getWidth());
		$('navigator-photos-title2').setOpacity(0).setWidth($('navigator-photos').getWidth());
		$('progressiveloading').setOpacity(0).hide();
		navtitleid = 1;
		for (var ii=0;ii<totalp;ii++) {
				addNavPhoto(ii+currentstartp,photonavmanager.photos[ii]['id'],photonavmanager.photos[ii]['title'],photonavmanager.photos[ii]['src'])
		}
		moveNavPhotoPos('s');
	}
	else if (_type=='prev') {
		//var dbb='PREV +';
		for (var ii=_xmlobj.childNodes.length-1-1;ii>0;ii--) {
			if (Number(_xmlobj.childNodes[ii].childNodes[0].firstChild.data)>0) {
				photonavmanager.add(Number(_xmlobj.childNodes[ii].childNodes[0].firstChild.data),
									String(_xmlobj.childNodes[ii].childNodes[1].firstChild.data),
									String(_xmlobj.childNodes[ii].childNodes[3].firstChild.data),
									String(_xmlobj.childNodes[ii].childNodes[2].firstChild.data),
									false);
				//dbb=dbb+'['+photonavmanager.photos[0]['id']+'] ';
				currentstartp--;
				addNavPhoto(currentstartp,photonavmanager.photos[0]['id'],photonavmanager.photos[0]['title'],photonavmanager.photos[0]['src'])
				totalp++;
				currentp++;
				moveNavPhotoSinglePos('s',currentstartp);
				
			} else {
				nothingbefore = true;
			}
		}
		//calldebugPrint(dbb);
	}
	else if (_type=='next') {
		//var dbb='NEXT +';
		for (var ii=1;ii<_xmlobj.childNodes.length;ii++) {
			if (Number(_xmlobj.childNodes[ii].childNodes[0].firstChild.data)>0) {
				photonavmanager.add(Number(_xmlobj.childNodes[ii].childNodes[0].firstChild.data),
									String(_xmlobj.childNodes[ii].childNodes[1].firstChild.data),
									String(_xmlobj.childNodes[ii].childNodes[3].firstChild.data),
									String(_xmlobj.childNodes[ii].childNodes[2].firstChild.data),
									true);
				
				totalp++;
				var id = photonavmanager.photos.length-1;
				//dbb=dbb+'['+photonavmanager.photos[id]['id']+'] ';
				addNavPhoto(currentstartp+totalp-1,photonavmanager.photos[id]['id'],photonavmanager.photos[id]['title'],photonavmanager.photos[id]['src'])
				moveNavPhotoSinglePos('s',currentstartp+totalp-1);
				
			} else {
				nothingafter = true;
			}
		}
		//calldebugPrint(dbb);
	}
	_xmlobj = null;
	
	if (_type=='prev'||_type=='next') hideNavProgressiveLoading();
}

function resetNavPhoto() {
	$('navigator-photos').setInnerHTML('');
	totalp=0;
}

function addNavPhoto(ii,id,title,src) {
	$('navigator-photos').appendChild(createA('','javascript:activePhoto('+id+');','','')).appendChild(createImg('photonavt'+ii,pathphotos+src,'').setProperty('class','t'));
	$('photonavt'+ii).setTop(topb);
	$('photonavt'+ii).setLeft(-bigw);
	$('photonavt'+ii).setHeight(baseh);
	$('photonavt'+ii).setWidth(basew);
}


/***************************************************************/
/* Gestione Navigator Photos Moves */

var nothingbefore;
var nothingafter;

var currentstartp = 0;

var totalp;
var currentp;
var durationp = 500;
var spacep = 0;

var rangep = 3; //numero pari!
var rangept = rangep*2+1;

function setRange(value) {
	rangep = value;
	rangept = rangep*2+1;
}

var basew = 90, baseh = 67.5;
var bigw = 120, bigh = (bigw*baseh)/basew;
var topb = 50, tops = 37;

var distancep = 10;

var transnavigatorphoto = false;

var navtitleid = 1;
	
function moveNavPhotoCalcPos(_index) {
	return _index-currentp;
}

function moveNavPhotoCalcLeft(_relativeindex) {
	var left = (spacep/2)-(bigw/2);
	if (_relativeindex>0) {
		left=left+(bigw+distancep)+((basew+distancep)*(_relativeindex-1));
	}else if (_relativeindex<0) {
		left=left+((basew+distancep)*(_relativeindex));
	}
	return left;
}

function moveNavPhotoPos(_mode) {
	// _mode > i = immediata > a = animata > s = starting (semi animata)
	
	if (_mode=='a') transnavigatorphoto = true;
	
	for (ii=currentstartp;ii<totalp+currentstartp;ii++) {
		moveNavPhotoSinglePos(_mode,ii);
	}
	
	if (_mode=='a') setTimeout(function() { transnavigatorphoto = false },durationp+50);
}
	
function moveNavPhotoSinglePos(_mode,ii) {
	
		var inside = false;
		var left = 0, height = 0, width = 0, top = 0, opacity = 0;
		var tt = moveNavPhotoCalcPos(ii-currentstartp);
		
		if (tt<-rangep) { left = 0-(bigw+distancep); opacity = 0;  } //uscita sinistra
		else if (tt>rangep) { left = spacep+bigw+distancep; opacity = 0; } //uscita destra
		else { left = moveNavPhotoCalcLeft(tt); opacity = 1; inside = true; } //dentro
			
		if (tt==0) {
			top = tops; height = bigh; width = bigw;
			if (_mode=='i') {
				$('navigator-photos-title'+navtitleid).setInnerHTML(photonavmanager.photos[ii-currentstartp]['title']);
			}else{
				$('navigator-photos-title'+navtitleid).fxMorph({'duration': durationp }).start({'opacity':0});
				navtitleid = (navtitleid==1)?(2):(1);
				$('navigator-photos-title'+navtitleid).setInnerHTML(photonavmanager.photos[ii-currentstartp]['title']);
				$('navigator-photos-title'+navtitleid).fxMorph({'duration': durationp }).start({'opacity':1});
			}
		} //centrale
		else { top = topb; height = baseh; width = basew; } //altro
		
		if (_mode=='a') {
			var options = new Object();
			var act = false;
			if ($('photonavt'+ii).getStyleLeft()!=left+'px') { options.left = left; act = true; }
			if ($('photonavt'+ii).getStyleTop()!=top+'px') { options.top = top; act = true; }
			if ($('photonavt'+ii).getStyleHeight()!=height+'px') { options.height = height; act = true; }
			if ($('photonavt'+ii).getStyleWidth()!=width+'px') { options.width = width; act = true; }
			if ($('photonavt'+ii).getOpacity()!=opacity) { options.opacity = opacity; act = true; }
			if (act) $('photonavt'+ii).fxMorph({'duration': durationp }).start(options);
		}
		else {
			$('photonavt'+ii).setLeft(left);
			if (_mode=='s' && inside) {
				/*if (ii%2!=0) */$('photonavt'+ii).setTop(0-bigh-10);
				//else $('photonavt'+ii).setTop($('navigator-photos').getRealHeight()+bigh+10);
				$('photonavt'+ii).fxMorph({'duration': durationp+Math.ceil(100*Math.random())
,'transition': Fx.Transitions.Bounce.easeOut }).start({'top':top});
			}
			else $('photonavt'+ii).setTop(top);
			$('photonavt'+ii).setOpacity(opacity);
			$('photonavt'+ii).setWidth(width);
			$('photonavt'+ii).setHeight(height);
		}
}

function moveNavPhotoNext(moves) {
	if (transnavigatorphoto || (currentp == totalp-1)) return;
	if (moves==null) moves = 1
	currentp=currentp+moves; 
	if (currentp >= totalp) currentp = totalp-1
	
	checkNavPhotoProgressiveLoading();
	moveNavPhotoPos('a');
}

function moveNavPhotoPrev(moves) {
	if (transnavigatorphoto || (currentp == 0)) return;
	if (moves==null) moves = 1
	currentp=currentp-moves;
	if (currentp < 0) currentp = 0;
	
	checkNavPhotoProgressiveLoading()
	moveNavPhotoPos('a');
}

function moveNavPhotoWheel(event) {
	event = new Event(event);
	if (event.wheel > 0) { /*$('navigator-photos').getElements('.speed.right').highlight('#E2A5A5');*/ moveNavPhotoNext(rangept); }
	if (event.wheel < 0) { /*$('navigator-photos').getElements('.speed.left').highlight('#E2A5A5');*/ moveNavPhotoPrev(rangept); }
}


/***************************************************************
 E' FINITO, COSA VOLEVATE ANCORA?
 ***************************************************************/

function makeCoffee() { alert('un espresso buono come al bar'); }
