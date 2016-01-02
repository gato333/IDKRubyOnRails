
$(document).ready( function(){

	$("a.social").on( 'click', function(e){
		e.preventDefault()
		var url = "", 
				id = $(this).parent()[0].id, 
				currentUrl = encodeURIComponent(window.location.host + "/event/" + id), 
				eventName = $(this).parent().parent().children("h3")[0] || $(this).parent().parent().children(".text").children("h3")[0]; 
		eventName = eventName.innerHTML; 
		eventName = eventName.substr(0, eventName.indexOf(' ', 50)); 
		eventName = encodeURIComponent(eventName); 

		console.log(eventName); console.log( currentUrl); 
		if( $(this).hasClass("facebook") ){
			url = "https://www.facebook.com/sharer/sharer.php?u=" + currentUrl;
		} else if ( $(this).hasClass("twitter") ) {
			url = "https://twitter.com/intent/tweet?url=" + currentUrl +"&text="+ eventName + encodeURIComponent(" at IDK NYC") + "&via=idk_nyc"; 
		} else if ( $(this).hasClass("google") ) {
			url = "https://plus.google.com/share?url=" + currentUrl; 
		} else if ( $(this).hasClass("email") ) {
			url = "mailto:all@idknyc.com?subject=" + eventName + "%2Fat%2FIDK%2FNYC%2F" + currentUrl; 
		} else if ( $(this).hasClass("tumblr") ) {
			url = "http://www.tumblr.com/share/link?url="  + currentUrl; 
		} else { 
			console.log("weirdness, not valid social media");
			return;
		}
		var newwindow = window.open(url, "Sharing IDK NYC Events", 'height=550,width=350');
		newwindow.focus();

	}); 
}); 