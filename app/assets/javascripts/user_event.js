function disappear(eventObj){
	$(eventObj).addClass('disappear'); 
	setTimeout( function(){
		eventObj.remove(); 
	}, 1000);
}