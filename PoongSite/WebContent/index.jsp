<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<!-- 유튜브 -->
<script src="/js/video/youtube.js" type="text/javascript"></script>
<script src="https://apis.google.com/js/client.js?onload=onClientLoad" type="text/javascript"></script>

<!-- 에디터 -->
<script src="/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
<script src="/daumeditor/js/editor_creator.js" type="text/javascript" charset="utf-8"></script>

<link href="/daumeditor/css/trex/editor/container.css" type="text/css" rel="stylesheet" />
<link href="/daumeditor/css/trex/editor/tool.css" type="text/css" rel="stylesheet" />
<link href="/daumeditor/css/trex/editor/fullscreen.css" type="text/css" rel="stylesheet" />
<link href="/daumeditor/css/trex/editor/extra_dropdown.css" type="text/css" rel="stylesheet" />
<link href="/daumeditor/css/trex/editor/advanced.css" type="text/css" rel="stylesheet" />
<link href="/daumeditor/css/trex/editor/richtextbox.css" type="text/css" rel="stylesheet" />
<link href="/daumeditor/css/trex/editor/attacher.css" type="text/css" rel="stylesheet" />
<link href="/daumeditor/css/trex/editor/plugin.css" type="text/css" rel="stylesheet" />
<link href="/daumeditor/css/trex/editor/attachbox.css" type="text/css" rel="stylesheet" />

<title>만년</title>
</head>
<body>
	<jsp:include page="index_header.jsp"></jsp:include>
	<script type="text/javascript" src="/js/video/video-play.js?20170302"></script>
	<section style="float:left; width: 87%;">
		<article class="videoStatus" id="videoStatus">
			<div>등록된 영상 : 0 개</div>
		</article>
		<article class="divVideo" id="divVideo" style="display:block;">
			<!-- <iframe width="80%" height="480" src="https://www.youtube.com/embed/-WWIWDD0G44" frameborder="0" allowfullscreen></iframe> -->
		</article>
		<div style="margin:auto; text-align:center;"><input type="button" id="videoClose" value="▲"></div>
		<article id="writeable">
	       	<form method="post" name="frm" action="#">
	            <c:choose>
	            	<c:when test="${sessionScope.loginUser == null}">
	            		<input type="text" id="writeNick" data-rule-required="true" placeholder="닉네임" maxlength="10" style="width: 200px;"><br>
	            		<input type="password" id="writePwd" data-rule-required="true" placeholder="비밀번호" maxlength="10" style="width: 100px;">
						<input type="hidden" id="loginId" value="dynamic">
	            	</c:when>
	            	<c:otherwise>
	            		<input type="text" id="writeNick" value="${loginUser.nick}" readonly style="width: 200px;">
	            		<input type="hidden" id="writePwd" value="static">
	            		<input type="hidden" id="loginId" value="${loginUser.id}">
					</c:otherwise>
	            </c:choose>
				<input type="text" id="title" data-rule-required="true" placeholder="제목" maxlength="20" style="width: 90%;">
				<textarea id="content" style="width: 100%; height: 490px;"></textarea>
	         	<input type="button" id="cancelWrite" class="btn-blue" value="닫기">
	         	<input type="button" id="saveWrite" class="btn-blue" value="저장">
	        </form>
		</article>
		<article id="contents">
			<div id="listBoard" class="header">
				<div id="wrapper-part-info">
					<div id="conTitle" class="content-title"></div>
					<div id="conDates" class="content-dates"></div>
				</div>
				<div id="wrapper-part-info">
					<div id="conNick" class="content-nick"></div>
					<div id="conHits" class="content-hits"></div>
					<div id="conComm" class="content-commSize"></div>
				</div>
			</div>
			<input type="button" id="closeContentTop" class="btn-gray" value="닫기" />
			<input type="button" id="writeContentTop" class="btn-gray" value="글쓰기" />
			<input type="button" id="deleteContentTop" class="btn-gray" value="삭제" style="display: none;" />
			<div id="listBoard" class="contents">
				<div id="conContent"></div>
				<div id="contentMenu">
					<input type="button" id="closeContentBot" class="btn-gray" value="닫기" />
					<input type="button" id="writeContentBot" class="btn-gray" value="글쓰기" />
					<input type="button" id="deleteContentBot" class="btn-gray" value="삭제" style="display: none;" />
				</div>
			</div>
	           	<div id="comment"></div>
            	<div class="post-send" style="margin-top: 50px;">
               	<div id="main-post-send"> 
                       <div id="title-post-send">댓글 작성하기</div>
            			<input type="hidden" id="selected" value="${requestScope.select}">
                       <input type="hidden" id="num" value="${board.num}">   
		            <c:choose>
		            	<c:when test="${sessionScope.loginUser == null}">
							<input type="text" id="commName" placeholder="닉네임" maxlength="10" style="width: 20%;">
							<input type="password" id="commPwd" placeholder="비밀번호">
						</c:when>
		            	<c:otherwise>
							<input type="text" id="commName" value="${loginUser.nick}" style="width: 20%;" readonly>
	          				<input type="hidden" id="commPwd" value="commlogin">
		            	</c:otherwise>
					</c:choose>
					<fieldset>
						<input type="text" id="commMsg" name="commMsg" maxlength="60" placeholder="댓글을 입력하세요.">
						<input type="button" id="commBtn" class="btn-blue" value="등록" />
					</fieldset>
                   </div>
				</div>
		</article>
		<article>
			<div id="tableName"></div>
			<div class="board-table">
				<div id="boardList"></div>
				<div class="boardnum center">
					<input type="button" id="write" class="btn-blue" value="글쓰기">
					<ul id="boardSize">
						<li id="size1"><a href="#">1</a></li>
						<li id="size2"><a href="#">2</a></li>
						<li id="size3"><a href="#">3</a></li>
						<li id="size4"><a href="#">4</a></li>
						<li id="size5"><a href="#">5</a></li>
						<li id="size6"><a href="#">6</a></li>
						<li id="size7"><a href="#">7</a></li>
						<li id="size8"><a href="#">8</a></li>
						<li id="size9"><a href="#">9</a></li>
					</ul>
				</div>
			</div>
		</article>
	</section>
	<aside style="position:fixed; bottom:0; right:0; width: 15%; height: 90%;">
		 <fieldset>
		 	<div id="chatMessage" height="90%" style="text-align:left; height: 90%; border: 1px solid gray; overflow-x: hidden; overflow-y: scroll;"></div><br>
			<input type="text" id="inputMessage" placeholder="대화를 입력하세요."/>
	   </fieldset>
		<!-- <script src='//uchat.co.kr/uchat.php' charset='UTF-8'></script>
		<script type='text/javascript'>
		u_chat({
			room:'manyears'
			, skin:'1'
			, view_mb_list:false
			, chat_record:true
			, fully_size:true
			, no_indi:true
			, no_inout:true
		});
		</script> -->
	</aside>
</body>
<script type="text/javascript" src="/js/editor/index_editor.js"></script>
<script type="text/javascript" src="/js/chat/wschat.js?20170301"></script>
</html>