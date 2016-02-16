/**
 * 
 */
package aca.ciclo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Elifo
 *
 */
public class CicloGrupoActividad {
	private String cicloGrupoId;
	private String cursoId;
	private String evaluacionId;
	private String actividadId;
	private String actividadNombre;
	private String fecha;
	private String valor;
	private String tipoactId;
	private String etiquetaId;
	private String mostrar;
	
	public CicloGrupoActividad(){
		cicloGrupoId		= "";
		cursoId				= "";
		evaluacionId		= "";
		actividadId			= "";
		actividadNombre		= "";
		fecha				= "";
		valor				= "";
		tipoactId			= "";
		etiquetaId			= "";
		mostrar				= "";
		
	}

	/**
	 * @return the cicloGrupoId
	 */
	public String getCicloGrupoId() {
		return cicloGrupoId;
	}

	/**
	 * @param cicloGrupoId the cicloGrupoId to set
	 */
	public void setCicloGrupoId(String cicloGrupoId) {
		this.cicloGrupoId = cicloGrupoId;
	}

	/**
	 * @return the cursoId
	 */
	public String getCursoId() {
		return cursoId;
	}

	/**
	 * @param cursoId the cursoId to set
	 */
	public void setCursoId(String cursoId) {
		this.cursoId = cursoId;
	}

	/**
	 * @return the evaluacionId
	 */
	public String getEvaluacionId() {
		return evaluacionId;
	}

	/**
	 * @param evaluacionId the evaluacionId to set
	 */
	public void setEvaluacionId(String evaluacionId) {
		this.evaluacionId = evaluacionId;
	}

	/**
	 * @return the actividadId
	 */
	public String getActividadId() {
		return actividadId;
	}

	/**
	 * @param actividadId the actividadId to set
	 */
	public void setActividadId(String actividadId) {
		this.actividadId = actividadId;
	}

	/**
	 * @return the actividadNombre
	 */
	public String getActividadNombre() {
		return actividadNombre;
	}

	/**
	 * @param actividadNombre the actividadNombre to set
	 */
	public void setActividadNombre(String actividadNombre) {
		this.actividadNombre = actividadNombre;
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
	
	public String getTipoactId() {
		return tipoactId;
	}

	public void setTipoactId(String tipoactId) {
		this.tipoactId = tipoactId;
	}
	
	public String getEtiquetaId() {
		return etiquetaId;
	}

	public void setEtiquetaId(String etiquetaId) {
		this.etiquetaId = etiquetaId;
	}

	public String getMostrar() {
		return mostrar;
	}

	public void setMostrar(String mostrar) {
		this.mostrar = mostrar;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
 		boolean ok = false;
		
		try{
			ps = conn.prepareStatement("INSERT INTO CICLO_GRUPO_ACTIVIDAD" +
					" (CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, ACTIVIDAD_ID, ACTIVIDAD_NOMBRE, FECHA, VALOR, TIPOACT_ID, ETIQUETA_ID, MOSTRAR)" +
					" VALUES(?, ?, TO_NUMBER(?, '99'), TO_NUMBER(?, '99'), ?, TO_TIMESTAMP(?, 'DD/MM/YYYY HH24:MI'), TO_NUMBER(?, '999.99'), TO_NUMBER(?, '99'), TO_NUMBER(?, '999'), ?)");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, evaluacionId);
			ps.setString(4, actividadId);
			ps.setString(5, actividadNombre);
			ps.setString(6, fecha);
			ps.setString(7, valor);
			ps.setString(8, tipoactId);
			ps.setString(9, etiquetaId);
			ps.setString(10, mostrar);
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoActividad|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		
		try{
			ps = conn.prepareStatement("UPDATE CICLO_GRUPO_ACTIVIDAD" +
					" SET ACTIVIDAD_NOMBRE = ?," +
					" FECHA = TO_TIMESTAMP(?, 'DD/MM/YYYY HH24:MI')," +
					" VALOR = TO_NUMBER(?, '999.99'), TIPOACT_ID = TO_NUMBER(?, '99'), ETIQUETA_ID = TO_NUMBER(?, '999'), MOSTRAR=?" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?, '99')" +
					" AND ACTIVIDAD_ID = TO_NUMBER(?, '99')");
			
			ps.setString(1, actividadNombre);
			ps.setString(2, fecha);
			ps.setString(3, valor);
			ps.setString(4, tipoactId);
			ps.setString(5, etiquetaId);
			ps.setString(6, mostrar);
			ps.setString(7, cicloGrupoId);
			ps.setString(8, cursoId);
			ps.setString(9, evaluacionId);
			ps.setString(10, actividadId);
			
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoActividad|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CICLO_GRUPO_ACTIVIDAD" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?, '99')" +
					" AND ACTIVIDAD_ID = TO_NUMBER(?, '99')");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, evaluacionId);
			ps.setString(4, actividadId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoActividad|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	/*
	 * BORRA TODAS LAS ACTIVIDADES DEL GRUPO
	 * */
	
	public static boolean deleteGrupoAct(Connection conn, String cicloGrupoId, String cursoId) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CICLO_GRUPO_ACTIVIDAD" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);	
			
			if ( ps.executeUpdate() >= 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoActividad|deleteGrupoAct|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		cicloGrupoId		= rs.getString("CICLO_GRUPO_ID");
		cursoId				= rs.getString("CURSO_ID");
		evaluacionId		= rs.getString("EVALUACION_ID");
		actividadId			= rs.getString("ACTIVIDAD_ID");
		actividadNombre		= rs.getString("ACTIVIDAD_NOMBRE");
		fecha				= rs.getString("FECHA");
		valor				= rs.getString("VALOR");
		tipoactId			= rs.getString("TIPOACT_ID");
		etiquetaId			= rs.getString("ETIQUETA_ID");
		mostrar				= rs.getString("MOSTRAR");
	}
	
	public void mapeaRegId(Connection con, String cicloGrupoId, String cursoId, String evaluacionId, String actividadId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, ACTIVIDAD_ID," +
					" ACTIVIDAD_NOMBRE, TO_CHAR(FECHA, 'DD/MM/YYYY HH:MI AM') AS FECHA, VALOR, TIPOACT_ID, ETIQUETA_ID, MOSTRAR " +
					" FROM CICLO_GRUPO_ACTIVIDAD" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?, '99')" +
					" AND ACTIVIDAD_ID = TO_NUMBER(?, '99')");
				
