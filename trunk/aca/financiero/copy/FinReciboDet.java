package aca.financiero.copy;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class FinReciboDet {
	private String reciboId;
	private String folio;
	private String codigoId;
	private String nombre;
	private String concepto;
	private String importe;
	
	
	public FinReciboDet(){
		reciboId		= "";
		folio			= "";
		codigoId		= "";
		nombre			= "";
		concepto 		= "";
		importe			= "";
	}
	

	/**
	 * @return the reciboId
	 */
	public String getReciboId() {
		return reciboId;
	}

	/**
	 * @param reciboId the reciboId to set
	 */
	public void setReciboId(String reciboId) {
		this.reciboId = reciboId;
	}

	/**
	 * @return the folio
	 */
	public String getFolio() {
		return folio;
	}

	/**
	 * @param folio the folio to set
	 */
	public void setFolio(String folio) {
		this.folio = folio;
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
	 * @return the nombre
	 */
	public String getNombre() {
		return nombre;
	}

	/**
	 * @param nombre the nombre to set
	 */
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	/**
	 * @return the concepto
	 */
	public String getConcepto() {
		return concepto;
	}

	/**
	 * @param concepto the concepto to set
	 */
	public void setConcepto(String concepto) {
		this.concepto = concepto;
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

	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "INSERT INTO FIN_RECIBODET( RECIBO_ID, FOLIO, CODIGO_ID, NOMBRE, CONCEPTO, IMPORTE )" +
                    " VALUES(TO_NUMBER(?, '9999999'), TO_NUMBER(?, '99'), ?, ?, ?," +
                    " TO_NUMBER(?, '99999.99'))");
            
            ps.setString(1, reciboId);
            ps.setString(2, folio);
            ps.setString(3, codigoId);
            ps.setString(4, nombre);
            ps.setString(5, concepto);
            ps.setString(6, importe);
            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.financiero.FinReciboDet|insertReg|:" + ex);
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
                    "UPDATE FIN_RECIBODET" +
                    " SET CODIGO_ID = ?," +
                    " NOMBRE = ?," +
                    " CONCEPTO = ?," +
                    " IMPORTE = TO_NUMBER(?, '99999.99')" +
                    " WHERE RECIBO_ID = TO_NUMBER(?, '9999999') " +
                    " AND FOLIO = TO_NUMBER(?, '99')");
            ps.setString(1, codigoId);
            ps.setString(2, nombre);
            ps.setString(3, concepto);
            ps.setString(4, importe);
            ps.setString(5, reciboId);
            ps.setString(6, folio);   
            

            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.financiero.FinReciboDet|updateReg|:" + ex);
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
                    "DELETE FROM FIN_RECIBODET " +
                    " WHERE RECIBO_ID = TO_NUMBER(?, '9999999')" +
                    " AND FOLIO = TO_NUMBER(?, '99')");
            
            ps.setString(1, reciboId);
            ps.setString(2, folio);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.financiero.FinReciboDet|deleteReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {
        reciboId		= rs.getString("RECIBO_ID");
		folio	= rs.getString("FOLIO");
		codigoId	= rs.getString("CODIGO_ID");
		nombre	= rs.getString("NOMBRE");
		concepto   	= rs.getString("CONCEPTO");
		importe		= rs.getString("IMPORTE");
    }

    public void mapeaRegId(Connection con, String reciboId, String folio) throws SQLException{
        ResultSet rs = null;
        PreparedStatement ps = null; 
        try{
	        ps = con.prepareStatement(
	                " SELECT RECIBO_ID, FOLIO, CODIGO_ID, NOMBRE, CONCEPTO, IMPORTE " +
	                " FROM FIN_RECIBODET" +
	                " WHERE RECIBO_ID = TO_NUMBER(?, '9999999') " +
	                " AND FOLIO = TO_NUMBER(?, '99')");
	        ps.setString(1, reciboId);
	        ps.setString(2, folio);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.financiero.FinReciboDet|mapeaRegId|:"+ex);
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
            ps = conn.prepareStatement("SELECT * FROM FIN_RECIBODET" +
            		" WHERE RECIBO_ID = TO_NUMBER(?, '9999999')" +
            		" AND FOLIO = TO_NUMBER(?, '99')");
            ps.setString(1, reciboId);
            ps.setString(2, folio);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.financiero.FinReciboDet|existeReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return ok;
    }
    
    public String maxReg(Connection conn, String reciboId) throws SQLException {
        
        ResultSet rs = null;
        PreparedStatement ps = null;
        String maximo = "1";
        try {
            ps = conn.prepareStatement("SELECT COALESCE(MAX(FOLIO+1),1) AS MAXIMO FROM FIN_RECIBODET" +
            		" WHERE RECIBO_ID = TO_NUMBER(?, '9999999')");
            ps.setString(1, reciboId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                maximo = rs.getString("MAXIMO");
            }
        }catch(Exception ex){
            System.out.println("Error - aca.financiero.FinReciboDet|maxReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return maximo;
    }    
}