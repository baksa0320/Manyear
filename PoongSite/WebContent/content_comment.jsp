<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.util.List"%>
<%@page import="com.board.dao.CommentDAO"%>
<%@page import="com.board.dto.CommentVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	if(request.getMethod().equals("POST")){
		try{
			String num = request.getParameter("num");
			int select = Integer.parseInt(request.getParameter("select"));

			CommentDAO cDao = CommentDAO.getInstance();
			List<CommentVO> commentList = cDao.selectComments(num, select);

			JSONObject jsonMain = new JSONObject();
		  	JSONArray jArray = new JSONArray();
		  	if(commentList.size() > 0){
		  		for(int i = 0; i < commentList.size(); i++){
				  	JSONObject jObject = new JSONObject();
		  			jObject.put("commName", commentList.get(i).getName());
		  			jObject.put("commPwd", commentList.get(i).getPwd());
		  			jObject.put("commIp", commentList.get(i).getIp());
		  			jObject.put("commDates", commentList.get(i).getDates());
		  			jObject.put("commContent", commentList.get(i).getContent());
		  			jObject.put("commGood", commentList.get(i).getGood());
		  			jObject.put("commBad", commentList.get(i).getBad());
			  		jArray.add(i, jObject);
				  	jsonMain.put("comments", jArray);
		  		}
		  	} else{
		  		jsonMain.put("commSize", 0);
		  	}
		  	out.print(jsonMain);
		  	//System.out.println(jsonMain);
		} catch(Exception e){
			response.sendRedirect("index.jsp");
		}
	} else {
		response.sendRedirect("index.jsp");
	}
%>