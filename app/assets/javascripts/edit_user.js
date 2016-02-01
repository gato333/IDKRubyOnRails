$(document).ready( function() {

	$('input[type="radio"]').on( 'click', function(){
		if($(this).hasClass('checked')){
			$(this).removeClass('checked');
			$(this).prop('checked', false);
		} else{
			$(this).addClass('checked');
			$(this).prop('checked', true);
		} 

	});

});
