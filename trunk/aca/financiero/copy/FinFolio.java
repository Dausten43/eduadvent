package aca.financiero.copy;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class FinFolio {
	
	private String codigoId;
	private String escuelaId;
	private String folioRecibo;
	private String folioFactura;
	
	public FinFolio(){
		codigoId		= "";
		escuelaId		= "";
		folioRecibo		= "";
		folioFactura	= "";
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
	 * @return the escuelaId
	 */
	public String getEscuelaId() {
		return escuelaId;
	}

	/**
	 * @param escuelaId the escuelaId to set
	 */
	public void setEscuelaId(String escuelaId) {
		this.escuelaId = escuelaId;
	}

	/**
	 * @return the folioRecibo
	 */
	public String getFolioRecibo() {
		return folioRecibo;
	}

	/**
	 * @param folioRecibo the folioRecibo to set
	 */
	public void setFolioRecibo(String folioRecibo) {
		this.folioRecibo = folioRecibo;
	}

	/**
	 * @return the folioFactura
	 */
	public String getFolioFactura() {
		return folioFactura;
	}

	/**
	 * @param folioFactura the folioFactura to set
	 */
	public void setFolioFactura(String folioFactura) {
		this.folioFactura = folioFactura;
	}


	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "INSERT INTO FIN_FOLIO(CODIGO_ID, ESCUELA_ID, FOLIO_RECIBO, FOLIO_FACTURA)" +
                    " VALUES(?, TO_NUMBER(?, '99'), TO_NUMBER(?, '9999999'), TO_NUMBER(?, '9999999'))");
           
            ps.setString(1, codigoId);           
            ps.setString(2, escuelaId);
            ps.setString(3, folioRecibo);
            ps.setString(4, folioFactura);
            
            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.financiero.FinFolio|insertReg|:" + ex);
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
            ps = conn.prepareStatement("UPDATE FIN_FOLIO SET ESCUELA_ID = TO_NUMBER(?, '99'), " +
            		"FOLIO_RECIBO = TO_NUMBER(?, '9999999'), " +
            		"FOLIO_FACTURA = TO_NUMBER(?, '9999999') WHERE CODIGO_ID = ?");            
            ps.setString(1, escuelaId);
            ps.setString(2, folioRecibo);
            ps.setString(3, folioFactura);
            ps.setString(4, codigoId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.financiero.FinFolio|updateReg|:" + ex);
        }finally{
        	 if(ps != null){
                 ps.close();
             }
        }

        return ok;
    }
    
    public static boolean aumentarFolio(Connection conn, String codigoId, String tipo) throws SQLException{
        
        PreparedStatement ps 	= null;
        boolean ok 				= false;
        try{
        	if (tipo.equals("R")){
        		ps = conn.prepareStatement("UPDATE FIN_FOLIO SET FOLIO_RECIBO = FOLIO_RECIBO+1 WHERE CODIGO_ID = ?");
        	}else{
        		ps = conn.prepareStatement("UPDATE FIN_FOLIO SET FOLIO_FACTURA = FOLIO_FACTURA+1 WHERE CODIGO_ID = ?"); 		
        	}
            
            ps.setString(1, codigoId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }

           
        }catch (Exception ex){
            System.out.println("Error - aca.financiero.FinFolio|aumentarFolio|:" + ex);
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
            ps = conn.prepareStatement("DELETE FROM FIN_FOLIO WHERE CODIGO_ID = ?");            
            ps.setString(1, codigoId);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }

            
        }catch (Exception ex){
            System.out.println("Error - aca.financiero.FinFolio|deleteReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {
        codigoId		= rs.getString("CODIGO_ID");
        escuelaId		= rs.getString("ESCUELA_ID");
		folioRecibo		= rs.getString("FOLIO_RECIBO");
		folioFactura	= rs.getString("FOLIO_FACTURA");
    }
        
    public void mapeaRegId(Connection con, String codigoId) throws SQLException{
        ResultSet rs = null;
        PreparedStatement ps = null; 
        try{
	        ps = con.prepareStatement("SELECT CODIGO_ID, ESCUELA_ID, FOLIO_RECIBO, FOLIO_FACTURA FROM FIN_FOLIO WHERE CODIGO_ID = ?");
	        ps.setString(1, codigoId); 
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.financiero.FinFolio|mapeaRegId|:"+ex);
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
            ps = conn.prepareStatement("SELECT * FROM FIN_FOLIO WHERE CODIGO_ID = ?");            
            ps.setString(1, codigoId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.financiero.FinFolio|existeReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        
        return ok;
    }
    
    public boolean existeReg(Connection conn, String codigoId) throws SQLException {
        boolean ok = false;
        ResultSet rs = null;
        PreparedStatement ps = null;

        try {
            ps = conn.prepareStatement("SELECT * FROM FIN_FOLIO WHERE CODIGO_ID = ?");           
            ps.setString(1, codigoId);   
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.financiero.FinFolio|existeReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return ok;
    }
    
    public static String getSigFolio(Connection conn, String codigoId, String tipo) throws SQLException {        
        
        PreparedStatement ps 	= null;
        ResultSet rs 			= null;
        String folio 			= "0";

        try {
        	if (tipo.equals("R")){
        		ps = conn.prepareStatement("SELECT FOLIO_RECIBO AS FOLIO FROM FIN_FOLIO WHERE CODIGO_ID = ?");
        	}else{
        		ps = conn.prepareStatement("SELECT FOLIO_FACTURA AS FOLIO FROM FIN_FOLIO WHERE CODIGO_ID = ?");
        	}        	
            ps.setString(1, codigoId);            
            
            rs = ps.executeQuery();
            if(rs.next()){
                folio = rs.getString("FOLIO");
            }
        }catch(Exception ex){
            System.out.println("Error - aca.financiero.FinFolio|existeReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return folio;
    }
}
