/**
 * 
 */
package aca.kardex;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Elifo
 *
 */
public class KrdxAlumActiv {
	private String codigoId;
	private String cicloGrupoId;
	private String cursoId;
	private String evaluacionId;
	private String actividadId;
	private String nota;
	
	public KrdxAlumActiv(){
		codigoId		= "";
		cicloGrupoId	= "";
		cursoId			= "";
		evaluacionId	= "";
		actividadId		= "";
		nota			= "";
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
	 * @return the nota
	 */
	public String getNota() {
		return nota;
	}

	/**
	 * @param nota the nota to set
	 */
	public void setNota(String nota) {
		this.nota = nota;
	}
	
	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO KRDX_ALUM_ACTIV" +
					" (CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID," +
					" ACTIVIDAD_ID, NOTA)" +
					" VALUES(?, ?, ?, TO_NUMBER(?, '99')," +
					" TO_NUMBER(?, '99'), TO_NUMBER(?, '999.99'))");
			
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, evaluacionId);
			ps.setString(5, actividadId);
			ps.setString(6, nota);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumActiv|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE KRDX_ALUM_ACTIV" +
					" SET NOTA = TO_NUMBER(?, '999.99')" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?, '99')" +
					" AND ACTIVIDAD_ID = TO_NUMBER(?, '99')");
			
			ps.setString(1, nota);
			ps.setString(2, codigoId);
			ps.setString(3, cicloGrupoId);
			ps.setString(4, cursoId);
			ps.setString(5, evaluacionId);
			ps.setString(6, actividadId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumActiv|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM KRDX_ALUM_ACTIV" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?, '99')" +
					" AND ACTIVIDAD_ID = TO_NUMBER(?, '99')");
			
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, evaluacionId);
			ps.setString(5, actividadId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumActiv|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	/*
	 * BORRA LAS NOTAS DE LAS ACTIVIDADES DEL ALUMNO EN UNA MATERIA
	 * */
	public static boolean deleteRegMateria(Connection conn, String codigoId, String cicloGrupoId, String cursoId) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM KRDX_ALUM_ACTIV" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");
			
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);			
			if ( ps.executeUpdate() >= 1){
				ok = true;
			}else{
				ok = false;
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumActiv|deleteRegMateria|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}	
	
	/*
	 * BORRA LAS NOTAS DE LAS ACTIVIDADES DEL ALUMNO EN TODAS LAS MATERIAS DEL GRUPO
	 * */
	public static boolean deleteRegGrupo(Connection conn, String codigoId, String cicloGrupoId ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM KRDX_ALUM_ACTIV" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" );
			
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);						
			if ( ps.executeUpdate() >= 1){
				ok = true;
			}else{
				ok = false;
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumActiv|deleteRegGrupo|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	/*
	 * BORRA TODAS LAS NOTAS DE LAS ACTIVIDADES DE UNA MATERIAS
	 * */
	public static boolean deleteGrupoAct(Connection conn, String cicloGrupoId, String cursoId ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM KRDX_ALUM_ACTIV" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" );
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			if ( ps.executeUpdate() >= 1){
				ok = true;				
			}else{
				ok = false;
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumActiv|deleteGrupoAct|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	/*
	 * BORRA LAS NOTAS DE UNA ACTIVIDAD DE LA MATERIA
	 * */
	public static boolean deleteNotasAct(Connection conn, String cicloGrupoId, String cursoId, String evaluacionId, String actividadId) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM KRDX_ALUM_ACTIV" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?,'99')" +
					" ACTIVIDAD_ID = TO_NUMBER(?,'99')");			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);	
			ps.setString(3, evaluacionId);
			ps.setString(4, actividadId);
			
			if ( ps.executeUpdate() >= 1){
				ok = true;
			}else{
				ok = false;
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumActiv|deleteRegMateria|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId		= rs.getString("CODIGO_ID");
		cicloGrupoId	= rs.getString("CICLO_GRUPO_ID");
		cursoId			= rs.getString("CURSO_ID");
		evaluacionId	= rs.getString("EVALUACION_ID");
		actividadId		= rs.getString("ACTIVIDAD_ID");
		nota			= rs.getString("NOTA");
	}
	
	public void mapeaRegId(Connection con, String codigoId, String cicloGrupoId, String cursoId, String evaluacionId, String actividadId) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null; 
		try{
			ps = con.prepareStatement("SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID," +
					" ACTIVIDAD_ID, NOTA" +
					" FROM KRDX_ALUM_ACTIV" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?, '99')" +
					" AND ACTIVIDAD_ID = TO_NUMBER(?, '99')");
				
				ps.setString(1, codigoId);
				ps.setString(2, cicloGrupoId);
				ps.setString(3, cursoId);
				ps.setString(4, evaluacionId);
				ps.setString(5, actividadId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumnoActiv|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM KRDX_ALUM_ACTIV" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?, '99')" +
					" AND ACTIVIDAD_ID = TO_NUMBER(?, '99')");
			
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, evaluacionId);
			ps.setString(5, actividadId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumActiv|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public static boolean tieneNotas(Connection conn, String cicloGrupoId, String cursoId, String evaluacionId, String actividadId) throws SQLException{
		boolean	tieneNotas		= false;
		ResultSet 		rs		= null;
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
			
			rs = ps.executeQuery();
			if (rs.next())
				tieneNotas = true;
			
		}catch(Exception ex){
			System.out.println("Error - aca.krdx.KrdxAlumActiv|tieneNotas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return tieneNotas;
	}	
	
	public static boolean tieneActividades(Connection conn, String codigoId, String cicloGrupoId) throws SQLException{
		boolean	tieneNotas		= false;
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM KRDX_ALUM_ACTIV" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ? ");
			
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);	
			
			rs = ps.executeQuery();
			if (rs.next())
				tieneNotas = true;
			
		}catch(Exception ex){
			System.out.println("Error - aca.krdx.KrdxAlumActiv|tieneActividades|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return tieneNotas;
	}
	
	public static boolean tieneAct(Connection conn, String cicloGrupoId, String cursoId) throws SQLException{
		boolean	tieneNotas		= false;
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM KRDX_ALUM_ACTIV" +
					" WHERE CICLO_GRUPO_ID = ?" +					
					" AND CURSO_ID  = ?");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			
			rs = ps.executeQuery();
			if (rs.next())
				tieneNotas = true;
			
		}catch(Exception ex){
			System.out.println("Error - aca.krdx.KrdxAlumActiv|tieneAct|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return tieneNotas;
	}
	
	public static int getNumActividades(Connection conn, String cicloGrupoId, String cursoId, String evaluacionId, String codigoId) throws SQLException{
		int suma				= 0;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT COUNT(NOTA) AS NOTA FROM KRDX_ALUM_ACTIV" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?, '99')" +
					" AND CODIGO_ID = ? ");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, evaluacionId);
			ps.setString(4, codigoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				suma = rs.getInt("NOTA");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.krdx.KrdxAlumActiv|getNumActividades|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return suma;
	}
	
}
