$(function(){
	
	$('#loginBtn').click(function() {
		showPopup($("#login-box"));
	});
	$('#videoReg').click(function() {
		showPopup($("#video-submit"));
	});

	$("#deleteContentTop, #deleteContentBot").click(function(){
		showPopup($("#delete-box"));
	});
	
	function showPopup(boxName){
		var loginBox = boxName;
	
		$(loginBox).fadeIn(300);
	
		var popMargTop = ($(loginBox).height() + 24) / 2;
		var popMargLeft = ($(loginBox).width() + 24) / 2;
	
		$(loginBox).css({
			'margin-top' : -popMargTop,
			'margin-left' : -popMargLeft
		});

		loginBox.css("display", "block");
		$('body').append('<div id="mask"></div>');
		$('#mask').fadeIn(300);
		return false;
	}
	
	$('body').on('click', '#mask', function() {
		$('#mask , .login-popup').fadeOut(300, function() {
			$('#mask').remove();
		});
		return false;
	});
});