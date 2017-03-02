<%@page import="com.board.dao.BoardDAO"%>
<%@page import="java.util.List"%>
<%@page import="com.board.dao.CommentDAO"%>
<%@page import="com.board.dto.CommentVO"%>
<%@page import="com.board.dto.BoardVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	int select = Integer.parseInt(request.getParameter("select"));
	try{
		String num = request.getParameter("num");
		int hits = Integer.parseInt(request.getParameter("hits"));
		BoardDAO pDao = BoardDAO.getInstance();
		BoardVO pVo = pDao.getBoardContent(num, hits, select);
		request.setAttribute("board", pVo);
		
		CommentDAO cDao = CommentDAO.getInstance();
		List<CommentVO> commentList = cDao.selectComments(num, select);
		request.setAttribute("comment", commentList);
		request.setAttribute("select", select);
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("board_detail.jsp");
		dispatcher.forward(request, response);
	} catch(Exception e){
		response.sendRedirect("index.jsp");
	}
%>