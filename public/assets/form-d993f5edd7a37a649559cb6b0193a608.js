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
			dataType: 'json',
			type: 'GET',
			timeout: 20000,
			success: function(result){
				$('.dbquery').on('click', function(e){});
	      $('.dbquery').prop('disabled', false);
	      $('input[name="lat"]').val(result.latitude); 
	      $('input[name="long"]').val(result.longitude);
	    
	    }, 
	  	error: function(data){
	  		$('.dbquery').prop('disabled', false);
	  		$('.dbquery').on('click', function(e){
	  			e.preventDefault();
	  			$('.ipDialog').removeClass("hidden");
	  			$('.ipDialog .dialog-box span').text("Can not submit your request. I cannot discern your location."); 
	  		});
	  	}
	  });
	}
})
;