				ps.setString(1, cicloGrupoId);
				ps.setString(2, cursoId);
				ps.setString(3, evaluacionId);
				ps.setString(4, actividadId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoActividad|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CICLO_GRUPO_ACTIVIDAD" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?, '99')" +
					" AND ACTIVIDAD_ID = TO_NUMBER(?, '99')");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, evaluacionId);
			ps.setString(4, actividadId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoActividad|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public String maximoReg(Connection conn) throws SQLException{
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		String maximo			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(ACTIVIDAD_ID)+1,'1') AS MAXIMO"+
				" FROM CICLO_GRUPO_ACTIVIDAD"+				
				" WHERE CICLO_GRUPO_ID = ?" +
				" AND CURSO_ID = ?" +
				" AND EVALUACION_ID = TO_NUMBER(?, '99')");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, evaluacionId);
			
			rs = ps.executeQuery();
			if (rs.next())
				maximo = rs.getString("MAXIMO");			
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoActividad|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return maximo;
	}
	
	public static boolean tieneNotas(Connection conn, String cicloGrupoId, String cursoId, String evaluacionId, String actividadId) throws SQLException{
		boolean ok 				= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM KRDX_ALUM_ACTIV" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?, '99')" +
					" AND ACTIVIDAD_ID = TO_NUMBER(?, '99')");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, evaluacionId);
			ps.setString(4, actividadId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoActividad|tieneNotas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	/*
	 * Determina si se puede borrar una actividad
	 * */
	public static boolean tieneNotas(Connection conn, String cicloGrupoId, String evaluacionId, String actividadId) throws SQLException{
		boolean ok 				= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM KRDX_ALUM_ACTIV" +
					" WHERE CICLO_GRUPO_ID LIKE ?||'%'" +					
					" AND EVALUACION_ID = TO_NUMBER(?, '99')" +
					" AND ACTIVIDAD_ID = TO_NUMBER(?, '99')");
			
			ps.setString(1, cicloGrupoId);			
			ps.setString(2, evaluacionId);
			ps.setString(3, actividadId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoActividad|tieneNotas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	/*public static String getPromedio(Connection conn, String cicloGrupoId, String cursoId, String evaluacionId, String actividadId) throws SQLException{
		String promedio			= "X";
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM KRDX_ALUM_ACTIV" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?, '99')" +
					" AND ACTIVIDAD_ID = TO_NUMBER(?, '99')");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, evaluacionId);
			ps.setString(4, actividadId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				promedio = rs.getString("PROMEDIO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoActividad|getPromedio|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return promedio;
	}*/
	
	public static boolean tieneActividades(Connection conn, String cicloGrupoId, String cursoId, String evaluacionId) throws SQLException{
		boolean ok 				= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CICLO_GRUPO_ACTIVIDAD" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?, '99')");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, evaluacionId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoActividad|tieneActividades|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public static int getSumActividades(Connection conn, String cicloGrupoId, String cursoId, String evaluacionId) throws SQLException{
		int suma				= 0;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT SUM(VALOR) AS SUMA FROM 	CICLO_GRUPO_ACTIVIDAD" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?, '99')");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, evaluacionId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				suma = rs.getInt("SUMA");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoActividad|getSumActividades|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return suma;
	}
	
	public static float getSumActividades(Connection conn, String cicloGrupoId, String cursoId, String evaluacionId, String actividadId) throws SQLException{
		float suma				= 0;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT SUM(VALOR) AS SUMA FROM CICLO_GRUPO_ACTIVIDAD" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?, '99')" +
					" AND ACTIVIDAD_ID != TO_NUMBER(?, '99')");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, evaluacionId);
			ps.setString(4, actividadId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				suma = rs.getFloat("SUMA");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoActividad|getSumActividades|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return suma;
	}
	
	public static int getNumActividades(Connection conn, String cicloGrupoId, String cursoId) throws SQLException{
		int actividades			= 0;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(COUNT(ACTIVIDAD_ID)) AS NUMACT FROM CICLO_GRUPO_ACTIVIDAD" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				actividades = rs.getInt("NUMACT");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoActividad|getNumActividades|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return actividades;
	}
}
