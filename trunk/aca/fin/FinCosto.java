/**
 * 
 */
package aca.fin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author JoseTorres
 *
 */
public class FinCosto {	
	private String cicloId;
	private String costoId;
	private String periodoId;
	private String planId;
	private String cuentaId;
	private String clasFinId;
	private String fecha; 
	private String importe;
	
	public FinCosto(){
		costoId		= "";
		cicloId		= "";
		periodoId	= "";
		planId		= "";
		clasFinId	= "";
		fecha		= "";
		cuentaId	= "";
		importe		= "";
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
	 * @return the costoId
	 */
	public String getCostoId() {
		return costoId;
	}

	/**
	 * @param costoId the costoId to set
	 */
	public void setCostoId(String costoId) {
		this.costoId = costoId;
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
	 * @return the planId
	 */
	public String getPlanId() {
		return planId;
	}

	/**
	 * @param planId the planId to set
	 */
	public void setPlanId(String planId) {
		this.planId = planId;
	}
	
	
	/**
	 * @return the clasFinId
	 */
	public String getClasFinId() {
		return clasFinId;
	}


	/**
	 * @param clasFinId the clasFinId to set
	 */
	public void setClasFinId(String clasFinId) {
		this.clasFinId = clasFinId;
	}	

	/**
	 * @return the importe
	 */
	public String getImporte() {
		return importe;
	}


	/**
	 * @param importe the importe to set
	 */
	public void setImporte(String importe) {
		this.importe = importe;
	}
	

	/**
	 * @return the cuentaId
	 */
	public String getCuentaId() {
		return cuentaId;
	}

	/**
	 * @param cuentaId the cuentaId to set
	 */
	public void setCuentaId(String cuentaId) {
		this.cuentaId = cuentaId;
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
	

	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "INSERT INTO FIN_COSTO( CICLO_ID, COSTO_ID, PERIODO_ID, PLAN_ID, CLASFIN_ID, CUENTA_ID, FECHA, IMPORTE )" +
                    " VALUES(?," +
                    " TO_NUMBER(?, '999')," +
                    " TO_NUMBER(?, '99'), ?," +
                    " TO_NUMBER(?,'99'), ?," +
                    " TO_DATE(?,'DD/MM/YYYY')," +
                    " TO_NUMBER(?, '99999.99') )");
            
            ps.setString(1, cicloId);
            ps.setString(2, costoId);
            ps.setString(3, periodoId);
            ps.setString(4, planId);
            ps.setString(5, clasFinId);
            ps.setString(6, cuentaId);
            ps.setString(7, fecha);
            ps.setString(8, importe);

            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinCosto|insertReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }

    public boolean updateReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "UPDATE FIN_COSTO" +
                    " SET PERIODO_ID = TO_NUMBER(?, '99')," +
                    " PLAN_ID = ?," +
                    " CLASFIN_ID = TO_NUMBER(?,'99')," +
                    " CUENTA_ID = ?," +
                    " FECHA = TO_DATE(?,'DD/MM/YYYY')," +
                    " IMPORTE = TO_NUMBER(?, '99999.99')" +
                    " WHERE CICLO_ID = ? " +
                    " AND COSTO_ID = TO_NUMBER(?, '999')");
            
