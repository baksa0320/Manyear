<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.login.dao.MemberDAO"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>아이디 중복 체크</title>
</head>
<body>
	<%
	String id = request.getParameter("id");
	MemberDAO mDao = MemberDAO.getInstance();
	int result = mDao.confirmID(id);
	if(result == -1){
		%>
		<script type="text/javascript">
			opener.document.frm.id_message.value = "사용 가능한 아이디입니다.";
			opener.document.frm.reid.value = <%=result%>;
			self.close();
		</script>
	<% 
	} else{
	%>
		<script type="text/javascript">
			opener.document.frm.id_message.value = "사용할 수 없는 아이디입니다.";
			opener.document.frm.reid.value = <%=result%>;
			self.close();
		</script>
	<% 
	}
	%>
</body>
</html>