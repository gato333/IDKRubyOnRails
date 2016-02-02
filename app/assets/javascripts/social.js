function favorite_event(fav_button, event_id){
	$.ajax({
	    method: "GET",
	    url: "/fav/" + event_id ,
	    error :function(e){
	    	$(this).removeClass("active");
				console.log("failed favorite event.")
			}
	}); 
}

function unfavorite_event(fav_button, event_id){
	$.ajax({
 			method: "GET",
 		  url: "/unfav/" + event_id ,
 		  error :function(e){
 		  	$(this).addClass("active");
				console.log("failed to unfavorite event.")
			}
 	}); 
}

$(document).ready( function(){

	$("a.social").on( 'click', function(e){
		e.preventDefault(); 

		var url = "", 
				id = $(this).parent()[0].id || $(this).parent().children('.share-obj')[0].id, 
				currentUrl = window.location.origin + "/event/" + id, 
				description =  $(this).parent().children("input#description")[0].value, 
				eventName = $(this).parent().parent().children('.text').children('h3')[0] ||
									  $($(this).parent().children(".text")[0]).children('h3')[0]; 
		eventName = eventName.innerHTML.replace(/\s+/g,' ').trim(); 
		eventName = eventName.substr(0, eventName.indexOf(' ', 40)); 
		eventName = encodeURI(eventName); 

		if( $(this).hasClass("facebook") ){
			url = "https://www.facebook.com/sharer/sharer.php?u=" + currentUrl;
		} else if ( $(this).hasClass("twitter") ) {
			url = "https://twitter.com/intent/tweet?url=" + currentUrl +"&text="+ eventName + encodeURI(" at IDK NYC") + "&via=idk_nyc"; 
		} else if ( $(this).hasClass("google") ) {
			url = "https://plus.google.com/share?url=" + currentUrl; 
		} else if ( $(this).hasClass("email") ) {
			url = "https://mail.google.com/mail/?view=cm&fs=1" +
						"&su=" + encodeURI("Sharing an event with you from IDK NYC") +
						"&body=" + "Found an exciting event, that you'll be interested in." + eventName + 
						"%0A%0A" + encodeURI(currentUrl); 
		} else if ( $(this).hasClass("tumblr") ) {
			url = "http://www.tumblr.com/share/link?url="  + currentUrl; 
		} else if ( $(this).hasClass("fav") ) {
			if( $(this).hasClass("active") ){
				$(this).removeClass("active"); 
				unfavorite_event(this, id); 
				if(typeof disappear !== 'undefined'){
					disappear($(this).parent()); 
				}
			} else {
				$(this).addClass("active").addClass("blink-animation"); 
				favorite_event(this, id);
				var button = this; 
				setTimeout(function() {
		        $(button).removeClass('blink-animation');
		    }, 500);
			}
			return;
		} else{ 
			console.log("weirdness, not valid social media");
			return;
		}
		var newwindow = window.open(url, "Sharing IDK NYC Events", 'height=550,width=500');
		newwindow.focus();
	}); 
}); 