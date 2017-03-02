$(function() {
	/** 유튜브 api **/
	if (typeof(YT) == 'undefined' || typeof(YT.Player) == 'undefined') {
		var tag = document.createElement('script');
		tag.src = "https://www.youtube.com/iframe_api";
		var firstScriptTag = document.getElementsByTagName('script')[0];
			firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
			window.onYouTubePlayerAPIReady = function() {
				onYouTubePlayer();
			};
		} else {
			onYouTubePlayer();
		}
		
		var pages = $(location).attr('pathname');
		if(pages == "/board"){
			updateAjax();
		}
});
var player;

function onYouTubePlayer() {
	player = new YT.Player('player', {
		width : 640,
		height : 480,
		videoId : videoIdInit,
		playerVars : {
			'autoplay' : true,
			'controls' : 0,
			'loop' : false,
			'showinfo' : 1,
			'showsearch' : 0,
			'start' : currents,
			'end' : videoLength
		},
		events : {
			'onReady' : onPlayerReady,
			'onStateChange' : onPlayerStateChange,
			'onPlaybackRateChange' : onPlayerbackRateChange,
			'onError' : onPlayerError
		}
	});
}

function onPlayerReady(event) {
	event.target.playVideo();
}

var done = false;
var bufferSeconds = 0;
var bufferInterval;

function onPlayerStateChange(event) {
	switch(event.data){
		case YT.PlayerState.ENDED:
			break;
		case YT.PlayerState.PLAYING:
			if(!done)
				done = true;
			clearInterval(bufferInterval);
			bufferSeconds = 0;
			break;
		case YT.PlayerState.PAUSED:
			event.target.playVideo();
			break;
		case YT.PlayerState.BUFFERING:
			bufferInterval = setInterval(function() {
				bufferSeconds += 1000;
			}, 1000);
			break;
		case YT.PlayerState.CUED:
			break;
	}
}

function onPlayerbackRateChange(event) {
	player.setPlaybackRate(1);
}
function onSetVolume(val) {
	player.setVolume(val);
}
function stopVideo() {
	player.stopVideo();
}
function onPlayerError(event) {
	videoChange = 1;
	updateAjax();
}

var videoLength = 0;
var currents = 0;
var videoIdInit = '';
var videoChange = 0;

function updateAjax(){
	 $.ajax({
	        type: "post",
	        url: "videoData_get.jsp",
	        dataType: "json",
	        data: {
	        	change: videoChange,
	        },
	        success: function(data){
		        	$("#videoStatus").html(
	                     '<div>등록된 영상 : ' + data.readyNum + '개</div>'
	                );
		        	videoChange = 0;
	        	
		        	videoIdInit = data.name;
		        	currents = data.currents;
		        	videoLength = data.length;
		        	
		        	$("#divVideo").html(
			                      	'<div id="player" style="width:80%; margin: auto;"></div>' +
			                      	'<div style="background-color:#000; width: 80%; margin: auto; text-align:center;"><input id="vol-control" type="range" min="0" max="100" step="1" value="100" oninput="onSetVolume(this.value)" onchange="onSetVolume(this.value)"></input></div>' +
			                      	'<div>' + data.nick + '님의 영상</div>' +
			                      	'<div>' + data.description + '</div>' +
			                      	'<div id="videoTime"></div>'
			                      	);
		        	var timeInterval;
		        	
		        	setTimeout(function() {
						videoChange = 1;
						updateAjax();
						clearInterval(timeInterval);
						$("#videoTime").html('');
					}, (videoLength - currents) * 1000 + bufferSeconds);

		        	
		        	var seconds = videoLength;
		        	var minStr = '';
		        	if(seconds >= 60){
		        		var minutes = parseInt(seconds / 60);
		        		seconds = seconds % 60;
		        		minStr = minutes + ":";
		        	}
		        	var time = minStr + seconds;

		        	var curSec = currents;
		        	var curMinStr = '';
		        	var curMin = 0;

		        	if(curSec >= 60){
		        		curMin = parseInt(curSec / 60);
		        		curSec = curSec % 60;
		        		curMinStr = curMin + ":";
		        	}
		        	
		        	timeInterval = setInterval(function() {
			        	if(curSec >= 60){
			        		curMin++;
			        		curSec = 0;
			        		curMinStr = curMin + ":";
			        	}
			        	var curTime = curMinStr + curSec;
						$("#videoTime").html(curTime + '/' + time);
						curSec++;
					}, 1000);
		        	
		        	onYouTubePlayer();
	    	},
	        error: function(e){
	        	$("#videoStatus").html('<div>등록된 영상 : 0개</div>');
		        $("#divVideo").html('');
				$("#videoTime").html('');
		        setTimeout(function() {updateAjax();}, 1000);
	        }
	 });
}
