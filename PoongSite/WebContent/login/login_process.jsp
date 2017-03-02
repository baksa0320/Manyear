<%@ page import="java.io.IOException"%>
<%@page import="com.login.dto.MemberVO"%>
<%@page import="com.login.dao.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String url = "/home";
	if (session.getAttribute("loginUser") != null) { // 이미 로그인된 사용자이면
		response.sendRedirect(url);
	}
	String id = request.getParameter("id");
	String pwd = request.getParameter("pwd");
	MemberDAO mDao = MemberDAO.getInstance();
	int result = mDao.userCheck(id, pwd);
	if (result == 1) {
		MemberVO mVo = mDao.getMember(id);
		HttpSession session2 = request.getSession();
		session2.setAttribute("loginUser", mVo);
		request.setAttribute("message", "로그인에 성공했습니다.");
		response.sendRedirect(url);
	} else if (result == 0 || result == -1) {
%>
		<script type="text/javascript">
			alert("아이디 또는 비밀번호가 맞지 않습니다.");
			history.back();
		</script>
<%
	}
%>