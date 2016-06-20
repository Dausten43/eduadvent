
package aca.kardex;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class KrdxAlumActitud {
	private String codigoId;
	private String cicloGrupoId;
	private String cursoId;
	private String promedioId;
	private String evaluacionId;
	private String aspectosId;
	private String nota;
	
	public KrdxAlumActitud(){
		codigoId		= "";
		cicloGrupoId	= "";
		cursoId			= "";
		promedioId 		= "";
		evaluacionId	= "";
		aspectosId		= "";
		nota			= "";
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

	public String getAspectos() {
		return aspectosId;
	}

	public void setAspectos(String aspectos) {
		this.aspectosId = aspectos;
	}

	public String getNota() {
		return nota;
	}

	public void setNota(String nota) {
		this.nota = nota;
	}
	
	public String getPromedioId() {
		return promedioId;
	}

	public void setPromedioId(String promedioId) {
		this.promedioId = promedioId;
	}

	public String getAspectosId() {
		return aspectosId;
	}

	public void setAspectosId(String aspectosId) {
		this.aspectosId = aspectosId;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO KRDX_ALUM_ACTITUD"
					+ " (CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, PROMEDIO_ID, EVALUACION_ID, ASPECTOS_ID, NOTA)"
					+ " VALUES(?, ?, ?,"
					+ " TO_NUMBER(?, '99'),"
					+ " TO_NUMBER(?, '99'),"
					+ " TO_NUMBER(?, '999'),"
					+ " TO_NUMBER(?, '999.99'))");
			
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, promedioId);
			ps.setString(5, evaluacionId);
			ps.setString(6, aspectosId);
			ps.setString(7, nota);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumActitud|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		
		try{
			ps = conn.prepareStatement("UPDATE KRDX_ALUM_ACTITUD" +
					" SET NOTA = TO_NUMBER(?,'999.99')" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND PROMEDIO_ID = TO_NUMBER(?, '99')" +
					" AND EVALUACION_ID = TO_NUMBER(?, '99')" +
					" AND ASPECTOS_ID = TO_NUMBER(?,'999')");		
			
			ps.setString(1, nota);
			ps.setString(2, codigoId);			
			ps.setString(3, cicloGrupoId);
			ps.setString(4, cursoId);			
			ps.setString(5, promedioId);
			ps.setString(6, evaluacionId);
			ps.setString(7, aspectosId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumActitud|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM KRDX_ALUM_ACTITUD" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND PROMEDIO_ID = TO_NUMBER(?,'99')"+
					" AND EVALUACION_ID = TO_NUMBER(?,'99')"+
					" AND ASPECTOS_ID = TO_NUMBER(?,'999')");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, promedioId);
			ps.setString(5, evaluacionId);
			ps.setString(6, aspectosId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumActitud|deleteReg|:"+ex);
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
		aspectosId		= rs.getString("ASPECTOS_ID");
		nota			= rs.getString("NOTA");
	}
	
	public void mapeaRegId(Connection con, String codigoId, String cicloGrupoId, String cursoId, String evaluacionId, String aspectosId) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null; 
		try{
			ps = con.prepareStatement("SELECT CODIGO_ID, CICLO_GRUPO_ID," +
					" CURSO_ID, PROMEDIO_ID, EVALUACION_ID, ASPECTOS_ID, NOTA" +
					" FROM KRDX_ALUM_ACTITUD" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?"+
					" AND PROMEDIO_ID = TO_NUMBER(?,'99')"+
					" AND EVALUACION_ID = TO_NUMBER(?,'99')"+
					" AND ASPECTOS_ID = TO_NUMBER(?,999)");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, evaluacionId);
			ps.setString(5, aspectosId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumActitud|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM KRDX_ALUM_ACTITUD" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND PROMEDIO_ID = TO_NUMBER(?, '99')"+
					" AND EVALUACION_ID = TO_NUMBER(?, '99')"+
					" AND ASPECTOS_ID = TO_NUMBER(?, '999')");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, promedioId);
			ps.setString(5, evaluacionId);
			ps.setString(6, aspectosId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumActitud|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public static String calFinalActitud(Connection conn, String codigoId, String cicloGrupoId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String calFinal			= "";
		
		try{
			ps = conn.prepareStatement("SELECT SUM(NOTA) AS FINAL FROM KRDX_ALUM_ACTITUD " +
					" WHERE CODIGO_ID='"+codigoId+"' AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' ");
			
			rs= ps.executeQuery();		
			if(rs.next()){
				calFinal = rs.getString("FINAL");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumFalta|calFinalActitud|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return calFinal;
	}
	
	public static String calActitud(Connection conn, String codigoId, String cicloGrupoId, String evaluacionId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String actitud			= "";
		
		try{
			ps = conn.prepareStatement("SELECT NOTA AS ACTITUD FROM KRDX_ALUM_ACTITUD " +
					" WHERE CODIGO_ID='"+codigoId+"' AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' AND EVALUACION_ID = '"+evaluacionId+"'");
			
			rs= ps.executeQuery();		
			if(rs.next()){
				actitud = rs.getString("ACTITUD");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumFalta|calActitud|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return actitud;
	}
}
