<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="shortcut icon" type="image/png" href="img/p-logo.png" />

<!-- etc -->
<script src="https://code.jquery.com/jquery-3.1.1.min.js" type="text/javascript"></script>

<!-- board page -->
<script src="/js/board/jquery-ajax.js?20170301" type="text/javascript"></script>
<script src="/js/board/layer-popup.js" type="text/javascript"></script>
<script src="/js/video/video-regi.js?20170301" type="text/javascript"></script>

<!-- cssJS -->
<script src="/js/jquery.min.js" type="text/javascript"></script>
<script src="/js/bootstrap.min.js" type="text/javascript"></script>
<script src="/js/superfish.min.js" type="text/javascript"></script>
<script src="/js/animate.js" type="text/javascript"></script>
<script src="/js/myscript.js" type="text/javascript"></script>

<!-- FONTS -->
<link href="https://fonts.googleapis.com/css?family=Roboto:400,100,100italic,300,300italic,400italic,500italic,700,500,700italic,900,900italic" rel='stylesheet' type='text/css'>
<link href="https://netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" rel="stylesheet">

<!-- Behavioral Meta Data -->
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">

<!-- CSS -->
<link href="/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
<link href="/css/flexslider.css" rel="stylesheet" type="text/css" />
<link href="/css/animate.css" rel="stylesheet" type="text/css" media="all" />
<link href="/css/style.css" rel="stylesheet" type="text/css" />
<link href="/css/indexStyle.css?ver=1" rel="stylesheet" type="text/css" />
<link href="/css/login.css" type="text/css" rel="stylesheet" />

 <div id="login-box" class="login-popup" style="display: none;">
   	<form method="post" class="signin" action="/login/login_process.jsp">
   		<fieldset class="textbox">
        	<label class="username">
             <span>ID</span>
             <input name="id" type="text" autocomplete="on" placeholder="아이디">
            </label>	                
            <label class="password">
             <span>Password</span>
             <input name="pwd" type="password" placeholder="비밀번호">
            </label>
           <input type="submit" class="submit-button" value="로그인" onclick="return loginCheck()"><br>
           <input type="button" value="회원가입" style="color: #000; background-color: #fff" onclick="location.href='/register'">             
           </fieldset>
        </form>
</div>

<div id="video-submit" class="login-popup" style="background-color: #fff; display: none;">
 	<div>시작 시간  <input type="text" id="startLength" placeholder="0:00 or 0:00:00" onchange="timeChange(this);" style="width: 100px; vertical-align: middle;"></div>
 	<div>종료 시간  <input type="text" id="totalLength" placeholder="0:00 or 0:00:00" onchange="timeChange(this);" style="width: 100px; vertical-align: middle;"></div>
	<input type="text" id="videoSrc" placeholder="유튜브 영상 주소를 입력하세요." onchange="search();"><p>
	<input type="text" id="description" placeholder="메시지를 입력해 주세요." maxlength="50">
	<div>
		<label id="ytTitle" style="width:200px; font-size: 10pt;"></label><p>
		<img id="ytThum">
	</div>
	<input type="button" id="videoSubmitBtn" class="submit-button" onclick="return videoCheck('${loginUser.nick}')" value="등록">
</div>

<div id="delete-box" class="login-popup" style="display: none;">
 	<fieldset class="textbox">
      	<label class="username">
           <span style="color: #fff;">정말 삭제하시겠습니까?</span>
       </label><br>
 		<label id="pwdLabel" class="password">
  		<input id="deletePwd" type="password" placeholder="비밀번호를 입력하세요." style="margin: auto; display: block;">
 		</label>
 		<input type="button" id="delOK" value="게시물 삭제" style="color: #000; background-color: #fff">             
     	</fieldset>
</div>

<div id="comment-delete-box" style="display: none; position: absolute; background-color: #fff; border: 2px solid #000">
	<label id="pwdLabel" class="password">
		<input id="comment-deletePwd" type="password" placeholder="비밀번호를 입력하세요." style="display: block; font-size: 10pt; margin-top: 10px;">
	</label>
	<input type="button" id="commentDelete" value="삭제" style="color: #fff; background-color: #8c8c8c; margin-top: 8px; border-radius: 5px;">
	<input type="button" id="closeDelete" value="x" style="color: #ff0000; background-color: #fff; margin-top: 9px; border:0;">
</div>
<header>
	<div class="menu_block">
		<div class="container clearfix">
			<div class="logo pull-left">
				<a href="home"><span class="b1">m</span><span class="b2">a</span><span class="b3">n</span><span class="b4">y</span><span class="b5">e</span><span class="b6">a</span><span class="b6">r</span></a>
			</div>
			<div id="search-form" class="pull-right">
				<form method="get" action="#">
					<input type="text" name="Search" value="Search" onFocus="if (this.value == 'Search') this.value = '';" onBlur="if (this.value == '') this.value = 'Search';" />
				</form>
			</div>
			<div class="pull-right">
				<nav class="navmenu center">
					<ul>
						<li class="first active scroll_btn" id="home"><a href="#">공지사항</a></li>
						<li class="scroll_btn" id="select1"><a href="#">자유게시판</a></li>
						<li class="scroll_btn" id="select2"><a href="#">만화게시판</a></li>
						<li class="scroll_btn" id="select3"><a href="#">정보게시판</a></li>
						<li class="scroll_btn" id="select4"><a href="#">신고및건의</a></li>
						<c:choose>
							<c:when test="${sessionScope.loginUser == null}">
								<li class="scroll_btn last" id="loginBtn"><a href="#">로그인</a></li>
            					<input type="hidden" id="checkAdmin" value="0">
							</c:when>
							<c:otherwise>
								<li class="sub-menu">
									<a id="nickA" href="javascript:void(0);">${loginUser.nick}님</a>
									<ul>
										<li><label>레벨: ${loginUser.levels}</label></li>
										<li><label id="userScore">점수: ${loginUser.score}</label></li>
										<li id="videoReg"><a href="#">전광판 영상 등록</a></li>
										<li><a href="login/logout_process.jsp">로그아웃</a></li>
									</ul>
								</li>
            					<input type="hidden" id="checkAdmin" value="${loginUser.admin}">
							</c:otherwise>
						</c:choose>
					</ul>
				</nav>
			</div>
		</div>
	</div>
</header>