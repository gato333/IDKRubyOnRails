function requestCount(current, refreshTime, failCount){
	var initalWait = 200;
	$.ajax({
			method: "GET",
		  url: "/count.json",
			error :function(e){
				console.log(e);
				console.log("failed to get new count.")
			},
			success: function(data) {
				$('#all')[0].innerHTML = data.all;
			  $('#valid')[0].innerHTML = data.valid;
			  if(current.all !== data.all || current.valid !== data.valid ) 
			  	setTimeout( function () {
			  		requestCount( data, initalWait, 0);
			  	}, initalWait);
			  else if(failCount < 10) 
			  	setTimeout( function(){
						requestCount(data, refreshTime*2, failCount + 1);
					}, refreshTime); 
			}
	});
}

$(document).ready( function() {
	var current = {
		all: parseInt($('#all')[0].innerHTML), 
		valid: parseInt($("#valid")[0].innerHTML)
	}
	var initalWait = 200;
	setTimeout( function(){
		requestCount(current, initalWait, 0);
	}, initalWait);
	
});