package Video;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import util.DBManager;

public class VideoDAO {

	private static VideoDAO instance = new VideoDAO();
	public static VideoDAO getInstance() {
		return instance;
	}
	public VideoVO getVideo(int videoNum) {
		String sql = "select * from video where num = ?";
		VideoVO vVo = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, videoNum);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				vVo = new VideoVO();
				vVo.setNum(rs.getInt("num"));
				vVo.setNick(rs.getString("nick"));
				vVo.setName(rs.getString("name"));
				vVo.setDescription(rs.getString("description"));
				vVo.setStarts(rs.getInt("starts"));
				vVo.setLength(rs.getInt("length"));
				vVo.setDates(rs.getString("dates"));
			}
		}
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBManager.close(conn, pstmt, rs);
		}
		return vVo;
	}
	public List<VideoVO> getVideoList(int videoNum) {
		String sql = "select * from video where num >= ?";
		List<VideoVO> list = new ArrayList<VideoVO>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, videoNum);
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				VideoVO vVo = new VideoVO();
				vVo.setNum(rs.getInt("num"));
				vVo.setNick(rs.getString("nick"));
				vVo.setName(rs.getString("name"));
				vVo.setDescription(rs.getString("description"));
				vVo.setStarts(rs.getInt("starts"));
				vVo.setLength(rs.getInt("length"));
				vVo.setDates(rs.getString("dates"));
				list.add(vVo);
			}
		}
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBManager.close(conn, pstmt, rs);
		}
		return list;
	}

	public void insertVideo(VideoVO vVo) {
		String sql = "insert into video values(video_num.nextval, ?, ?, ?, ?, ?, ?)";

		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, vVo.getNick());
			pstmt.setString(2, vVo.getName());
			pstmt.setString(3, vVo.getDescription());
			pstmt.setInt(4, vVo.getStarts());
			pstmt.setInt(5, vVo.getLength());
			pstmt.setString(6, vVo.getDates());
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBManager.close(conn, pstmt);
		}
	}
}
