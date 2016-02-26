
package aca.kardex;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class KrdxAlumActitud {
	private String codigoId;
	private String cicloGrupoId;
	private String cursoId;
	private String evaluacionId;
	private String aspectosId;
	private String nota;
	
	public KrdxAlumActitud(){
		codigoId		= "";
		cicloGrupoId	= "";
		cursoId			= "";
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

	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO KRDX_ALUM_CONDUCTA" +
					" (CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, ASPECTOS_ID, NOTA)" +
					" VALUES(?, ?, ?," +
					" TO_NUMBER(?, '99')," +
					" TO_NUMBER(?, '999.99'),"
					+ "TO_NUMBER(?, '99999.99'))");
			
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, evaluacionId);
			ps.setString(5, aspectosId);
			ps.setString(6, nota);
			
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
			ps = conn.prepareStatement("UPDATE KRDX_ALUM_CONDUCTA" +
					" SET NOTA = TO_NUMBER(?,'99999.99')" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?, '99')" +
					" AND ASPECTOS_ID = TO_NUMBER(?,'99')");			
			
			ps.setString(1, nota);
			ps.setString(2, codigoId);			
			ps.setString(3, cicloGrupoId);
			ps.setString(4, cursoId);			
			ps.setString(5, evaluacionId);		
			ps.setString(6, aspectosId);
			
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
			ps = conn.prepareStatement("DELETE FROM KRDX_ALUM_CONDUCTA" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?,'99')"+
					" AND ASPECTOS_ID = TO_NUMBER(?,'99')");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, evaluacionId);
			ps.setString(5, aspectosId);
			
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
		evaluacionId	= rs.getString("EVALUACION_ID");
		aspectosId		= rs.getString("ASPECTOS_ID");
		nota			= rs.getString("NOTA");
	}
	
	public void mapeaRegId(Connection con, String codigoId, String cicloGrupoId, String cursoId, String evaluacionId, String aspectosId) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null; 
		try{
			ps = con.prepareStatement("SELECT CODIGO_ID, CICLO_GRUPO_ID," +
					" CURSO_ID, EVALUACION_ID, ASPECTOS_ID, NOTA" +
					" FROM KRDX_ALUM_CONDUCTA" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?"+
					" AND EVALUACION_ID = TO_NUMBER(?,'99')"+
					" AND ASPECTOS_ID = TO_NUMBER(?,99.99)");
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
			ps = conn.prepareStatement("SELECT * FROM KRDX_ALUM_CONDUCTA" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?, '99')"+
					" AND ASPECTOS_ID = TO_NUMBER(?, '99')");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, evaluacionId);
			ps.setString(5, aspectosId);
			
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
}
