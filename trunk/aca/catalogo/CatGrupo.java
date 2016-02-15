/**
 * 
 */
package aca.catalogo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Jose Torres
 *
 */
public class CatGrupo {
	private String folio;
	private String nivelId;
	private String grado;
	private String grupo;
	private String escuelaId;
	private String turno;
	
	public CatGrupo(){
		folio 		= "";
		nivelId		= "";
		grado		= "";
		grupo		= "";
		escuelaId	= "";
		turno		= "";
	}
	

	/**
	 * @return Returns the folio.
	 */
	public String getFolio() {
		return folio;
	}
	

	/**
	 * @param folio The folio to set.
	 */
	public void setFolio(String folio) {
		this.folio = folio;
	}
	

	/**
	 * @return Returns the grado.
	 */
	public String getGrado() {
		return grado;
	}
	

	/**
	 * @param grado The grado to set.
	 */
	public void setGrado(String grado) {
		this.grado = grado;
	}
	

	/**
	 * @return Returns the grupo.
	 */
	public String getGrupo() {
		return grupo;
	}
	

	/**
	 * @param grupo The grupo to set.
	 */
	public void setGrupo(String grupo) {
		this.grupo = grupo;
	}
	

	/**
	 * @return Returns the nivelId.
	 */
	public String getNivelId() {
		return nivelId;
	}


	/**
	 * @param nivelId The nivelId to set.
	 */
	public void setNivelId(String nivelId) {
		this.nivelId = nivelId;
	}	

	/**
	 * @return the escuelaId
	 */
	public String getEscuelaId() {
		return escuelaId;
	}


	/**
	 * @param escuelaId the escuelaId to set
	 */
	public void setEscuelaId(String escuelaId) {
		this.escuelaId = escuelaId;
	}


	public String getTurno() {
		return turno;
	}


	public void setTurno(String turno) {
		this.turno = turno;
	}


	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("INSERT INTO CAT_GRUPO " +
					"(FOLIO, NIVEL_ID, GRADO, GRUPO, ESCUELA_ID, TURNO) " +
					"VALUES(TO_NUMBER(?, '99999'), " +
					"TO_NUMBER(?, '99'), " +
					"TO_NUMBER(?, '99'),?,?,?)");
			
			ps.setString(1, folio);
			ps.setString(2, nivelId);
			ps.setString(3, grado);
			ps.setString(4, grupo);
			ps.setString(5, escuelaId);
			ps.setString(6, turno);
			
			if ( ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;
			}
			if (ps!=null) ps.close();
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatGrupo|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		
		try{
		  ps = conn.prepareStatement("UPDATE CAT_GRUPO " +
					" SET NIVEL_ID = TO_NUMBER(?,'99')," +
					" GRADO = TO_NUMBER(?, '99')," +
					" GRUPO = ?," +
					" ESCUELA_ID = ?, TURNO = ?"+
					" WHERE FOLIO = TO_NUMBER(?, '99999')");
			ps.setString(1, nivelId);
			ps.setString(2, grado);
			ps.setString(3, grupo);
			ps.setString(4, escuelaId);
			ps.setString(5, turno);
			ps.setString(6, folio);		
			
			if ( ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatGrupo|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps =  null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CAT_GRUPO" +
					" WHERE FOLIO = TO_NUMBER(?, '99999')");
			ps.setString(1, folio);
			
			if ( ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatGrupo|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		folio		= rs.getString("FOLIO");
		nivelId		= rs.getString("NIVEL_ID");
		grado		= rs.getString("GRADO");
		grupo		= rs.getString("GRUPO");
		escuelaId	= rs.getString("ESCUELA_ID");
		turno 		= rs.getString("TURNO");
	}
	
	public void mapeaRegId(Connection con, String folio) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT FOLIO, NIVEL_ID, GRADO, GRUPO, ESCUELA_ID, TURNO " +
					" FROM CAT_GRUPO" +
					" WHERE FOLIO = TO_NUMBER(?, '99999')");
			ps.setString(1, folio);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatGrupo|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
	}
	
	public boolean existeReg(Connection conn) throws SQLException{
	
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		boolean ok 				= false;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CAT_GRUPO" +
					" WHERE FOLIO = TO_NUMBER(?, '99999')");
			ps.setString(1, folio);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatGrupo|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean existeReg(Connection conn, String escuelaId, String nivel, String grado, String grupo) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		boolean ok 				= false;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CAT_GRUPO" +
					" WHERE ESCUELA_ID = ? AND NIVEL_ID = TO_NUMBER(?, '99') AND GRADO = TO_NUMBER(?, '99') AND GRUPO = ?");
			ps.setString(1, escuelaId);
			ps.setString(2, nivel);
			ps.setString(3, grado);
			ps.setString(4, grupo);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatGrupo|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public static boolean existeNivel(Connection conn, String escuelaId, String nivelId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		boolean ok 				= false;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CAT_GRUPO" +
					" WHERE ESCUELA_ID = ? AND NIVEL_ID = TO_NUMBER(?, '99') ");
			ps.setString(1, escuelaId);
			ps.setString(2, nivelId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatGrupo|existeNivel|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public String getFolio(Connection conn, String escuelaId, String nivel, String grado, String grupo) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String folio			= "0";
		
		try{
			ps = conn.prepareStatement("SELECT FOLIO FROM CAT_GRUPO" +
					" WHERE ESCUELA_ID = ? AND NIVEL_ID = TO_NUMBER(?, '99') AND GRADO = TO_NUMBER(?, '99') AND GRUPO = ? ");
			ps.setString(1, escuelaId);
			ps.setString(2, nivel);
			ps.setString(3, grado);
			ps.setString(4, grupo);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				folio = rs.getString("FOLIO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatGrupo|getFolio|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return folio;
	}
	
	public String maximoReg(Connection conn) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(FOLIO)+1,'1') AS MAXIMO FROM CAT_GRUPO");
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatGrupo|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}		
	
}