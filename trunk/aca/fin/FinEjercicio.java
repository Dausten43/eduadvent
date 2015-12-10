package aca.fin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class FinEjercicio {
	
	private String ejercicioId;	
	private String escuelaId;
	private String year;
	private String fechaIni;
	private String fechaFin;
	
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
	
	/**
	 * @return the fechaIni
	 */
	public String getFechaIni() {
		return fechaIni;
	}
	/**
	 * @param fechaIni the fechaIni to set
	 */
	public void setFechaIni(String fechaIni) {
		this.fechaIni = fechaIni;
	}
	/**
	 * @return the fechaFin
	 */
	public String getFechaFin() {
		return fechaFin;
	}
	
	/**
	 * @param fechaFin the fechaFin to set
	 */
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}
	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "INSERT INTO FIN_EJERCICIO(EJERCICIO_ID, ESCUELA_ID, YEAR, FECHA_INI, FECHA_FIN)" +
                    " VALUES(?, ?, TO_NUMBER(?, '9999'), TO_DATE(?,'DD/MM/YYYY'), TO_DATE(?,'DD/MM/YYYY'))");
            
            ps.setString(1, ejercicioId);            
            ps.setString(2, escuelaId);
            ps.setString(3, year);
            ps.setString(4, fechaIni);
            ps.setString(5, fechaFin);
            
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
	
	 public boolean updateReg(Connection conn) throws SQLException {
	    	PreparedStatement ps = null;
	    	boolean ok = false;

	        try {
	           ps = conn.prepareStatement("UPDATE FIN_EJERCICIO"
	           		+ " SET FECHA_INI = TO_DATE(?,'DD/MM/YYYY'),"
	           		+ " FECHA_FIN = TO_DATE(?,'DD/MM/YYYY')"
	           		+ " WHERE EJERCICIO_ID = ?");
	            
	            ps.setString(1, fechaIni);
	            ps.setString(2, fechaFin);
	            ps.setString(3, ejercicioId);

	            if (ps.executeUpdate() == 1) {
	                ok = true;
	            } else {
	                ok = false;
	            }

	            
	        } catch (Exception ex) {
	            System.out.println("Error - aca.fin.FinEjercicio|updateReg|:" + ex);
	        }finally{
	        	if (ps != null) {
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
		fechaIni		= rs.getString("FECHA_INI");
		fechaFin		= rs.getString("FECHA_FIN");
    }

    public void mapeaRegId(Connection con, String ejercicioId) throws SQLException{
        ResultSet rs = null;
        PreparedStatement ps = null; 
        try{
	        ps = con.prepareStatement(
	                " SELECT EJERCICIO_ID, ESCUELA_ID, YEAR, TO_CHAR(FECHA_INI,'DD/MM/YYYY') AS FECHA_INI, TO_CHAR(FECHA_FIN,'DD/MM/YYYY') AS FECHA_FIN" +
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
    
    public static String getEjercicioActual(Connection conn, String escuelaId) throws SQLException {
    	
    	PreparedStatement ps 	= null;
        ResultSet rs 			= null;        
        String ejercicioId 		= escuelaId+"-"+String.valueOf(aca.util.Fecha.getYearNum());

        try {
            ps = conn.prepareStatement("SELECT EJERCICIO_ID FROM FIN_EJERCICIO WHERE ESCUELA_ID = ? AND NOW() BETWEEN FECHA_INI AND FECHA_FIN");
            ps.setString(1, escuelaId);
            
            rs = ps.executeQuery();
            if(rs.next()){
            	ejercicioId = rs.getString("EJERCICIO_ID");
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinEjercicio|getEjercicioActual|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return ejercicioId;
    }
    
}