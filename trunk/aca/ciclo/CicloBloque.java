/**
 * 
 */
package aca.ciclo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Jose Torres
 *
 */
public class CicloBloque {
	private String cicloId;
	private String bloqueId;
	private String bloqueNombre;
	private String fInicio;
	private String fFinal;
	private String valor;
	private String orden;
	private String promedioId;
	private String corto;
	private String decimales;
	private String redondeo;
	private String calculo;
	
	public CicloBloque(){
		cicloId			= "";
		bloqueId		= "";
		bloqueNombre	= "";
		fInicio			= "";
		fFinal			= "";
		valor			= "";
		orden			= "";
		promedioId		= "";
		corto			= "";
		decimales		= "";
		redondeo		= "";
		calculo			= "";
	}

	/**
	 * @return Returns the bloqueId.
	 */
	public String getBloqueId() {
		return bloqueId;
	}
	

	/**
	 * @param bloqueId The bloqueId to set.
	 */
	public void setBloqueId(String bloqueId) {
		this.bloqueId = bloqueId;
	}
	

	/**
	 * @return Returns the bloqueNombre.
	 */
	public String getBloqueNombre() {
		return bloqueNombre;
	}
	

	/**
	 * @param bloqueNombre The bloqueNombre to set.
	 */
	public void setBloqueNombre(String bloqueNombre) {
		this.bloqueNombre = bloqueNombre;
	}
	

	/**
	 * @return Returns the cicloId.
	 */
	public String getCicloId() {
		return cicloId;
	}
	

	/**
	 * @param cicloId The cicloId to set.
	 */
	public void setCicloId(String cicloId) {
		this.cicloId = cicloId;
	}
	

	/**
	 * @return Returns the fFinal.
	 */
	public String getFFinal() {
		return fFinal;
	}
	

	/**
	 * @param final1 The fFinal to set.
	 */
	public void setFFinal(String final1) {
		fFinal = final1;
	}
	

	/**
	 * @return Returns the fInicio.
	 */
	public String getFInicio() {
		return fInicio;
	}
	

	/**
	 * @param inicio The fInicio to set.
	 */
	public void setFInicio(String inicio) {
		fInicio = inicio;
	}
	
	
	public String getValor() {
		return valor;
	}

	public void setValor(String valor) {
		this.valor = valor;
	}

	public String getOrden() {
		return orden;
	}

	public void setOrden(String orden) {
		this.orden = orden;
	}
	
	public String getfInicio() {
		return fInicio;
	}

	public void setfInicio(String fInicio) {
		this.fInicio = fInicio;
	}

	public String getfFinal() {
		return fFinal;
	}

	public void setfFinal(String fFinal) {
		this.fFinal = fFinal;
	}

	public String getPromedioId() {
		return promedioId;
	}

	public void setPromedioId(String promedioId) {
		this.promedioId = promedioId;
	}
	

	public String getCorto() {
		return corto;
	}

	public void setCorto(String corto) {
		this.corto = corto;
	}

	public String getDecimales() {
		return decimales;
	}

	public void setDecimales(String decimales) {
		this.decimales = decimales;
	}
	
	public String getRedondeo() {
		return redondeo;
	}

	public void setRedondeo(String redondeo) {
		this.redondeo = redondeo;
	}
	
	public String getCalculo() {
		return calculo;
	}

