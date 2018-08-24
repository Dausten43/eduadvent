/**
 * 
 */
package aca.alumno;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * @author Jose Torres
 *
 */
public class AlumPadres {
	private String codigoId;
	private String codigoPadre;
	private String codigoMadre;
	private String codigoTutor;
		
	public AlumPadres(){
		codigoId		= "";
		codigoPadre		= "";
		codigoMadre		= "";
		codigoTutor		= "";
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
	 * @return the codigoPadre
	 */
	public String getCodigoPadre() {
		return codigoPadre;
	}


	/**
	 * @param codigoPadre the codigoPadre to set
	 */
	public void setCodigoPadre(String codigoPadre) {
		this.codigoPadre = codigoPadre;
	}


	/**
	 * @return the codigoMadre
	 */
	public String getCodigoMadre() {
		return codigoMadre;
	}


	/**
	 * @param codigoMadre the codigoMadre to set
	 */
	public void setCodigoMadre(String codigoMadre) {
		this.codigoMadre = codigoMadre;
	}


	/**
	 * @return the tutor
	 */
	public String getCodigoTutor() {
		return codigoTutor;
	}


	/**
	 * @param tutor the tutor to set
	 */
	public void setCodigoTutor(String codigoTutor) {
		this.codigoTutor = codigoTutor;
	}


	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO ALUM_PADRES" +
					" (CODIGO_ID, CODIGO_PADRE, CODIGO_MADRE, CODIGO_TUTOR)" +
					" VALUES(?,?,?,?)");
			
			ps.setString(1, codigoId);
			ps.setString(2, codigoPadre);
			ps.setString(3, codigoMadre);
			ps.setString(4, codigoTutor);
			
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
			ps = conn.prepareStatement("UPDATE ALUM_PADRES" +					
					" SET CODIGO_PADRE = ?," +
					" CODIGO_MADRE = ?," +
					" CODIGO_TUTOR = ?" +
					" WHERE CODIGO_ID = ? ");
			
			ps.setString(1, codigoPadre);
			ps.setString(2, codigoMadre);
			ps.setString(3, codigoTutor);
			ps.setString(4, codigoId);
			
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
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM ALUM_PADRES" +
					" WHERE CODIGO_ID = ?");
			ps.setString(1, codigoId);
			
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
		codigoPadre		= rs.getString("CODIGO_PADRE");
		codigoMadre		= rs.getString("CODIGO_MADRE");
		codigoTutor		= rs.getString("CODIGO_TUTOR");
	}
	
	public void mapeaRegId(Connection con, String codigoId) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null;
		try{
			ps = con.prepareStatement("SELECT CODIGO_ID, CODIGO_PADRE, CODIGO_MADRE, CODIGO_TUTOR" +				
					" FROM ALUM_PADRES" +
					" WHERE CODIGO_ID = ?");
			
			ps.setString(1, codigoId);
			
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
			ps = conn.prepareStatement("SELECT * FROM ALUM_PADRES" +
					" WHERE CODIGO_ID = ?");
			ps.setString(1, codigoId);
			
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
	
	public String maximoReg(Connection conn, String escuelaId) throws SQLException{
 		
 		ResultSet 		rs		= null;
 		PreparedStatement ps	= null;
 		String maximo			= "";
 		
 		try{
 			
 			ps = conn.prepareStatement("SELECT COALESCE( TO_NUMBER(MAX( SUBSTR(CODIGO_ID,5,4) ),'9999')+1, 1) AS MAXIMO FROM EMP_PERSONAL" +
 					" WHERE SUBSTR(CODIGO_ID,1,4) = '"+escuelaId+"P'");
 					
 			rs = ps.executeQuery();
 			if (rs.next()){
 				maximo = String.valueOf( rs.getString("MAXIMO") );
 				switch(maximo.length()){
 					case 1: maximo = "000"+maximo; break;
 					case 2: maximo = "00"+ maximo; break; 					
 					case 3: maximo = "0"+  maximo; break;
 				}
 				maximo = escuelaId+"P"+maximo;
 			}else{
 				maximo = "0000000";
 			}			
 			
 		}catch(Exception ex){
 			System.out.println("Error - aca.alumno.AlumPadres|maximoReg|:"+ex);
 		}finally{
	 		if (rs!=null) rs.close();
	 		if (ps!=null) ps.close();
 		}
 		return maximo;
 	}
	
	public static boolean borraPadre(Connection conn, String padreId) throws SQLException{
 		
 		ResultSet 		rs		= null;
 		PreparedStatement ps	= null;
 		boolean ok			= false;
 		
 		try{
 			
 			ps = conn.prepareStatement("DELETE FROM ALUM_PADRES WHERE CODIGO_PADRE = ? OR CODIGO_MADRE = ? OR CODIGO_TUTOR = ?");
 			
 			ps.setString(1, padreId);
 			ps.setString(2, padreId);
 			ps.setString(3, padreId);
 					
 			if(ps.executeUpdate() > 0)
 				ok = true;
 			
 		}catch(Exception ex){
 			System.out.println("Error - aca.alumno.AlumPadres|borraPadre|:"+ex);
 		}finally{
	 		if (rs!=null) rs.close();
	 		if (ps!=null) ps.close();
 		}
 		
 		return ok;
 	}
	
	public static String getCorreo(Connection conn, String codigoId) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		String genero		= "x";
	
		try{
			comando = "SELECT EMAIL FROM " +
					"ALUM_PERSONAL WHERE CODIGO_ID IN " +
					" (SELECT CODIGO_ID FROM ALUM_PADRES WHERE CODIGO_PADRE = '"+codigoId+"'" +
					"  OR CODIGO_TUTOR = '"+codigoId+"' " +
					"  OR CODIGO_MADRE = '"+codigoId+"')";			
			rs = st.executeQuery(comando);
			if (rs.next()){
				genero = rs.getString("EMAIL");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getCorreo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return genero;
	}
	
	public static int numeroDeHijos(Connection conn, String padreId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		//String comando			= "";	//By Jonathan: Que alguien me explique que onda con esto.	
		int hijos			= 0;
		try{
			ps = conn.prepareStatement("SELECT COALESCE(COUNT(CODIGO_ID),0) AS TOTAL FROM ALUM_PADRES"
					+ " WHERE CODIGO_PADRE = ? OR CODIGO_MADRE = ? OR CODIGO_TUTOR = ?");
 			
 			ps.setString(1, padreId);
 			ps.setString(2, padreId);
 			ps.setString(3, padreId);					
			rs = ps.executeQuery(/*comando*/);
			if (rs.next()){
				hijos = rs.getInt("TOTAL");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|numeroDeHijos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();			
		}
		
		return hijos;
	}
}
