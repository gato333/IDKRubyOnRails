
$(document).ready( function(){

	$("a.social").on( 'click', function(e){
		e.preventDefault()
		console.log(this); 
		var url = "", 
				currentUrl = encodeURIComponent(window.location.href),
		    eventName = $(this).parent().parent().children("h3").text || $(this).parent().parent().children(".text").children("h3").text; 
		eventName = encodeURIComponent(eventName); 
		
		if( $(this).hasClass("facebook") ){
			url = "https://www.facebook.com/sharer/sharer.php?u=" + currentUrl;
		} else if ( $(this).hasClass("twitter") ) {
			url = "https://twitter.com/intent/tweet?text="+ eventName +"%2Fat%2FIDK%2FNYC&url=" + currentUrl +"&via=idkNYC"; 
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