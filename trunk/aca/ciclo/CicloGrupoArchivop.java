/**
 * 
 */
package aca.ciclo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Blob;

/**
 * @author ifo
 *
 */
public class CicloGrupoArchivop {
	private String cicloGrupoId;
	private String folio;
	private String comentario;
	private String alumnos;
	private String nombre;
	private Blob archivo;
	private String fecha;
	
	public CicloGrupoArchivop(){
		cicloGrupoId	= "";
		folio			= "";
		comentario		= "";
		alumnos			= "";
		nombre			= "";
		archivo			= null;
		fecha			= "";
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
	 * @return the comentario
	 */
	public String getComentario() {
		return comentario;
	}

	/**
	 * @param comentario the comentario to set
	 */
	public void setComentario(String comentario) {
		this.comentario = comentario;
	}

	/**
	 * @return the alumnos
	 */
	public String getAlumnos() {
		return alumnos;
	}

	/**
	 * @param alumnos the alumnos to set
	 */
	public void setAlumnos(String alumnos) {
		this.alumnos = alumnos;
	}

	/**
	 * @return the nombre
	 */
	public String getNombre() {
		return nombre;
	}

	/**
	 * @param nombre the nombre to set
	 */
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	/**
	 * @return the archivo
	 */
	public Blob getArchivo() {
		return archivo;
	}

	/**
	 * @param archivo the archivo to set
	 */
	public void setArchivo(Blob archivo) {
		this.archivo = archivo;
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

	public boolean insertReg(Connection conn ) throws Exception{
		PreparedStatement ps 	= null;
		boolean ok 				= false;
		
		try{
			ps = conn.prepareStatement("INSERT INTO CICLO_GRUPO_ARCHIVOP"+
				"(CICLO_GRUPO_ID, FOLIO, COMENTARIO, ALUMNOS, NOMBRE, ARCHIVO, FECHA)"+
				" VALUES( ?, TO_NUMBER(?,'9999'), ?, ?, ?, ?, SYSDATE)");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, folio);			
			ps.setString(3, comentario);
			ps.setString(4, alumnos);
			ps.setString(5, nombre);
			ps.setBlob(6, archivo);
			
			if (ps.executeUpdate()== 1)
				ok = true;				
			else
				ok = false;		
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoArchivop|insertReg|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
	
	public boolean updateRegAlumnos(Connection conn ) throws Exception{
		PreparedStatement ps 	= null;		
		boolean ok 				= false;
		
		try{
			ps = conn.prepareStatement("UPDATE CICLO_GRUPO_ARCHIVOP"+
				" SET ALUMNOS = ?"+
				" WHERE CICLO_GRUPO_ID = ?"+
				" AND FOLIO = TO_NUMBER(?,'9999')");
			
			ps.setString(1, alumnos);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, folio);
			
			if (ps.executeUpdate()== 1)
				ok = true;	
			else
				ok = false;	
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoArchivop|updateReg|:"+ex);		
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws Exception{
		PreparedStatement ps 	= null;
		boolean ok 				= false;
		try{
			ps = conn.prepareStatement("DELETE FROM CICLO_GRUPO_ARCHIVOP"+
				" WHERE CICLO_GRUPO_ID = ?"+
				" AND FOLIO = TO_NUMBER(?,'9999')");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, folio);
			
			if (ps.executeUpdate()== 1)
				ok = true;
			else
				ok = false;		
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoArchivop|deleteReg|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		cicloGrupoId	= rs.getString("CICLO_GRUPO_ID");
		folio			= rs.getString("FOLIO");
		comentario		= rs.getString("COMENTARIO");
		alumnos			= rs.getString("ALUMNOS");
		nombre			= rs.getString("NOMBRE");
		archivo			= rs.getBlob("ARCHIVO");
		fecha			= rs.getString("FECHA");
	}
	
	
	public void mapeaRegId( Connection conn, String cicloGrupoId, String folio ) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = conn.prepareStatement("SELECT"+
				" CICLO_GRUPO_ID, FOLIO, COMENTARIO, ALUMNOS, NOMBRE, ARCHIVO, TO_CHAR(FECHA, 'DD/MM/YYYY HH24:MI:SS') AS FECHA"+
				" FROM CICLO_GRUPO_ARCHIVOP"+
				" WHERE CICLO_GRUPO_ID = ?"+
				" AND FOLIO = TO_NUMBER(?,'9999')");
				
			ps.setString(1, cicloGrupoId);
			ps.setString(2, folio);
			
			rs = ps.executeQuery();
			if (rs.next()){
				mapeaReg(rs);
			}
		
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoArchivop|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
	}

	public boolean existeReg(Connection conn) throws SQLException{
		
		PreparedStatement ps	= null;
		boolean 		ok 		= false;
		ResultSet 		rs		= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CICLO_GRUPO_ARCHIVOP"+
				" WHERE CICLO_GRUPO_ID = ?"+
				" AND FOLIO = TO_NUMBER(?,'9999')");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, folio);
			
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoArchivop|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public String maxReg(Connection conn, String cicloGrupoId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet 		rs		= null;
		String maximo			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT MAX(FOLIO)+1 AS MAXIMO FROM CICLO_GRUPO_ARCHIVOP"+
				" WHERE CICLO_GRUPO_ID = ?");
			
			ps.setString(1, cicloGrupoId);
			
			rs = ps.executeQuery();
			if (rs.next())
				maximo = rs.getString("MAXIMO")==null?"1":rs.getString("MAXIMO");
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoArchivop|maxReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return maximo;
	}
}