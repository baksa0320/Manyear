<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<c:if test="${sessionScope.loginUser == null}">
	<script type="text/javascript">
		alert("로그인후 사용하세요.");
		history.back();
	</script>
</c:if>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="members.js"></script>
<link href="../css/bootstrap.css" rel="stylesheet" type="text/css"/>
<title>회원정보 수정</title>
</head>
<body>
	<h2 align="center">회원 수정</h2>
	<form name ="frm" action="update_process.jsp" method="post">
		<table class="table table-condensed" style="width: 60%; margin: auto; text-align: left;">
			<tr>
				<td>닉네임</td>
				<td>
					<input type="text" name="nick" size="20" value="${loginUser.nick}">
					<input type="button" id="nickCheck" class="btn btn-default" value="중복 체크">
					<input type="text" name="message" readonly>
				</td>
			</tr>
			<tr>
				<td>아이디</td>
				<td><input type="text" name="id" size="20" value="${loginUser.id}" readonly></td>
			</tr>
			<tr>
				<td>이메일</td>
				<td><input type="text" name="email" size="20" value="${loginUser.email}"></td>
			</tr>
			<tr>
				<td>암 &nbsp; 호</td>
				<td><input type="password" name="pwd" size="20"> *</td>
			</tr>
			<tr height="30">
				<td width="80">암호 확인</td>
				<td><input type="password" name="pwd_check" size="20"> *</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input type="submit" class="btn btn-default" value="확인" onclick="return updateCheck()"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="button" class="btn btn-default" value="취소" onclick="location.href='main.jsp'"> <!-- 취소시 메인화면으로 -->
				</td>
			</tr>
		</table>
	</form>
</body>
</html>