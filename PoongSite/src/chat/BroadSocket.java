package chat;

import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint("/chat")
public class BroadSocket {

	public static Set<Session> clients = Collections
			.synchronizedSet(new HashSet<Session>());
	private static Quiz quiz = Quiz.getInstance;
	
	@OnMessage
	public void onMessage(String message, Session session) throws IOException, InterruptedException {
		System.out.println(message);
		synchronized (clients) {
			// Iterate over the connected sessions
			// and broadcast the received message
			for (Session client : clients) {
				if (!client.equals(session)) {
					client.getBasicRemote().sendText(message);
				}
			}
		}
		if(message.contains("/퀴즈봇종료") && quiz.quizStart){
			quiz.quizStart = false;
			onMessage(quiz.QUIZNAME + "퀴즈봇을 종료합니다.", null);
		} else if(quiz.quizStart){
			try{
				String[] answer = message.split(":");
				if(quiz.answer.equals(answer[1].trim())){
					quiz.answer = "";
					onMessage(quiz.QUIZNAME + answer[0] + " 정답입니다!", null);
					Thread.sleep(3000);
					quiz.setQuiz();
				}
			} catch(ArrayIndexOutOfBoundsException e){}
		} else if(message.contains("/퀴즈봇시작") && !quiz.quizStart){
			onMessage(quiz.QUIZNAME + "퀴즈봇을 가동합니다.", null);
			Thread.sleep(3000);
			quiz.setQuiz();
			quiz.quizStart = true;
		}
	}
	@OnOpen
	public void onOpen(Session session) {
		// Add session to the connected sessions set
		System.out.println(session);
		clients.add(session);
	}

	@OnClose
	public void onClose(Session session) {
		// Remove session from the connected sessions set
		clients.remove(session);
	}
	
	@OnError
	public void onError(Session session, Throwable e) throws IOException, InterruptedException {
		onMessage("서버:서버와의 접속이 해제 되었습니다.", session);
		clients.remove(session);
		System.out.println("클라이언트 강제 종료");
	}
}