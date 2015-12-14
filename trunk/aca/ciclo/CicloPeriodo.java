/**
 * 
 */
package aca.ciclo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author elifo
 *
 */
public class CicloPeriodo {
	private String cicloId;
	private String periodoId;
	private String periodoNombre;
	private String fInicio;
	private String fFinal;
	
	public CicloPeriodo(){
		cicloId			= "";
		periodoId		= "0";
		periodoNombre	= "";
		fInicio			= "";
		fFinal			= "";
	}

	/**
	 * @return the cicloId
	 */
	public String getCicloId() {
		return cicloId;
	}

	/**
	 * @param cicloId the cicloId to set
	 */
	public void setCicloId(String cicloId) {
		this.cicloId = cicloId;
	}

	/**
	 * @return the fFinal
	 */
	public String getFFinal() {
		return fFinal;
	}

	/**
	 * @param final1 the fFinal to set
	 */
	public void setFFinal(String final1) {
		fFinal = final1;
	}

	/**
	 * @return the fInicio
	 */
	public String getFInicio() {
		return fInicio;
	}

	/**
	 * @param inicio the fInicio to set
	 */
	public void setFInicio(String inicio) {
		fInicio = inicio;
	}

	/**
	 * @return the periodoId
	 */
	public String getPeriodoId() {
		return periodoId;
	}

	/**
	 * @param periodoId the periodoId to set
	 */
	public void setPeriodoId(String periodoId) {
		this.periodoId = periodoId;
	}

	/**
	 * @return the periodoNombre
	 */
	public String getPeriodoNombre() {
		return periodoNombre;
	}

	/**
	 * @param periodoNombre the periodoNombre to set
	 */
	public void setPeriodoNombre(String periodoNombre) {
		this.periodoNombre = periodoNombre;
	}
	
	public boolean insertReg(Connection conn) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;

        try{
            ps = conn.prepareStatement(
                    "INSERT INTO CICLO_PERIODO(CICLO_ID, PERIODO_ID, PERIODO_NOMBRE, F_INICIO, F_FINAL)" +
                    " VALUES(?, TO_NUMBER(?, '99'), ?, TO_DATE(?, 'DD/MM/YYYY'), TO_DATE(?, 'DD/MM/YYYY'))");
            
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, periodoNombre);
            ps.setString(4, fInicio);
            ps.setString(5, fFinal);

