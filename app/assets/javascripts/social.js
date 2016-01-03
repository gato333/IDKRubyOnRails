function openMailer(name, description, url){

}

function closeMailer(){


}

$(document).ready( function(){

	$("a.social").on( 'click', function(e){
		e.preventDefault(); 

		var url = "", 
				id = $(this).parent()[0].id, 
				currentUrl = window.location.origin + "/event/" + id, 
				description =  $(this).parent().children("input#description")[0].value, 
				eventName = $(this).parent().parent().children("h3")[0] || $(this).parent().parent().children(".text").children("h3")[0]; 
		eventName = eventName.innerHTML; 
		eventName = eventName.substr(0, eventName.indexOf(' ', 40)); 
		eventName = encodeURIComponent(eventName); 

		if( $(this).hasClass("facebook") ){
			url = "https://www.facebook.com/sharer/sharer.php?u=" + currentUrl;
		} else if ( $(this).hasClass("twitter") ) {
			url = "https://twitter.com/intent/tweet?url=" + currentUrl +"&text="+ eventName + encodeURIComponent(" at IDK NYC") + "&via=idk_nyc"; 
		} else if ( $(this).hasClass("google") ) {
			url = "https://plus.google.com/share?url=" + currentUrl; 
		} else if ( $(this).hasClass("email") ) {
			openMailer( decodeURIComponent(eventName), description, decodeURIComponent(currentUrl) ); 
			return;
		} else if ( $(this).hasClass("tumblr") ) {
			url = "http://www.tumblr.com/share/link?url="  + currentUrl; 
		} else { 
			console.log("weirdness, not valid social media");
			return;
		}
		var newwindow = window.open(url, "Sharing IDK NYC Events", 'height=550,width=500');
		newwindow.focus();

	}); 
}); 