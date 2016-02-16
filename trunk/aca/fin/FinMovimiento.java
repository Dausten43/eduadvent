/**
 * 
 */
package aca.fin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author elifo
 *
 */
public class FinMovimiento {
	private String codigoId;
	private String folio;
	private String fecha;
	private String descripcion;
	private String importe;
	private String naturaleza;
	private String referencia;
	
	public FinMovimiento(){
		codigoId	= "";
		folio		= "";
		fecha		= "";
		descripcion	= "";
		importe		= "";
		naturaleza	= "";
		referencia	= "";
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
	 * @return the descripcion
	 */
	public String getDescripcion() {
		return descripcion;
	}

	/**
	 * @param descripcion the descripcion to set
	 */
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	/**
	 * @return the fecha
	 */
	public String getFecha() {
		return fecha;
	}

	/**
	 * @param fecha the fecha to set
	 */
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}

	/**
	 * @return the folio
	 */
	public String getFolio() {
		return folio;
	}

	/**
	 * @param folio the folio to set
	 */
	public void setFolio(String folio) {
		this.folio = folio;
	}

	/**
	 * @return the importe
	 */
	public String getImporte() {
		return importe;
	}

	/**
	 * @param importe the importe to set
	 */
	public void setImporte(String importe) {
		this.importe = importe;
	}

	/**
	 * @return the naturaleza
	 */
	public String getNaturaleza() {
		return naturaleza;
	}

	/**
	 * @param naturaleza the naturaleza to set
	 */
	public void setNaturaleza(String naturaleza) {
		this.naturaleza = naturaleza;
	}

	/**
	 * @return the referencia
	 */
	public String getReferencia() {
		return referencia;
	}

