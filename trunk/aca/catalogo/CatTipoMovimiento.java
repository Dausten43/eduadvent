package aca.catalogo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Sem Barba
 */

public class CatTipoMovimiento {
	
	private String tipoMovId;
	private String nombre;
	private String tipo;
	
	public CatTipoMovimiento(){
		tipoMovId    		= "";
		nombre      		= "";
		tipo				= "";
	}

	
	
	public String getTipoMovId() {
		return tipoMovId;
	}

	public void setTipoMovId(String tipoMovId) {
		this.tipoMovId = tipoMovId;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	
	public String getTipo() {
		return tipo;
	}

	public void setTipo(String tipo) {
		this.tipo = tipo;
	}



	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO CAT_TIPOMOV" +
					" (TIPOMOV_ID, NOMBRE, TIPO)" +
					" VALUES(TO_NUMBER(?, '99'), ?, ?)");
			
			ps.setString(1, tipoMovId);
			ps.setString(2, nombre);
			ps.setString(3, tipo);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipoMovimiento|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		
		try{
			ps = conn.prepareStatement("UPDATE CAT_TIPOMOV" +
					" SET NOMBRE = ?, TIPO = ?" +
					" WHERE TIPOMOV_ID = TO_NUMBER(?, '99') ");			
			ps.setString(1, nombre);
			ps.setString(2, tipo);
			ps.setString(3, tipoMovId);

			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipoMovimiento|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CAT_TIPOMOV" +
					" WHERE TIPOMOV_ID = TO_NUMBER(?, '99')");
			ps.setString(1, tipoMovId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipoMovimiento|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		tipoMovId				= rs.getString("TIPOMOV_ID");
		nombre					= rs.getString("NOMBRE");	
		tipo					= rs.getString("TIPO");	
	}
	
	public void mapeaRegId(Connection con, String tipoMovId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT TIPOMOV_ID, NOMBRE, TIPO " +
					" FROM CAT_TIPOMOV WHERE TIPOMOV_ID = TO_NUMBER(?, '99') ");
			ps.setString(1, tipoMovId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipoMovimiento|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
	}
	
	public boolean existeReg(Connection conn) throws SQLException{
		boolean ok 				= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CAT_TIPOMOV WHERE TIPOMOV_ID = TO_NUMBER(?, '99') ");
			ps.setString(1, tipoMovId);
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipoMovimiento|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public String maximoReg(Connection conn) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(TIPOMOV_ID)+1,1) AS MAXIMO FROM CAT_TIPOMOV");
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipoMovimiento|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}

}
