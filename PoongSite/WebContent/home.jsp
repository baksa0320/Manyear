<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<title>만년</title>
</head>
<body>
<jsp:include page="index_header.jsp"></jsp:include>
<!-- 
<div id="poongTwitch" style=" width:100%; height:auto; margin: auto; display: block;">
	<iframe src="http://player.twitch.tv/?channel=hanryang1125" id="twitch_embed" width="100%" height="100%" frameborder="0" scrolling="no" allowfullscreen="allowfullscreen"></iframe>
	<iframe frameborder="0" scrolling="no" id="chat_embed" src="http://www.twitch.tv/hanryang1125/chat" width="100%" height="100%"></iframe>
</div>
<div style="width:100%; height:80px; margin: auto;"><input type="button" id="twitchClose" value="▲" style="width:100%; background-color: #fff; border: 0px;"></div>
 -->
<div style="margin-top: 50px;"></div>
<section style="width: 60% - 50px; float: left; margin-left: 100px;">
	<canvas id="canvas" width="800" height="500" style="cursor: crosshair; background-color: #EAEAEA;"></canvas><br>
	<span>배경 선택</span><span><input type="file" id="loadImg" title="배경선택"></span><br>
	<input type="hidden" id="x">
	<input type="hidden" id="y">
	<input type="button" value="펜" onclick="changeMode(0)">
	<!-- <input type="button" value="직선" onclick="changeMode(1)"> -->
	<input type="button" value="사각형" onclick="changeMode(2)">
	<input type="button" value="지우개" onclick="changeMode(3)"><br>
	<input type="button" value="저장" onclick="save()"><br>
	<input type="hidden" id="data">
</section>
	<section style="width: 40%; float: right;">
		 <fieldset>
		 	<div id="chatMessage" style="text-align:left; height: 60%; border: 1px solid gray; overflow-x: hidden; overflow-y: scroll;"></div><br>
			<input id="inputMessage" type="text"/>
	   </fieldset>
   </section>
   
<%/* 
   	String url = request.getRequestURL().toString();
   	if (url.startsWith("http://") && url.indexOf("localhost") < 0) {
   		url = url.replaceAll("http://", "https://");
   		response.sendRedirect(url);
   	} */
   	System.out.println(request.getRemoteAddr());
   %>
</body>
<script type="text/javascript" src="/js/chat/canvas.js?20170227"></script>
<script type="text/javascript" src="/js/chat/wschat.js?20170301"></script>
</html>