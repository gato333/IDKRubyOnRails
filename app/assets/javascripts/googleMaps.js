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
