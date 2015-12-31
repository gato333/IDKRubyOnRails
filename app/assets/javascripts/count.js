function requestCount(currentTotal, refreshTime, failCount){
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
			  if(currentTotal < data.all) {
			  	setTimeout( function () {
			  		requestCount(data.all, initalWait, 0);
			  	}, initalWait);
			  }else if(failCount < 10) {
			  	setTimeout( function(){
						requestCount(currentTotal, refreshTime*2, failCount + 1);
					}, refreshTime)
			  }
			}
	});
}



$(document).ready( function() {

	var totalAll = $('#all')[0].innerHTML; 
	var initalWait = 200;
	setTimeout( function(){
		requestCount(totalAll, initalWait, 0);
	}, initalWait);
	
});