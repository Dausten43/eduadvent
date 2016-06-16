/**
 * 
 */
package aca.beca;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Jose Torres
 *
 */
public class BecAlumno {
	private String becaId;
	private String cicloId;
	private String periodoId;
	private String codigoId;
	private String entidadId;
	private String cuentaId;
	private String beca;
	private String tipo;
	private String usuario;	
	
	public BecAlumno(){
		becaId		= "";
		cicloId		= "";
		periodoId	= "";
		codigoId	= "";
		entidadId	= "";
		cuentaId 	= "";
		beca		= "";
		tipo 		= "";
		usuario 	= "";
							
	}

	/**
	 * @return the becaId
	 */
	public String getBecaId() {
		return becaId;
	}

	/**
	 * @param becaId the becaId to set
	 */
	public void setBecaId(String becaId) {
		this.becaId = becaId;
	}

	/**
	 * @return the cicloId
	 */
	public String getCicloId() {
		return cicloId;
	}

	/**
	 * @param cicloId the cicloId to set
	 */
	public void setCicloId(String cicloId) {
		this.cicloId = cicloId;
	}

	/**
	 * @return the codigoId
	 */
	public String getCodigoId() {
		return codigoId;
	}

	/**
	 * @param codigoId the codigoId to set
	 */
	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
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
	 * @return the periodoId
	 */
	public String getPeriodoId() {
		return periodoId;
	}

	/**
	 * @param periodoId the periodoId to set
	 */
	public void setPeriodoId(String periodoId) {
		this.periodoId = periodoId;
	}

	public String getCuentaId() {
		return cuentaId;
	}

	public void setCuentaId(String cuentaId) {
		this.cuentaId = cuentaId;
	}

	public String getBeca() {
		return beca;
	}

	public void setBeca(String beca) {
		this.beca = beca;
	}

	public String getTipo() {
		return tipo;
	}

	public void setTipo(String tipo) {
		this.tipo = tipo;
	}

