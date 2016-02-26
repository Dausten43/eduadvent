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
public class CatAsociacion {
	private String asociacionId;
	private String asociacionNombre;
	private String unionId;
	private String fondoId;
	private String asociacionNombreCorto;
	
	public CatAsociacion(){
		asociacionId			= "";
		asociacionNombre		= "";
		unionId 				= "";
		fondoId 				= "";
		asociacionNombreCorto 	= "";
		
	}
	
	public String getAsociacionId() {
		return asociacionId;
	}

	public void setAsociacionId(String asociacionId) {
		this.asociacionId = asociacionId;
	}

	public String getAsociacionNombre() {
		return asociacionNombre;
	}

	public void setAsociacionNombre(String asociacionNombre) {
		this.asociacionNombre = asociacionNombre;
	}	

	/**
	 * @return the union
	 */
	public String getUnionId() {
		return unionId;
	}

	/**
	 * @param union the union to set
	 */
	public void setUnionId(String unionId) {
		this.unionId = unionId;
	}
	
	public String getFondoId() {
		return fondoId;
	}

	public void setFondoId(String fondoId) {
		this.fondoId = fondoId;
	}
	
	public String getAsociacionNombreCorto() {
		return asociacionNombreCorto;
	}


	public void setAsociacionNombreCorto(String asociacionNombreCorto) {
		this.asociacionNombreCorto = asociacionNombreCorto;
	}
	
	
	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO CAT_ASOCIACION" +
					" (ASOCIACION_ID, ASOCIACION_NOMBRE, UNION_ID, FONDO_ID, ASOCIACION_CORTO)" +
					" VALUES(TO_NUMBER(?, '99'), ?, TO_NUMBER(?,'99'), ?,?)");
							
			ps.setString(1, asociacionId);
			ps.setString(2, asociacionNombre);			
			ps.setString(3, unionId);
			ps.setString(4, fondoId);
			ps.setString(5, asociacionNombreCorto);
						
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAsociacion|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		
		try{
			ps = conn.prepareStatement("UPDATE CAT_ASOCIACION" +
					" SET ASOCIACION_NOMBRE = ?, UNION_ID = TO_NUMBER(?, '99'), FONDO_ID = ?, ASOCIACION_CORTO = ? " +
					" WHERE ASOCIACION_ID = TO_NUMBER(?, '99')");
			
			ps.setString(1, asociacionNombre);					
			ps.setString(2, unionId);
			ps.setString(3, fondoId);
			ps.setString(4, asociacionNombreCorto);	
			ps.setString(5, asociacionId);
				
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAsociacion|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CAT_ASOCIACION" +
					" WHERE ASOCIACION_ID = TO_NUMBER(?, '99')");
			ps.setString(1, asociacionId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAsociacion|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		asociacionId	      = rs.getString("ASOCIACION_ID");
		asociacionNombre	  = rs.getString("ASOCIACION_NOMBRE");
		unionId				  = rs.getString("UNION_ID");	
		fondoId				  = rs.getString("FONDO_ID");
		asociacionNombreCorto = rs.getString("ASOCIACION_CORTO");
	}
	
	public void mapeaRegId(Connection con, String asociacionId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT ASOCIACION_ID, ASOCIACION_NOMBRE, UNION_ID, FONDO_ID, ASOCIACION_CORTO " +
					" FROM CAT_ASOCIACION WHERE ASOCIACION_ID = TO_NUMBER(?, '99') ");
			ps.setString(1, asociacionId);
			
			rs = ps.executeQuery();			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAsociacion|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CAT_ASOCIACION WHERE ASOCIACION_ID = TO_NUMBER(?, '99') ");
			ps.setString(1, asociacionId);
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAsociacion|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public String maximoReg(Connection conn) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(ASOCIACION_ID)+1,'1') AS MAXIMO FROM CAT_ASOCIACION");
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAsociacion|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
	
	public static String getNombre(Connection conn, String asociacionId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nombre			= "X";		
		
		try{
			ps = conn.prepareStatement("SELECT ASOCIACION_NOMBRE FROM CAT_ASOCIACION WHERE ASOCIACION_ID = TO_NUMBER(?,'99') ");
			ps.setString(1, asociacionId);
			rs= ps.executeQuery();		
			if(rs.next()){
				nombre = rs.getString("ASOCIACION_NOMBRE");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAsociacion|getNombre|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return nombre;
	}
	
	public static String getUnionId(Connection conn, String asociacionId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String union			= "0";
		
		try{
			ps = conn.prepareStatement("SELECT UNION_ID FROM CAT_ASOCIACION WHERE ASOCIACION_ID = TO_NUMBER(?,'99')");
			ps.setString(1, asociacionId);
			rs= ps.executeQuery();		
			if(rs.next()){
				union = rs.getString("UNION_ID");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAsociacion|getUnionId|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return union;
	}
	
	public static String getUnionEscuela(Connection conn, String escuelaId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String union			= "0";
		
		try{
			ps = conn.prepareStatement("SELECT UNION_ID FROM CAT_ASOCIACION WHERE ASOCIACION_ID = (SELECT ASOCIACION_ID FROM CAT_ESCUELA WHERE ESCUELA_ID = ?)");
			ps.setString(1, escuelaId);
			rs= ps.executeQuery();		
			if(rs.next()){
				union = rs.getString("UNION_ID");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAsociacion|getUnionEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return union;
	}
	
	public static String getFondoIdEscuela(Connection conn, String escuelaId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String fondo			= "0";
		
		try{
			ps = conn.prepareStatement("SELECT FONDO_ID FROM CAT_ASOCIACION WHERE ASOCIACION_ID = (SELECT ASOCIACION_ID FROM CAT_ESCUELA WHERE ESCUELA_ID = ?)");
			ps.setString(1, escuelaId);
			rs= ps.executeQuery();		
			if(rs.next()){
				fondo = rs.getString("FONDO_ID");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAsociacion|getFondoIdEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return fondo;
	}
	
	public static String getAsociacionNombreCorto(Connection conn, String escuelaId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nombreCorto			= "-";
		
		try{
			ps = conn.prepareStatement("SELECT ASOCIACION_CORTO FROM CAT_ASOCIACION WHERE ASOCIACION_ID = (SELECT ASOCIACION_ID FROM CAT_ESCUELA WHERE ESCUELA_ID = ?)");
			ps.setString(1, escuelaId);
			rs= ps.executeQuery();		
			if(rs.next()){
				nombreCorto = rs.getString("ASOCIACION_CORTO");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAsociacion|getAsociacionNombreCorto|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return nombreCorto;
	}
	
	public static String getAsociacionNombre(Connection conn, String escuelaId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nombreCorto			= "-";
		
		try{
			ps = conn.prepareStatement("SELECT ASOCIACION_NOMBRE FROM CAT_ASOCIACION WHERE ASOCIACION_ID = (SELECT ASOCIACION_ID FROM CAT_ESCUELA WHERE ESCUELA_ID = ?)");
			ps.setString(1, escuelaId);
			rs= ps.executeQuery();		
			if(rs.next()){
				nombreCorto = rs.getString("ASOCIACION_NOMBRE");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAsociacion|getAsociacionNombreCorto|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return nombreCorto;
	}


	
}
