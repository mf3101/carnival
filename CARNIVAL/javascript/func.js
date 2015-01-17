/***************************************************************
 PAGESCROLL and PAGESIZE
 original code quirksmode.org
 ***************************************************************/
 
//
// getPageScroll()
// Returns array with x,y page scroll values.
// Core code from - quirksmode.org
//
function getPageScroll(){

	var yScroll;

	if (self.pageYOffset) {
		yScroll = self.pageYOffset;
	} else if (document.documentElement && document.documentElement.scrollTop){	 // Explorer 6 Strict
		yScroll = document.documentElement.scrollTop;
	} else if (document.body) {// all other Explorers
		yScroll = document.body.scrollTop;
	}

	arrayPageScroll = new Array('',yScroll) 
	return arrayPageScroll;
}

// -----------------------------------------------------------------------------------

//
// getPageSize()
// Returns array with page width, height and window width, height
// Core code from - quirksmode.org
// Edit for Firefox by pHaez
//
function getPageSize(){
	
	var xScroll, yScroll;
	
	if (window.innerHeight && window.scrollMaxY) {	
		xScroll = document.body.scrollWidth;
		yScroll = window.innerHeight + window.scrollMaxY;
	} else if (document.body.scrollHeight > document.body.offsetHeight){ // all but Explorer Mac
		xScroll = document.body.scrollWidth;
		yScroll = document.body.scrollHeight;
	} else { // Explorer Mac...would also work in Explorer 6 Strict, Mozilla and Safari
		xScroll = document.body.offsetWidth;
		yScroll = document.body.offsetHeight;
	}
	
	var windowWidth, windowHeight;
	if (self.innerHeight) {	// all except Explorer
		windowWidth = self.innerWidth;
		windowHeight = self.innerHeight;
	} else if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict Mode
		windowWidth = document.documentElement.clientWidth;
		windowHeight = document.documentElement.clientHeight;
	} else if (document.body) { // other Explorers
		windowWidth = document.body.clientWidth;
		windowHeight = document.body.clientHeight;
	}	
	
	// for small pages with total height less then height of the viewport
	if(yScroll < windowHeight){
		pageHeight = windowHeight;
	} else { 
		pageHeight = yScroll;
	}

	// for small pages with total width less then width of the viewport
	if(xScroll < windowWidth){	
		pageWidth = windowWidth;
	} else {
		pageWidth = xScroll;
	}

	arrayPageSize = new Array(pageWidth,pageHeight,windowWidth,windowHeight) 
	return arrayPageSize;
}

// -----------------------------------------------------------------------------------

function hideElementsByClass(className,zeroSize) {
 var els = document.getElementsByClassName(className);
 for (var i=0; i<els.length; i++) {
   if (zeroSize==0 || zeroSize==2) Element.setHeight(els[i],0);
   if (zeroSize==1 || zeroSize==2) Element.setWidth(els[i],0);
   els[i].style.display = 'none';
 }
}

// -----------------------------------------------------------------------------------

function switchDisplay(el) {
	if (!Element.isVisible(el)) {
		Element.show(el);
		Element.fxHeight(el, { 'duration': 500,
						       'transition': fx.quadOut
							 }).custom(0,Element.getRealHeight(el)); 
	} else {
		Element.fxHeight(el, { 'duration': 500,
						 	   'transition': fx.quadOut,
							   'onComplete': function() {
								   			   Element.hide(el);
											 }
							 }).custom(Element.getRealHeight(el),0); 
	}
}

// -----------------------------------------------------------------------------------

function createA(id,href,onclick,title) {
	var objHtml
	objHtml = document.createElement("a");
	if (id!='') Element.setAttribute(objHtml,'id',id);
	Element.setAttribute(objHtml,'href',href);
	if (onclick!='') Element.setAttribute(objHtml,'onclick',onclick);
	if (title!='') Element.setAttribute(objHtml,'title',title);
	return objHtml;
}

function createDiv(id) {
	var objHtml
	objHtml = document.createElement("div");
	if (id!='') Element.setAttribute(objHtml,'id',id);
	return objHtml;
}

function createImg(id,src,alt) {
	var objHtml
	objHtml = document.createElement("img");
	if (id!='') Element.setAttribute(objHtml,'id',id);
	if (src!='') Element.setAttribute(objHtml,'src',src);
	Element.setAttribute(objHtml,'alt',alt);
	return objHtml;
}