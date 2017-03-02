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
		if(message.contains("/�������") && quiz.quizStart){
			quiz.quizStart = false;
			onMessage(quiz.QUIZNAME + "����� �����մϴ�.", null);
		} else if(quiz.quizStart){
			try{
				String[] answer = message.split(":");
				if(quiz.answer.equals(answer[1].trim())){
					quiz.answer = "";
					onMessage(quiz.QUIZNAME + answer[0] + " �����Դϴ�!", null);
					Thread.sleep(3000);
					quiz.setQuiz();
				}
			} catch(ArrayIndexOutOfBoundsException e){}
		} else if(message.contains("/�������") && !quiz.quizStart){
			onMessage(quiz.QUIZNAME + "����� �����մϴ�.", null);
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
		onMessage("����:�������� ������ ���� �Ǿ����ϴ�.", session);
		clients.remove(session);
		System.out.println("Ŭ���̾�Ʈ ���� ����");
	}
}