
//  click events for random page
//  randomly chooses one of the supplied options, given that all the options 
// 	are filled in
function chooseRandomly() {
  choices = $("article#random input[type!='button']").removeClass("error").removeClass("chosen");
  var result = $("span.result").text("");
  var validInput = true; 
  $(choices).each( function() {
  	if($(this).val() === ""){
  		validInput = false; 
  		$(this).addClass("error");
  		$(result).text("All Choices must be filled, put 'nothing' if you must.");  
  	}
  }); 
  if($(result).text() === "" && validInput){
	  var chosen = Math.floor(Math.random() * choices.length); 
	  $(result).text($(choices.get(chosen)).addClass("chosen").val()); 
	}
}

//  adds choice to the randomizer, allows for infinite addition of options
function addChoice(){
	var choiceCount = ($("form input[type='text']").length + 1).toString(); 
	var countWord = choiceCount == 3 ? 'rd': 'th'; 
	var newChoice = $('<input type="text" placeholder="'+choiceCount+countWord+' Choice" class= "choice-'+choiceCount+'"><div class="delete-choice choice-'+choiceCount+'" onclick="deleteChoice(this); return false;">x</div>'); 
	$("input[name='addmore']").before(newChoice);
	$("article#random input[type!='button']").removeClass("error").removeClass("chosen");
}

//  removes choice to the randomizer, except for the first two
function deleteChoice(elem){
	var name = elem.className.replace("delete-choice", "").replace(" ", "");
	$("article#random input[type!='button']").removeClass("error").removeClass("chosen");
	$("."+name).remove(); 
}