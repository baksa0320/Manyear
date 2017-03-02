<%@page import="com.board.dto.CommentVO"%>
<%@page import="com.board.dao.CommentDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	boolean deleteCheck = false;
	if(request.getMethod().equals("POST")){
		int select = Integer.parseInt(request.getParameter("select"));
		int num = Integer.parseInt(request.getParameter("num"));
		String name = request.getParameter("name");
		String pwd = request.getParameter("pwd");
		
		CommentDAO cDao = CommentDAO.getInstance();
		
		deleteCheck = cDao.getDeleteCheck(num, name, pwd, select);
		System.out.println("댓글 삭제 : " + select + ", " + num + ", " + name + ", " + pwd);
	}
%>
<%=deleteCheck%>