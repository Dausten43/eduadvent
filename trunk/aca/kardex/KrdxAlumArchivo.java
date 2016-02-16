/**
 * 
 */
package aca.kardex;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Elier
 *
 */
public class KrdxAlumArchivo{
	private String codigoId;
	private String folio;
	private String cicloGrupoId;
	private String cursoId;
	private String evaluacionId;
	private String actividadId;
	private String archivo;
	private String fecha;
	
	public KrdxAlumArchivo(){
		codigoId		= "";
		folio			= "";
		cicloGrupoId	= "";
		cursoId			= "";
		evaluacionId	= "";
		actividadId		= "";
		archivo			= "";
		fecha			= "";
	}

	public String getCodigoId() {
		return codigoId;
	}

	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}

	public String getFolio() {
		return folio;
	}

	public void setFolio(String folio) {
		this.folio = folio;
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

	public String getActividadId() {
		return actividadId;
	}

	public void setActividadId(String actividadId) {
		this.actividadId = actividadId;
	}

	public String getArchivo() {
		return archivo;
	}

	public void setArchivo(String archivo) {
		this.archivo = archivo;
	}

	public String getFecha() {
		return fecha;
	}

	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	
	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok 				= false;
		PreparedStatement ps 	= null;
		try{
			ps = conn.prepareStatement("INSERT INTO KRDX_ALUM_ARCHIVO " +
					" (CODIGO_ID, FOLIO, CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, " +
					" ACTIVIDAD_ID, ARCHIVO, FECHA) " +
					" VALUES(?, TO_NUMBER(?, '9999'), ?, ?, " +
					" TO_NUMBER(?, '99'), TO_NUMBER(?, '99'), ?, localtimestamp)");
			
			ps.setString(1, codigoId);
			ps.setString(2, folio);
			ps.setString(3, cicloGrupoId);
			ps.setString(4, cursoId);
			ps.setString(5, evaluacionId);
			ps.setString(6, actividadId);
			ps.setString(7, archivo);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumArchivo|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok 				= false;
		PreparedStatement ps 	= null;
		try{
			ps = conn.prepareStatement("DELETE FROM KRDX_ALUM_ARCHIVO" +
					" WHERE CODIGO_ID = ? AND FOLIO = TO_NUMBER(?, '9999')");
			
			ps.setString(1, codigoId);
			ps.setString(2, folio);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumArchivo|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId 		= rs.getString("CODIGO_ID");
		folio 			= rs.getString("FOLIO");
		cicloGrupoId 	= rs.getString("CICLO_GRUPO_ID");
		cursoId 		= rs.getString("CURSO_ID");
		evaluacionId 	= rs.getString("EVALUACION_ID");
		actividadId 	= rs.getString("ACTIVIDAD_ID");
		archivo 		= rs.getString("ARCHIVO");
		fecha			= rs.getString("FECHA");
	}
	
	public void mapeaRegId(Connection con, String codigoId) throws SQLException{
		
		ResultSet rs 			= null;		
		PreparedStatement ps 	= null; 
		try{
			ps = con.prepareStatement("SELECT CODIGO_ID, FOLIO, CICLO_GRUPO_ID, CURSO_ID," +
					" EVALUACION_ID, ACTIVIDAD_ID, ARCHIVO, FECHA" +
					" FROM KRDX_ALUM_ARCHIVO" +
					" WHERE CODIGO_ID = ?");
				ps.setString(1, codigoId);
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumArchivo|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
	}
	
	public boolean existeReg(Connection conn, String codigoId, String folio) throws SQLException{
		boolean ok 				= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM KRDX_ALUM_ARCHIVO" +
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
			System.out.println("Error - aca.kardex.KrdxAlumArchivo|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean existeArchivo(Connection conn) throws SQLException{
		boolean ok 				= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM KRDX_ALUM_ARCHIVO" +
					" WHERE CODIGO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?, '99')" +
					" AND ACTIVIDAD_ID = TO_NUMBER(?, '99')" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");
			
			ps.setString(1, codigoId);
			ps.setString(2, evaluacionId);
			ps.setString(3, actividadId);
			ps.setString(4, cicloGrupoId);
			ps.setString(5, cursoId);
			
			rs= ps.executeQuery();
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumArchivo|existeArchivo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
	
	public String maximoReg(Connection conn, String codigoId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(FOLIO)+1,1) AS MAXIMO FROM KRDX_ALUM_ARCHIVO WHERE CODIGO_ID = ?");
			ps.setString(1, codigoId);
			rs= ps.executeQuery();
			
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumArchivo|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
	
	public String ordenarFecha(Connection conn, String fecha){		
		fecha = fecha.substring(8, 10)+ "/" + fecha.substring(5, 7)+ "/" + fecha.substring(0, 4);	
		return fecha;
	}
}