            if(ps.executeUpdate() == 1){
                ok = true;
            }

            
        }catch (Exception ex){
            System.out.println("Error - aca.ciclo.CicloPeriodo|insertReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }

    public boolean updateReg(Connection conn) throws SQLException{
    	PreparedStatement ps = null;
    	boolean ok = false;

        try{
            ps = conn.prepareStatement(
                    "UPDATE CICLO_PERIODO" +
                    " SET PERIODO_NOMBRE = ?," +
                    " F_INICIO = TO_DATE(?, 'DD/MM/YYYY')," +
                    " F_FINAL = TO_DATE(?, 'DD/MM/YYYY')" +
                    " WHERE CICLO_ID = ?" +
                    " AND PERIODO_ID = TO_NUMBER(?, '99')");
            
            ps.setString(1, periodoNombre);
            ps.setString(2, fInicio);
            ps.setString(3, fFinal);
            ps.setString(4, cicloId);
            ps.setString(5, periodoId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }

            
        }catch (Exception ex){
            System.out.println("Error - aca.ciclo.CicloPeriodo|updateReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }

    public boolean deleteReg(Connection conn) throws SQLException{
    	PreparedStatement ps = null;
    	boolean ok = false;

        try {
            ps = conn.prepareStatement(
                    "DELETE FROM CICLO_PERIODO" +
                    " WHERE CICLO_ID = ?" +
                    " AND PERIODO_ID = TO_NUMBER(?, '99')");
            
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }

            
        }catch (Exception ex){
            System.out.println("Error - aca.ciclo.CicloPeriodo|deleteReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {
        cicloId			= rs.getString("CICLO_ID");
		periodoId		= rs.getString("PERIODO_ID");
		periodoNombre	= rs.getString("PERIODO_NOMBRE");
		fInicio			= rs.getString("F_INICIO");
		fFinal			= rs.getString("F_FINAL");
    }

    public void mapeaRegId(Connection con, String cicloId, String periodoId) throws SQLException{
    	PreparedStatement ps = null;
    	ResultSet rs = null;
        try{
	    	ps = con.prepareStatement(
	                "SELECT CICLO_ID, PERIODO_ID, PERIODO_NOMBRE," +
	                " TO_CHAR(F_INICIO, 'DD/MM/YYYY') AS F_INICIO," +
	                " TO_CHAR(F_FINAL, 'DD/MM/YYYY') AS F_FINAL" +
	                " FROM CICLO_PERIODO" +
	                " WHERE CICLO_ID = ?" +
	                " AND PERIODO_ID = TO_NUMBER(?, '99')");
	        
	        ps.setString(1, cicloId);
	        ps.setString(2, periodoId);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloPeriodo|existeReg|:"+ex);
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
            ps = conn.prepareStatement("SELECT * FROM CICLO_PERIODO" +
                    " WHERE CICLO_ID = ?" +
                    " AND PERIODO_ID = TO_NUMBER(?, '99')");
            
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.ciclo.CicloPeriodo|existeReg|:" +ex);
        }finally{
        
        	if(rs != null){
                rs.close();
            }

            if(ps != null){
                ps.close();
            }

        }   
        return ok;
    }
    
    public String siguientePeriodo(Connection conn, String cicloId) throws SQLException {
        String maximo 			= "1";
        ResultSet rs 			= null;
        PreparedStatement ps 	= null;

        try {
            ps = conn.prepareStatement("SELECT COALESCE(MAX(PERIODO_ID)+1, 1) AS MAXIMO FROM CICLO_PERIODO" +
                    " WHERE CICLO_ID = ?");
            
            ps.setString(1, cicloId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                maximo = rs.getString("MAXIMO");
            }else{
            	maximo = "1";
            }
        }catch(Exception ex){
            System.out.println("Error - aca.ciclo.CicloPeriodo|siguientePeriodo|:" +ex);
        }finally{
        
        	if(rs != null){
                rs.close();
            }

            if(ps != null){
                ps.close();
            }

        }
        
        return maximo;
    }
    
    public static boolean tieneDatos(Connection conn, String cicloId, String periodoId) throws SQLException {
        boolean ok	 			= false;
        ResultSet rs1 			= null;
        PreparedStatement ps1 	= null;
        ResultSet rs2 			= null;
        PreparedStatement ps2 	= null;

        try {
            ps1 = conn.prepareStatement("SELECT * FROM FIN_COSTO" +
                    " WHERE CICLO_ID = ?" +
                    " AND PERIODO_ID = TO_NUMBER(?, '99')");
            
            ps1.setString(1, cicloId);
            ps1.setString(2, periodoId);
            
            rs1 = ps1.executeQuery();
            if(rs1.next()){
            	ps2 = conn.prepareStatement("SELECT * FROM FIN_PAGO" +
                        " WHERE CICLO_ID = ?" +
                        " AND PERIODO_ID = TO_NUMBER(?, '99')");
                
                ps2.setString(1, cicloId);
                ps2.setString(2, periodoId);
                
                rs2 = ps2.executeQuery();
                if(rs2.next()){
                    ok = true;
                }
            }
        }catch(Exception ex){
            System.out.println("Error - aca.ciclo.CicloPeriodo|tieneDatos|:" +ex);
        }finally{
        
        	if(rs1 != null){
                rs1.close();
            }
            if(ps1 != null){
                ps1.close();
            }
            
            if(rs2 != null){
                rs2.close();
            }
            if(ps2 != null){
                ps2.close();
            }

        }
        return ok;
    }
    
    public static String periodoActual(Connection conn, String cicloId) throws SQLException {
    	PreparedStatement ps 	= null;
        ResultSet rs 			= null;
        String periodoId		= "0";
        
        try {
            ps = conn.prepareStatement("SELECT COALESCE(PERIODO_ID,'0') AS PERIODO FROM CICLO_PERIODO" +            		
                    " WHERE CICLO_ID = ?" +
                    " AND NOW() BETWEEN F_INICIO AND F_FINAL"); 
            ps.setString(1, cicloId);            
            
            rs = ps.executeQuery();
            if(rs.next()){
            	periodoId = rs.getString("PERIODO");
            }
        }catch(Exception ex){
            System.out.println("Error - aca.ciclo.CicloPeriodo|tieneDatos|:" +ex);
        }finally{        
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }

                
        return periodoId;
    }
    
    public static String periodoNombre(Connection conn, String cicloId, String periodoId) throws SQLException {
    	PreparedStatement ps 	= null;
        ResultSet rs 			= null;
        String nombre			= "x";
        
        try {
            ps = conn.prepareStatement("SELECT PERIODO_NOMBRE FROM CICLO_PERIODO" + 		
                    " WHERE CICLO_ID = ?" +
                    " AND PERIODO_ID = TO_NUMBER(?, '99')");            
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            
            rs = ps.executeQuery();
            if(rs.next()){
            	nombre = rs.getString("PERIODO_NOMBRE");
            }
        }catch(Exception ex){
            System.out.println("Error - aca.ciclo.CicloPeriodo|periodoNombre|:" +ex);
        }finally{
        
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        return nombre;
    }
}
