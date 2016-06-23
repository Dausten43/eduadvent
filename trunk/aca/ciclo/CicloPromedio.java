package aca.ciclo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CicloPromedio {

	private String cicloId;
	private String promedioId;	
	private String nombre;
	private String corto;
	private String calculo;
	private String orden;
	private String decimales;
	private String valor;
	private String redondeo;
	
	public CicloPromedio(){		
		  cicloId		= "";
		  promedioId 	= "";		  
		  nombre 		= "";
		  corto 		= "";
		  calculo 		= "V";
		  orden 		= "";
		  decimales		= "";
		  valor 		= "";
		  redondeo		= "A";
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
	 * @return the promedioId
	 */
	public String getPromedioId() {
		return promedioId;
	}

	/**
	 * @param promedioId the promedioId to set
	 */
	public void setPromedioId(String promedioId) {
		this.promedioId = promedioId;
	}

	/**
	 * @return the nombre
	 */
	public String getNombre() {
		return nombre;
	}

	/**
	 * @param nombre the nombre to set
	 */
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	/**
	 * @return the corto
	 */
	public String getCorto() {
		return corto;
	}

	/**
	 * @param corto the corto to set
	 */
	public void setCorto(String corto) {
		this.corto = corto;
	}

	/**
	 * @return the calculo
	 */
	public String getCalculo() {
		return calculo;
	}

	/**
	 * @param calculo the calculo to set
	 */
	public void setCalculo(String calculo) {
		this.calculo = calculo;
	}

	/**
	 * @return the orden
	 */
	public String getOrden() {
		return orden;
	}

	/**
	 * @param orden the orden to set
	 */
	public void setOrden(String orden) {
		this.orden = orden;
	}

	/**
	 * @return the decimales
	 */
	public String getDecimales() {
		return decimales;
	}

	/**
	 * @param decimales the decimales to set
	 */
	public void setDecimales(String decimales) {
		this.decimales = decimales;
	}	

	public String getRedondeo() {
		return redondeo;
	}

	public void setRedondeo(String redondeo) {
		this.redondeo = redondeo;
	}

	/**
	 * @return the valor
	 */
	public String getValor() {
		return valor;
	}

	/**
	 * @param valor the valor to set
	 */
	public void setValor(String valor) {
		this.valor = valor;
	}	
	
	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("INSERT INTO CICLO_PROMEDIO"
					+ " (CICLO_ID, PROMEDIO_ID, NOMBRE, CORTO, CALCULO, ORDEN, DECIMALES, VALOR, REDONDEO)"
					+ " VALUES(?, TO_NUMBER(?, '99'), ?, ?, ?, TO_NUMBER(?, '99'), TO_NUMBER(?, '9'), TO_NUMBER(?, '999.99'), ?)");
			
			ps.setString(1, cicloId);
			ps.setString(2, promedioId);
			ps.setString(3, nombre);
			ps.setString(4, corto);
			ps.setString(5, calculo);
			ps.setString(6, orden);
			ps.setString(7, decimales);
			ps.setString(8, valor);
			ps.setString(9, redondeo);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloPromedio|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("UPDATE CICLO_PROMEDIO"
					+ " SET NOMBRE = ?,"
					+ " CORTO = ?,"
					+ " CALCULO = ?,"
					+ " ORDEN = TO_NUMBER(?, '99'),"
					+ " DECIMALES = TO_NUMBER(?, '9'),"
					+ " VALOR = TO_NUMBER(?, '999.99'),"
					+ " REDONDEO = ?"
					+ " WHERE CICLO_ID = ?"
					+ " AND PROMEDIO_ID = TO_NUMBER(?, '99')");			
			ps.setString(1, nombre);
			ps.setString(2, corto);
			ps.setString(3, calculo);
			ps.setString(4, orden);
			ps.setString(5, decimales);
			ps.setString(6, valor);
			ps.setString(7, redondeo);
			ps.setString(8, cicloId);
			ps.setString(9, promedioId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloPromedio|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CICLO_PROMEDIO" +
					" WHERE CICLO_ID = ?" +
					" AND PROMEDIO_ID = TO_NUMBER(?, '99')");
			ps.setString(1, cicloId);
			ps.setString(2, promedioId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloPromedio|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		cicloId			= rs.getString("CICLO_ID");
		promedioId		= rs.getString("PROMEDIO_ID");
		nombre			= rs.getString("NOMBRE");
		corto			= rs.getString("CORTO");
		calculo			= rs.getString("CALCULO");
		orden			= rs.getString("ORDEN");
		decimales		= rs.getString("DECIMALES");
		valor			= rs.getString("VALOR");
		redondeo		= rs.getString("REDONDEO");
		
	}
	
	public void mapeaRegId(Connection con, String cicloId, String promedioId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT CICLO_ID, PROMEDIO_ID, NOMBRE, CORTO, CALCULO, ORDEN, DECIMALES, VALOR, REDONDEO"
					+ " FROM CICLO_PROMEDIO"
					+ " WHERE CICLO_ID = ?"
					+ " AND PROMEDIO_ID = TO_NUMBER(?, '99')");
			ps.setString(1, cicloId);
			ps.setString(2, promedioId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloPromedio|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CICLO_PROMEDIO" +
					" WHERE CICLO_ID = ?" +
					" AND PROMEDIO_ID = TO_NUMBER(?, '99')");
			ps.setString(1, cicloId);
			ps.setString(2, promedioId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloPromedio|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return ok;
	}
	
	public String maximoReg(Connection conn, String cicloId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "0";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(PROMEDIO_ID)+1, '1') AS MAXIMO FROM CICLO_PROMEDIO" +
					" WHERE CICLO_ID = ?");
			ps.setString(1, cicloId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloPromedio|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return maximo;
	}
	
	public static boolean existeEvaluaciones(Connection conn, String cicloId) throws SQLException{	
		
		boolean ok 			= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CICLO_PROMEDIO" +
					" WHERE CICLO_ID = ?");
			ps.setString(1, cicloId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloPromedio|existeEvaluaciones|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return ok;
	}
	
	public static String numPromedios(Connection conn, String cicloId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String total 			= "0";
		
		try{
			ps = conn.prepareStatement("SELECT COUNT(*) AS TOTAL FROM CICLO_PROMEDIO WHERE CICLO_ID = ?");
			ps.setString(1, cicloId);
			
			rs= ps.executeQuery();	
			if(rs.next()){
				total = rs.getString("TOTAL");
			}	
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloPromedio|numPromedios|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return total;
	}
	
	public static String getNombre(Connection conn, String cicloId, String promedioId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String total 			= "0";
		
		try{
			ps = conn.prepareStatement("SELECT NOMBRE FROM CICLO_PROMEDIO WHERE CICLO_ID = ? AND PROMEDIO_ID = TO_NUMBER(?,'99')");
			ps.setString(1, cicloId);
			ps.setString(2, promedioId);
			
			rs= ps.executeQuery();	
			if(rs.next()){
				total = rs.getString("NOMBRE");
			}	
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloPromedio|getNombre|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return total;
	}
	
	public static String getDecimales(Connection conn, String cicloId, String promedioId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String total 			= "0";
		
		try{
			ps = conn.prepareStatement("SELECT DECIMALES FROM CICLO_PROMEDIO WHERE CICLO_ID = ? AND PROMEDIO_ID = TO_NUMBER(?,'99')");
			ps.setString(1, cicloId);
			ps.setString(2, promedioId);
			
			rs= ps.executeQuery();	
			if(rs.next()){
				total = rs.getString("DECIMALES");
			}	
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloPromedio|getDecimales|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return total;
	}
	
	public static String getRedondeo(Connection conn, String cicloId, String promedioId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String total 			= "0";
		
		try{
			ps = conn.prepareStatement("SELECT REDONDEO FROM CICLO_PROMEDIO WHERE CICLO_ID = ? AND PROMEDIO_ID = TO_NUMBER(?,'99')");
			ps.setString(1, cicloId);
			ps.setString(2, promedioId);
			
			rs= ps.executeQuery();	
			if(rs.next()){
				total = rs.getString("REDONDEO");
			}	
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloPromedio|getRedondeo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return total;
	}
	
	
}

