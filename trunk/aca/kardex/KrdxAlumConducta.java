
package aca.kardex;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class KrdxAlumConducta {
	private String codigoId;
	private String cicloGrupoId;
	private String cursoId;
	private String promedioId;
	private String evaluacionId;
	private String conducta;	
	
	public KrdxAlumConducta(){
		codigoId		= "";
		cicloGrupoId	= "";
		cursoId			= "";
		promedioId		= "";
		evaluacionId	= "";		
		conducta		= "";
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

	public String getConducta() {
		return conducta;
	}

	public void setConducta(String conducta) {
		this.conducta = conducta;
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
			ps = conn.prepareStatement("INSERT INTO KRDX_ALUM_CONDUCTA" +
					" (CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, PROMEDIO_ID, EVALUACION_ID, CONDUCTA )"
					+ " VALUES(?, ?, ?, TO_NUMBER(?,'99'), TO_NUMBER(?, '99'), TO_NUMBER(?, '999.99'))");
			
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, promedioId);
			ps.setString(5, evaluacionId);
			ps.setString(6, conducta);
			
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumConducta|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE KRDX_ALUM_CONDUCTA"
					+ " SET CONDUCTA = TO_NUMBER(?,'999.99')"
					+ " WHERE CODIGO_ID = ?"
					+ " AND CICLO_GRUPO_ID = ?"
					+ " AND CURSO_ID = ?"
					+ " AND PROMEDIO_ID = TO_NUMBER(?,'99')"
					+ " AND EVALUACION_ID = TO_NUMBER(?, '99')");			
			
			ps.setString(1, conducta);
			ps.setString(2, codigoId);			
			ps.setString(3, cicloGrupoId);
			ps.setString(4, cursoId);
			ps.setString(5, promedioId);
			ps.setString(6, evaluacionId);			
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumConducta|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM KRDX_ALUM_CONDUCTA"
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
			System.out.println("Error - aca.kardex.KrdxAlumConducta|deleteReg|:"+ex);
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
		conducta		= rs.getString("CONDUCTA");
	}
	
	public void mapeaRegId(Connection con, String codigoId, String cicloGrupoId, String cursoId, String promedioId, String evaluacionId) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null; 
		try{
			ps = con.prepareStatement("SELECT CODIGO_ID, CICLO_GRUPO_ID,"
					+ " CURSO_ID, PROMEDIO_ID, EVALUACION_ID, CONDUCTA"
					+ " FROM KRDX_ALUM_CONDUCTA"
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
			System.out.println("Error - aca.kardex.KrdxAlumConducta|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM KRDX_ALUM_CONDUCTA"
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
			System.out.println("Error - aca.kardex.KrdxAlumConducta|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	/* Dejar de usar esta función */
	public static boolean tieneEvaluacionesDeConducta(Connection conn, String cicloGrupoId, String evaluacionId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		boolean faltan			= false;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM KRDX_ALUM_CONDUCTA"
					+ " WHERE CICLO_GRUPO_ID = ?"					
					+ " AND CONDUCTA <> 0"
					+ " AND CURSO_ID IN"
					+ " 	(SELECT CURSO_ID FROM PLAN_CURSO WHERE CONDUCTA = 'S')"					
					+ " AND EVALUACION_ID = TO_NUMBER(?, '99')");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, evaluacionId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				faltan = true;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumConducta|faltanEvaluacionesDeDisciplina|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return faltan;
	}
	
	/* Sustituye a la funcion con el mismo nombre pero dos parametros */
	public static boolean tieneEvaluacionesDeConducta(Connection conn, String cicloGrupoId, String promedioId, String evaluacionId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		boolean faltan			= false;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM KRDX_ALUM_CONDUCTA"
					+ " WHERE CICLO_GRUPO_ID = ?"					
					+ " AND CONDUCTA <> 0"
					+ " AND CURSO_ID IN"
					+ " 	(SELECT CURSO_ID FROM PLAN_CURSO WHERE CONDUCTA = 'S')"
					+ " AND PROMEDIO_ID = TO_NUMBER(?, '99')"					
					+ " AND EVALUACION_ID = TO_NUMBER(?, '99')");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, promedioId);
			ps.setString(3, evaluacionId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				faltan = true;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumConducta|faltanEvaluacionesDeDisciplina|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return faltan;
	}
	
}
