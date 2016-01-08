package aca.alumno;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AlumMensaje {
	private String codigoId;
	private String folio;
	private String cicloGrupoId;
	private String cursoId;
	private String fecha;
	private String maestroId;
	private String padreId;
	private String comentario;
	private String leido;
	private String fromMaestro;
	private String fromPadre;
	
		
	public AlumMensaje(){
		codigoId		= "";
		folio			= "";
		cicloGrupoId	= "";
		cursoId			= "";
		fecha			= "";
		maestroId		= "";
		padreId			= "";
		comentario		= "";
		leido 			= "";
		fromMaestro		= "";
		fromPadre		= "";
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
	 * @return the maestroId
	 */
	public String getMaestroId() {
		return maestroId;
	}


	/**
	 * @param maestroId the maestroId to set
	 */
	public void setMaestroId(String maestroId) {
		this.maestroId = maestroId;
	}


	/**
	 * @return the padreId
	 */
	public String getPadreId() {
		return padreId;
	}


	/**
	 * @param padreId the padreId to set
	 */
	public void setPadreId(String padreId) {
		this.padreId = padreId;
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


	public String getLeido() {
		return leido;
	}


	public void setLeido(String leido) {
		this.leido = leido;
	}


	public String getFromMaestro() {
		return fromMaestro;
	}


	public void setFromMaestro(String fromMaestro) {
		this.fromMaestro = fromMaestro;
	}


	public String getFromPadre() {
		return fromPadre;
	}


	public void setFromPadre(String fromPadre) {
		this.fromPadre = fromPadre;
	}


	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO ALUM_MENSAJE" +
					" (CODIGO_ID, FOLIO, CICLO_GRUPO_ID, CURSO_ID,FECHA,MAESTRO_ID,PADRE_ID,COMENTARIO,LEIDO,FROM_MAESTRO,FROM_PADRE)" +
					" VALUES(?,TO_NUMBER(?,'99999'),?,?,TO_TIMESTAMP(?,'DD/MM/YYYY HH24:MI:SS'),?,?,?,?,?,?)");
			
			ps.setString(1, codigoId);
			ps.setString(2, folio);
			ps.setString(3, cicloGrupoId);
			ps.setString(4, cursoId);
			ps.setString(5, fecha);
			ps.setString(6, maestroId);
			ps.setString(7, padreId);
			ps.setString(8, comentario);
			ps.setString(9, leido);
			ps.setString(10, fromMaestro);
			ps.setString(11, fromPadre);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPadres|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE ALUM_MENSAJE" +					
					" SET CODIGO_ID = ?," +
					" CICLO_GRUPO_ID = ?," +
					" CURSO_ID = ?," +
					" FECHA = TO_DATE(?,'DD/MM/YYYY')," +
					" PADRE_ID = ?," +
					" COMENTARIO = ?, LEIDO = ?, FROM_MAESTRO = ?, FROM_PADRE = ? " +
					" WHERE MAESTRO_ID = ? " +
					" AND FOLIO = TO_NUMBER(?,'99999')");
			
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, fecha);
			ps.setString(5, padreId);
			ps.setString(6, comentario);
			ps.setString(7, leido);
			ps.setString(8, fromMaestro);
			ps.setString(9, fromPadre);
			ps.setString(10, maestroId);
			ps.setString(11, folio);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPadres|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateLeido(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE ALUM_MENSAJE" +					
					" SET LEIDO = ? " +
					" WHERE MAESTRO_ID = ? " +
					" AND FOLIO = TO_NUMBER(?,'99999')");
			
			ps.setString(1, leido);
			ps.setString(2, maestroId);
			ps.setString(3, folio);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPadres|updateLeido|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM ALUM_MENSAJE" +
					" WHERE MAESTRO_ID = ?" +
					" AND FOLIO = TO_NUMBER(?,'99999')");
			ps.setString(1, maestroId);
			ps.setString(2, folio);
			
			if ( ps.executeUpdate()!= -1){
				ok = true;
			}else{
				ok = false;
			}
		
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPadres|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId		= rs.getString("CODIGO_ID");
		folio			= rs.getString("FOLIO");
		cicloGrupoId	= rs.getString("CICLO_GRUPO_ID");
		cursoId			= rs.getString("CURSO_ID");
		fecha			= rs.getString("FECHA");
		maestroId		= rs.getString("MAESTRO_ID");
		padreId			= rs.getString("PADRE_ID");
		comentario		= rs.getString("COMENTARIO");
		leido 			= rs.getString("LEIDO");
		fromMaestro		= rs.getString("FROM_MAESTRO");
		fromPadre		= rs.getString("FROM_PADRE");

	}
	
	public void mapeaRegId(Connection con, String maestroId, String folio) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null;
		try{
			ps = con.prepareStatement("SELECT CODIGO_ID, FOLIO, CICLO_GRUPO_ID, CURSO_ID," +
					" TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, MAESTRO_ID, PADRE_ID, COMENTARIO, LEIDO, FROM_MAESTRO, FROM_PADRE " +				
					" FROM ALUM_MENSAJE" +
					" WHERE MAESTRO_ID = ?" +
					" AND FOLIO = TO_NUMBER(?,'99999')");
			
			ps.setString(1, maestroId);
			ps.setString(2, folio);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPadres|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM ALUM_MENSAJE" +
					" WHERE MAESTRO_ID = ?" +
					" AND FOLIO = TO_NUMBER(?,'99999') ");
			ps.setString(1, maestroId);
			ps.setString(2, folio);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public static String mensajesNoLeidosPorAlumno(Connection conn, String cicloGrupoId, String cursoId, String codigoId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String cantidad 		= "0";
		
		try{
			ps = conn.prepareStatement("SELECT COUNT(*) AS CANTIDAD FROM ALUM_MENSAJE "
					+ " WHERE CICLO_GRUPO_ID = ? "
					+ " AND CURSO_ID = ? "
					+ " AND FROM_PADRE = 'SI' "
					+ " AND (LEIDO != 'SI' OR LEIDO IS NULL) "
					+ " AND CODIGO_ID = ? ");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, codigoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				cantidad = rs.getString("CANTIDAD");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatReligion|mensajesNoLeidosPorAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return cantidad;
	}
	
	public static String mensajesNoLeidosPorMateria(Connection conn, String cicloGrupoId, String cursoId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String cantidad 		= "0";
		
		try{
			ps = conn.prepareStatement("SELECT COUNT(*) AS CANTIDAD FROM ALUM_MENSAJE "
					+ " WHERE CICLO_GRUPO_ID = ? "
					+ " AND CURSO_ID = ? "
					+ " AND FROM_PADRE = 'SI' "
					+ " AND "
					+ "		( SELECT COUNT(*) FROM KRDX_CURSO_ACT "
					+ "		  WHERE CODIGO_ID = ALUM_MENSAJE.CODIGO_ID "
					+ "       AND CICLO_GRUPO_ID = ALUM_MENSAJE.CICLO_GRUPO_ID"
					+ "		  AND CURSO_ID = ALUM_MENSAJE.CURSO_ID  ) > 0 "
					+ " AND (LEIDO != 'SI' OR LEIDO IS NULL) ");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				cantidad = rs.getString("CANTIDAD");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatReligion|mensajesNoLeidosPorMateria|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return cantidad;
	}
	
	public static String mensajesNoLeidosPorMateriaDelAlumno(Connection conn, String cicloGrupoId, String cursoId, String codigoId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String cantidad 		= "0";
		
		try{
			ps = conn.prepareStatement("SELECT COUNT(*) AS CANTIDAD FROM ALUM_MENSAJE "
					+ " WHERE CICLO_GRUPO_ID = ? "
					+ " AND CURSO_ID = ? "
					+ " AND FROM_MAESTRO = 'SI' "
					+ " AND (LEIDO != 'SI' OR LEIDO IS NULL)"
					+ " AND CODIGO_ID = ? ");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, codigoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				cantidad = rs.getString("CANTIDAD");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatReligion|mensajesNoLeidosPorMateria|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return cantidad;
	}
	
	
	public String maximoReg(Connection conn, String maestroId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(FOLIO)+1,'1') AS MAXIMO " +
					"FROM ALUM_MENSAJE WHERE MAESTRO_ID = ? ");
			
			ps.setString(1, maestroId);
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatReligion|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}

	
}

