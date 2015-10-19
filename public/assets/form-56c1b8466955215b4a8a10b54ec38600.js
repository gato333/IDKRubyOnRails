$(document).ready( function() {
	
		//  submit is disabled until the ajax call finishes, and is successful
	$('.dbquery').prop('disabled', true);

//  removes red from form elements on focus
	//  gives reactive look
	$('.error').on("onfocus click", function(){
		$(this).removeClass("error");
	});

	//ip problems dialog click events
	$('.ipDialog .x-button').on('click', function(){
		$('.ipDialog').addClass('hidden');
	});
	$('.ipDialog .refresh-button').on('click', function(){
		location.reload();
	});

	//  gets the ip which ruby has saved into website
	//  ajax call is then ulized to retrieve the geolocation of 
	//  the supplied ip address, and embeds it in the page, 
	//  also enables the submit on success, error msg on failure
	var ip = $('.ipHolder').val(); 
	console.log(ip);
	
	if ( typeof ip === 'undefined' ){
		$('.ipDialog').removeClass("hidden");
	} else {
		$.ajax({ 
			url: 'https://freegeoip.net/json/' + ip, 
			dataType: 'jsonp',
			type: 'GET',
			success: function(result){
	      $('.dbquery').prop('disabled', false);
	      $('input[name="lat"]').val(result.latitude); 
	      $('input[name="long"]').val(result.longitude); 
	    }, 
	  	error: function(data){
	  		$('.dbquery').on('click', function(){
	  			alert("Can not submit your request. I cannot discern your location.")
	  		});
	  		console.log("errors"); 
	  		console.log(data);
	  	}
	  });
	}
})
;
