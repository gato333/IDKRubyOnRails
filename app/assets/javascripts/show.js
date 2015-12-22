
$(document).ready( function() {

	var mapContainer = $(".map_container")[0]; 
	var lat = parseFloat(mapContainer.getElementsByClassName("lat")[0].value); 
	var lng = parseFloat(mapContainer.getElementsByClassName("lng")[0].value); 
	var name = mapContainer.getElementsByClassName("name")[0].value;

	if(name.length > 100) name  = name.substr(0,97) + "..."; 
	while (mapContainer.firstChild) mapContainer.removeChild(mapContainer.firstChild);

	initMap(lat, lng, name, mapContainer); 

}); 