<%@page import="com.board.dto.CommentVO"%>
<%@page import="com.board.dao.CommentDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	if(request.getMethod().equals("POST")){
		int select = Integer.parseInt(request.getParameter("select"));
		String num = request.getParameter("num");
		String name = request.getParameter("name");
		String pwd = request.getParameter("pwd");
		String content = request.getParameter("content");
		String ip = request.getRemoteAddr();
	
		CommentVO cVo = new CommentVO();
		CommentDAO cDao = CommentDAO.getInstance();
		
		cVo.setNum(Integer.parseInt(num));
		cVo.setName(name);
		cVo.setPwd(pwd);
		cVo.setContent(content);
		cVo.setIp(ip);
		cDao.insertComment(cVo, select);
	}
%>