	/**
	 * @param referencia the referencia to set
	 */
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	
	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO FIN_MOVIMIENTO" +
					" (CODIGO_ID, FOLIO, FECHA, DESCRIPCION," +
					" IMPORTE, NATURALEZA, REFERENCIA)" +
					" VALUES(?, TO_NUMBER(?, '9999'), TO_DATE(?, 'DD/MM/YYYY'), ?," +
					" TO_NUMBER(?, '99999.99'), ?, ?)");
			
			/*System.out.println("INSERT INTO FIN_MOVIMIENTO" +
					" (CODIGO_ID, FOLIO, FECHA, DESCRIPCION," +
					" IMPORTE, NATURALEZA, REFERENCIA)" +
					" VALUES('"+codigoId+"', TO_NUMBER('"+folio+"', '9999'), TO_DATE('"+fecha+"', 'DD/MM/YYYY'), '"+descripcion+"'," +
					" TO_NUMBER('"+importe+"', '99999.99'), '"+naturaleza+"', '"+referencia+"')");*/
			
			ps.setString(1, codigoId);
			ps.setString(2, folio);
			ps.setString(3, fecha);
			ps.setString(4, descripcion);
			ps.setString(5, importe);
			ps.setString(6, naturaleza);
			ps.setString(7, referencia);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimiento|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE FIN_MOVIMIENTO" +
					" SET FECHA = TO_DATE(?, 'DD/MM/YYYY')," +
					" DESCRIPCION = ?," +
					" IMPORTE = TO_NUMBER(?, '99999.99')," +
					" NATURALEZA = ?," +
					" REFERENCIA = ?" +
					" WHERE CODIGO_ID = ?" +
					" AND FOLIO = TO_NUMBER(?, '9999')");
			
			ps.setString(1, fecha);
			ps.setString(2, descripcion);
			ps.setString(3, importe);
			ps.setString(4, naturaleza);
			ps.setString(5, referencia);
			ps.setString(6, codigoId);
			ps.setString(7, folio);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimiento|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM FIN_MOVIMIENTO" +
					" WHERE CODIGO_ID = ?" +
					" AND FOLIO = TO_NUMBER(?, '9999')");
			
			ps.setString(1, codigoId);
			ps.setString(2, folio);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimiento|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteMovtosAlumno(Connection conn, String codigoId, String cicloId, String periodoId ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM FIN_MOVIMIENTO" +
					" WHERE CODIGO_ID = ?" +
					" AND REFERENCIA = ?");
			
			ps.setString(1, codigoId);
			ps.setString(2, cicloId+"-"+periodoId);
			
			if ( ps.executeUpdate()== 1){				
				ok = true;				
			}
						
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimiento|deleteMovtosAlumno|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId	= rs.getString("CODIGO_ID");
		folio		= rs.getString("FOLIO");
		fecha		= rs.getString("FECHA");
		descripcion	= rs.getString("DESCRIPCION");
		importe		= rs.getString("IMPORTE");
		naturaleza	= rs.getString("NATURALEZA");
		referencia	= rs.getString("REFERENCIA");
	}
	
	public void mapeaRegId(Connection con, String codigoId, String folio) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null; 
		try{
			ps = con.prepareStatement("SELECT CODIGO_ID, FOLIO," +
					" TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, DESCRIPCION," +
					" IMPORTE, NATURALEZA, REFERENCIA" +
					" FROM FIN_MOVIMIENTO" +
					" WHERE CODIGO_ID = ?" +
					" AND FOLIO = TO_NUMBER(?, '9999')");
			
			ps.setString(1, codigoId);
			ps.setString(2, folio);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimiento|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM FIN_MOVIMIENTO" +
					" WHERE CODIGO_ID = ?" +
					" AND FOLIO = TO_NUMBER(?, '9999')");
			
			ps.setString(1, codigoId);
			ps.setString(2, folio);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimiento|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public static String maxReg( Connection conn, String codigoId) throws SQLException{		
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		String maximo 			= "001";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(FOLIO)+1,'1') AS MAXIMO" +
					" FROM FIN_MOVIMIENTO" +
					" WHERE CODIGO_ID = ?");
			
			ps.setString(1, codigoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
			if(maximo == null)
				maximo = "001";
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimiento|maxReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return maximo;
	}
	
	public static boolean movtosGrabados( Connection conn, String codigoId, String cicloId, String periodoId) throws SQLException{		
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		int movtos 				= 0;
		boolean ok				= false;
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(COUNT(CODIGO_ID),0) AS MOVTOS FROM FIN_MOVIMIENTO" +
					" WHERE CODIGO_ID = ?" +
					" AND REFERENCIA = ?");
			
			ps.setString(1, codigoId);
			ps.setString(2, cicloId+"-"+periodoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				movtos = rs.getInt("MOVTOS");
			}
			if(movtos >0) ok = true;
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimiento|movtosGrabados|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public static double saldoAlumno( Connection conn, String codigoId, String fecha ) throws SQLException{
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		double saldo			= 0;
		
		try{
			ps = conn.prepareStatement("SELECT SUM(CASE NATURALEZA WHEN 'C' THEN IMPORTE*1 ELSE IMPORTE*-1 END) AS SALDO" +
					" FROM FIN_MOVIMIENTO" +
					" WHERE CODIGO_ID = ?" +
					" AND FECHA <= TO_DATE(?,'DD/MM/YYYY')");
			
			ps.setString(1, codigoId);
			ps.setString(2, fecha);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				saldo = rs.getDouble("SALDO");
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimiento|saldoAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return saldo;
	}
	
	public static double saldoPolizas( Connection conn, String escuela, String tipo, String estado, String fechaIni, String fechaFin, String naturaleza ) throws SQLException{
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		double saldo			= 0;
		
		try{
			ps = conn.prepareStatement("SELECT SUM(IMPORTE) AS SALDO FROM FIN_MOVIMIENTOS"
				+ " WHERE POLIZA_ID IN "
				+ " 	(SELECT POLIZA_ID FROM FIN_POLIZA WHERE SUBSTR(POLIZA_ID,1,3) = ? AND ESTADO IN (?) AND TIPO IN (?) "
				+ "		AND FECHA BETWEEN TO_DATE('"+fechaIni+"','DD/MM/YYYY') AND TO_DATE('"+fechaFin+"','DD/MM/YYYY'))"
				+ " AND NATURALEZA = ?");
			
			ps.setString(1, escuela);
			ps.setString(2, estado);
			ps.setString(3, tipo);
			ps.setString(4, fechaIni);
			ps.setString(5, fechaFin);
			ps.setString(6, naturaleza);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				saldo = rs.getDouble("SALDO");
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimiento|saldoPolizas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return saldo;
	}
	
	
}
