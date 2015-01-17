/****************************************************************************
 *	AHAH
 *	Asychronous HTML and HTTP
 *	original code from Microformats (http://microformats.org/wiki/rest/ahah)
 ****************************************************************************
 *	edited by Simone Cingano
 ****************************************************************************
 * @version         SVN: $Id: ahah.js 8 2008-05-22 00:26:46Z imente $
 ****************************************************************************/

function ahah(url, target, postdata, loading, base, done) {
  document.getElementById(target).innerHTML = loading;
  if (window.XMLHttpRequest) {
    req = new XMLHttpRequest();
  } else if (window.ActiveXObject) {
    req = new ActiveXObject("Microsoft.XMLHTTP");
  }
  if (req != undefined) {
    req.onreadystatechange = function() {ahahDone(url, target, loading, base, done);};
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
function ahahDone(url, target, loading, base, done) {
  
  if (req.readyState == 4) {
    var t = document.getElementById(target);
    if (req.status == 200) {
		if (req.responseText.substring(0,9)=='redirect>') ahah(req.responseText.substring(9), target, '', loading, base);
		else t.innerHTML = base + req.responseText;
	}
    else {
		t.innerHTML = base + "<b>ahah error:</b><br/>\n"+req.statusText+'\n<hr/>'+req.responseText;
	}
	if (done!='') eval(done);
  }
}