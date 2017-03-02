<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.login.dao.MemberDAO"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script type="text/javascript" src="members.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>아이디 중복 체크</title>
	<%
		String nick = request.getParameter("nick");
		MemberDAO mDao = MemberDAO.getInstance();
		int result = mDao.confirmNick(nick);
		if(result == -1){
			%>
			<script type="text/javascript">
				opener.document.frm.nick_message.value = "사용 가능한 닉네임입니다.";
				opener.document.frm.reNick.value = <%=result%>;
				self.close();
			</script>
	<% 
		} else{
	%>
			<script type="text/javascript">
				opener.document.frm.nick_message.value = "사용할 수 없는 닉네임입니다.";
				opener.document.frm.reNick.value = <%=result%>;
				self.close();
			</script>
	<% 
		}

	%>