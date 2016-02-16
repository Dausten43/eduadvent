/**
 * 
 */
package aca.catalogo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Jose Torres
 *
 */
public class CatSalon {
	private String salonId;
	private String salonClave;
	private String edificioId;
	private String salonNombre;
	private String limite;
	
	public CatSalon(){
		salonId			= "";
		salonClave		= "";
		edificioId		= "";
		salonNombre		= "";
		limite			= "";
	}
	
	public String getSalonId() {
		return salonId;
	}

	public void setSalonId(String salonId) {
		this.salonId = salonId;
	}

	public String getSalonClave() {
		return salonClave;
	}

	public void setSalonClave(String salonClave) {
		this.salonClave = salonClave;
	}

	public String getEdificioId() {
		return edificioId;
	}

	public void setEdificioId(String edificioId) {
		this.edificioId = edificioId;
	}

	public String getSalonNombre() {
		return salonNombre;
	}

	public void setSalonNombre(String salonNombre) {
		this.salonNombre = salonNombre;
	}

	public String getLimite() {
		return limite;
	}

	public void setLimite(String limite) {
		this.limite = limite;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("INSERT INTO CAT_SALON"
					+ " (SALON_CLAVE, EDIFICIO_ID, SALON_NOMBRE, LIMITE)"
					+ " VALUES( ?, TO_NUMBER(?,'999'), ?, TO_NUMBER(?,'999'))");
			
			ps.setString(1, salonClave);
			ps.setString(2, edificioId);
			ps.setString(3, salonNombre);
			ps.setString(4, limite);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatSalon|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("UPDATE CAT_SALON"
					+ " SET SALON_CLAVE = ?,"
					+ " EDIFICIO_ID = TO_NUMBER(?,'999'), "
					+ " SALON_NOMBRE = ?, "
					+ " LIMITE = TO_NUMBER(?,'999')"
					+ " WHERE SALON_ID = TO_NUMBER(?,'999') ");			
			ps.setString(1, salonClave);
			ps.setString(2, edificioId);
			ps.setString(3, salonNombre);
			ps.setString(4, limite);
			ps.setString(5, salonId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatSalon|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CAT_SALON"
					+ " WHERE SALON_ID = TO_NUMBER(?,'999') ");
			ps.setString(1, salonId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatSalon|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		salonId			= rs.getString("SALON_ID");
		salonClave		= rs.getString("SALON_CLAVE");
		edificioId		= rs.getString("EDIFICIO_ID");
		salonNombre		= rs.getString("SALON_NOMBRE");
		limite			= rs.getString("LIMITE");
	}
	
	public void mapeaRegId(Connection con, String salonId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT * FROM CAT_SALON"
					+ " WHERE SALON_ID = TO_NUMBER(?,'999') ");
			ps.setString(1, salonId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatSalon|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CAT_SALON"
					+ " WHERE SALON_ID = TO_NUMBER(?,'999')");
			ps.setString(1, salonId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatSalon|existeReg|:"+ex);
		}
		if (rs!=null) rs.close();
		if (ps!=null) ps.close();
		
		return ok;
	}
	
	public boolean existeEdificio(Connection conn) throws SQLException{
		boolean ok 			= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CAT_SALON"
					+ " WHERE EDIFICIO_ID = TO_NUMBER(?,'999')");
			ps.setString(1, edificioId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatSalon|existeEdificio|:"+ex);
		}
		if (rs!=null) rs.close();
		if (ps!=null) ps.close();
		
		return ok;
	}
	
	public static String getSalonNombre(Connection conn, String salonId) throws SQLException{
		String resultado 		= "";
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT SALON_NOMBRE FROM CAT_SALON"
					+ " WHERE SALON_ID = TO_NUMBER(?,'999')");
			ps.setString(1, salonId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				resultado = rs.getString("SALON_NOMBRE");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatSalon|getSalonNombre|:"+ex);
		}
		if (rs!=null) rs.close();
		if (ps!=null) ps.close();
		
		return resultado;
	}
	
	public static String getEdificioNombre(Connection conn, String salonId) throws SQLException{
		String resultado 		= "";
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT EDIFICIO_NOMBRE FROM CAT_EDIFICIO"
					+ " WHERE EDIFICIO_ID = ( SELECT EDIFICIO_ID FROM CAT_SALON WHERE SALON_ID = TO_NUMBER(?,'999') ) ");
			ps.setString(1, salonId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				resultado = rs.getString("EDIFICIO_NOMBRE");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatSalon|getEdificioNombre|:"+ex);
		}
		if (rs!=null) rs.close();
		if (ps!=null) ps.close();
		
		return resultado;
	}
}
