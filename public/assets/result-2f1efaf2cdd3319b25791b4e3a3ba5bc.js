
$(document).ready( function() {
	$('.learn_more_button').on("click", function(){
		if( $(this).parent().children(".learn_more_box").hasClass("hidden") ){
			$(".learn_more_box").addClass("hidden");
			$(".learn_more_button").val("expand");
			$(this).parent().children(".learn_more_box").removeClass("hidden"); 
			$(this).val("hide");
			$('body, html').animate({ scrollTop: $($(this).parent()).offset().top });
		} else {
			$(this).parent().children(".learn_more_box").addClass("hidden"); 
			$(this).val("expand");
		}
	});
});
