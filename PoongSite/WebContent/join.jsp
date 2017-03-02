<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>회원 가입</title>
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script type="text/javascript" src="/login/members.js"></script>
<body>
<jsp:include page="/index_header.jsp"></jsp:include>
	<h3 align="center" style="margin-top: 200px;">회원가입</h3>
	<form name="frm" id="registerForm" action="/register/process" method="post">
		<table class="table table-condensed">
			<tr>
				<td>아이디</td>
				<td>
					<input type="text" name="id" size="20" maxlength="10" style="width: 200px; height: 30px;">
					<input type="hidden" name="reid">
					<input type="button" class="btn-blue" value="아이디 체크" onclick="idCheck()" style="float:none; width:100px; height:30px; margin: 0;">
					<input type="text" name="id_message" readonly style="width: 200px; height: 30px;">
				</td>
			</tr>
			<tr>
				<td align="left">닉네임</td>
				<td>
					<input type="text" name="nick" id="regNick" size="20" maxlength="10" style="width: 200px; height: 30px;">
					<input type="hidden" id="reNick" name="reNick" value="-1">
					<input type="button" id="nickCheck" class="btn-blue" value="닉네임 체크" style="float:none; width:100px; height:30px; margin: 0;">
					<input type="text" name="nick_message" readonly style="width: 200px; height: 30px;">
				</td>
			</tr>
			<tr>
				<td>암호</td>
				<td><input type="password" name="pwd" size="20" maxlength="10"></td>
			</tr>
			<tr height="30">
				<td width="80">암호 확인</td>
				<td><input type="password" name="pwd_check" size="20" maxlength="10"></td>
			</tr>
			<tr>
				<td>이메일</td>
				<td>
					<input type="text" name="email" id="emails" size="20" style="width: 200px; height: 30px;">
					<input type="button" id="emailCheck" class="btn-blue" value="코드발송" style="float:none; width:100px; height:30px; margin: 0;">
				</td>
			</tr>
			<tr>
				<td>인증코드</td>
				<td>
					<input type="text" name="email" id="emailCode" size="20" style="width: 200px; height: 30px;">
					<input type="button" id="emailConfirm" class="btn-blue" value="인증확인" style="float:none; width:100px; height:30px; margin: 0;">
					<input type="hidden" id="emailBool" value="fail">
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input type="submit" class="btn btn-default" value="확인" onclick="return joinCheck()">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="button" class="btn btn-default" value="취소" onclick="location.href='/home'"> <!-- 취소시 로그인 화면으로 -->
				</td>
			</tr>
		</table>
	</form>
</body>
</html>
