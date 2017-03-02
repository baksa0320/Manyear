package com.board.dao;

import java.io.File;
import java.io.StringReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.board.dto.BoardVO;
import com.login.dto.MemberVO;

import util.DBManager;

public class BoardDAO{

	private static BoardDAO instance = new BoardDAO();

	public static BoardDAO getInstance() {
		return instance;
	}
	
	public List<BoardVO> getBoardList(int pageNum, int select) {
		String sql = "select * from (select title, id, nick, dates, hits, recommend, num, rank() over (order by num desc) num_rank from board" + select + ") where num_rank <= ? and num_rank > ?";
		List<BoardVO> list = new ArrayList<BoardVO>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, 20 * pageNum);
			pstmt.setInt(2, 20 * pageNum - 20);
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				BoardVO pVo = new BoardVO();
				pVo.setNum(rs.getInt("num"));
				pVo.setId(rs.getString("id"));
				pVo.setNick(rs.getString("nick"));
				pVo.setTitle(rs.getString("title"));
				pVo.setDates(rs.getString("dates"));
				pVo.setHits(rs.getInt("hits"));
				pVo.setRecommend(rs.getInt("recommend"));
				pVo.setCommSize(getCommentsSize(rs.getInt("num"), select));
				list.add(pVo);
			}
		}
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBManager.close(conn, pstmt, rs);
		}
		return list;
	}

	public void setInsertBoard(BoardVO pVo, int select) {
		String sql = "insert into board" + select + " values(board" + select + "_num.nextval, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		Date d = new Date();
	    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    String date = format.format(d);
	    
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBManager.getConnection();
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(sql);	
			pstmt.setString(1, pVo.getId());
			pstmt.setString(2, pVo.getNick());
			pstmt.setString(3, pVo.getTitle());
			pstmt.setString(4, pVo.getPwd());
			pstmt.setString(5, date);
			pstmt.setInt(6, pVo.getHits());
			pstmt.setString(7, pVo.getIp());
			StringReader sr = new StringReader(pVo.getContent());
	        pstmt.setCharacterStream(8, sr, pVo.getContent().length());
			pstmt.setInt(9, pVo.getRecommend());
			pstmt.executeUpdate();
			conn.commit();
			conn.setAutoCommit(true);
			addUserScore(pVo.getNick());
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBManager.close(conn, pstmt);
		}
	}
	private void addUserScore(String nick){
		String sql = "update member set score=((select score from member where nick=?)+100) where nick=?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, nick);
			pstmt.setString(2, nick);
			pstmt.executeUpdate();
			MemberVO mVo = new MemberVO();
			mVo.setScore(mVo.getScore() + 100);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBManager.close(conn, pstmt);
		}
	}
	public BoardVO getBoardContent(String num, int hits, int select) {
		String sql = "select * from board" + select + " where num=?";
		BoardVO pVo = null;
		try {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = DBManager.getConnection();
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, num);
				rs = pstmt.executeQuery();
				setUpdateHits(hits, num, select);
				if (rs.next()) {
					pVo = new BoardVO();
					pVo.setNum(rs.getInt("num"));
					pVo.setId(rs.getString("id"));
					pVo.setNick(rs.getString("nick"));
					pVo.setTitle(rs.getString("title"));
					pVo.setDates(rs.getString("dates"));
					pVo.setHits(rs.getInt("hits") + 1);
					pVo.setContent(rs.getString("content"));
					pVo.setRecommend(rs.getInt("recommend"));
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBManager.close(conn, pstmt, rs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return pVo;
	}

	private void setUpdateHits(int hits, String num, int select){
		String sql = "update board" + select + " set hits=? where num=?";
		int hit = hits + 1;
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, hit);
			pstmt.setInt(2, Integer.parseInt(num));
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBManager.close(conn, pstmt);
		}
	}
	public void setUpdateBoard(BoardVO pVo, int select) {
		String sql = "update board" + select + " set nick=?, title=?, pwd=?, content=? where num=?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, pVo.getNick());
			pstmt.setString(2, pVo.getTitle());
			pstmt.setString(3, pVo.getPwd());
			pstmt.setString(4, pVo.getContent());
			pstmt.setInt(5, pVo.getNum());
			pstmt.executeUpdate(); // �뜝�룞�삕�뜝�룞�삕�뜝�룞�삕 �뜝�룞�삕�뜝�룞�삕
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBManager.close(conn, pstmt);
		}
	}

	public void getDeleteCheck(int num, int select) {
		String sql = "select * from board" + select + " where num=?";
		try {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = DBManager.getConnection();
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, num);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					getImageName(rs.getString("content"));
					setDeleteWritable(num, select);
					setDeleteComment(num, select);
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBManager.close(conn, pstmt, rs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public boolean getDeleteCheck(int num, String pwd, int select) {
		String sql = "select * from board" + select + " where num=? and pwd=?";
		try {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = DBManager.getConnection();
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, num);
				pstmt.setString(2, pwd);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					getImageName(rs.getString("content"));
					setDeleteWritable(num, select);
					setDeleteComment(num, select);
					return true;
				} else
					return false;
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBManager.close(conn, pstmt, rs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	private void getImageName(String content){
		String filePath = "D:\\poongsite\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\PoongSite\\";
		
		try{
			String[] contents = content.toString().split("src=");
			File file;
			for(int i = 0; i < contents.length; i++){
				System.out.println(contents[i]);
				if(contents[i].contains("upload")){
					contents[i] = contents[i].substring(contents[i].indexOf("u"), contents[i].indexOf("\">"));
					System.out.println("���Ͼ��ε� : " + filePath + contents[i]);
					file = new File(filePath + contents[i]);
					if(file.exists())
						file.delete();
				}
			}
		} catch(Exception e){
			System.out.println("���� ���ε� ����");
		}
		
	}
	
	private void setDeleteWritable(int num, int select){
		String sql = "delete board" + select + " where num=?";
		try {
			Connection conn = null;
			PreparedStatement pstmt = null;
			try {
				conn = DBManager.getConnection();
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, num);
				pstmt.executeUpdate();
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBManager.close(conn, pstmt);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private void setDeleteComment(int num, int select){
		String sql = "delete comments" + select + " where num=?";
		try {
			Connection conn = null;
			PreparedStatement pstmt = null;
			try {
				conn = DBManager.getConnection();
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, num);
				pstmt.executeUpdate();
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBManager.close(conn, pstmt);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	private int getCommentsSize(int num, int select) {
		String sql = "select num from comments" + select + " where num=?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int size = 0;
		
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			rs.last();
			size = rs.getRow();
		}
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBManager.close(conn, pstmt, rs);
		}
		return size;
	}

	public int getBoardSize(int select) {
		String sql = "select num from board" + select;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int size = 0;
		
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			rs = pstmt.executeQuery();
			rs.last();
			size = rs.getRow();
		}
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBManager.close(conn, pstmt, rs);
		}
		return size;
	}
} // �겢�뜝�룞�삕�뜝�룞�삕�뜝�룞�삕 �뜝�룞�삕