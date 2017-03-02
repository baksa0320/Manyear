$(function(){
	var selNum = 0;
	var url = "board_process.jsp";
	var pageNum = 1;
	var boardNum = 0;
	
	if(getCookie("select") != "" || getCookie("select") != "undefined"){
		selNum = getCookie("select");
		setAjax();
	} else{
		setCookie("select", selNum, 365);
	}
	/** 글쓰기 **/
	$("#write, #writeContentTop, #writeContentBot").click(function() {
		if(selNum != 0 || $("#checkAdmin").val() == "1"){
			$("#writeable").css("display", "block");
			onScrollEvent();
		} else {
			alert("글쓰기 권한이 없습니다.");
		}
	});
	/** 글쓰기 등록 **/
	$("#saveWrite").click(function() {
 		if ($.trim($("#writeNick").val()) == "") {
 			alert("닉네임을 입력해 주세요.");
 		} else if ($.trim($("#writePwd").val()) == "") {
 			alert("비밀번호를 입력해 주세요");
 		} else if(!validForm){
			alert('내용을 입력하세요.');
 		} else {
			Editor.save();
			 $.ajax({
			        type: "post",
			        url: "board_write_process.jsp",
			        data: {
			        	id : $("#loginId").val(),
			        	nick : $("#writeNick").val(),
			        	pwd : $("#writePwd").val(),
			        	title : $("#title").val(),
			        	content : $("#content").val(),
			        	select : selNum
			        },
			        success: function written(){
			    		$("#writeable").css("display", "none");
			    		$("#writePwd").val("");
			    		$("#title").val("");
			    		$("#content").val("");
			        },
			        error: whenError
		  	});
 		}
 		/** 다음 에디터 **/
 		function validForm(editor) {
 			var validator = new Trex.Validator();
 			var content = editor.getContent();
 			if (!validator.exists(content)) {
 				return false;
 			}
 			return true;
 		}
	});
	/** 글쓰기 닫기 **/
	$("#cancelWrite").click(function() {
		$("#writeable").css("display", "none");
	});
	/** 글 닫기 **/
	$("#closeContentTop, #closeContentBot").click(function() {
		$("#contents").css("display", "none");
	});
	/** 공지사항 **/
	$("#home").click(function() {
		setClickEvent(0);
	});
	/** 게시판 **/
	$("#select1").click(function() {
		setClickEvent(1);
	});
	$("#select2").click(function() {
		setClickEvent(2);
	});
	$("#select3").click(function() {
		setClickEvent(3);
	});
	$("#select4").click(function() {
		setClickEvent(4);
	});
	/** 페이지 변경 **/
	$("#boardSize li").click(function() {
		pageNum = parseInt($(this).text());
		setAjax();
	});
	/** 게시판 클릭 이벤트 **/
	function setClickEvent(selected){
		var pages = $(location).attr('pathname');
		selNum = selected;
		if(pages != "/board"){
			setCookie("select", selNum, 365);
			$(location).attr('href',"/board");
		} else{
			setAjax();
		}
	}
	function setAjax(){
		 $.ajax({
		        type: "get",
		        url: url,
		        dataType: "json",
		        cache: false,
		        data: {
			        select : selNum,
			        page : pageNum
		        },
		        success: whenSuccess,
		        error: whenError
	  	});
	}
	function whenSuccess(data){
		setCookie("select", selNum, 365);
		if(selNum == 0){
			$("#tableName").html("공지사항");
		} else if(selNum == 1){
			$("#tableName").html("자유게시판");
		} else if(selNum == 2){
			$("#tableName").html("만화게시판");
		} else if(selNum == 3){
			$("#tableName").html("정보게시판");
		} else if(selNum == 4){
			$("#tableName").html("신고및건의");
		}
		$("#writeable").css("display", "none");
		$("#contents").css("display", "none");
		commentsClose();
		
		$("#boardList").html("");
		$("#boardList").append(
			'<div id="listBoard" class="header">' + 
				'<div id="wrapper-part-info">' + 
                   		'<div class="part-info-list-num">번호</div>' + 
                       	'<div class="part-info-list-title">제목</div>' + 
                       	'<div class="part-info-list-hits">조회</div>' + 
                       	'<div class="part-info-list-dates">등록일</div>' + 
                       	'<div class="part-info-list-nick">글쓴이</div>' + 
				'</div>' + 
			'</div>');
		for(var i = 0; i < data.boardList.length; i++){
			var logo = "none";
			if(data.boardList[i].id == "dynamic")
				logo = "none";
			else
				logo = "block";
			
			$("#boardList").append(
				'<div id="listBoard" class="contents">' + 
					'<div id="wrapper-part-info">' + 
                       		'<div class="part-info-list-num">' + data.boardList[i].num + '</div>' + 
                           	'<div class="part-info-list-title">' + data.boardList[i].title + ' [' + data.boardList[i].commSize + ']</div>' + 
                           	'<div class="part-info-list-hits">' + data.boardList[i].hits + '</div>' + 
                           	'<div class="part-info-list-dates">' + data.boardList[i].dates.substring(5,10) + '</div>' + 
                           	'<div class="part-info-list-nick"><span>' + data.boardList[i].nick + '</span><span style="display:inline-block; height:15px;"><img alt="" src="/img/p-logo.png" style="height:15px; display:' + logo + ';"></span></div>' +
					'</div>' + 
				'</div>');
		}
	}
	/** 게시글 클릭 이벤트 **/
	$('#boardList').on('click', '.contents', function() {
		var child = $(this).children();
		boardNum = child.children('.part-info-list-num').text();
		var hits = child.children('.part-info-list-hits').text();
		
		if(selNum == 4 && $("#checkAdmin").val() == "0" && child.children('.part-info-list-nick').text() != $("#writeNick").val())
			alert("신고게시판은 관리자만 볼 수 있습니다.");
		else if(selNum == 2 && $("#checkAdmin").val() == "0" && child.children('.part-info-list-nick').text() != $("#writeNick").val())
			alert("만화게시판은 인증된 회원만 볼 수 있습니다.");
		else{
			 $.ajax({
			        type: "post",
			        url: "board_content.jsp",
			        dataType: "json",
			        data: {
				        num : boardNum,
				        hits : hits,
				        select : selNum
			        },
			        success: showContent,
			        error: whenError
			        
		  	});
		}
		function showContent(data){
			$("#contents").css("display", "block");
			$("#conTitle").html(data.title);
			$("#conHits").html("조회: " + data.hits);
			$("#conDates").html(data.dates);
			$("#conNick").html("글쓴이: " + data.nick);
			$("#conContent").html(data.content);
			
			if(data.id == "dynamic"){
				$("#deleteContentTop, #deleteContentBot").css("display", "block");
				$("#deletePwd").css("display", "block");
				$("#deletePwd").val("");
			} else if($("#loginId").val() == data.id){
				$("#deleteContentTop, #deleteContentBot").css("display", "block");
				$("#deletePwd").css("display", "none");
				$("#deletePwd").val("static");
			} else{
				$("#deleteContentTop, #deleteContentBot").css("display", "none");
			}
			
			onScrollEvent();
	        
			 $.ajax({
			        type: "post",
			        url: "content_comment.jsp",
			        dataType: "json",
			        data: {
				        num : boardNum,
				        select : selNum
			        },
			        success: getComment,
			        error: whenError
		  	});
		}
		/** 댓글 가져오기 **/
		function getComment(data){
			$("#comment").html("");
			try{
				var commSize = data.comments.length;
				if(commSize > 0){
					for(var i = commSize - 1; i >= 0; i--){
						$("#conComm").html("댓글수: " + commSize);
						$("#comment").append(
			            	'<div class="post-reply">' +
                            	/*'<div class="image-reply-post"></div>' +*/
			                '<div class="name-reply-post">' + data.comments[i].commName + '</div>' +
		                	'<div class="delete-reply-post">삭제</div>' +
		                	'<div class="ip-reply-post">' + data.comments[i].commIp.substring(0,7) + '*</div>' +
		                	'<div class="dates-reply-post">' + data.comments[i].commDates.substring(5,data.comments[i].commDates.length) + '</div>' +
		                	'<div class="text-reply-post">' + data.comments[i].commContent + '</div>' + 
			            	'</div>'
						);
					}
				}
			} catch(err){
				$("#conComm").html("댓글수: 0");
			}
		}

	}); //게시글 클릭
	/** 댓글 등록 **/
	$("#commBtn").click(function( event ) {
		var pName = $("#commName");
		var pPassword = $("#commPwd");
		var pMessage = $("#commMsg");
		
	    if($.trim(pName.val())==""){
	        alert("닉네임을 입력하세요.");
	        pName.focus();
	        return;
	    } else if($.trim(pPassword.val())==""){
	        alert("패스워드를 입력하세요.");
	        pPassword.focus();
	        return;
	    } else if($.trim(pMessage.val())==""){
	        alert("내용을 입력하세요.");
	        pMessage.focus();
	        return;
	    }
		 $.ajax({
		        type: "post",
		        url : "comment_process.jsp",
		        data: {
			        select : selNum,
			        num : boardNum,
		    		name : pName.val(),
		    		pwd : pPassword.val(),
			        content : pMessage.val()
		        },
		        success: function setComment(data){
		        	var d = new Date();
		        	var time = d.getMonth() + "-" + d.getDate() + " " + d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds();
		        	var ip = '';
		        	$.get("http://ipaddress.urgulbook.com/",function(res){
		        	    ip = res.IP;
		        	},"jsonp");
		        	
				     $('#comment').append(
						    '<div class="post-reply">'+
		                    	/*'<div class="image-reply-post"></div>' +*/
			                	'<div class="name-reply-post">' + pName.val() + '</div>' +
			                	'<div class="delete-reply-post">삭제</div>' +
			                	'<div class="ip-reply-post">' + ip + '</div>' +
			                	'<div class="dates-reply-post">' + time + '</div>' +
			                	'<div class="text-reply-post">' + pMessage.val() + '</div>' + 
					        '</div>'
			         );
				     pMessage.val("");
				},
		        error: whenError
	  	});
	});//댓글 등록
	
	/** 게시물 삭제 **/
	$("#delOK").click(function(){
		 $.ajax({
		        type: "post",
		        url: "board_delete.jsp",
		        data: {
			        select : selNum,
			        num : boardNum,
			        pwd : $("#deletePwd").val()
		        },
		        success: function sucDelete(data){
					$("#contents").css("display", "none");
		    		$('#mask , .login-popup').fadeOut(300, function() {
		    			$('#mask').remove();
		    		});
					$("#delete-box").css("display", "none");
		        },
		        error: whenError
	  	});
	});

	var commentContent = '';
	var commentName = '';
	var commentDelete = '';
	var commentDates = '';
	
	/** 댓글 삭제창 **/
	$('#comment').on('click', '.delete-reply-post', function() {
		commentContent = $(this).parent('.post-reply');
		commentName = commentContent.children('.name-reply-post');
		commentDelete = commentContent.children('.delete-reply-post');
		commentDates = commentContent.children('.dates-reply-post');
		var deleteBox = $("#comment-delete-box");

		if($("#loginId").val() == commentName){
			$("#comment-deletePwd").val("commlogin");
			$("#comment-deletePwd").css("display", "none");
		} else if($("#loginId").val() == "dynamic"){
			$("#comment-deletePwd").val("");
			$("#comment-deletePwd").css("display", "block");
		} else{
			$("#comment-deletePwd").val("");
			$("#comment-deletePwd").css("display", "block");
		}
		
		$(deleteBox).css({
			'top' : commentDelete.offset().top - 50,
			'left' : commentDelete.offset().left + 20
		});
		deleteBox.css("display", "block");
	});//댓글 삭제 창
	
	/** 댓글 삭제 **/
	$("#commentDelete").click(function(){
		 $.ajax({
		        type: "post",
		        url: "comment_delete.jsp",
		        data: {
			        select : selNum,
			        num : boardNum,
			        name : commentName.text(),
			        pwd : $("#comment-deletePwd").val(),
		        },
		        success: function sucDelete(data){
		        	if($.trim(data) == 'true'){
		    			commentsClose();
		        		commentContent.css("display", "none");
		        	} else if($.trim(data) == 'false')
		        		alert("비밀번호가 맞지 않습니다 ");
		        },
		        error: whenError
	  	});
	});
	
	/** 댓글 삭제창 닫기 이벤트 **/
	$("#closeDelete").click(function(){
		commentsClose();
	});
	
	/** 스크롤 올리기 **/
	function onScrollEvent(){
        $('html, body').animate({scrollTop : 500}, 400);
	}
	/** 댓글 삭제창 닫기**/
	function commentsClose(){
		$("#comment-delete-box").css("display", "none");
		$("#comment-deletePwd").val("");
	}
	/** 풍 트위치 스트림 닫기 **/
	$("#videoClose").click(function() {
		if($("#divVideo").css("display") == "block"){
			$("#divVideo").css("display", "none");
			$("#videoClose").val("▼");
		} else {
			$("#divVideo").css("display", "block");
			$("#videoClose").val("▲");
		}
	});
	function whenError(){
	    //alert("데이터를 불러오는데 실패하였습니다.");
	}
	function setCookie(cName, cValue, cDay){
        var expire = new Date();
        expire.setDate(expire.getDate() + cDay);
        cookies = cName + '=' + escape(cValue) + '; path=/ '; // 한글 깨짐을 막기위해 escape(cValue)를 합니다.
        if(typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
        document.cookie = cookies;
    }
	function getCookie(cName) {
        cName = cName + '=';
        var cookieData = document.cookie;
        var start = cookieData.indexOf(cName);
        var cValue = '';
        if(start != -1){
            start += cName.length;
            var end = cookieData.indexOf(';', start);
            if(end == -1)end = cookieData.length;
            cValue = cookieData.substring(start, end);
        }
        return unescape(cValue);
    }
});