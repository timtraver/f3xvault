$(document).ready(function(){	

	$('.hider').click(function(){
		$('.header').animate({
			  marginTop: "-=170px",          
		}, 1000);
		$('.grid').animate({
			  marginTop: "-=330px",          
		}, 1000);			
	})
	
	$('.question-href').click(function(){
		$(this).parent().find('em').toggle();
		return false;
	});
	
	$('.question-href').parent().find('em').hide();
	
});