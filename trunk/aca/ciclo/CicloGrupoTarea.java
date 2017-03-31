package aca.ciclo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CicloGrupoTarea {
	private String cicloGrupoId;
	private String tareaId;
	private String tareaNombre;
	private String descripcion;
	private String temaId;	
	private String cursoId;
	private String fecha; 
	
	public CicloGrupoTarea(){
		cicloGrupoId= "";
		tareaId		= "";
		tareaNombre	= "";
		descripcion	= "";
		temaId		= "";
		cursoId		= "";
		fecha		= "";
	}

	public String getCursoId() {
		return cursoId;
	}

	/**
	 * @param cicloGrupoId the cicloGrupoId to set
	 */
	public void setCursoId(String cursoId) {
		this.cursoId = cursoId;
	}
	
	
	public String getTemaId() {
		return temaId;
	}

	/**
	 * @param cicloGrupoId the cicloGrupoId to set
	 */
	public void setTemaId(String temaId) {
		this.temaId = temaId;
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
	 * @return the tareaId
	 */
	public String getTareaId() {
		return tareaId;
	}

	/**
	 * @param tareaId the tareaId to set
	 */
	public void setTareaId(String tareaId) {
		this.tareaId = tareaId;
	}

	/**
	 * @return the tareaNombre
	 */
	public String getTareaNombre() {
		return tareaNombre;
	}

	/**
	 * @param tareaNombre the tareaNombre to set
	 */
	public void setTareaNombre(String tareaNombre) {
		this.tareaNombre = tareaNombre;
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
	

	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
 		boolean ok = false;
		
		try{
			ps = conn.prepareStatement("INSERT INTO CICLO_GRUPO_TAREA" +
					" (CICLO_GRUPO_ID, TAREA_ID, TAREA_NOMBRE, DESCRIPCION,TEMA_ID, CURSO_ID, FECHA)" +
					" VALUES(?, ?, ?, ?, ?, ?, TO_DATE(?, 'DD/MM/YYYY'))");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, tareaId);
			ps.setString(3, tareaNombre);
			ps.setString(4, descripcion);
			ps.setString(5, temaId);
			ps.setString(6, cursoId);
			ps.setString(7, fecha);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoTarea|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		
		try{
			ps = conn.prepareStatement("UPDATE CICLO_GRUPO_TAREA" +
					" SET TAREA_NOMBRE = ?," +
					" DESCRIPCION = ?," +
					" TEMA_ID = ?," +
					" FECHA = TO_DATE(?, 'DD/MM/YYYY')" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND TAREA_ID = ?" +
					" AND CURSO_ID = ? ");
			
			ps.setString(1, tareaNombre);
			ps.setString(2, descripcion);
			ps.setString(3, temaId);
			ps.setString(4, fecha);
			ps.setString(5, cicloGrupoId);
			ps.setString(6, tareaId);
			ps.setString(7, cursoId);
			
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoTarea|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CICLO_GRUPO_TAREA" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND TAREA_ID = ?" +
					" AND CURSO_ID = ? ");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, tareaId);
			ps.setString(3, cursoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoTarea|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		cicloGrupoId		= rs.getString("CICLO_GRUPO_ID");
		tareaId				= rs.getString("TAREA_ID");
		tareaNombre 		= rs.getString("TAREA_NOMBRE");
		descripcion			= rs.getString("DESCRIPCION");
		temaId				= rs.getString("TEMA_ID");
		cursoId				= rs.getString("CURSO_ID");
		fecha				= rs.getString("FECHA");
	}
	
	public void mapeaRegId(Connection con, String cicloGrupoId,String cursoId, String tareaId ) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;		
		try{
			ps = con.prepareStatement("SELECT CICLO_GRUPO_ID, TAREA_ID, " +
					" TAREA_NOMBRE, DESCRIPCION, TEMA_ID, CURSO_ID, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA" +
					" FROM CICLO_GRUPO_TAREA" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND TAREA_ID = ?" +
					" AND CURSO_ID = ?");
				
				ps.setString(1, cicloGrupoId);
				ps.setString(2, tareaId);
				ps.setString(3, cursoId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoTarea|mapeaRegId|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
	
	}
	
	public boolean existeReg(Connection conn) throws SQLException{
		boolean ok 			    = false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CICLO_GRUPO_TAREA" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND TAREA_ID = ?" +
					" AND CURSO_ID = ?");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, tareaId);
			ps.setString(3, cursoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoTarea|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public String maximoReg(Connection conn) throws SQLException{
		String maximo 			= "01";
		ResultSet rs			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(TRIM(TO_CHAR(MAX(TO_NUMBER(SUBSTRING(TAREA_ID,5,2),'99'))+1,'00')),'01') AS MAXIMO" +
					" FROM CICLO_GRUPO_TAREA " +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND TEMA_ID = ?");
			
			ps.setString(1, cicloGrupoId );
			ps.setString(2, cursoId );
			ps.setString(3, temaId);
			
			rs = ps.executeQuery();
			if (rs.next()){
				maximo = temaId + rs.getString("MAXIMO");
				
			}		
	         
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGpoModulo|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return maximo;
	}
	
	
}