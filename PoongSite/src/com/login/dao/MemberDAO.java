package com.login.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.login.dto.MemberVO;

import util.DBManager;
import util.SHA256;

public class MemberDAO {
	private MemberDAO() {
	}

	private static MemberDAO instance = new MemberDAO();

	public static MemberDAO getInstance() {
		return instance;
	}
	public int userCheck(String id, String pwd) throws Exception {
		String sha256PWD = SHA256.getSHACode(pwd);
		int result = -1;
		String sql = "select pwd from member where id=?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getString("pwd") != null && rs.getString("pwd").equals(sha256PWD)) {
					result = 1;
				} else {
					result = 0;
				}
			} else {
				result = -1;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return result;
	}

	// ¾ÆÀÌµð Áßº¹ Ã¼Å©
	public MemberVO getMember(String id) {
		MemberVO mVo = null;
		String sql = "select * from member where id=?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				mVo = new MemberVO();
				mVo.setId(rs.getString("id"));
				mVo.setPwd(rs.getString("pwd"));
				mVo.setNick(rs.getString("nick"));
				mVo.setEmail(rs.getString("email"));
				mVo.setLevels(rs.getInt("levels"));
				mVo.setScore(rs.getInt("score"));
				mVo.setAdmin(rs.getInt("admin"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return mVo;
	}

	// getMember() ï¿½Þ¼ï¿½ï¿½ï¿½ ï¿½Ú¿ï¿½ ï¿½Úµï¿½ ï¿½ß°ï¿½, ï¿½ï¿½ï¿½Ìµï¿½ ï¿½ßºï¿½ Ã¼Å©ï¿½ï¿½ ï¿½ï¿½ï¿½ï¿½ ï¿½Þ¼ï¿½ï¿½ï¿½
	public int confirmID(String id) {
		if(id.length() < 2){//ï¿½Ð³ï¿½ï¿½ï¿½ ï¿½ï¿½ï¿½Ì°ï¿½ 2ï¿½Ì»ï¿½ï¿½ï¿½ï¿½ï¿½ È®ï¿½ï¿½
			return 0;
		}
		int result = -1;
		String sql = "select id from member where id=?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				result = 1;
			} else {
				result = -1;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return result;
	}

	public int confirmNick(String nick) {
		String[] filter = { "¿î¿µÀÚ", "ÄûÁîº¿", "°ü¸®ÀÚ", "¾îµå¹Î", "admin" };
		if(nick.length() < 2)//´Ð³×ÀÓ ÇÊÅÍ
			return 0;
		
		for(String str : filter){
			if(nick.equals(str))
				return 0;
		}
		int result = -1;
		String sql = "select nick from member where nick=?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, nick);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				result = 1;
			} else {
				result = -1;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return result;
	}
	
	public int insertMember(MemberVO mVo) {
		int result = -1;
		String sql = "insert into member values(?, ?, ?, ?, ?, ?, ?)";
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, mVo.getId());
			pstmt.setString(2, SHA256.getSHACode(mVo.getPwd()));
			pstmt.setString(3, mVo.getNick());
			pstmt.setString(4, mVo.getEmail());
			pstmt.setInt(5, 1);
			pstmt.setInt(6, 300000);
			pstmt.setInt(7, 0);
			result = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return result;
	}

	// insertMember() ï¿½Þ¼ï¿½ï¿½ï¿½ ï¿½Ú¿ï¿½ ï¿½Úµï¿½ ï¿½ß°ï¿½, È¸ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ ï¿½ï¿½ï¿½ï¿½
	public int updateMember(MemberVO mVo) {
		int result = -1;
		String sql = "update member set pwd=?, nick=?, email=? where id=?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, mVo.getPwd());
			pstmt.setString(2, mVo.getNick());
			pstmt.setString(3, mVo.getEmail());
			pstmt.setString(4, mVo.getId());
			result = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return result;
	}
	
	public boolean confirmEmail(String email) {
		boolean result = false;
		String sql = "select nick from member where email=?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, email);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				result = false;
			} else {
				result = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return result;
	}
	public boolean getUserScore(String nick, int score) {
		String sql = "select score from member where nick=?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, nick);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				int myscore = rs.getInt("score");
				if(myscore >= score){
					updateScore(nick, myscore - score);
					return true;
				} else {
					return false;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return false;
	}
	private void updateScore(String nick, int score) {
		String sql = "update member set score=? where nick=?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, score);
			pstmt.setString(2, nick);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
}
