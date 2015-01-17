/****************************************************************************
 *	ELEMENT EXTEND
 *	original code (?)
 ****************************************************************************
 *	edited by Simone Cingano
 ****************************************************************************
 * @license         http://www.opensource.org/licenses/mit-license.php
 * @version         SVN: $Id: extend.js 8 2008-05-22 00:26:46Z imente $
 ****************************************************************************/

Object.extend(Element, {
	
	//DOM SHORTCUTS
	show: function(element) { $(element).style.display = ''; },
	hide: function(element) { $(element).style.display = 'none'; },
	isVisible: function(element) { return ($(element).style.display=='none')?false:true },
	getWidth: function(element) { return $(element).offsetWidth; },
	getRealWidth: function(element) { return $(element).scrollWidth; },
	setWidth: function(element,w) { $(element).style.width = w +"px"; },
	getHeight: function(element) { return $(element).offsetHeight; },
	getRealHeight: function(element) { return $(element).scrollHeight; },
	setHeight: function(element,h) { $(element).style.height = h +"px"; },
	setTop: function(element,t) { $(element).style.top = t +"px"; },
	setLeft: function(element,t) { $(element).style.left = t +"px"; },
	getTop: function(element) { return getPosY($(element)); },
	getLeft: function(element) { return getPosX($(element)); },
	setSrc: function(element,src) {	$(element).src = src; },
	setInnerHTML: function(element,content) { $(element).innerHTML = content; },

	//MOO.FX SHORTCUTS
	fxOpacity: function(el,options,start){ return new fx.Opacity(el, options, start); },
	fxWidth: function(el,options){ return new fx.Width(el, options); },
	fxHeight: function(el,options){	return new fx.Height(el, options); }
});

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