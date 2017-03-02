<%@page import="com.login.dao.MemberDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="Video.VideoLengthVO"%>
<%@page import="Video.VideoLengthDAO"%>
<%@page import="Video.VideoDAO"%>
<%@page import="Video.VideoVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	boolean scoreTF = false;
	if(request.getMethod().equals("POST")){
		try{
			String nick = request.getParameter("nick");
			String name = request.getParameter("name");
			String description = request.getParameter("description");
			int starts = Integer.parseInt(request.getParameter("starts"));
			int length = Integer.parseInt(request.getParameter("length"));
			int score = Integer.parseInt(request.getParameter("score"));

			MemberDAO mdao = MemberDAO.getInstance();
			scoreTF = mdao.getUserScore(nick, score);
			
			if(scoreTF){
				VideoLengthVO vlVo = new VideoLengthVO();
				VideoLengthDAO vlDao = VideoLengthDAO.getInstance();
	
				vlVo = vlDao.getVideoLength();
				vlDao.updateVideoLength(vlVo.getLength() + (length - starts));
				
				Date d = new Date();

			    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			    String date = format.format(d);
			    /*
				int hours = date.getHours();
				int minutes = date.getMinutes();
				int seconds = date.getSeconds() + length;
				
				if(seconds >= 60){
					minutes = date.getMinutes() + ((int) (seconds / 60));
					seconds = seconds % 60;
					if(minutes >= 60){
						hours = date.getHours() + ((int) (minutes / 60));
						minutes = minutes % 60;
					}
				}
				*/
				VideoVO vVo = new VideoVO();
				VideoDAO vDao = VideoDAO.getInstance();
	
				vVo.setNick(nick);
				vVo.setName(name);
				vVo.setDescription(description);
				vVo.setStarts(starts);
				vVo.setLength(length);
				vVo.setDates(date);
				vDao.insertVideo(vVo);
				out.print(scoreTF);
			}
		} catch(Exception e){
			response.sendRedirect("home.jsp");
		}
	} else {
		response.sendRedirect("home.jsp");
	}
%>