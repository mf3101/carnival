/****************************************************************************
 BALOON
 developed by Simone Cingano (http://www.imente.it)
 ****************************************************************************
 * @license         http://www.opensource.org/licenses/mit-license.php
 * @version         SVN: $Id: baloon.js 18 2008-06-29 02:54:08Z imente $
 ****************************************************************************
 
 needs: prototype.lite.js, moo.fx.js, extend.js
 
 ***************************************************************
 STRUCTURE:
 
 |---------------------------| <-- baloon
 | / |___________________| \ | <-- topleft + border + topright
 ||_________________________|| <-- content
 | \ |___________________| / | <-- bottomleft + border + bottomright
 |---------------------------|
 
 baloon: 					id = baloonID, class = DIVCLASS
 content:					id = baloonIDcontent, class = balooncontent
 border (top e bottom): 	class = border
 topleftborder: 			class = tl-border
 toprightborder: 			class = tr-border
 bottomleftborder: 			class = bl-border
 bottomrightborder: 		class = br-border
 
 ***************************************************************/

function baloonsChecks() { for (var ii=0;ii<Baloon_baloons.length;ii++) eval(Baloon_baloons[ii]+'.check(0);'); }

function baloonAddCheck(arg) { Baloon_baloons.push(arg); }
function baloonClearCheck(arg) { Baloon_baloons = Array(); }
var Baloon_baloons = Array();
 
var Baloon = Class.create();

Baloon.prototype = {
	
	initialize: function() {},
	
	id: String(''), 			/*id della divclasse (l'oggetto principale si chiamerà "baloonID", il contenuto "baloonIDcontent"*/
	instance: String(''), 		/*il nome dell'istanza*/
	caller: String(''), 		/*l'oggetto che richiama la baloon (id dell'oggetto)*/
	divclass: String('baloon'), /*il nome della classe dei baloon*/
	top:Number(0), 				/*posizione top (0 automatico oppure pixel)*/
	left:Number(0), 			/*posizione left (0 automatico oppure pixel)*/
	move:Boolean(false), 		/*se il mouse è sull'oggetto esso non scompare*/
	callerfunc: null,
	
	baloonAction: Number(0),
	baloonState: Number(0),
	
	start: function(id,instance,caller,callerfunc,divclass,top,left,move) {
		
		this.id = id;
		this.instance = instance;
		this.top = top;
		this.left = left;
		this.move = move;
		if (callerfunc != null) this.callerfunc = callerfunc;
		if (divclass != '' && divclass != null) this.divclass = divclass;
		
		var objBaloon = document.createElement("div");
		Element.setAttribute(objBaloon,'id','baloon'+this.id);
		Element.setAttribute(objBaloon,'class',this.divclass);
		if (this.move) {
			Element.setAttribute(objBaloon,'onmouseover',this.instance+'.check(1);');
			Element.setAttribute(objBaloon,'onmouseout',this.instance+'.check(1);');
		}
		$('baloon').appendChild(objBaloon);
		
		//if (callerfunc == null)	Element.setAttribute($(caller),'onmouseover',this.instance+'.show();');
		//else Element.setAttribute($(caller),'onmouseover',callerfunc);
		
		if (caller != null) {
			if (callerfunc == null)	$(caller).onmouseover = function() { eval(instance+'.show();'); };
			else $(caller).onmouseover = callerfunc;
		}
		
		var objRound1, objRound2, objRound3, objAppend, objAppend2
		objRound1 = document.createElement("div");
		Element.setAttribute(objRound1,'class','border-tl');
		objBaloon.appendChild(objRound1);
		objRound2 = document.createElement("div");
		Element.setAttribute(objRound2,'class','border-tr');
		objRound1.appendChild(objRound2);
		objRound3 = document.createElement("div");
		Element.setAttribute(objRound3,'class','border');
		objRound2.appendChild(objRound3);
		objAppend = document.createElement("div");
		Element.setAttribute(objAppend,'class','content');
		objBaloon.appendChild(objAppend);
		objAppend2 = document.createElement("div");
		Element.setAttribute(objAppend2,'id','baloon'+this.id+'content');
		Element.setAttribute(objAppend2,'class','balooncontent');
		objAppend.appendChild(objAppend2);
		objRound1 = document.createElement("div");
		Element.setAttribute(objRound1,'class','border-bl');
		objBaloon.appendChild(objRound1);
		objRound2 = document.createElement("div");
		Element.setAttribute(objRound2,'class','border-br');
		objRound1.appendChild(objRound2);
		objRound3 = document.createElement("div");
		Element.setAttribute(objRound3,'class','border');
		objRound2.appendChild(objRound3);
		
		objRound1 = null; objRound2 = null; objRound3 = null; objAppend = null; objAppend2 = null;
		
		Element.hide('baloon'+this.id);
		
		baloonAddCheck(this.instance);
		
		
	},
	
	setPosition: function(x,y) {
		Element.setLeft('baloon'+this.id,x);
		Element.setTop('baloon'+this.id,y);
	},
	
	place: function(positioning,x,y) {
		if (positioning != 'absolute') {
			if (x != null && y != null) this.setPosition(x+this.left,y+this.top);
			else this.setPosition(this.left,this.top);
		} else {
			if (x != null && y != null) this.setPosition(x,y);
			else this.setPosition(this.left,this.top);
		}
	},
	
	show: function(positioning,x,y) {
		if (this.baloonState == 0) {
			this.place(positioning,x,y);
			this.baloonState=2;
			var instance = this.instance;
			Element.show('baloon'+this.id);
			Element.fxOpacity('baloon'+this.id, { 'duration': 500,
										  'transition': fx.quadOut,
										  'onComplete': function(){	eval(instance+'.baloonState = 1;'); }
										},0).custom(0,1);
		}
	},
	
	forceShow: function(positioning,x,y) {
		this.place(positioning,x,y);
		this.baloonState = 1;
		Element.show('baloon'+this.id);
	},
	
	hide: function() {
		if (this.baloonState == 1) {
			this.baloonState=2;
			var instance = this.instance;
			Element.fxOpacity('baloon'+this.id, { 'duration': 500,
										  'transition': fx.quadOut,
										  'onComplete': function(){
															eval(instance+'.baloonState = 0;');
														}
										},1).custom(1,0);
		}
	},
	
	forceHide: function() {
		this.baloonState = 0;
		Element.hide('baloon'+this.id);
	},
	
	check: function(arg) {
		
		this.baloonAction = Number(arg);
		var instance = this.instance;
		setTimeout(function() { eval(instance+'.checkin();') }, 250);
	},
	
	checkin: function() {
		if (this.baloonAction==0 && this.baloonState==1) this.hide();
	},
	
	end: function() {
		
	}
	
}