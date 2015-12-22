
$(document).ready( function() {

	$("input#event_result_imageurl").on('change input', function(){
		$("img").attr("src", this.value); 
	})

});