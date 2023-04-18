package aca.catalogo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Jose Torres
 *
 */
public class CatEdificio {
	private String edificioId;
	private String edificioNombre;
	private String escuelaId;
	
	public CatEdificio(){
		edificioId				= "";
		edificioNombre			= "";
		escuelaId 				= "";
	}

	public String getEdificioId() {
		return edificioId;
	}

	public void setEdificioId(String edificioId) {
		this.edificioId = edificioId;
	}

	public String getEdificioNombre() {
		return edificioNombre;
	}

	public void setEdificioNombre(String edificioNombre) {
		this.edificioNombre = edificioNombre;
	}

	public String getEscuelaId() {
		return escuelaId;
	}

	public void setEscuelaId(String escuelaId) {
		this.escuelaId = escuelaId;
	}


	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO CAT_EDIFICIO" +
					" (EDIFICIO_NOMBRE, ESCUELA_ID)" +
					" VALUES( ?, ? )");
			
			ps.setString(1, edificioNombre);
			ps.setString(2, escuelaId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEdificio|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		
		try{
			ps = conn.prepareStatement("UPDATE CAT_EDIFICIO" +
					" SET EDIFICIO_NOMBRE = ?, ESCUELA_ID = ? " +
					" WHERE EDIFICIO_ID = ? ");			
			ps.setString(1, edificioNombre);
			ps.setString(2, escuelaId);
			ps.setString(3, edificioId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEdificio|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CAT_EDIFICIO " +
					" WHERE EDIFICIO_ID = ? ");
			ps.setInt(1, Integer.parseInt(edificioId));
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEdificio|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		edificioId			= rs.getString("EDIFICIO_ID");
		edificioNombre		= rs.getString("EDIFICIO_NOMBRE");
		escuelaId			= rs.getString("ESCUELA_ID");
	}
	
	public void mapeaRegId(Connection con, String asociacionId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT EDIFICIO_ID, EDIFICIO_NOMBRE, ESCUELA_ID " +
					" FROM CAT_EDIFICIO WHERE EDIFICIO_ID = ? ");
			ps.setString(1, edificioId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEdificio|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CAT_EDIFICIO WHERE EDIFICIO_ID = ? ");
			ps.setString(1, edificioId);
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEdificio|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	
}
