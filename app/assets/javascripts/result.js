
$(document).ready( function() {
	var pageMaps = {}; 

	function initMap(lat, lng, name, obj) {
	  var myLatLng = {lat: lat, lng: lng};

	  var map = new google.maps.Map(obj, {
	    zoom: 16,
	    center: myLatLng
	  });

	  var marker = new google.maps.Marker({
	    position: myLatLng,
	    map: map,
	    title: name
	  });

	  pageMaps[map] = marker; 
	}

	function closeMore(){
		$(".learn_more_box").addClass("hidden");
		$(".learn_more_button").val("expand");
	}

	function closeMap(){
		$(".map_container").addClass("hidden");
		$(".map_button").val("see map");
	}

	$('.learn_more_button').on("click", function(){
		if( $(this).parent().children(".learn_more_box").hasClass("hidden") ){
			closeMore(); 
			closeMap();
			$(this).parent().children(".learn_more_box").removeClass("hidden"); 
			$(this).val("hide");
			$('body, html').animate({ scrollTop: $($(this).parent()).offset().top });
		} else {
			$(this).parent().children(".learn_more_box").addClass("hidden"); 
			$(this).val("expand");
		}
	});

	$('.map_button').on("click", function(){
		var mapContainer = $(this).parent().children(".map_container")[0]; 
		if( $(mapContainer).hasClass("hidden") ){
			closeMore(); 
			closeMap();
			$(this).parent().children(".map_container").removeClass("hidden");
			$(this).val("hide map"); 
			$('body, html').animate({ scrollTop: $($(this).parent()).offset().top });
			if( !$(mapContainer).hasClass("exists") ){
				var lat = parseFloat(mapContainer.getElementsByClassName("lat")[0].value); 
				var lng = parseFloat(mapContainer.getElementsByClassName("lng")[0].value); 
				var name = mapContainer.getElementsByClassName("name")[0].value;
				
				if(name.length > 100) name  = name.substr(0,97) + "..."; 
				while (mapContainer.firstChild) mapContainer.removeChild(mapContainer.firstChild);
				console.log(lat, lng); 
				initMap(lat, lng, name, mapContainer); 
				$(mapContainer).addClass("exists"); 
			} 
		} else {
			$(this).parent().children(".map_container").addClass("hidden");
			$(this).val("see map"); 
		}
	}); 

});