<%@page import="com.login.dto.MemberVO"%>
<%@page import="com.login.dao.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>회원정보 수정</title>
</head>
<body>
	<%
		String method = request.getMethod();
		if (method.equals("GET")) {
			String id = request.getParameter("id");
			MemberDAO mDao = MemberDAO.getInstance();
			MemberVO mVo = mDao.getMember(id);
			request.setAttribute("mVo", mVo);
			RequestDispatcher dispatcher = request.getRequestDispatcher("memberUpdate.jsp");
			dispatcher.forward(request, response);
		} else if (method.equals("POST")) {
			request.setCharacterEncoding("UTF-8"); 
			String nick = request.getParameter("nick");
			String id = request.getParameter("id");
			String email = request.getParameter("email");
			String pwd = request.getParameter("pwd");
			
			MemberVO mVo = new MemberVO();
			mVo.setNick(nick);
			mVo.setId(id);
			mVo.setPwd(pwd);
			mVo.setEmail(email);
			MemberDAO mDao = MemberDAO.getInstance();
			mDao.updateMember(mVo);
			
			String url = "login_process.jsp";
			HttpSession session2 = request.getSession();
			session2.setAttribute("loginUser", mVo);
			request.setAttribute("message", "회원정보를 수정하였습니다.");
			RequestDispatcher dispatcher = request.getRequestDispatcher(url);
			dispatcher.forward(request, response);
		}
	%>
</body>
</html>