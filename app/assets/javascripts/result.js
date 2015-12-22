
$(document).ready( function() {
	function closeMore(){
		$(".learn_more_box").addClass("hidden");
		$(".learn_more_button").val("expand");
	}

	$('.learn_more_button').on("click", function(){
		var mapContainer = $(this).parent().children(".learn_more_box").children(".map_container")[0]; 
		if( $(this).parent().children(".learn_more_box").hasClass("hidden") ){
			//delete all others that are open 
			closeMore(); 
			$(mapContainer).removeClass("hidden");
			//if map obj doesnt exist we create it 
			if( !$(mapContainer).hasClass("exists") ){
				var lat = parseFloat(mapContainer.getElementsByClassName("lat")[0].value); 
				var lng = parseFloat(mapContainer.getElementsByClassName("lng")[0].value); 
				var name = mapContainer.getElementsByClassName("name")[0].value;
				
				if(name.length > 100) name  = name.substr(0,97) + "..."; 
				while (mapContainer.firstChild) mapContainer.removeChild(mapContainer.firstChild);

				initMap(lat, lng, name, mapContainer); 
				$(mapContainer).addClass("exists"); 
			}

			$(this).parent().children(".learn_more_box").removeClass("hidden"); 
			$(this).val("hide");
			$('body, html').animate({ scrollTop: $($(this).parent()).offset().top });
		} else {
			$(mapContainer).addClass("hidden"); 
			$(this).parent().children(".learn_more_box").addClass("hidden"); 
			$(this).val("expand");
		}
	}); 

});