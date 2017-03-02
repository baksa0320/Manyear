<%@page import="com.login.dao.MemberDAO"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="javax.mail.MessagingException"%>
<%@page import="javax.mail.Transport"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.Session"%>
<%@page import="javax.mail.Authenticator" %>
<%@page import="javax.mail.PasswordAuthentication" %>
<%@page import="java.util.UUID"%>
<%@page import="java.util.Properties" %>
<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%
	String randomCode = "";
	if(request.getMethod().equals("POST")){
		try{
		    String email = request.getParameter("email");    // 받는 사람
			MemberDAO mDao = MemberDAO.getInstance();
			boolean result = mDao.confirmEmail(email);
			if(result == false){
				return;
			}
			else
				randomCode = UUID.randomUUID().toString().substring(0, 6);
		
		    String sbj = "'poongs' 사이트에서 보낸 이메일 인증 코드 메일입니다.";
		    String sf = "baksa0320@naver.com";   // 보내는 사람(인증 정보와 동일한 email 주소여야 함!!)
		    String sMsg = "'poongs' 사이트에서 발송된 인증 메일 입니다.<br>" + 
		    				"인증코드 : " + randomCode + "<br>" +
		    				"회원가입 인증코드 입력란에 기입해주세요.";
		
		    Properties p = new Properties(); // 정보를 담을 객체
		
		    p.put("mail.smtp.host","smtp.naver.com"); // 네이버 SMTP
		
		    p.put("mail.smtp.port", "465");
		    // p.put("mail.smtp.starttls.enable", "false");   // 이부분은 true,false든 일단 제외시키니깐 정상작동되네...
		    p.put("mail.smtp.auth", "true");
		    p.put("mail.smtp.debug", "true");
		    p.put("mail.smtp.socketFactory.port", "465");
		    p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		    p.put("mail.smtp.socketFactory.fallback", "false");
		
		    try {
		      Session mailSession = Session.getInstance(p,
		              new javax.mail.Authenticator() {
		                protected PasswordAuthentication getPasswordAuthentication() {
		                  return new PasswordAuthentication("baksa0320","Rkdwnsgur1@");    // 네이버 메일 ID / PWD
		                }
		              });
		
		      mailSession.setDebug(true);
		
		      // Create a default MimeMessage object.
		      Message message = new MimeMessage(mailSession);
		
		      // Set From: header field of the header.
		      message.setFrom(new InternetAddress(sf));
		
		      // Set To: header field of the header.
		      message.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
		
		      // Set Subject: header field
		      message.setSubject(sbj);
		
		      // Now set the actual message
		      message.setContent(sMsg, "text/html;charset=utf-8"); // 내용과 인코딩
		
		      // Send message
		      Transport.send(message);
		
		      // System.out.println("Sent message successfully....");
		      // sResult = "Sent message successfully....";
		      
		    } catch (MessagingException e) {
		      e.printStackTrace();
		      System.out.println("Error: unable to send message...." + e.toString());
		    }
		}catch (Exception err){
		  System.out.println(err.toString());
		}finally {
		  // dbhandle.close(dbhandle.con);
		}
	}
%>
<%=randomCode%>