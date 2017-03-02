<%@page import="com.login.dao.MemberDAO"%>
<%@page import="com.login.dto.MemberVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String method = request.getMethod();
	if (method.equals("GET")) {
		RequestDispatcher dispatcher = request.getRequestDispatcher("/error");
		dispatcher.forward(request, response);
	} else if (method.equals("POST")) {
		request.setCharacterEncoding("UTF-8");
		String nick = request.getParameter("nick");
		String id = request.getParameter("id");
		String pwd = request.getParameter("pwd");
		String email = request.getParameter("email");
		
		MemberVO mVo = new MemberVO();
		mVo.setNick(nick);
		mVo.setId(id);
		mVo.setPwd(pwd);
		mVo.setEmail(email);
		
		MemberDAO mDao = MemberDAO.getInstance();
		int result = mDao.insertMember(mVo);
		HttpSession session2 = request.getSession();
		if (result == 1) {
			session2.setAttribute("id", mVo.getId());
		} else {
		}
		response.sendRedirect("/error");
	}
%>