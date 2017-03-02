$(function(){
	var msgText = $("#inputMessage");
	
	msgText.bind("keypress", function (event) {
		var keyCode = event.which || event.keyCode;
		if(keyCode == 13 && $.trim(msgText.val()) != ''){
			send();
		}
	});
});
	
	var webSocket = new WebSocket('ws://poongs.sytes.net/chat');
	var inputMessage = document.getElementById('inputMessage');
	var nickName = $("#nickA").text();
	var chatMessage = $("#chatMessage");
	var connected = true;
	
	if($.trim(nickName) == ''){
		var ran = Math.round(Math.random() * 1000);
		nickName = "손님(" + ran + ")";
	}
	
    webSocket.onerror = function(event) {
    	onError(event)
    };
    webSocket.onopen = function(event) {
    	onOpen(event)
    };
    webSocket.onmessage = function(event) {
    	onMessage(event)
    };
    function onMessage(event) {
    	var splitText = event.data.split(':', 2);
    	if(splitText[0] == '퀴즈봇' || splitText[0] == '만년님')
        	chatMessage.append('<div><span style="color: blue; font-weight: bold;">' + splitText[0] + ':</span> <span style="font-weight: bold">' + splitText[1] + '</span></div>');
    	else
    		chatMessage.append('<div><span style="font-weight: bold;">' + splitText[0] + ':</span> <span>' + splitText[1] + '</span></div>');
		
    	chatMessage.scrollTop(chatMessage.prop('scrollHeight'));
    }
    function onOpen(event) {
    	$("#chatMessage").append('<div style="color: blue; text-align:center;">만년 사이트 채팅에 입장하였습니다.</div>');
    }
    function onError() {
    	$("#chatMessage").append('<div style="color: red; text-align:center;">접속에 실패하였습니다.</div>');
    	connected = false;
    }
    function send() {
    	if(connected){
	    	chatMessage.append('<div style="background-color: #EAEAEA;"><span style="font-weight: bold;">' + nickName + ':</span> <span>' + inputMessage.value + '</span></div>');
			webSocket.send(nickName + ": " + inputMessage.value);
			inputMessage.value = "";
			chatMessage.scrollTop(chatMessage.prop('scrollHeight'));
	    }
    }