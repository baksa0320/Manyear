function videoCheck(nickname) {
	var start_length = $("#startLength").val();
	var video_length = $("#totalLength").val();
	var video_src = $("#videoSrc").val();
	var numLength = Number(video_length)
	if (video_src.length == 0) {
		alert("영상주소를 입력하세요.");
		return false;
	} else if (start_length.length == 0) {
		alert("시작시간을 입력해주세요.");
		return false;
	} else if (video_length.length == 0) {
		alert("종료 시간을 입력해주세요.");
		return false;
	} else if (Number(video_length) - Number(start_length) > 1800) {
		alert("재생 시간이 30분을 넘을 수 없습니다.");
		return false;
	} else if (video_src.indexOf("youtu.be") == -1) {
		alert("영상주소가 올바르지 않습니다.");
		return false;
	} else {
		video_src = video_src.substring(video_src.indexOf(".be") + 4);
		var desc = '';
		if($("#description").val() != 'null')
			desc = $("#description").val();
		
		var scores = Number(video_length) * 10;
		
		 $.ajax({
		        type: "post",
		        url: "videoData.jsp",
		        data: {
		        	nick: nickname,
		        	name: video_src,
		        	description: desc,
		        	starts: start_length,
		        	length: video_length,
		        	score: scores
		        },
		        success: function videoSuccess(data){
		        	if($.trim(data) == 'true'){
			        	alert("등록되었습니다.");
			    		$('#mask , .login-popup').fadeOut(300, function() {
			    			$('#mask').remove();
			    		});
			    		var getScore = $('#userScore').val().replace('점수: ', '');
			    		
			    		var getScoreNum = Number(getScore) - scores;
			    		$('#userScore').val(getScoreNum);
			    		
			    		if(!videoPlay){
			    			videoNum - 1;
			    			$(location).attr('href',"/board");
			    		}
		        	} else
			        	alert("점수가 부족합니다.");
		        },
		        error: function Error(){
		        	alert("서버가 불안정 합니다.");
		        }
	  	});
	}
}

function timeChange(lengthText){
	
	if(lengthText.value.indexOf(":") != -1){
		var time = lengthText.value.split(":");
		var changeLength;
		if(time.length == 3)
			changeLength = Number(time[0]) * 60 + Number(time[1]) * 60 + Number(time[2]);
		else
			changeLength = Number(time[0]) * 60 + Number(time[1]);
		
		lengthText.value = changeLength;
	}
}