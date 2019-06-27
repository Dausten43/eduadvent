package aca.ciclo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CicloGrupoArchivo {
	
	private String cicloGrupoId;
	private String cursoId;
	private String temaId;
	private String folio;
	private long archivo;
	private String descripcion;
	private String nombre;
	
	public CicloGrupoArchivo(){
		cicloGrupoId 	= "";
		cursoId 		= "";
		temaId			= "";
		folio			= "";
		archivo			= 0;
		descripcion		= "";
		nombre			= "";
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
	 * @return the temaId
	 */
	public String getTemaId() {
		return temaId;
	}

	/**
	 * @param temaId the temaId to set
	 */
	public void setTemaId(String temaId) {
		this.temaId = temaId;
	}

	/**
	 * @return the folio
	 */
	public String getFolio() {
		return folio;
	}

	/**
	 * @param folio the folio to set
	 */
	public void setFolio(String folio) {
		this.folio = folio;
	}

	/**
	 * @return the archivo
	 */
	public long getArchivo() {
		return archivo;
	}

	/**
	 * @param archivo the archivo to set
	 */
	public void setArchivo(long archivo) {
		this.archivo = archivo;
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
	 * @return the descripcion
	 */
	public String getNombre() {
		return nombre;
	}

	/**
	 * @param descripcion the descripcion to set
	 */
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}	
	
	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{			
			ps = conn.prepareStatement("INSERT INTO CICLO_GRUPO_ARCHIVO" +
					"(CICLO_GRUPO_ID, CURSO_ID, TEMA_ID, FOLIO, ARCHIVO, DESCRIPCION, NOMBRE) " +
					"VALUES(?, ?, ?, TO_NUMBER(?,'99'), ?, ?, ?)");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, temaId);
			ps.setString(4, folio);
			ps.setLong(5, archivo);
			ps.setString(6, descripcion);
			ps.setString(7, nombre);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoArchivo.insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteSoloRegistro(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		
		try{
			ps = conn.prepareStatement("DELETE FROM CICLO_GRUPO_ARCHIVO"+
					" WHERE CICLO_GRUPO_ID  = ?" +
					" AND CURSO_ID = ?" +
					" AND TEMA_ID = ?" +
					" AND FOLIO = TO_NUMBER(?,'99')");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, temaId);
			ps.setString(4, folio);
			
			if (ps.executeUpdate()== 1)
				ok = true;
			else
				ok = false;
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoCurso|deleteSoloRegistro|:"+ex);
			ok = false;
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
	
	public boolean deleteReg(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ResultSet rs = null;
			ps = conn.prepareStatement("SELECT LO_UNLINK(ARCHIVO) AS RESULTADO FROM CICLO_GRUPO_ARCHIVO"+
				" WHERE CICLO_GRUPO_ID  = ?" +
				" AND CURSO_ID = ?" +
				" AND TEMA_ID = ?" +
				" AND FOLIO = TO_NUMBER(?,'99')" );
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, temaId);
			ps.setString(4, folio);
		
			
			rs = ps.executeQuery();
			if(rs.next()){
			    ok=rs.getInt("RESULTADO")==1?true:false;
			}
		}catch(Exception ex){
			System.out.println("Error - adm.ciclo.CicloGrupoCurso|unlink - deleteReg|:"+ex);
			ok = false;
		}finally{
			if (ps!=null) ps.close();
		}
		ps = null;
		if(ok){
			ok = false;
			try{
				ps = conn.prepareStatement("DELETE FROM CICLO_GRUPO_ARCHIVO"+
						" WHERE CICLO_GRUPO_ID  = ?" +
						" AND CURSO_ID = ?" +
						" AND TEMA_ID = ?" +
						" AND FOLIO = TO_NUMBER(?,'99')");
				
				ps.setString(1, cicloGrupoId);
				ps.setString(2, cursoId);
				ps.setString(3, temaId);
				ps.setString(4, folio);
				
				if (ps.executeUpdate()== 1)
					ok = true;
				else
					ok = false;
			}catch(Exception ex){
				System.out.println("Error - aca.ciclo.CicloGrupoCurso|borrar - deleteReg|:"+ex);
				ok = false;
			}finally{
				if (ps!=null) ps.close();
			}
		}else{
			System.out.println("No se pudo desligar la imagen... - aca.ciclo..CicloGrupoArchivo|deleteReg");
		}
		
		return ok;
	}	
		
	public void mapeaReg(ResultSet rs ) throws SQLException{
		cicloGrupoId	= rs.getString("CICLO_GRUPO_ID");
		cursoId  		= rs.getString("CURSO_ID");
		temaId			= rs.getString("TEMA_ID");
		folio			= rs.getString("FOLIO");
		archivo			= rs.getInt("ARCHIVO");
		descripcion		= rs.getString("DESCRIPCION");
		nombre			= rs.getString("NOMBRE");
	}
	
	public void mapeaRegId(Connection con, String cicloGrupoId, String cursoId, String temaId, String folio) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT CICLO_GRUPO_ID, CURSO_ID," +
					" TEMA_ID, TO_CHAR(FOLIO,'99') AS FOLIO, DESCRIPCION, ARCHIVO, NOMBRE" +
					" FROM CICLO_GRUPO_ARCHIVO" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND TEMA_ID = ?" +
					" AND FOLIO = TO_NUMBER(?,'99')");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, temaId);
			ps.setString(4, folio);		
			rs = ps.executeQuery();
		
			if(rs.next()){		
				mapeaReg(rs);		
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoArchivo|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
	}
	
	public boolean existeReg(Connection conn) throws SQLException{
		boolean ok 				= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CICLO_GRUPO_ARCHIVO" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND TEMA_ID = ?" +
					" AND FOLIO = TO_NUMBER(?,'99')");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, temaId);
			ps.setString(4, folio);
			rs= ps.executeQuery();
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchDocAlumno|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public String maximoReg(Connection conn, String cicloGrupoId, String cursoId, String temaId) throws SQLException{
		String maximo 			= "1";
		ResultSet rs			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(FOLIO)+1, 1) AS MAXIMO FROM CICLO_GRUPO_ARCHIVO" +
					" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
					" AND CURSO_ID = '"+cursoId+"'" +
					" AND TEMA_ID = '"+temaId+"'");
			rs = ps.executeQuery();
			if (rs.next())
				maximo = rs.getString("MAXIMO");
			
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchDocAlumno|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return maximo;
	}
	
	public int getCantidadOID(Connection conn, long oid) throws SQLException{
		int cantidad 			= 0;
		ResultSet rs			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(COUNT(*),0) AS CANTIDAD FROM CICLO_GRUPO_ARCHIVO WHERE ARCHIVO = "+oid+" ");
			rs = ps.executeQuery();
			if (rs.next())
				cantidad = rs.getInt("CANTIDAD");
			
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.getCantidadOID|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return cantidad;
	}
	
	public static int numArchivos(Connection conn, String cicloGrupoId, String cursoId, String temaId) throws SQLException{
		
		ResultSet rs			= null;
		PreparedStatement ps	= null;
		int numTareas			= 0;
		
		try{
			ps = conn.prepareStatement("SELECT COUNT(*) AS NUMARCHIVOS FROM CICLO_GRUPO_ARCHIVO " +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND TEMA_ID = ?");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, temaId);
			
			rs = ps.executeQuery();
			if (rs.next())
				numTareas = rs.getInt("NUMARCHIVOS");
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGpoArchivo|numArchivos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return numTareas;
	}
		
	
}
