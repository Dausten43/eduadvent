/**
 * 
 */
package aca.catalogo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Elifo
 *
 */
public class CatTipocurso {
	private String tipocursoId;
	private String tipocursoNombre;
	
	public CatTipocurso(){
		tipocursoId		= "";
		tipocursoNombre	= "";
	}

	/**
	 * @return the tipocursoId
	 */
	public String getTipocursoId() {
		return tipocursoId;
	}

	/**
	 * @param tipocursoId the tipocursoId to set
	 */
	public void setTipocursoId(String tipocursoId) {
		this.tipocursoId = tipocursoId;
	}

	/**
	 * @return the tipocursoNombre
	 */
	public String getTipocursoNombre() {
		return tipocursoNombre;
	}

	/**
	 * @param tipocursoNombre the tipocursoNombre to set
	 */
	public void setTipocursoNombre(String tipocursoNombre) {
		this.tipocursoNombre = tipocursoNombre;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		tipocursoId		= rs.getString("TIPOCURSO_ID");
		tipocursoNombre	= rs.getString("TIPOCURSO_NOMBRE");
	}
	
	public void mapeaRegId(Connection con, String tipocalId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT TIPOCURSO_ID, TIPOCURSO_NOMBRE" +
					" FROM CAT_TIPOCURSO" +
					" WHERE TIPOCURSO_ID = TO_NUMBER(?, '99')");
					
			ps.setString(1, tipocursoId);			
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipoCurso|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
	}
	
	public static String getNombre(Connection con, String tipocursoId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		String nombreCorto = "";
		
		try{
			ps = con.prepareStatement("SELECT TIPOCURSO_ID, TIPOCURSO_NOMBRE" +
					" FROM CAT_TIPOCURSO" +
					" WHERE TIPOCURSO_ID = TO_NUMBER(?, '99')");
					
			ps.setString(1, tipocursoId);			
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				nombreCorto = rs.getString("TIPOCURSO_NOMBRE");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipoCurso|getNombre|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		return nombreCorto;
	}
}
