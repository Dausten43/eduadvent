/**
 * 
 */
package aca.menu;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Elifo
 *
 */
public class Menu{
	private String menu_id;
	private String menu_nombre;
	
	public Menu(){
		menu_id			= "";
		menu_nombre		= "";
	}
			
	public String getMenu_id() {
		return menu_id;
	}

	public void setMenu_id(String menu_id) {
		this.menu_id = menu_id;
	}

	public String getMenu_nombre() {
		return menu_nombre;
	}

	public void setMenu_nombre(String menu_nombre) {
		this.menu_nombre = menu_nombre;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO MENU" +
					" (MENU_ID, MENU_NOMBRE)" +
					" VALUES(TO_NUMBER(?, '99'), ?)");
			
			ps.setString(1, menu_id);
			ps.setString(2, menu_nombre);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.menu.Menu|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE MENU" +
					" SET MENU_NOMBRE = ?" +
					" WHERE MENU_ID = TO_NUMBER(?, '99')");
			
			ps.setString(1, menu_id);
			ps.setString(2, menu_nombre);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.menu.Menu|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM MENU" +
					" WHERE MENU_ID = TO_NUMBER(?, '99')");
			
			ps.setString(1, menu_id);
			ps.setString(2, menu_nombre);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.menu.Menu|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		menu_id			= rs.getString("MENU_ID");
		menu_nombre		= rs.getString("MENU_NOMBRE");
	}
	
	public void mapeaRegId(Connection con, String codigoId) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null; 
		try{
			ps = con.prepareStatement("SELECT *" +
					" FROM MENU" +
					" WHERE MENU_ID = TO_NUMBER(?, '99')");
				
			ps.setString(1, menu_id);
			ps.setString(2, menu_nombre);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.menu.Menu|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
	}
	
	public boolean existeReg(Connection conn) throws SQLException{
		boolean ok 			= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM MENU" +
					" WHERE MENU_ID = TO_NUMBER(?, '99')");
			
			ps.setString(1, menu_id);
			ps.setString(2, menu_nombre);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.menu.Menu|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
}