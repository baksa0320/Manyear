<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="com.board.dto.BoardVO"%>
<%@page import="com.board.dao.BoardDAO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	try{
		int select = Integer.parseInt(request.getParameter("select"));
		int pageNum = 1;
		BoardDAO bDao = BoardDAO.getInstance();
		int boardSize = bDao.getBoardSize(select) / 20;
		
		try{
			pageNum = Integer.parseInt(request.getParameter("page"));
			if(pageNum < 1){
				pageNum = 1;
			} else if(pageNum > boardSize){
				pageNum = boardSize + 1;
			}
		} catch(Exception e){
			pageNum = 1;
		}
		List<BoardVO> boardList = bDao.getBoardList(pageNum, select);
		
		JSONObject jsonMain = new JSONObject();
	  	JSONArray jArray = new JSONArray();
	  	
	  	for(int i = 0; i < boardList.size(); i++){
		  	JSONObject jObject = new JSONObject();
	  		jObject.put("num", boardList.get(i).getNum());
	  		jObject.put("id", boardList.get(i).getId());
	  		jObject.put("nick", boardList.get(i).getNick());
	  		jObject.put("title", boardList.get(i).getTitle());
	  		jObject.put("dates", boardList.get(i).getDates());
	  		jObject.put("hits", boardList.get(i).getHits());
	  		jObject.put("commSize", boardList.get(i).getCommSize());
	  		jObject.put("select", select);
	  		jArray.add(i, jObject);
	  	}
	  	jsonMain.put("boardList", jArray);
	  	out.print(jsonMain);
	} catch(Exception e){
		response.sendRedirect("index.jsp");
	}
%>