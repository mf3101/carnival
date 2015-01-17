/****************************************************************************
 *	COMMON CARNIVAL
 *	Funzioni e classi comuni per carnival
 ****************************************************************************
 *	MENU:
 *    - EXTEND: Element improvments
 *	  - DOM: manipulates dom
 *    - SIZE'n'POSITION: info about size&positions
 *	  - NAVSNIFFER: info about client
 *    - AHAH: Asychronous HTML and HTTP
 ****************************************************************************
 * @version         SVN: $Id: commons.js 111 2010-10-11 13:00:10Z imente $
 ****************************************************************************/



/****************************************************************************
 *	ELEMENT EXTEND
 *	extends element functionalities
 ****************************************************************************
 *	created by Simone Cingano
 ****************************************************************************/

Element.implement({
	//DOM SHORTCUTS
	show: function() { this.style.display = ''; return this; },
	hide: function() { this.style.display = 'none'; return this; },
	isVisible: function() { return (this.style.display=='none')?false:true },
	getWidth: function() { return this.offsetWidth; },
	setWidth: function(w) { this.style.width = w +"px"; return this; },
	getRealWidth: function() { return this.scrollWidth; },
	getStyleWidth: function() { return this.style.width; },
	getHeight: function() { return this.offsetHeight; },
	setHeight: function(h) { this.style.height = h+"px"; return this; },
	getRealHeight: function() { return this.scrollHeight; },
	getStyleHeight: function() { return this.style.height; },
	setTop: function(t) { this.style.top = t +"px"; return this; },
	setLeft: function(t) { this.style.left = t +"px"; return this; },
	getTop: function() { return getPosY(this); },
	getLeft: function() { return getPosX(this); },
	getStyleTop: function() { return this.style.top; },
	getStyleLeft: function() { return this.style.left; },
	setSrc: function(src) {	this.src = src; return this; },
	setInnerHTML: function(content) { this.innerHTML = content; return this; },
	setOpacity: function(value) { this.set('opacity',value); return this; },
	getOpacity: function(value) { return this.get('opacity'); },
	
	//MOO.FX SHORTCUTS
	fxOpacity: function(el,options){ return new Fx.Opacity(el, options); },
	fxWidth: function(el,options){ return new Fx.Width(el, options); },
	fxHeight: function(el,options){	return new Fx.Height(el, options); },
	
	fxTween: function(options) { return new Fx.Tween(this, options); },
	fxMorph: function(options) { return new Fx.Morph(this, options); }
	
});



/****************************************************************************
 *	DOM MANIPULATION
 ****************************************************************************
 *	created by Simone Cingano
 ****************************************************************************/

function createA(id,href,onclick,title) {
	var objHtml;
	objHtml = document.createElement("a");
	if (id!='') $(objHtml).setProperty('id',id);
	$(objHtml).setProperty('href',href);
	if (onclick!='') $(objHtml).addEvent('click',onclick);
	if (title!='') $(objHtml).setProperty('title',title);
	return objHtml;
}

function createDiv(id,cls) {
	var objHtml;
	objHtml = document.createElement("div");
	if (id!='') $(objHtml).setProperty('id',id);
	if (cls!='') $(objHtml).setProperty('class',cls);
	return objHtml;
}

function createImg(id,src,alt) {
	var objHtml;
	objHtml = document.createElement("img");
	if (id!=''&&id!=null) $(objHtml).setProperty('id',id);
	if (src!=''&&src!=null) $(objHtml).setProperty('src',src);
	$(objHtml).setProperty('alt',alt);
	return objHtml;
}

// -----------------------------------------------------------------------------------

function hideElementsByClass(className,zeroSize) {
 var els = $(document.body).getElements('.'+className)
 for (var i=0; i<els.length; i++) {
   //if (zeroSize==0 || zeroSize==2) $(els[i]).setHeight(0);
   //if (zeroSize==1 || zeroSize==2) Element.setWidth(els[i],0);
   $(els[i]).setStyles({ 'height' : $(els[i]).getHeight() ,
						 'display' : 'none' });
 }
}

// -----------------------------------------------------------------------------------

function switchDisplay(el) {
	var height = $(el).getStyle('height');
	if (!$(el).isVisible()) {
		$(el).setStyle('height',0);
		$(el).show();
		$(el).fxTween({ 'duration': 500, 
				 	  	'transition': Fx.Transitions.Quad.easeOut
					 }).start('height',height);
	} else {
		
		$(el).fxTween({ 'duration': 500, 
						'transition': Fx.Transitions.Quad.easeOut,
						'onComplete': function() { $(el).hide(); $(el).setStyle('height',height); }
					 }).start('height',0);
	}
}



/****************************************************************************
 *	SIZE'n'POSITION
 ****************************************************************************
 *	edited by Simone Cingano
 ****************************************************************************/

