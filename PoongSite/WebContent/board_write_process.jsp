<%@page import="com.board.dao.BoardDAO"%>
<%@page import="com.board.dto.BoardVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	try{
		String method = request.getMethod();
		if (method.equals("GET")) {
			RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");
			dispatcher.forward(request, response);
		} else if (method.equals("POST")) {
			request.setCharacterEncoding("UTF-8");
			String id = request.getParameter("id");
			String nick = request.getParameter("nick");
			String pwd = request.getParameter("pwd");
			String title = request.getParameter("title");
			String content = request.getParameter("content");
			int select = Integer.parseInt(request.getParameter("select"));
			System.out.println(content);
			String clientIp = request.getRemoteAddr();
			BoardVO bVo = new BoardVO();
			BoardDAO bDao = BoardDAO.getInstance();

			bVo.setId(id);
			bVo.setNick(nick);
			bVo.setPwd(pwd);
			bVo.setTitle(title);
			bVo.setIp(clientIp);
			bVo.setContent(content);
			bVo.setRecommend(0);
			bDao.setInsertBoard(bVo, select);
		}
	} catch(Exception e){
		e.printStackTrace();
		response.sendRedirect("index.jsp");
	}
%>