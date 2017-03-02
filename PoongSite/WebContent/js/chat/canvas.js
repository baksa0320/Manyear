	
	var picture = {
		canvas : null,
		context : null
	};
	/**
	 * 0 : 펜
	 * 1 : 직선
	 * 2 : 사각형
	 * 3 : 지우개
	 */
	var eventObject = {
		mode : 0,
		click : false,
		x : 0,
		y : 0,
	};
	
	var currentX = 100;
	var currentY = 130;
	// 초기화
	window.onload = function() {
		document.getElementById("loadImg").addEventListener("change", loadImg, false);
		picture.canvas = document.getElementById("canvas");
		picture.context = picture.canvas.getContext("2d");
		mouseListener();
	}
	
	// 현재 클릭중인지 아닌지 구분?하기위한 변수 세팅
	function setClickTrue() {
		eventObject.click = true;
	}
	function setClickFalse() {
		eventObject.click = false;
	}

	// 좌표 출력
	function printXY(e) {
		var g = picture.context;
	}

	// 라인, 사각형 등 이전 좌표가 필요할 경우 이전좌표 세팅
	function setBeforeXY(e) {
		var g = picture.context;
		eventObject.x = e.x - currentX;
		eventObject.y = e.y - currentY;
		g.moveTo(e.x - currentX, e.y - currentY);
	}
	// 펜일 경우의 이벤트
	function dragEvent(event) {
		var g = picture.context;
		g.beginPath();
		g.moveTo(eventObject.x, eventObject.y);
		eventObject.x = event.x - currentX;
		eventObject.y = event.y - currentY;
		if (eventObject.click) {
			g.lineTo(event.x - currentX, event.y - currentY);
			g.stroke();
		}
	}
	// 지우개
	function eraseEvent(event) {
		var g = picture.context;
		g.beginPath();
		g.moveTo(eventObject.x, eventObject.y);
		eventObject.x = event.x - currentX;
		eventObject.y = event.y - currentY;
		if (eventObject.click) {
			g.fillStyle = "#EAEAEA";
			g.rect(event.x - currentX - 20, event.y - currentY - 20, 40, 40);
			g.fill();
		}
	}
	// setBeforeXY 에서 세팅한 좌표부터 현재 좌표까지 직선을 그림
	function drawLine(e) {
		var g = picture.context;
		g.lineTo(e.x - currentX, e.y - currentY);
		g.stroke();
	}
	
	// setBeforeXY 에서 세팅한 좌표부터 현재 좌표까지 사각형을 그림
	function drawRect(e) {
		var g = picture.context;
		g.beginPath();
		g.rect(eventObject.x, eventObject.y, e.x - eventObject.x - currentX, e.y - eventObject.y - currentY);
		g.stroke();
		// g.fill(); 을 g.stroke() 대신 사용하면 속이 꽉찬 사각형을 그린다.
	}
	
	// 각 경우에 따라서 이벤트리스너를 달아준다.
	function mouseListener() {
		var mode = Number(eventObject.mode);
		picture.canvas.addEventListener("mousemove", printXY, false);
		switch (mode) {
		case 0:
			picture.canvas.addEventListener("mousedown", setClickTrue, false);
			picture.canvas.addEventListener("mouseup", setClickFalse, false);
			picture.canvas.addEventListener("mousemove", dragEvent, false);
			break;
		case 1:
			picture.canvas.addEventListener("mousedown", setBeforeXY, false);
			picture.canvas.addEventListener("mouseup", drawLine, false);
			break;
		case 2:
			picture.canvas.addEventListener("mousedown", setBeforeXY, false);
			picture.canvas.addEventListener("mouseup", drawRect, false);
			break;
		case 3:
			picture.canvas.addEventListener("mousedown", setClickTrue, false);
			picture.canvas.addEventListener("mouseup", setClickFalse, false);
			picture.canvas.addEventListener("mousemove", eraseEvent, false);
			break;
		}
	}
	
	// 이벤트 리스너 제거
	function removeEvent() {
		picture.canvas.removeEventListener("mousedown", setClickTrue, false);
		picture.canvas.removeEventListener("mouseup", setClickFalse, false);
		picture.canvas.removeEventListener("mousemove", dragEvent, false);
		picture.canvas.removeEventListener("mousedown", setBeforeXY, false);
		picture.canvas.removeEventListener("mouseup", drawLine, false);
		picture.canvas.removeEventListener("mouseup", drawRect, false);
		picture.canvas.removeEventListener("mousemove", eraseEvent, false);
	}
	
	// 모드 체인지
	function changeMode(mode) {
		removeEvent();
		eventObject.mode = mode;
		mouseListener();
	}
	
	//////////////////////////////////////////////////////////////////////////////
	// input file 로 읽어온 이미지를 canvas 에 배경으로 출력
	function loadImg(e) {
		var file = e.target.files[0];
		var fileReader = new FileReader();
		fileReader.readAsDataURL(file);
		fileReader.onload = function() {
			var output = new Image();
			output.src = fileReader.result;
			picture.context.drawImage(output, 0, 0, 800, 600);
			picture.context.stroke();
		};
	}
	
	// canvas에 그려진 그림을 파일로 저장
	function save() {
		var image = picture.canvas.toDataURL("image/png").replace("image/png", "image/octet-stream");
		document.getElementById("data").innerHTML = image;
		window.location.href = image;
	}