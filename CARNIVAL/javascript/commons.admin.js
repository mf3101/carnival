/****************************************************************************
 * ADMIN FUNCTIONS
 ****************************************************************************
 * @version         SVN: $Id: commons.admin.js 76 2008-08-12 09:17:19Z imente $
 ****************************************************************************/

function sendValueToPage(info,def,page) {
	var	value = prompt(info,def);
	if (value!=null) document.location.href = page + value;
}

// -----------------------------------------------------------------------------------

function multiselAll(checked) {
	var ii=1;
	while ($('multisel'+ii)) {
		$('multisel'+ii).checked = checked;	
		ii++;
	}
}

/*function multiGetIds() {
	var ret='',ii=1;
	while ($('multisel'+ii)) {
		if($('multisel'+ii).checked) ret=ret+$('multiid'+ii).value+'|';
		ii++;
	}
	if (ret=='') ret = false;
	return ret;
}*/

function multiValid() {
	var ret=false,ii=1;
	while ($('multisel'+ii)&&!ret) {
		if($('multisel'+ii).checked) ret=true
		ii++;
	}
	return ret;
}

// -----------------------------------------------------------------------------------