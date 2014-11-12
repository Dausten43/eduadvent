package aca.financiero.copy;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class FinCalculoDet {
	private String cicloId;
	private String periodoId;
	private String codigoId;
	private String cuentaId;
	private String fecha;
	private String importe;
	private String beca;
	
	
	public FinCalculoDet(){
		cicloId		= "";
		periodoId	= "";
		codigoId	= "";
		cuentaId	= "";
		fecha 		= "";
		importe		= "";
		beca 		= "";
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
	 * @return the beca
	 */
	public String getBeca() {
		return beca;
	}

	/**
	 * @param beca the beca to set
	 */
	public void setBeca(String beca) {
		this.beca = beca;
	}


	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "INSERT INTO FIN_CALCULO_DET( CICLO_ID, PERIODO_ID, CODIGO_ID, CUENTA_ID, FECHA, IMPORTE, BECA )" +
                    " VALUES(?, TO_NUMBER(?, '99'), ?, ?," +
                    " TO_DATE(?, 'DD/MM/YYYY'), " +
                    " TO_NUMBER(?, '99999.99')," +
                    " TO_NUMBER(?,'999.99'))");
            
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, codigoId);
            ps.setString(4, cuentaId);
            ps.setString(5, fecha);
            ps.setString(6, importe);
            ps.setString(7, beca);
            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.financiero.FinCalculoDet|insertReg|:" + ex);
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
                    "UPDATE FIN_CALCULO_DET" +
                    " SET FECHA = O_DATE(?, 'DD/MM/YYYY')," +
                    " IMPORTE = TO_NUMER(?, '99999.99')," +
                    " BECA = TO_NUMBER(?,'999.99')" +
                    " WHERE CICLO_ID = ? " +
                    " AND PERIODO_ID = TO_NUMBER(?, '99')" +
                    " AND CODIGO_ID = ?" +
                    " AND CUENTA_ID = ?");
            ps.setString(1, fecha);
            ps.setString(2, importe);
            ps.setString(3, cicloId);
            ps.setString(4, periodoId);
            ps.setString(5, beca);
            ps.setString(6, codigoId);            
            ps.setString(7, cuentaId);
            

            if(ps.executeUpdate() == 1){
                ok = true;
            }

            
        }catch (Exception ex){
            System.out.println("Error - aca.financiero.FinCalculoDet|updateReg|:" + ex);
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
                    "DELETE FROM FIN_CALCULO_DET " +
                    " WHERE CICLO_ID = ?" +
                    " AND PERIODO_ID = TO_NUMBER(?, '99')" +
                    " AND CODIGO_ID = ?" +
                    " AND CUENTA_ID = ?");
            
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, codigoId);
            ps.setString(4, cuentaId);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.financiero.FinCalculoDet|deleteReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {
        cicloId		= rs.getString("CICLO_ID");
		periodoId	= rs.getString("PERIODO_ID");
		codigoId	= rs.getString("CODIGO_ID");
		cuentaId	= rs.getString("CUENTA_ID");
		fecha   	= rs.getString("FECHA");
		importe		= rs.getString("IMPORTE");
		beca		= rs.getString("BECA");
    }

    public void mapeaRegId(Connection con, String cicloId, String periodoId, String codigoId, String cuentaId) throws SQLException{
        ResultSet rs = null;
        PreparedStatement ps = null; 
        try{
	        ps = con.prepareStatement(
	                " SELECT CICLO_ID, PERIODO_ID, CODIGO_ID, CUENTA_ID, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, IMPORTE, BECA" +
	                " FROM FIN_CALCULO_DET" +
	                " WHERE CICLO_ID = ? " +
	                " AND PERIODO_ID = TO_NUMBER(?, '99')" +
	                " AND CODIGO_ID = ?," +
	                " AND CUENTA_ID = ? ");
	        ps.setString(1, cicloId);
	        ps.setString(2, periodoId);
	        ps.setString(3, codigoId);
	        ps.setString(4, cuentaId);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.financiero.FinCalculoDet|mapeaRegId|:"+ex);
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
            ps = conn.prepareStatement("SELECT * FROM FIN_CALCULO_DET" +
            		" WHERE CICLO_ID = ?" +
            		" AND PERIODO_ID = TO_NUMBER(?, '99')" +
            		" AND CODIGO_ID = ?" +
            		" AND CUENTA_ID = ?");
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, codigoId);
            ps.setString(4, cuentaId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.financiero.FinCalculoDet|existeReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return ok;
    }
    
    public static int getNumDetalles(Connection conn, String cicloId, String periodoId, String codigoId ) throws SQLException {
    	PreparedStatement ps 	= null;
    	ResultSet rs 			= null;
        int numDetalles			= 0; 

        try {
            ps = conn.prepareStatement("SELECT COALESCE(COUNT(CUENTA_ID),0) AS DETALLES FROM FIN_CALCULO_DET" +
            		" WHERE CICLO_ID = ?" +
            		" AND PERIODO_ID = TO_NUMBER(?, '99')" +
            		" AND CODIGO_ID = ?");
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, codigoId);           
            
            rs = ps.executeQuery();
            if(rs.next()){
                numDetalles = rs.getInt("DETALLES");
            }
        }catch(Exception ex){
            System.out.println("Error - aca.financiero.FinCalculoDet|getNumDetalles|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return numDetalles;
    }    

}
