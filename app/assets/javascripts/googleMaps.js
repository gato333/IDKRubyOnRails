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

function initMapMulti(lat, lng, name, obj, locationArray){
  var myLatLng = {lat: lat, lng: lng};

  var map = new google.maps.Map(obj, {
    zoom: 16,
    center: myLatLng
  });

  for (var i = 0; i < latlongArray.length; i++) {
    var locationLatLng = {lat: latlongArray[i].latitude, lng: latlongArray[i].longitude };
    var marker = new google.maps.Marker({
      position: locationLatLng,
      map: map,
      title: latlongArray[i].name
    });
    if(i === 0) pageMaps[map] = marker;
  }
}
