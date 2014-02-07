/* 
	Stock DHTML functions
 */

var addEvent;
if (document.addEventListener) {
	addEvent = function(element, type, handler) {
		element.addEventListener(type, handler, null);
	}
}
else if (document.attachEvent) {
	addEvent = function(element, type, handler) {
	element.attachEvent("on" + type, handler);
	}
}
else {
	addEvent = new Function; // not supported
}

function getTarget(e) {
	if (window.event && window.event.srcElement)
		return window.event.srcElement ;
	if (e && e.target)
		return e.target ;
	if (!el)
		return false ;
}

function climbDOM(e, tag_type) {
	while (e.nodeName.toLowerCase() != tag_type && e.nodeName.toLowerCase() != 'html') e = e.parentNode ;
	return (e.nodeName.toLowerCase() == 'html') ? null : e ;
}

/* / stock DHTML functions */

function setup() {
	if (!document.getElementById) return false ;
	// Get admin options drop-down to redirect to relevant Rails action
	if (document.getElementById('suggest_new')) {
		addEvent(document.getElementById('suggest_new'), 'change', adminMenu, false) ;
	}
	
	// Attach reload to WVW filter
	if (document.getElementById('wvw-filter')) {
		addEvent(document.getElementById('wvw-filter'), 'change', reloadWVW, false) ;
	}
}

function adminMenu() {
	if (document.getElementById('suggest_new') && document.getElementById('suggest_new').value != "") {
		window.location.replace(document.getElementById('suggest_new').value) ;
	}
}

function reloadWVW() {
	if (document.getElementById('wvw-filter') && document.getElementById('wvw-filter').value != "") {
		window.location.replace(document.getElementById('wvw-filter').value) ;
	}
}












addEvent(window, 'load', setup, false) ;