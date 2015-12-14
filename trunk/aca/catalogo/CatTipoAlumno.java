/**
 * 
 */
package aca.catalogo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 *
 */
public class CatTipoAlumno {
	private String escuelaId;
	private String tipoAlumnoId;
	private String nombre;
	private String estado;
	
	public CatTipoAlumno(){
		escuelaId		= "";
		tipoAlumnoId	= "";
		nombre			= "";
		estado			= "";
	}
	
	
	public String getEscuelaId() {
		return escuelaId;
	}
	public void setEscuelaId(String escuelaId) {
		this.escuelaId = escuelaId;
	}

	public String getTipoAlumnoId() {
		return tipoAlumnoId;
	}
	public void setTipoAlumnoId(String tipoAlumnoId) {
		this.tipoAlumnoId = tipoAlumnoId;
	}
	
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}

	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		escuelaId		= rs.getString("ESCUELA_ID");
		tipoAlumnoId	= rs.getString("TIPOALUMNO_ID");
		nombre			= rs.getString("NOMBRE");
		estado			= rs.getString("ESTADO");		
	}
	
	public void mapeaRegId(Connection con, String escuelaId, String tipoAlumnoId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT ESCUELA_ID, TIPOALUMNO_ID, NOMBRE, ESTADO" +
					" FROM CAT_TIPOALUMNO" +
					" WHERE ESCUELA_ID = ? AND TIPOALUMNO_ID = TO_NUMBER(?, '999')");
					
			ps.setString(1, escuelaId);
			ps.setString(2, tipoAlumnoId);
			ps.setString(3, nombre);
			ps.setString(4, estado);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipoAlumno|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
	}
	
	public static String getNombre(Connection con, String escuelaId, String tipoAlumnoId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		String nombreTipoAlumno = "";
		
		
		try{
			ps = con.prepareStatement("SELECT ESCUELA_ID, TIPOALUMNO_ID, NOMBRE, ESTADO" +
					" FROM CAT_TIPOALUMNO" +
					" WHERE ESCUELA_ID = ? AND TIPOALUMNO_ID = TO_NUMBER(?,'999)') ");
					
			ps.setString(1, escuelaId);
			ps.setString(2, tipoAlumnoId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				nombreTipoAlumno = rs.getString("NOMBRE");
					
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipoAlumno|getNombre|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		return nombreTipoAlumno;
	}
}