            ps.setString(1, periodoId);
            ps.setString(2, planId);
            ps.setString(3, clasFinId);
            ps.setString(4, cuentaId);
            ps.setString(5, fecha);       
            ps.setString(6, importe);
            ps.setString(7, cicloId);
            ps.setString(8, costoId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinCosto|updateReg|:" + ex);
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
            ps = conn.prepareStatement("DELETE FROM FIN_COSTO WHERE CICLO_ID = ? AND COSTO_ID = TO_NUMBER(?, '999')");            
            ps.setString(1, cicloId);
            ps.setString(2, costoId);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }
            
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinCosto|deleteReg|:" + ex);
        }finally{
            if(ps != null) ps.close();
        }
        
        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {        
		cicloId		= rs.getString("CICLO_ID");
		costoId		= rs.getString("COSTO_ID");
		periodoId	= rs.getString("PERIODO_ID");
		planId		= rs.getString("PLAN_ID");
		clasFinId	= rs.getString("CLASFIN_ID");
		cuentaId	= rs.getString("CUENTA_ID");
		fecha		= rs.getString("FECHA");
		importe		= rs.getString("IMPORTE");
    }

    public void mapeaRegId(Connection con, String cicloId, String costoId) throws SQLException{
        ResultSet rs = null;
        PreparedStatement ps = null; 
        try{
	        ps = con.prepareStatement(
	                "SELECT COSTO_ID, CICLO_ID, PERIODO_ID, PLAN_ID," +
	                " CLASFIN_ID, CUENTA_ID, FECHA, IMPORTE " +
	                " FROM FIN_COSTO" +
	                " WHERE CICLO_ID = ? " +
	                " AND COSTO_ID = TO_NUMBER(?, '999')");
	        
	        ps.setString(1, cicloId);
	        ps.setString(2, costoId);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.fin.FinCosto|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
        
    }
    
    public void mapeaRegId(Connection con, String cicloId, String periodoId, String planId, String clasfinId) throws SQLException{
        ResultSet rs = null;
        PreparedStatement ps = null; 
        try{
	        ps = con.prepareStatement(
	                "SELECT COSTO_ID, CICLO_ID, PERIODO_ID, PLAN_ID, CLASFIN_ID, CUENTA_ID, FECHA, IMPORTE" +
	                " FROM FIN_COSTO" +
	                " WHERE CICLO_ID = ? " +
	                " AND PERIODO_ID = TO_NUMBER(?, '99')" +
	        		" AND PLAN_ID = ?" +
	        		" AND CLASFIN_ID = TO_NUMBER(?, '99')");
	        ps.setString(1, cicloId);
	        ps.setString(2, periodoId);
	        ps.setString(3, planId);
	        ps.setString(4, clasfinId);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.fin.FinCosto|mapeaRegId|:"+ex);
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
            ps = conn.prepareStatement("SELECT * FROM FIN_COSTO WHERE CICLO_ID = ? AND COSTO_ID = TO_NUMBER(?, '999')");
            ps.setString(1, cicloId);
            ps.setString(2, costoId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCosto|existeReg|:" +ex);
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
    
    public boolean existeCuenta(Connection conn) throws SQLException {
        boolean ok = false;
        ResultSet rs = null;
        PreparedStatement ps = null;

        try {
            ps = conn.prepareStatement("SELECT * FROM FIN_COSTO WHERE CICLO_ID = ? AND PERIODO_ID = TO_NUMBER(?, '99') AND CLASFIN_ID = TO_NUMBER(?, '99') AND PLAN_ID = ? AND CUENTA_ID = ?");
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, clasFinId);
            ps.setString(4, planId);
            ps.setString(5, cuentaId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCosto|existeCuenta|:" +ex);
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
    
    public static boolean existeSoloCuenta(Connection conn,String cuentaId) throws SQLException {
        boolean ok = false;
        ResultSet rs = null;
        PreparedStatement ps = null;

        try {
            ps = conn.prepareStatement("SELECT * FROM FIN_COSTO WHERE CUENTA_ID = ?");
            ps.setString(1, cuentaId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCosto|existeSoloCuenta|:" +ex);
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
    
    public boolean existeReg(Connection conn, String cicloId, String costoId) throws SQLException {
        boolean ok = false;
        ResultSet rs = null;
        PreparedStatement ps = null;

        try {
            ps = conn.prepareStatement("SELECT * FROM FIN_COSTO WHERE CICLO_ID = ? AND COSTO_ID = TO_NUMBER(?, '999') ");
            
            ps.setString(1, cicloId);
            ps.setString(2, costoId);           
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCosto|existeReg|:" +ex);
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
    
    public boolean existeReg(Connection conn, String cicloId, String periodoId, String planId, String clasfinId ) throws SQLException {    
        PreparedStatement ps 	= null;
        ResultSet rs 			= null;
        boolean ok 				= false;

        try {
            ps = conn.prepareStatement("SELECT * FROM FIN_COSTO " +
            		" WHERE CICLO_ID = ?" +
            		" AND PERIODO_ID = TO_NUMBER(?, '99')" +
            		" AND PLAN_ID = ?" +
            		" AND CLASFIN_ID = TO_NUMBER(?, '99')");
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, planId);
            ps.setString(4, clasfinId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCosto|existeReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return ok;
    }
    
    public String maxReg(Connection conn, String cicloId) throws SQLException {
        String maximo			= "1";
        ResultSet rs			= null;
        PreparedStatement ps	= null;

        try {
            ps = conn.prepareStatement("SELECT COALESCE(MAX(COSTO_ID)+1,1) AS MAXIMO FROM FIN_COSTO WHERE CICLO_ID = ?");
            ps.setString(1, cicloId);
            rs = ps.executeQuery();
            if(rs.next()){
                maximo = rs.getString("MAXIMO");
            }
            
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCosto|existeReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return maximo;
    }
    
    public static boolean tieneDatos(Connection conn, String cicloId, String costoId) throws SQLException {
    	PreparedStatement ps 	= null;        
    	ResultSet rs 			= null;
        boolean ok 				= false;
        
        try {
            ps = conn.prepareStatement("SELECT COUNT(CICLO_ID) AS CONT" +
            		" FROM FIN_CALCULO" +
            		" WHERE CICLO_ID||PERIODO_ID||PLAN_ID||CLASFIN_ID IN " +
            		"	(SELECT CICLO_ID||PERIODO_ID||PLAN_ID||CLASFIN_ID" +
            		" 	FROM FIN_COSTO" +
            		"	WHERE CICLO_ID = ? AND COSTO_ID = TO_NUMBER(?, '999'))");            
            ps.setString(1, cicloId);
            ps.setString(2, costoId);
            
            rs = ps.executeQuery();
            if(rs.next()){
            	if(rs.getInt("CONT") > 0)
            		ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCosto|tieneDatos|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return ok;
    }
    
    public static boolean existenDatos(Connection conn, String cicloId, String periodoId, String cuentaId, String clasFin, String planId ) throws SQLException {
    	PreparedStatement ps 	= null;        
    	ResultSet rs 			= null;
        boolean ok 				= false;
        
        try {
            ps = conn.prepareStatement("SELECT COUNT(FCD.CICLO_ID) AS CONT" +
            	" FROM FIN_CALCULO_DET FCD, FIN_CALCULO FC" +
            	" WHERE FCD.CICLO_ID = ?" +
            	" AND FCD.PERIODO_ID = TO_NUMBER(?, '99')"+
            	" AND FCD.CUENTA_ID = ?" +
            	" AND FC.CLASFIN_ID = TO_NUMBER(?,'99')" +
            	" AND FC.PLAN_ID = ?" +
            	" AND FC.CICLO_ID = FCD.CICLO_ID" +
            	" AND FC.PERIODO_ID = FCD.PERIODO_ID");
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, cuentaId);
            ps.setString(4, clasFin);
            ps.setString(5, planId);
            
            rs = ps.executeQuery();
            if(rs.next()){
            	if(rs.getInt("CONT") > 0)
            		ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCosto|existenDatos|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return ok;
    }
}