	public void setCalculo(String calculo) {
		this.calculo = calculo;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("INSERT INTO CICLO_BLOQUE"
					+ " (CICLO_ID, BLOQUE_ID, BLOQUE_NOMBRE, F_INICIO, F_FINAL, VALOR, ORDEN, PROMEDIO_ID, CORTO, DECIMALES, REDONDEO, CALCULO)"
					+ " VALUES(?, TO_NUMBER(?, '99'), ?,"
					+ " TO_DATE(?, 'DD/MM/YYYY'),"
					+ " TO_DATE(?, 'DD/MM/YYYY'),"
					+ " TO_NUMBER(?, '999.99'), "
					+ " TO_NUMBER(?, '99'),"
					+ " TO_NUMBER(?, '99'),"
					+ " ?, TO_NUMBER(?, '9'),"
					+ " ?,"
					+ " ?)");
			
			ps.setString(1, cicloId);
			ps.setString(2, bloqueId);
			ps.setString(3, bloqueNombre);
			ps.setString(4, fInicio);
			ps.setString(5, fFinal);
			ps.setString(6, valor);
			ps.setString(7, orden);
			ps.setString(8, promedioId);
			ps.setString(9, corto);
			ps.setString(10, decimales);
			ps.setString(11, redondeo);
			ps.setString(12, calculo);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloBloque|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("UPDATE CICLO_BLOQUE"
					+ " SET BLOQUE_NOMBRE = ?,"
					+ " F_INICIO = TO_DATE(?, 'DD/MM/YYYY'),"
					+ " F_FINAL = TO_DATE(?, 'DD/MM/YYYY'),"
					+ " VALOR = TO_NUMBER(?, '999.99'),"
					+ " ORDEN = TO_NUMBER(?, '99'),"
					+ " PROMEDIO_ID = TO_NUMBER(?, '99'),"
					+ " CORTO = ?,"
					+ " DECIMALES = TO_NUMBER(?,'9'),"
					+ " REDONDEO = ?, "
					+ " CALCULO = ?" +
					" WHERE CICLO_ID = ?" +
					" AND BLOQUE_ID = TO_NUMBER(?, '99')");			
			ps.setString(1, bloqueNombre);
			ps.setString(2, fInicio);
			ps.setString(3, fFinal);
			ps.setString(4, valor);
			ps.setString(5, orden);
			ps.setString(6, promedioId);
			ps.setString(7, corto);
			ps.setString(8, decimales);
			ps.setString(9, redondeo);
			ps.setString(10, calculo);
			ps.setString(11, cicloId);
			ps.setString(12, bloqueId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloBloque|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CICLO_BLOQUE" +
					" WHERE CICLO_ID = ?" +
					" AND BLOQUE_ID = TO_NUMBER(?, '99')");
			ps.setString(1, cicloId);
			ps.setString(2, bloqueId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloBloque|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		cicloId			= rs.getString("CICLO_ID");
		bloqueId		= rs.getString("BLOQUE_ID");
		bloqueNombre	= rs.getString("BLOQUE_NOMBRE");
		fInicio			= rs.getString("F_INICIO");
		fFinal			= rs.getString("F_FINAL");
		valor			= rs.getString("VALOR");
		orden			= rs.getString("ORDEN");
		promedioId		= rs.getString("PROMEDIO_ID");
		corto			= rs.getString("CORTO");
		decimales		= rs.getString("DECIMALES");
		redondeo		= rs.getString("REDONDEO");
		calculo			= rs.getString("CALCULO");
	}
	
	public void mapeaRegId(Connection con, String cicloId, String bloqueId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT CICLO_ID, BLOQUE_ID, BLOQUE_NOMBRE," +
					" TO_CHAR(F_INICIO,'DD/MM/YYYY') AS F_INICIO, " +
					" TO_CHAR(F_FINAL,'DD/MM/YYYY') AS F_FINAL, VALOR, ORDEN, PROMEDIO_ID, CORTO, DECIMALES, REDONDEO, CALCULO " +
					" FROM CICLO_BLOQUE" +
					" WHERE CICLO_ID = ?" +
					" AND BLOQUE_ID = TO_NUMBER(?, '99')");
			ps.setString(1, cicloId);
			ps.setString(2, bloqueId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloBloque|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CICLO_BLOQUE" +
					" WHERE CICLO_ID = ?" +
					" AND BLOQUE_ID = TO_NUMBER(?, '99')");
			ps.setString(1, cicloId);
			ps.setString(2, bloqueId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloBloque|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return ok;
	}
	
	public static boolean existeEvaluaciones(Connection conn, String cicloId, String promedioId) throws SQLException{
		
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		boolean ok 				= false;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CICLO_BLOQUE WHERE CICLO_ID = ? AND PROMEDIO_ID = TO_NUMBER(?, '99')");
			ps.setString(1, cicloId);
			ps.setString(2, promedioId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloBloque|existeEvaluaciones|:"+ex);
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
			ps = conn.prepareStatement("SELECT COALESCE(MAX(BLOQUE_ID)+1, '1') AS MAXIMO FROM CICLO_BLOQUE" +
					" WHERE CICLO_ID = ?");
			ps.setString(1, cicloId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloBloque|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return maximo;
	}
	
	public String getUltimoBloque(Connection conn, String cicloId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "0";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(BLOQUE_ID), '0') AS MAXIMO FROM CICLO_BLOQUE" +
					" WHERE CICLO_ID = ?");
			ps.setString(1, cicloId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloBloque|getUltimoBloque|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return maximo;
	}
	
	public static int numBloques(Connection conn, String cicloId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		int numBloques 			= 0;
		
		try{
			ps = conn.prepareStatement("SELECT COUNT(BLOQUE_ID) AS NUMBLOQUES FROM CICLO_BLOQUE" +
					" WHERE CICLO_ID = ?");
			ps.setString(1, cicloId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				numBloques = rs.getInt("NUMBLOQUES");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloBloque|numBloques|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return numBloques;
	}
	
	public static String getDecimales(Connection conn, String cicloId, String bloqueId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String decimales		= "0";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(DECIMALES,0) AS DECIMALES FROM CICLO_BLOQUE" +
					" WHERE CICLO_ID = ? AND BLOQUE_ID = TO_NUMBER(?, '99')");
			ps.setString(1, cicloId);
			ps.setString(2, bloqueId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				decimales = rs.getString("DECIMALES");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloBloque|getDecimales|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return decimales;
	}
	
	public static String getRedondeo(Connection conn, String cicloId, String bloqueId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String decimales		= "0";
		
		try{
			ps = conn.prepareStatement("SELECT REDONDEO FROM CICLO_BLOQUE" +
					" WHERE CICLO_ID = ? AND BLOQUE_ID = TO_NUMBER(?, '99')");
			ps.setString(1, cicloId);
			ps.setString(2, bloqueId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				decimales = rs.getString("REDONDEO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloBloque|getRedondeo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return decimales;
	}
	
	public static String getCalculo(Connection conn, String cicloId, String bloqueId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String calculo			= "0";
		
		try{
			ps = conn.prepareStatement("SELECT CALCULO FROM CICLO_BLOQUE" +
					" WHERE CICLO_ID = ? AND BLOQUE_ID = TO_NUMBER(?, '99')");
			ps.setString(1, cicloId);
			ps.setString(2, bloqueId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				calculo = rs.getString("CALCULO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloBloque|getCalculo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return calculo;
	}
	
	public static String getBloqueNombre(Connection conn, String cicloId, String bloqueId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String calculo			= "0";
		
		try{
			ps = conn.prepareStatement("SELECT BLOQUE_NOMBRE FROM CICLO_BLOQUE" +
					" WHERE CICLO_ID = ? AND BLOQUE_ID = TO_NUMBER(?, '99')");
			ps.setString(1, cicloId);
			ps.setString(2, bloqueId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				calculo = rs.getString("BLOQUE_NOMBRE");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloBloque|getBloqueNombre|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return calculo;
	}
	
}
