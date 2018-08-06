
$(document).ready( function() {

	var mapContainer = $(".map_container")[0]; 
	var lat = parseFloat(mapContainer.getElementsByClassName("lat")[0].value); 
	var lng = parseFloat(mapContainer.getElementsByClassName("lng")[0].value); 
	var name = mapContainer.getElementsByClassName("name")[0].value;

	if(name.length > 100) name  = name.substr(0,97) + "...";

	var latLongArray = [];
	var iterateArray = mapContainer.getElementsByClassName("arrayelm");
	for(var i = 0; i < iterateArray.length; i++){
		var elm = {
			lat: iterateArray[i].getElementsByClassName("lat")[0].value,
			lng: iterateArray[i].getElementsByClassName("lng")[0].value,
			name: iterateArray[i].getElementsByClassName("name")[0].value
		}
		latLongArray.push(elm);
	}
	while (mapContainer.firstChild) mapContainer.removeChild(mapContainer.firstChild);

	initMapMulti(lat, lng, name, mapContainer, latLongArray);

}); 