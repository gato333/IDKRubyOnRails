
function trigger_edit_descripton(){
	$(".edit_description").removeClass('hidden'); 
	$('.description').addClass('hidden');
	$('.edit_description_button').addClass('hidden'); 
}

function cancel_description_edit(){
	$(".edit_description").addClass('hidden');
	$('.description').removeClass('hidden');
	$('.edit_description_button').removeClass('hidden'); 
}