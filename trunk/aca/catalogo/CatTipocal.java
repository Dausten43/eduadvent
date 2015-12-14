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
public class CatTipocal {
	private String tipocalId;
	private String tipocalNombre;
	private String tipocalCorto;
	
	public CatTipocal(){
		tipocalId		= "";
		tipocalNombre	= "";
		tipocalCorto	= "";
	}
	
	/**
	 * @return the tipocalCorto
	 */
	public String getTipocalCorto() {
		return tipocalCorto;
	}
	
	/**
	 * @param tipocalCorto the tipocalCorto to set
	 */
	public void setTipocalCorto(String tipocalCorto) {
		this.tipocalCorto = tipocalCorto;
	}
	
	/**
	 * @return the tipocalId
	 */
	public String getTipocalId() {
		return tipocalId;
	}
	
	/**
	 * @param tipocalId the tipocalId to set
	 */
	public void setTipocalId(String tipocalId) {
		this.tipocalId = tipocalId;
	}
	
	/**
	 * @return the tipocalNombre
	 */
	public String getTipocalNombre() {
		return tipocalNombre;
	}
	
	/**
	 * @param tipocalNombre the tipocalNombre to set
	 */
	public void setTipocalNombre(String tipocalNombre) {
		this.tipocalNombre = tipocalNombre;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		tipocalId		= rs.getString("TIPOCAL_ID");
		tipocalNombre	= rs.getString("TIPOCAL_NOMBRE");
		tipocalCorto	= rs.getString("TIPOCAL_CORTO");
	}
	
	public void mapeaRegId(Connection con, String tipocalId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT TIPOCAL_ID, TIPOCAL_NOMBRE, TIPOCAL_CORTO" +
					" FROM CAT_TIPOCAL" +
					" WHERE TIPOCAL_ID = TO_NUMBER(?, '99')");
					
			ps.setString(1, tipocalId);			
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipocal|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
	}
	
	public static String getNombreCorto(Connection con, String tipocalId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		String nombreCorto = "";
		try{
			ps = con.prepareStatement("SELECT TIPOCAL_CORTO" +
					" FROM CAT_TIPOCAL" +
					" WHERE TIPOCAL_ID = TO_NUMBER(?, '99')");				
			ps.setString(1, tipocalId);		
			
			rs = ps.executeQuery();		
			if(rs.next()){
				nombreCorto = rs.getString("TIPOCAL_CORTO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipoCal|getNombreCorto|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return nombreCorto;
	}
	
	public static String getNombre(Connection con, String tipocalId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		String nombreCorto = "";
		try{
			ps = con.prepareStatement("SELECT TIPOCAL_NOMBRE" +
					" FROM CAT_TIPOCAL" +
					" WHERE TIPOCAL_ID = TO_NUMBER(?, '99')");				
			ps.setString(1, tipocalId);		
			
			rs = ps.executeQuery();		
			if(rs.next()){
				nombreCorto = rs.getString("TIPOCAL_NOMBRE");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipoCal|getNombre|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return nombreCorto;
	}
}
