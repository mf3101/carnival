/****************************************************************************
 *	MODULE NAVSNIFFER (navsniffer.js)
 *	original code (?)
 *	a simple user-agent sniffer
 ****************************************************************************
 *	edited by Simone Cingano
 ****************************************************************************
 * @license         http://www.opensource.org/licenses/mit-license.php
 * @version         SVN: $Id: navsniffer.js 8 2008-05-22 00:26:46Z imente $
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