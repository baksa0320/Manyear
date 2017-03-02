<%@page import="org.json.simple.JSONObject"%>
<%@page import="com.board.dao.BoardDAO"%>
<%@page import="java.util.List"%>
<%@page import="com.board.dto.BoardVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	if(request.getMethod().equals("POST")){
		try{
			String num = request.getParameter("num");
			int hits = Integer.parseInt(request.getParameter("hits"));
			int select = Integer.parseInt(request.getParameter("select"));
			BoardDAO pDao = BoardDAO.getInstance();
			BoardVO pVo = pDao.getBoardContent(num, hits, select);
			
		  	JSONObject jObject = new JSONObject();
		  	
	  		jObject.put("num", pVo.getNum());
	  		jObject.put("id", pVo.getId());
	  		jObject.put("nick", pVo.getNick());
	  		jObject.put("title", pVo.getTitle());
	  		jObject.put("dates", pVo.getDates());
	  		jObject.put("hits", pVo.getHits());
	  		jObject.put("content", pVo.getContent());
	  		jObject.put("select", select);
		  	out.print(jObject);
		} catch(Exception e){
			response.sendRedirect("index.jsp");
		}
	} else {
		response.sendRedirect("index.jsp");
	}
%>