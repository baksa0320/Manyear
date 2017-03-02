<%@page import="Video.VideoThread"%>
<%@page import="Video.VideoLengthDAO"%>
<%@page import="Video.VideoLengthVO"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.util.List"%>
<%@page import="Video.VideoDAO"%>
<%@page import="Video.VideoVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%!
	private VideoLengthDAO vlDao = VideoLengthDAO.getInstance();
	private VideoLengthVO vlVo = new VideoLengthVO();
	private int num = 0;
	private int totalLength = 0;
	private int readyNum = 0;
	
	private VideoDAO vDao = VideoDAO.getInstance();
	private VideoVO vVo = null;
%>
<%
	if(request.getMethod().equals("POST")){
		try{
			int change = Integer.parseInt(request.getParameter("change"));
			vlVo = vlDao.getVideoLength();
			num = vlVo.getNum();
			readyNum = vlDao.getVideoCount() - vlVo.getNum() + 1;
			if(change == 0){
				if(readyNum < 0){
					readyNum = 0;
					VideoThread.setStartNum(0);
				}
			}
		  	
			vVo = vDao.getVideo(num);

			VideoThread.getInstance(vVo.getLength());
			if(VideoThread.getStartNum() < vVo.getStarts()){
				VideoThread.setStartNum(vVo.getStarts());
			}
			JSONObject jObject = new JSONObject();
			jObject.put("length", totalLength);
			jObject.put("readyNum", readyNum);
			jObject.put("nick", vVo.getNick());
			jObject.put("name", vVo.getName());
			jObject.put("description", vVo.getDescription());
			jObject.put("currents", VideoThread.getStartNum());
			jObject.put("length", vVo.getLength());
		  	out.print(jObject);
		  	
		} catch(Exception e){
			response.sendRedirect("index.jsp");
		}
	} else {
		response.sendRedirect("index.jsp");
	}
%>