
$(document).ready( function() {
	$( "#event_result_startdate, #event_result_enddate" ).datepicker();
	$("input#event_result_imageurl").on('change input', function(){
		$("img").attr("src", this.value); 
	})

});