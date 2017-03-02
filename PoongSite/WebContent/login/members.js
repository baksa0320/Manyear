function loginCheck() {
	if (document.frm.id.value.length == 0) {
		alert("아이디를 입력해 주세요");
		document.frm.id.focus();
		return false;
	} else if (document.frm.pwd.value == "") {
		alert("암호를 입력하세요.");
		document.frm.pwd.focus();
		return false;
	}
}
function idCheck() {
	if (document.frm.id.value == "") {
		alert('아이디를 입력하여 주십시오.');
		document.frm.id.focus();
		return;
	} else if (document.frm.id.value.length < 2) {
		alert("아이디는 2글자 이상이어야 합니다.");
		document.frm.id.focus();
		return;
	}
	var url = "/register/idConfirm_forward?id=" + document.frm.id.value;
	window.open(url, "_blank_1", "toolbar=no, menubar=no, scrollbars=yes,resizable=no, width=450, height=200");
}

function idok(userid) {
	opener.frm.id.value = userid;
	opener.frm.reid.value = userid;
	self.close();
}

$(function(){
    var nick = $("#regNick");
    $("#nickCheck").click(function( event ) {
        if($.trim(nick.val()) == ""){
            alert("닉네임을 입력하세요.");
            nick.focus();
            return;
        } else if($.trim(nick.val().length) < 2){
            alert("닉네임은 2글자 이상이어야 합니다.");
            nick.focus();
            return;
        }
    	var url = "/register/nickConfirm_forward?nick=" + encodeURI(nick.val());
    	window.open(url, "_blank_1", "toolbar=no, menubar=no, scrollbars=no,resizable=no, width=1, height=1");
    });
	var code = "code";
	$("#emailCheck").click(function (){
		var emailId = $("#emails").val();
		if(emailId.indexOf("@") == -1){
			alert("이메일 형식이 올바르지 않습니다.");
		} else if(emailId.indexOf(".") == -1){
			alert("이메일 형식이 올바르지 않습니다.");
		} else{
			 $.ajax({
		        type: "post",
		        url: "mail.jsp",
		        data: {
			        email : emailId,
		        },
		        success: function success(data){
		        	code = data.toString().trim();
		        	if(code == "")
			        	alert("이미 사용중인 이메일 입니다.");
		        	else
		        		alert("코드를 메일로 발송하였습니다.");
		        },
		        error: function error(){
		        	alert("코드 발송에 실패하였습니다.");
		        }
		  	});
		}
	});
	$("#emailConfirm").click(function (){
		if($.trim($("#emailCode").val()) == code){
			alert("인증되었습니다");
			$("#emailBool").val("success");
		} else{
			alert("코드가 맞지 않습니다.");
		}
	});
});

function joinCheck() {
	if (document.frm.id.value.length == 0) {
		alert("아이디를 입력해 주세요");
		document.frm.id.focus();
		return false;
	}
	else if (document.frm.nick.value.length == 0) {
		alert("닉네임을 입력해 주세요.");
		document.frm.nick.focus();
		return false;
	}
	else if (document.frm.id.value.length < 2) {
		alert("아이디는 2글자 이상이어야 합니다.");
		document.frm.id.focus();
		return false;
	}
	else if (document.frm.pwd.value == "") {
		alert("암호는 반드시 입력해야 합니다.");
		document.frm.pwd.focus();
		return false;
	}
	else if (document.frm.pwd.value != document.frm.pwd_check.value) {
		alert("암호가 일치하지 않습니다.");
		document.frm.pwd.focus();
		return false;
	}
	else if (document.frm.reid.value.length == 0) {
		alert("아이디 중복 체크를 하지 않았습니다.");
		document.frm.id.focus();
		return false;
	}
	else if ($("#reNick").val() != "-1") {
		alert("닉네임 중복 체크를 하지 않았습니다.");
		$("#nickCheck").focus();
		return false;
	}
	else if ($("#emailBool").val() != "success") {
		alert("코드 인증을 완료해주세요.");
		return false;
	}
	return true;
}

function updateCheck() {
	if (document.frm.nick.value.length == 0) {
		alert("닉네임을 입력해 주세요.");
		document.frm.nick.focus();
		return false;
	} else if (document.frm.pwd.value == "") {
		alert("암호는 반드시 입력해야 합니다.");
		document.frm.pwd.focus();
		return false;
	} else if (document.frm.pwd.value != document.frm.pwd_check.value) {
		alert("암호가 일치하지 않습니다.");
		document.frm.pwd.focus();
		return false;
	} else if (document.frm.reid.value.length == 0) {
		alert("로그인 후 사용해 주세요.");
		document.frm.id.focus();
		return false;
	} else if ($("#reNick").value != "-1") {
		alert("닉네임 중복 체크를 하지 않았습니다.");
		$("#nickCheck").focus();
		return false;
	}
	return true;
}