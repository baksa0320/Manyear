package com.board.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.board.dto.CommentVO;

import util.DBManager;

public class CommentDAO {

	private static CommentDAO instance = new CommentDAO();
	public static CommentDAO getInstance() {
		return instance;
	}

	public void insertComment(CommentVO cVo, int select) {
		String sql = "insert into comments" + select + " values(?, ?, ?, ?, ?, ?, ?, ?)";

		Date d = new Date();
	    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    String date = format.format(d);
	    
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cVo.getNum());
			pstmt.setString(2, cVo.getName());
			pstmt.setString(3, cVo.getPwd());
			pstmt.setString(4, cVo.getContent());
			pstmt.setString(5, date);
			pstmt.setString(6, cVo.getIp());
			pstmt.setInt(7, 0);
			pstmt.setInt(8, 0);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBManager.close(conn, pstmt);
		}
	}

	public List<CommentVO> selectComments(String num, int select) {
		String sql = "select * from comments" + select + " where num=? order by dates desc";
		List<CommentVO> list = new ArrayList<CommentVO>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt(num));
			rs = pstmt.executeQuery();
			while (rs.next()) {
				CommentVO cVo = new CommentVO();
				cVo.setName(rs.getString("name"));
				cVo.setPwd(rs.getString("pwd"));
				cVo.setContent(rs.getString("content"));
				cVo.setDates(rs.getString("dates"));
				cVo.setIp(rs.getString("ip"));
				cVo.setGood(rs.getInt("good"));
				cVo.setBad(rs.getInt("bad"));
				list.add(cVo);
			}
		}
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBManager.close(conn, pstmt, rs);
		}
		return list;
	}
	public boolean getDeleteCheck(int num, String name, String pwd, int select) {
		String sql = "select * from comments" + select + " where num=? and name=? and pwd=?";
		try {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = DBManager.getConnection();
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, num);
				pstmt.setString(2, name);
				pstmt.setString(3, pwd);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					deleteComment(num, name, pwd, select);
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
	private void deleteComment(int num, String name, String pwd, int select){
		String sql = "delete comments" + select + " where num=? and name=? and pwd=?";
		try {
			Connection conn = null;
			PreparedStatement pstmt = null;
			try {
				conn = DBManager.getConnection();
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, num);
				pstmt.setString(2, name);
				pstmt.setString(3, pwd);
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
}