//
// getPageScroll()
// Returns array with x,y page scroll values.
// Core code from - quirksmode.org
// Fully tested FF2/3, Opera7+, IE6+, Safari3+
//
function getPageScroll(){

	var yScroll, xScroll;

	if (self.pageYOffset) {
		yScroll = self.pageYOffset;
		xScroll = self.pageXOffset;
	} else if (document.documentElement && document.documentElement.scrollTop){	 // Explorer 6 Strict
		yScroll = document.documentElement.scrollTop;
		xScroll = document.documentElement.scrollLeft;
	} else if (document.body) {// all other Explorers
		yScroll = document.body.scrollTop;
		xScroll = document.body.scrollLeft;
	}

	arrayPageScroll = new Array(xScroll,yScroll);
	return arrayPageScroll;
}

// -----------------------------------------------------------------------------------

//GETPOSITION functions
function getPosY(obj) {
	var posTop = 0;
	while (obj.offsetParent) { posTop += obj.offsetTop;	obj = obj.offsetParent;	}
	return posTop;
}
function getPosX(obj) {
	var posLeft = 0;
	while (obj.offsetParent) { posLeft += obj.offsetLeft; obj = obj.offsetParent; }
	return posLeft;
}



/****************************************************************************
 *	MODULE NAVSNIFFER (navsniffer.js)
 *	original code (?)
 *	a simple user-agent sniffer
 ****************************************************************************
 *	edited by Simone Cingano
 ****************************************************************************/

var agt = navigator.userAgent.toLowerCase();
var appVer = navigator.appVersion.toLowerCase();

var is_minor = parseFloat(appVer);
var is_major = parseInt(is_minor);

var iePos = appVer.indexOf('msie');
if (iePos !=-1) {
   is_minor = parseFloat(appVer.substring(iePos+5,appVer.indexOf(';',iePos)))
   is_major = parseInt(is_minor);
}

var is_konq = false;
var kqPos   = agt.indexOf('konqueror');
if (kqPos !=-1) {                 
   is_konq  = true;
   is_minor = parseFloat(agt.substring(kqPos+10,agt.indexOf(';',kqPos)));
   is_major = parseInt(is_minor);
}     

var is_opera = (agt.indexOf("opera") != -1);
var is_safari = (agt.indexOf('safari')!=-1)?true:false;
var is_khtml  = (is_safari || is_konq);	
var is_fx   = (agt.indexOf('firefox')!=-1);
var is_win   = ( (agt.indexOf("win")!=-1) || (agt.indexOf("16bit")!=-1) );
var is_ie   = ((iePos!=-1) && (!is_opera) && (!is_khtml));
var is_ie4up = (is_ie && is_minor >= 4);
var is_ie5_5up = (is_ie && is_minor >= 5.5);
var is_ie_max6 = (is_ie && is_minor <= 6);
var is_ie7_7up = (is_ie && is_minor >= 7);


/****************************************************************************
 *	AHAH
 *	Asychronous HTML and HTTP
 *	original code from Microformats (http://microformats.org/wiki/rest/ahah)
 ****************************************************************************
 *	edited by Simone Cingano (1.2)
 *	   - added XML queue
 ****************************************************************************/

var ahahReq = [];

function ahah(url, target, postdata, loading, base, done) {
  // Clean resources
  idx = ahahReq.length-1;
  while (ahahReq[idx]==null) { ahahReq.pop(); if (--idx < 0) break; }
  // Create request
  document.getElementById(target).innerHTML = loading;
  if (window.XMLHttpRequest) newrequest = new XMLHttpRequest();
  else if (window.ActiveXObject) newrequest = new ActiveXObject("Microsoft.XMLHTTP");
  else alert('Unable to instance an XMLHttpRequest Object');
  var ahahReqIndex = parseInt(ahahReq.push(newrequest)-1);

  req = ahahReq[ahahReqIndex];
  // Send request
  if (req != undefined) {
    var test = parseInt(Math.random()*1000)+ahahReqIndex*10;
    req.onreadystatechange = function() {ahahDone(url, target, ahahReqIndex, loading, base, done);};
	if (postdata!='' && postdata != null) { /* POST request */
		req.open("POST", url, true);
		req.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		req.setRequestHeader("Connection","close"); 
		req.send(postdata);
	} else { /* GET request */
		req.open("GET", url, true);
		req.send("");
	}
  }
}

//**redirect version (fix opera bug)
//when response starts with "redirect>" send a new request using the given url
//example of redirect in responseText: "redirect>mypage.asp?id=5"
function ahahDone(url, target, index, loading, base, done) {
  req = ahahReq[index];
  if (req.readyState == 4) {
    var t = document.getElementById(target);
    if (req.status == 200) {
		  if (req.responseText.substring(0,9)=='redirect>') ahah(req.responseText.substring(9), target, '', loading, base);
		  else { t.innerHTML = base + req.responseText; }
	  } else {
		  t.innerHTML = base + "<b>ahah error:</b><br/>\n"+req.statusText+'\n<hr/>'+req.responseText;
	  }
	if (done!='') eval(done);
  ahahReq[index] = null; //destroy object
  }
}

/****************************************************************************/
/****************************************************************************/
