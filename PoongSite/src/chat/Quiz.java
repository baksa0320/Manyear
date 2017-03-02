package chat;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Random;


public class Quiz {

	public static Quiz getInstance = new Quiz();

	private ArrayList<String> QUESTION = new ArrayList<>();
	
	private Quiz(){
		File file = new File("Question.txt");
		FileInputStream fis = null;
		InputStreamReader isr = null;
		BufferedReader br = null;
		String temp = "";
		
		try{
			fis = new FileInputStream(file);
			isr = new InputStreamReader(fis, "UTF-8");
			br = new BufferedReader(isr);
			while( (temp = br.readLine()) != null) {
				QUESTION.add(temp);
            }
		} catch(IOException e){}
		finally {
			try {
				fis.close();
				isr.close();
				br.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
	
	public final String QUIZNAME = "퀴즈봇: ";
	public boolean quizStart = false;
	public String answer;
	private BroadSocket bs = new BroadSocket();

	public void setQuiz() throws IOException, InterruptedException{
		
		Random ran = new Random();
		int num = ran.nextInt(QUESTION.size());
		String[] tempQuest = QUESTION.get(num).split(":");
		answer = tempQuest[1];
		bs.onMessage(QUIZNAME + tempQuest[0], null);
		
		Thread th = new Thread(new Runnable() {
			@Override
			public void run() {
				int time = 0;
				while(quizStart){
					try{
						if(time == 1000){
							bs.onMessage(QUIZNAME + "시간 초과! 정답은 " + answer + " 입니다.", null);
							answer = "";
							Thread.sleep(3000);
							setQuiz();
							break;
						} else if(answer.equals("") == false){
							Thread.sleep(10);
							time++;
						} else{
							break;
						}
					} catch(InterruptedException | IOException e) {
						e.printStackTrace();
					}
				}
			}
		});
		th.start();
	}
}
