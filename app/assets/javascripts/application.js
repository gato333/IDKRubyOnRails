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



$(document).ready( function() {
	//  top nav click events
	//  may or not be necessary since the page redirects 
	//  too fast most of the times to bear the fruit of the
	//  animation tranistion that this funciton would create
	$(".fa").on("click", function(){
		if( !$(this).hasClass("active") ){
			$(".fa").removeClass("active");
			$(this).addClass("active");
		}
	});

	$(".user_nav ul > li").on("click", function(){
		var cl = this.className;
		if( $('div.'+cl).hasClass('hidden') ){
			$('.user_nav div').addClass('hidden'); 
			$('.user_nav div.'+cl).removeClass('hidden'); 
		} else 
			$('div.'+cl).addClass('hidden'); 
	});

	$(".user_nav ul > li, .user_nav ul > div").on("mouseenter", function(){
			var cl = this.className;
			if( $('div.'+cl).hasClass('hidden') ){
				$('.user_nav div').addClass('hidden'); 
				$('.user_nav div.'+cl).removeClass('hidden'); 
			}
	});

	$(".user_nav ul > div").on("mouseleave", function(){
			var cl = this.className;
			if( !$('div.'+cl).hasClass('hidden') ){
				$('div.'+cl).addClass('hidden');
			}
	});

	$(".user_nav ").on("mouseleave", function(){
			$('.user_nav div').addClass('hidden');
	});

});