package Video;

public class VideoThread extends Thread{

	private static VideoThread instance = new VideoThread();

	private static int startNum = 0;
	private static int totalLength = -1;
	
	public static VideoThread getInstance(int length) {
		totalLength = length;
		System.out.println(totalLength);
		System.out.println(startNum);
		return instance;
	}
	
	@Override
	public void run() {
		while(true){
			try{
				if(totalLength == -1){
					startNum = 0;
				} else if(startNum >= totalLength && totalLength != -1){
					VideoLengthDAO vlDao = VideoLengthDAO.getInstance();
					VideoLengthVO vlVo = new VideoLengthVO();
					vlVo = vlDao.getVideoLength();
					int num = vlVo.getNum();
					vlDao.updateVideo(++num, 0);
					startNum = 0;
					totalLength = -1;
				}
				Thread.sleep(1000);
				startNum++;
			} catch(InterruptedException e){}
		}
	}
	public static void setStartNum(int num){
		startNum = num;
	}
	public static int getStartNum(){
		return startNum;
	}
	private VideoThread() {
		start();
		System.out.println("Thread Start");
	}
}
