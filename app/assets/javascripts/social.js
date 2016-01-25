function favorite_event(event_id){
	$.ajax({
	    method: "GET",
	    url: "/favorite/" + event_id + ".json",
	    error :function(e){
				console.log(e);
				console.log("failed favorite event.")
			},
			success: function(data) {
				console.log(data);
				console.log("success favorited event.")
			}
	}); 
}

function unfavorite_event(event_id){
	$.ajax({
 			method: "GET",
 		  url: "/unfavorite/" + event_id + ".json",
 		  error :function(e){
				console.log(e);
				console.log("failed to unfavorite event.")
			},
			success: function(data)  {
				console.log(data);
				console.log("success unfavorited event.")
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
				eventName = $(this).parent().parent().children("h3")[0] ||  $($(this).parent().children(".text")[0]).children('h3')[0]; 
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
				unfavorite_event(id); 
			} else {
				$(this).addClass("active"); 
				favorite_event(id);
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