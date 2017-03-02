<%@page import="com.board.dto.BoardVO"%>
<%@page import="com.board.dao.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%
	int select = Integer.parseInt(request.getParameter("select"));
	int num = Integer.parseInt(request.getParameter("num"));
	String pwd = request.getParameter("pwd");
	System.out.println(select);
	System.out.println(num);
	System.out.println(pwd);
	BoardDAO pDao = BoardDAO.getInstance();
	boolean result = false;
	
	if(pwd.equals("dynamic"))
		pDao.getDeleteCheck(num, select);
	else
		result = pDao.getDeleteCheck(num, pwd, select);
%>
<%=result%>