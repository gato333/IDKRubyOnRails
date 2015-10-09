// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .


//click events for random page
function chooseRandomly() {
  choices = $("input[type!='button']").removeClass("error").removeClass("chosen"); 
  var result = $("span.result").text("");

  $(choices).each( function() {
  	console.log($(this).val());
  	if($(this).val() === ""){
  		$(this).addClass("error");
  		$(result).text("All Choices must be filled, put 'nothing' if you must.");  
  	}
  }); 
  if($(result).text() === ""){
	  var chosen = Math.floor(Math.random() * choices.length); 
	  $(result).text($(choices.get(chosen)).addClass("chosen").val()); 
	}
}

function addChoice(){
	var choiceCount = ($("form input[type='text']").length + 1).toString(); 
	var countWord = choiceCount == 3 ? 'rd': 'th'; 
	var newChoice = $('<input type="text" placeholder="'+choiceCount+countWord+' Choice" class= "choice-'+choiceCount+'"><div class="delete-choice choice-'+choiceCount+'" onclick="deleteChoice(this); return false;">x</div>'); 
	$("input[name='addmore']").before(newChoice);
}

function deleteChoice(elem){
	var name = elem.className.replace("delete-choice", "").replace(" ", "");
	$("."+name).remove(); 
}

$(document).ready( function() {
	$('.dbquery').prop('disabled', true);

	//top nav click events
	//may or not be necessary since the page redirects 
	//too fast most of the times to bear the fruit of the
	//animation tranistion that this funciton would create
	$(".fa").on("click", function(){
		if( !$(this).hasClass("active") ){
			$(".fa").removeClass("active");
			$(this).addClass("active");
		}
	});

	var ip = $('.ipHolder').val(); 

	$.ajax({ 
		url: 'http://freegeoip.net/json/' + ip, 
		dataType: 'jsonp',
		type: 'GET',
		success: function(result){
			console.log("result"); 
      console.log(result);
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

});