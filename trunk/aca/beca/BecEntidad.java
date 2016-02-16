package aca.beca;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Jose Torres
 *
 */
public class BecEntidad {
	private String entidadId;
	private String entidadNombre;
	private String referente;
	private String telefono;
	private String limitePorcentaje;
	private String limiteCantidad;
	private String escuelaId;
	private String tipo;
	
	public BecEntidad(){
		entidadId			= "";
		entidadNombre		= "";
		referente			= "";
		telefono			= "";
		limitePorcentaje	= "";
		limiteCantidad		= "";
		escuelaId			= "";
		tipo 				= "";
	}

	/**
	 * @return the entidadId
	 */
	public String getEntidadId() {
		return entidadId;
	}
	
	
	/**
	 * @param entidadId the entidadId to set
	 */
	public void setEntidadId(String entidadId) {
		this.entidadId = entidadId;
	}

	/**
	 * @return the entidadNombre
	 */
	public String getEntidadNombre() {
		return entidadNombre;
	}


	/**
	 * @param entidadNombre the entidadNombre to set
	 */
	public void setEntidadNombre(String entidadNombre) {
		this.entidadNombre = entidadNombre;
	}

	/**
	 * @return the referente
	 */
	public String getReferente() {
		return referente;
	}

	/**
	 * @param referente the referente to set
	 */
	public void setReferente(String referente) {
		this.referente = referente;
	}

	/**
	 * @return the telefono
	 */
	public String getTelefono() {
		return telefono;
	}

	/**
	 * @param telefono the telefono to set
	 */
	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}

	/**
	 * @return the escuelaId
	 */
	public String getEscuelaId() {
		return escuelaId;
	}

	/**
	 * @param escuelaId the escuelaId to set
	 */
	public void setEscuelaId(String escuelaId) {
		this.escuelaId = escuelaId;
	}
	
	public String getTipo() {
		return tipo;
	}

	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	
	public String getLimitePorcentaje() {
		return limitePorcentaje;
	}

	public void setLimitePorcentaje(String limitePorcentaje) {
		this.limitePorcentaje = limitePorcentaje;
	}

	public String getLimiteCantidad() {
		return limiteCantidad;
	}

	public void setLimiteCantidad(String limiteCantidad) {
		this.limiteCantidad = limiteCantidad;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO BEC_ENTIDAD" +
					" (ENTIDAD_ID, ENTIDAD_NOMBRE, REFERENTE, TELEFONO," +
					" LIMITE_PORCENTAJE, LIMITE_CANTIDAD, ESCUELA_ID)" +
					" VALUES(TO_NUMBER(?,'99999'), ?, ?, ?," +
					" TO_NUMBER(?,'999.99'), TO_NUMBER(?,'9999999.99'), ?)");
			
			ps.setString(1, entidadId);
			ps.setString(2, entidadNombre);
			ps.setString(3, referente);	
			ps.setString(4, telefono);
			ps.setString(5, limitePorcentaje);
			ps.setString(6, limiteCantidad);
			ps.setString(7, escuelaId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.beca.BecEntidad|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE BEC_ENTIDAD" +
					" SET ENTIDAD_NOMBRE = ?," +
					" REFERENTE = ?," +
					" TELEFONO = ?," +
					" LIMITE_PORCENTAJE = TO_NUMBER(?,'999.99')," +
					" LIMITE_CANTIDAD = TO_NUMBER(?,'9999999.99')," +
					" ESCUELA_ID = ?" +
					" WHERE ENTIDAD_ID = TO_NUMBER(?, '99999')");
			
			ps.setString(1, entidadNombre);
			ps.setString(2, referente);
			ps.setString(3, telefono);
			ps.setString(4, limitePorcentaje);
			ps.setString(5, limiteCantidad);
			ps.setString(6, escuelaId);
			ps.setString(7, entidadId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.beca.BecEntidad|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM BEC_ENTIDAD" +
					" WHERE ENTIDAD_ID = TO_NUMBER(?, '99999')");
			ps.setString(1, entidadId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.beca.BecEntidad|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		entidadId			= rs.getString("ENTIDAD_ID");
		entidadNombre		= rs.getString("ENTIDAD_NOMBRE");
		referente			= rs.getString("REFERENTE");
		telefono			= rs.getString("TELEFONO");
		limitePorcentaje	= rs.getString("LIMITE_PORCENTAJE");
		limiteCantidad		= rs.getString("LIMITE_CANTIDAD");
		escuelaId			= rs.getString("ESCUELA_ID");
	}
	
	public void mapeaRegId(Connection con, String entidadId) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null; 
		try{
			ps = con.prepareStatement("SELECT * FROM BEC_ENTIDAD " +
					"WHERE ENTIDAD_ID = TO_NUMBER(?, '99999')");
			ps.setString(1, entidadId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.beca.BecEntidad|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM BEC_ENTIDAD WHERE ENTIDAD_ID = TO_NUMBER(?, '99999')");
			ps.setString(1, entidadId);
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.beca.BecEntidad|existeReg|:"+ex);
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
			ps = conn.prepareStatement("SELECT COALESCE(MAX(ENTIDAD_ID)+1,'1') AS MAXIMO FROM BEC_ENTIDAD");
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.beca.BecEntidad|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
	
	public static String getEntidadNombre(Connection conn, String entidadId) throws SQLException {
        
		PreparedStatement ps 	= null;
		ResultSet rs 			= null;
		String entidad			= "X";

	    try{
			ps = conn.prepareStatement("SELECT ENTIDAD_NOMBRE FROM BEC_ENTIDAD" +
					" WHERE ENTIDAD_ID = TO_NUMBER(?, '99999')");
			ps.setString(1, entidadId);
	        rs = ps.executeQuery();
	        if(rs.next()){
				entidad = rs.getString("ENTIDAD_NOMBRE");
	        }
				
				
		}catch (Exception ex){
			System.out.println("Error - aca.beca.BecEntidad|getEntidadNombre|:" +ex);
	    }finally{
			if (rs != null) rs.close();
			if (ps != null) ps.close();
		}   

	    return entidad;
	}
	
}
