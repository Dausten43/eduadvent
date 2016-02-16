// Clase para la tabla de Modulo
package aca.menu;

import java.sql.*;

public class Modulo  implements java.io.Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String moduloId;
	private String nombreModulo;
	private String url;
	private String menuId;
	
	// Constructor
	public Modulo(){		
		moduloId 		= "";
		nombreModulo	= "";
		url 			= "";
		menuId			= "";
	}
	
	

	public String getMenuId() {
		return menuId;
	}



	public void setMenuId(String menuId) {
		this.menuId = menuId;
	}



	public String getModuloId(){
		return moduloId;
	}
	
	public void setModuloId(String moduloId){
		this.moduloId = moduloId;
	}
	
	public String getNombreModulo(){
		return nombreModulo;
	}
	
	public void setNombreModulo(String nombreModulo){
		this.nombreModulo = nombreModulo;
	}
	
	public String getUrl(){
		return url;
	}
	
	public void setUrl(String url){
		this.url = url;
	}
		
	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO MODULO(MODULO_ID, NOMBRE_MODULO, URL, MENU_ID)" +
					" VALUES(?,?,?,TO_NUMBER(?,'99'))");
			ps.setString(1, moduloId);
			ps.setString(2, nombreModulo);
			ps.setString(3, url);
			ps.setString(4, menuId);
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.menu.Modulo|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE MODULO" +
					" SET NOMBRE_MODULO = ?," +
					" URL= ?, " +
					" MENU_ID = TO_NUMBER(?,'99')" +
					" WHERE MODULO_ID = ?");			
			ps.setString(1, nombreModulo);
			ps.setString(2, url);
			ps.setString(3, moduloId);
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.menu.Modulo|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM MODULO WHERE MODULO_ID = ?");
			ps.setString(1, moduloId);			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.menu.Modulo|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		moduloId 		= rs.getString("MODULO_ID");
		nombreModulo	= rs.getString("NOMBRE_MODULO");
		url 			= rs.getString("URL");
		menuId 			= rs.getString("MENU_ID");
	}
	
	public void mapeaRegId(Connection con, String moduloId) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null; 
		try{
			ps = con.prepareStatement("SELECT MODULO_ID, NOMBRE_MODULO, URL, MENU_ID " +
					" FROM MODULO WHERE MODULO_ID = ? ");
			ps.setString(1, moduloId);
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.meno.Modulo|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM MODULO WHERE MODULO_ID = ? ");
			ps.setString(1, moduloId);
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.menu.Modulo|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public static String getModuloNombre(Connection conn, int opcionId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String modulo			= "X";
		String comando = "";
	
		try{
			comando = "SELECT A.NOMBRE_MODULO FROM MODULO A " +
					"WHERE A.MODULO_ID IN " +
						"(SELECT B.MODULO_ID FROM MODULO_OPCION B WHERE B.OPCION_ID = "+opcionId+")";			
			ps = conn.prepareStatement(comando);
			rs= ps.executeQuery();		
			if(rs.next()){
				modulo = rs.getString(1);
			}
		
		}catch(Exception ex){
			System.out.println("Error - aca.menu.Modulo|getModuloNombre|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}

		return modulo;
	}
	
	public static String getModuloNombre(Connection conn, String moduloId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String modulo			= "X";
	
		try{			 
			ps = conn.prepareStatement("SELECT NOMBRE_MODULO FROM MODULO " +
					"WHERE MODULO_ID = ?");
			ps.setString(1, moduloId);
			rs= ps.executeQuery();		
			if(rs.next()){
				modulo = rs.getString(1);
			}
		
		}catch(Exception ex){
			System.out.println("Error - aca.menu.Modulo|getModuloNombre|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
	
		return modulo;		
	}


}