	public String getUsuario() {
		return usuario;
	}

	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}

	
	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO BEC_ALUMNO" +
					" (BECA_ID, CICLO_ID, PERIODO_ID, CODIGO_ID, ENTIDAD_ID, CUENTA_ID, BECA, TIPO, USUARIO)" +
					" VALUES (TO_NUMBER(?, '9999999'), ?, TO_NUMBER(?,'99'), ?, TO_NUMBER(?, '99999'), ?, TO_NUMBER(?, '9999999.99'), ?, ?)");		
			ps.setString(1, becaId);
			ps.setString(2, cicloId);
			ps.setString(3, periodoId);
			ps.setString(4, codigoId);
			ps.setString(5, entidadId);
			ps.setString(6, cuentaId);
			ps.setString(7, beca);
			ps.setString(8, tipo);
			ps.setString(9, usuario);
			
			if ( ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.beca.BecAlumno|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE BEC_ALUMNO" +
					" SET CICLO_ID = ?," +
					" PERIODO_ID = TO_NUMBER(?, '99')," +
					" CODIGO_ID = ?," +
					" ENTIDAD_ID = TO_NUMBER(?, '99999')," +
					" CUENTA_ID  = ?," +
					" BECA = TO_NUMBER(?, '9999999.99')," +
					" TIPO = ?," +
					" USUARIO    = ?" +
					" WHERE BECA_ID = TO_NUMBER(?, '9999999')");			
			ps.setString(1, cicloId);
			ps.setString(2, periodoId);
			ps.setString(3, codigoId);
			ps.setString(4, entidadId);
			ps.setString(5, cuentaId);
			ps.setString(6, beca);
			ps.setString(7, tipo);
			ps.setString(8, usuario);
			ps.setString(9, becaId);	
			
			if ( ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.beca.BecAlumno|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM BEC_ALUMNO" +
					" WHERE BECA_ID = TO_NUMBER(?, '9999999')");
			
			ps.setString(1, becaId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.beca.BecAlumno|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		becaId		= rs.getString("BECA_ID");
		cicloId		= rs.getString("CICLO_ID");
		periodoId	= rs.getString("PERIODO_ID");
		codigoId	= rs.getString("CODIGO_ID");
		entidadId	= rs.getString("ENTIDAD_ID");
		cuentaId	= rs.getString("CUENTA_ID");
		beca		= rs.getString("BECA");
		tipo		= rs.getString("TIPO");
		usuario		= rs.getString("USUARIO");
	}
	
	public void mapeaRegId(Connection con, String becaId) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null; 
		try{
			ps = con.prepareStatement("SELECT *" +
					" FROM BEC_ALUMNO " +
					" WHERE BECA_ID = TO_NUMBER(?, '9999999')");
			ps.setString(1, becaId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.beca.BecaAlumno|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
	}
	
	public void mapeaRegId(Connection con, String cicloId, String periodoId, String codigoId, String entidadId) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null; 
		try{
			ps = con.prepareStatement("SELECT *" +
					" FROM BEC_ALUMNO " +
					" WHERE CICLO_ID = ?" +
					" AND PERIODO_ID = TO_NUMBER(?,'99')" +
					" AND CODIGO_ID = ?" +
					" AND ENTIDAD_ID = TO_NUMBER(?,'99999')");		
			ps.setString(1, cicloId);
			ps.setString(2, periodoId);
			ps.setString(3, codigoId);
			ps.setString(4, entidadId);
			
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.beca.BecaAlumno|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM BEC_ALUMNO" +
					" WHERE BECA_ID = TO_NUMBER(?, '9999999') ");
			
			ps.setString(1, becaId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.beca.BecAlumno|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean existeRegBeca(Connection conn) throws SQLException{
		boolean ok 				= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;		
		try{
			ps = conn.prepareStatement("SELECT * FROM BEC_ALUMNO" +
					" WHERE CICLO_ID = ?" +
					" AND PERIODO_ID = TO_NUMBER(?,'99')" +
					" AND CODIGO_ID = ?" +
					" AND CUENTA_ID = ?" +
					" AND ENTIDAD_ID = TO_NUMBER(?,'99999')");
			
			ps.setString(1, cicloId);
			ps.setString(2, periodoId);
			ps.setString(3, codigoId);
			ps.setString(4, cuentaId);
			ps.setString(5, entidadId);		    
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.beca.BecAlumno|existeRegBeca|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public String getBecaId(Connection conn, String cicloId, String periodoId, String codigoId, String entidadId, String cuentaId ) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String becaId			= "0";
		
		try{
			ps = conn.prepareStatement("SELECT BECA_ID FROM BEC_ALUMNO" +
					" WHERE CICLO_ID = ?" +
					" AND PERIODO_ID = TO_NUMBER(?,'99')" +
					" AND CODIGO_ID = ?" +
					" AND ENTIDAD_ID = TO_NUMBER(?,'99999') "+
					" AND CUENTA_ID = ?" );					
								
			ps.setString(1, cicloId);
			ps.setString(2, periodoId);
			ps.setString(3, codigoId);
			ps.setString(4, entidadId);
			ps.setString(5, cuentaId);
			
			
			rs= ps.executeQuery();		
			if(rs.next()){
				becaId = rs.getString("BECA_ID");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.beca.BecAlumno|getBecaId|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return becaId;
	}
	
	
	/*
	 * Consulta el total de beca del alumno en una cuenta
	 * */
	public static String getBecaCuenta(Connection conn, String cicloId, String periodoId, String codigoId, String cuentaId ) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String beca				= "0";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(SUM(PORCENTAJE),0) AS TOTAL FROM BEC_ALUMNO" +
					" WHERE CICLO_ID = ?" +
					" AND PERIODO_ID = TO_NUMBER(?,'99')" +
					" AND CODIGO_ID = ?" +					
					" AND CUENTA_ID = ?" );					
								
			ps.setString(1, cicloId);
			ps.setString(2, periodoId);
			ps.setString(3, codigoId);			
			ps.setString(4, cuentaId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				beca = rs.getString("TOTAL");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.beca.BecAlumno|getBecaCuenta|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return beca;
	}
	
	public String maximoReg(Connection conn) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(BECA_ID)+1,1) AS MAXIMO FROM BEC_ALUMNO");
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.beca.BecAlumno|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
	
	public String cantidadTotalBecas(Connection conn, String entidadId ) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String cantidad 		= "0";
		
		try{
			ps = conn.prepareStatement("SELECT SUM(IMPORTE_BECA) AS CANTIDAD FROM FIN_CALCULO_DET AS FC, BEC_ALUMNO AS BA "
									+ " WHERE FC.CODIGO_ID = BA.CODIGO_ID AND FC.CICLO_ID = BA.CICLO_ID AND FC.PERIODO_ID = BA.PERIODO_ID "
									+ " AND FC.CUENTA_ID = BA.CUENTA_ID AND BA.ENTIDAD_ID = TO_NUMBER(?,'99999')");
			ps.setString(1, entidadId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				cantidad = rs.getString("CANTIDAD");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.beca.BecAlumno|cantidadTotalBecas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return cantidad;
	}
}