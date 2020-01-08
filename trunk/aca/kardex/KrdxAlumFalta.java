/**
 * 
 */
package aca.kardex;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class KrdxAlumFalta {
	
	private String codigoId;
	private String cicloGrupoId;
	private String cursoId;
	private String promedioId;
	private String evaluacionId;
	private String falta;
	private String tardanza;
	
	public KrdxAlumFalta(){
		codigoId		= "";
		cicloGrupoId	= "";
		cursoId			= "";
		promedioId		= "";
		evaluacionId	= "";
		falta 			= "0";
		tardanza 		= "0";
		
	}
		
	public String getCodigoId() {
		return codigoId;
	}

	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}

	public String getCicloGrupoId() {
		return cicloGrupoId;
	}

	public void setCicloGrupoId(String cicloGrupoId) {
		this.cicloGrupoId = cicloGrupoId;
	}

	public String getCursoId() {
		return cursoId;
	}

	public void setCursoId(String cursoId) {
		this.cursoId = cursoId;
	}

	public String getEvaluacionId() {
		return evaluacionId;
	}

	public void setEvaluacionId(String evaluacionId) {
		this.evaluacionId = evaluacionId;
	}

	public String getFalta() {
		return falta;
	}

	public void setFalta(String falta) {
		this.falta = falta;
	}
	
	public String getTardanza() {
		return tardanza;
	}

	public void setTardanza(String tardanza) {
		this.tardanza = tardanza;
	}

	public String getPromedioId() {
		return promedioId;
	}

	public void setPromedioId(String promedioId) {
		this.promedioId = promedioId;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO KRDX_ALUM_FALTA " +
					" (CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, PROMEDIO_ID, EVALUACION_ID, FALTA, TARDANZA)"
					+ " VALUES(?, ?, ?, TO_NUMBER(?, '99'), TO_NUMBER(?, '99'), TO_NUMBER(?, '99'), TO_NUMBER(?, '99'))");
			
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, promedioId);
			ps.setString(5, evaluacionId);
			ps.setString(6, falta);
			ps.setString(7, tardanza);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumFalta|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE KRDX_ALUM_FALTA "
					+ " SET " 
					+ " FALTA = TO_NUMBER(?,'99'),"
					+ " TARDANZA = TO_NUMBER(?,'99')" 
					+ " WHERE CODIGO_ID = ?" 
					+ " AND CICLO_GRUPO_ID = ?" 
					+ " AND CURSO_ID = ?" 
					+ " AND PROMEDIO_ID = TO_NUMBER(?,'99')"
					+ " AND EVALUACION_ID = TO_NUMBER(?, '99')");			
			
			ps.setString(1, falta);
			ps.setString(2, tardanza);
			ps.setString(3, codigoId);			
			ps.setString(4, cicloGrupoId);
			ps.setString(5, cursoId);	
			ps.setString(6, promedioId);
			ps.setString(7, evaluacionId);			
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumFalta|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM KRDX_ALUM_FALTA "
					+ " WHERE CODIGO_ID = ?"
					+ " AND CICLO_GRUPO_ID = ?"
					+ " AND CURSO_ID = ?"
					+ " AND PROMEDIO_ID = TO_NUMBER(?,'99')"
					+ " AND EVALUACION_ID = TO_NUMBER(?,'99')");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, promedioId);
			ps.setString(5, evaluacionId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumFalta|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId		= rs.getString("CODIGO_ID");
		cicloGrupoId	= rs.getString("CICLO_GRUPO_ID");
		cursoId			= rs.getString("CURSO_ID");
		promedioId		= rs.getString("PROMEDIO_ID");
		evaluacionId	= rs.getString("EVALUACION_ID");
		falta			= rs.getString("FALTA");
		tardanza		= rs.getString("TARDANZA");
	}
	
	public void mapeaRegId(Connection con, String codigoId, String cicloGrupoId, String cursoId, String promedioId, String evaluacionId) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null; 
		try{
			ps = con.prepareStatement("SELECT CODIGO_ID, CICLO_GRUPO_ID," 
					+ " CURSO_ID, PROMEDIO_ID, EVALUACION_ID, FALTA, TARDANZA " 
					+ " FROM KRDX_ALUM_FALTA" 
					+ " WHERE CODIGO_ID = ?" 
					+ " AND CICLO_GRUPO_ID = ?" 
					+ " AND CURSO_ID = ?"
					+ " AND PROMEDIO_ID = TO_NUMBER(?,'99')"
					+ " AND EVALUACION_ID = TO_NUMBER(?,'99')");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, promedioId);
			ps.setString(5, evaluacionId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumFalta|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM KRDX_ALUM_FALTA" 
					+ " WHERE CODIGO_ID = ?" 
					+ " AND CICLO_GRUPO_ID = ?" 
					+ " AND CURSO_ID = ?" 
					+ " AND PROMEDIO_ID = TO_NUMBER(?, '99')"
					+ " AND EVALUACION_ID = TO_NUMBER(?, '99')");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, promedioId);
			ps.setString(5, evaluacionId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumFalta|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public static String totalfaltasEvaluacion(Connection conn, String codigoId, String cicloGrupoId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String faltas			= "";
		
		try{
			ps = conn.prepareStatement("SELECT SUM(FALTA) AS TOTAL FROM KRDX_ALUM_FALTA " +
					" WHERE CODIGO_ID='"+codigoId+"' AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' AND EVALUACION_ID != 0"
							+ "AND CURSO_ID NOT IN (SELECT CURSO_ID FROM PLAN_CURSO WHERE FALTA = 'N')");
			
			rs= ps.executeQuery();		
			if(rs.next()){
				faltas = rs.getString("TOTAL");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumFalta|totalfaltasEvaluacion|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return faltas;
	}
	
	public static String totalTardanzasEvaluacion(Connection conn, String codigoId, String cicloGrupoId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String tardanzas		= "";
		
		try{
			ps = conn.prepareStatement("SELECT SUM(TARDANZA) AS TOTAL FROM KRDX_ALUM_FALTA " +
					" WHERE CODIGO_ID='"+codigoId+"' AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' AND EVALUACION_ID != 0"
							+ "AND CURSO_ID NOT IN (SELECT CURSO_ID FROM PLAN_CURSO WHERE FALTA = 'N')");
			
			rs= ps.executeQuery();		
			if(rs.next()){
				tardanzas = rs.getString("TOTAL");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumFalta|totalTardanzasEvaluacion|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return tardanzas;
	}
	
	public static String totalfaltasPromedio(Connection conn, String codigoId, String cicloGrupoId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String faltas			= "";
		
		try{
			ps = conn.prepareStatement("SELECT SUM(FALTA) AS TOTAL FROM KRDX_ALUM_FALTA " +
					" WHERE CODIGO_ID='"+codigoId+"' AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' AND EVALUACION_ID = 0"
							+ "AND CURSO_ID NOT IN (SELECT CURSO_ID FROM PLAN_CURSO WHERE FALTA = 'N')");
			
			rs= ps.executeQuery();		
			if(rs.next()){
				faltas = rs.getString("TOTAL");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumFalta|totalfaltasPromedio|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return faltas;
	}
	
	public static String totalTardanzasPromedio(Connection conn, String codigoId, String cicloGrupoId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String tardanzas		= "";
		
		try{
			ps = conn.prepareStatement("SELECT SUM(TARDANZA) AS TOTAL FROM KRDX_ALUM_FALTA " +
					" WHERE CODIGO_ID='"+codigoId+"' AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' AND EVALUACION_ID = 0 "
							+ "AND CURSO_ID NOT IN (SELECT CURSO_ID FROM PLAN_CURSO WHERE FALTA = 'N')");
			
			rs= ps.executeQuery();		
			if(rs.next()){
				tardanzas = rs.getString("TOTAL");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumFalta|totalTardanzasPromedio|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return tardanzas;
	}
	
	public static String faltasPorCiclo(Connection conn, String codigoId, String cicloGrupoId, String evaluacionId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String faltas			= "";
		
		try{
			ps = conn.prepareStatement("SELECT SUM(FALTA) AS TOTAL FROM KRDX_ALUM_FALTA " +
					" WHERE CODIGO_ID='"+codigoId+"' AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' AND EVALUACION_ID = '"+evaluacionId+"' AND PROMEDIO_ID != 0"
							+ "AND CURSO_ID NOT IN (SELECT CURSO_ID FROM PLAN_CURSO WHERE FALTA = 'N')");
			
			rs= ps.executeQuery();		
			if(rs.next()){
				faltas = rs.getString("TOTAL");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumFalta|faltasPorCiclo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return faltas == null ? "" : faltas;
	}
	
	public static String tardanzasPorCiclo(Connection conn, String codigoId, String cicloGrupoId, String evaluacionId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String tardanzas		= null;
		
		try{
			ps = conn.prepareStatement("SELECT SUM(TARDANZA) AS TOTAL FROM KRDX_ALUM_FALTA " +
					" WHERE CODIGO_ID='"+codigoId+"' AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' AND EVALUACION_ID = '"+evaluacionId+"' AND PROMEDIO_ID != '0'"
							+ "AND CURSO_ID NOT IN (SELECT CURSO_ID FROM PLAN_CURSO WHERE FALTA = 'N')");
			
			rs= ps.executeQuery();		
			if(rs.next()){
				tardanzas = rs.getString("TOTAL");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumFalta|tardanzasPorCiclo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return tardanzas == null ? "" : tardanzas;
	}
	
	public static String faltasPorPromedioId(Connection conn, String codigoId, String cicloGrupoId, String promedioId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String faltas			= null;
		
		try{
			ps = conn.prepareStatement("SELECT SUM(FALTA) AS TOTAL FROM KRDX_ALUM_FALTA " +
					" WHERE CODIGO_ID='"+codigoId+"' AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' AND PROMEDIO_ID = '"+promedioId+"' "
							+ "AND CURSO_ID NOT IN (SELECT CURSO_ID FROM PLAN_CURSO WHERE FALTA = 'N')");
			
			rs= ps.executeQuery();		
			if(rs.next()){
				faltas = rs.getString("TOTAL");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumFalta|faltasPorPromedioId|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return faltas == null ? "" : faltas;
	}
	
	public static String tardanzasPorPromedioId(Connection conn, String codigoId, String cicloGrupoId, String promedioId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String tardanzas		= null;
		
		try{
			ps = conn.prepareStatement("SELECT SUM(TARDANZA) AS TOTAL FROM KRDX_ALUM_FALTA " +
					" WHERE CODIGO_ID='"+codigoId+"' AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' AND PROMEDIO_ID = '"+promedioId+"'"
							+ "AND CURSO_ID NOT IN (SELECT CURSO_ID FROM PLAN_CURSO WHERE FALTA = 'N')");
			
			rs= ps.executeQuery();		
			if(rs.next()){
				tardanzas = rs.getString("TOTAL");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumFalta|tardanzasPorPromedioId|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return tardanzas == null ? "" : tardanzas;
	}
}
