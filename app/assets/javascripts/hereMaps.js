function initDefualtLayers(){
   var platform = new H.service.Platform({
      'app_id': hereID,
      'app_code': hereCode
  });
  return platform.createDefaultLayers();
}


function initMap(lat, lng, name, obj) {
  var myLatLng = {lat: lat, lng: lng};
  var defaultLayers = initDefualtLayers();

  var map = new H.Map( obj, defaultLayers.normal.map );
  var behavior = new H.mapevents.Behavior(new H.mapevents.MapEvents(map));
  var ui = H.ui.UI.createDefault(map, defaultLayers);

  map.setCenter(myLatLng);
  map.setZoom(15);
  var marker = new H.map.Marker(myLatLng);
  map.addObject(marker);
}

function initMapMulti(lat, lng, name, obj, latlongArray){
  var myLatLng = {lat: lat, lng: lng};
  var defaultLayers = initDefualtLayers();

  var map = new H.Map( obj, defaultLayers.normal.map );
  var behavior = new H.mapevents.Behavior(new H.mapevents.MapEvents(map));
  var ui = H.ui.UI.createDefault(map, defaultLayers);

  map.setCenter(myLatLng);
  map.setZoom(15);

  var group = new H.map.Group();
  map.addObject(group);
  group.addEventListener('tap', function (evt) {
    var bubble =  new H.ui.InfoBubble(evt.target.getPosition(), {
      content: evt.target.getData()
    });
    ui.addBubble(bubble);
  }, false);

  for (var i = 0; i < latlongArray.length; i++) {
    var locationLatLng = {lat: parseFloat(latlongArray[i].lat), lng: parseFloat(latlongArray[i].lng) };
    var marker = new H.map.Marker(locationLatLng);

    var html =
    '<div id="info_bubble">'+
      '<h2 id="firstHeading" class="firstHeading">' + latlongArray[i].name + '</h1>'+
      '<div id="content">'+
        '<p>' + latlongArray[i].address + '<br>' + latlongArray[i].types + '</p>' +
        '<div class="learn_more">' +
          '<a class="page_link" href="/event/' + latlongArray[i].id + '">learn more</a>' +
        '</div>'+
      '</div>' +
    '</div>';
    marker.setData(html);
    group.addObject(marker);
  }
}
