package aca.fin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class FinEjercicio {
	
	private String ejercicioId;	
	private String escuelaId;
	private String year;
	
	public String getEjercicioId() {
		return ejercicioId;
	}
	public void setEjercicioId(String ejercicioId) {
		this.ejercicioId = ejercicioId;
	}
	
	public String getEscuelaId() {
		return escuelaId;
	}
	public void setEscuelaId(String escuelaId) {
		this.escuelaId = escuelaId;
	}	
	
	/**
	 * @return the year
	 */
	public String getYear() {
		return year;
	}
	/**
	 * @param year the year to set
	 */
	public void setYear(String year) {
		this.year = year;
	}
	
	
	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "INSERT INTO FIN_EJERCICIO(EJERCICIO_ID, ESCUELA_ID, YEAR)" +
                    " VALUES(?, ?, TO_NUMBER(?, '9999'))");
            
            ps.setString(1, ejercicioId);            
            ps.setString(2, escuelaId);
            ps.setString(3, year);
            
            if(ps.executeUpdate()==1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinEjercicio|insertReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }	
	
	public boolean deleteReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try {
            ps = conn.prepareStatement(
                    " DELETE FROM FIN_EJERCICIO WHERE EJERCICIO_ID = ? ");
            
            ps.setString(1, ejercicioId);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinEjercicio|deleteReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }
	
	public void mapeaReg(ResultSet rs) throws SQLException {
        ejercicioId		= rs.getString("EJERCICIO_ID");		
		escuelaId   	= rs.getString("ESCUELA_ID");
		year   			= rs.getString("YEAR");
    }

    public void mapeaRegId(Connection con, String ejercicioId) throws SQLException{
        ResultSet rs = null;
        PreparedStatement ps = null; 
        try{
	        ps = con.prepareStatement(
	                " SELECT EJERCICIO_ID, ESCUELA_ID, YEAR" +
	                " FROM FIN_EJERCICIO" +
	                " WHERE EJERCICIO_ID = ?");
	        ps.setString(1, ejercicioId);	        
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.fin.FinEjercicio|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
    }
	
    public boolean existeReg(Connection conn) throws SQLException {
        boolean ok = false;
        ResultSet rs = null;
        PreparedStatement ps = null;

        try {
            ps = conn.prepareStatement("SELECT * FROM FIN_EJERCICIO WHERE EJERCICIO_ID = ?");
	        ps.setString(1, ejercicioId);	       
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinEjercicio|existeReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return ok;
    }
    
    public static boolean existeEjercicio(Connection conn, String ejercicioId) throws SQLException {
        boolean ok = false;
        ResultSet rs = null;
        PreparedStatement ps = null;

        try {
            ps = conn.prepareStatement("SELECT * FROM FIN_EJERCICIO WHERE EJERCICIO_ID = '"+ejercicioId+"'");
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinEjercicio|existeEjercicio|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return ok;
    }
    
}