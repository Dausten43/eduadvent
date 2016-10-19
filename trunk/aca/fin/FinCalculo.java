/**
 * @author Jose Torres
 *
 */
package aca.fin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * @author EryTorres
 *
 */
public class FinCalculo {
	private String cicloId;
	private String periodoId;
	private String codigoId;
	private String planId;	
	private String tipoPago;
	private String importe;
	private String inscrito;
	private String folio;
	private String clasFinId;
	private String numPagos;
	private String pagoInicial;
	private String fecha;
	
	public FinCalculo(){		
		cicloId		= "";
		periodoId	= "";
		codigoId	= "";
		planId		= "";
		clasFinId	= "";
		tipoPago	= "";		
		importe		= "";
		inscrito	= "N";
		folio		= "0";
		numPagos	= "0";
		pagoInicial	= "0";
		fecha 		= "";
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
	 * @return the inscrito
	 */
	public String getInscrito() {
		return inscrito;
	}

	/**
	 * @param inscrito the inscrito to set
	 */
	public void setInscrito(String inscrito) {
		this.inscrito = inscrito;
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
	 * @return the tipoPago
	 */
	public String getTipoPago() {
		return tipoPago;
	}

	/**
	 * @param tipoPago the tipoPago to set
	 */
	public void setTipoPago(String tipoPago) {
		this.tipoPago = tipoPago;
	}	

	/**
	 * @return the numPagos
	 */
	public String getNumPagos() {
		return numPagos;
	}

	/**
	 * @param numPagos the numPagos to set
	 */
	public void setNumPagos(String numPagos) {
		this.numPagos = numPagos;
	}
	
	/**
	 * @return the pagoInicial
	 */
	public String getPagoInicial() {
		return pagoInicial;
	}
	
	/**
	 * @param pagoInicial the pagoInicial to set
	 */
	public void setPagoInicial(String pagoInicial) {
		this.pagoInicial = pagoInicial;
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
	 * @param Conection the conn to set
	 */
	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement("INSERT INTO FIN_CALCULO(CICLO_ID, PERIODO_ID, CODIGO_ID, PLAN_ID,"
                    + " CLASFIN_ID, TIPO_PAGO, IMPORTE, INSCRITO, NUMPAGOS, PAGOINICIAL, FECHA)"
                    + " VALUES(?, TO_NUMBER(?, '99'), ?, ?,"
                    + " TO_NUMBER(?,'99'), ?,"
                    + " TO_NUMBER(?, '99999.99'), ?,"
                    + " TO_NUMBER(?, '99'),"
                    + " TO_NUMBER(?, '99999.99'),"
                    + " TO_DATE(?,'DD/MM/YYYY'))");
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, codigoId);
            ps.setString(4, planId);
            ps.setString(5, clasFinId);
            ps.setString(6, tipoPago);
            ps.setString(7, importe);
            ps.setString(8, inscrito);
            ps.setString(9, numPagos);
            ps.setString(10, pagoInicial);
            ps.setString(11, fecha);

            if(ps.executeUpdate() == 1){
                ok = true;
            }


        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinCalculo|insertReg|:" + ex);
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
                    "UPDATE FIN_CALCULO " + 
                    " SET PLAN_ID = ?," +
                    " CLASFIN_ID = TO_NUMBER(?,'99')," +
                    " TIPO_PAGO = ?," +
                    " IMPORTE = TO_NUMBER(?, '99999.99')," +                   
                    " INSCRITO = ?, " +
                    " NUMPAGOS = TO_NUMBER(?,'99')," +
                    " PAGOINICIAL = TO_NUMBER(?, '99999.99')," +
                    " FECHA = TO_DATE(?,'DD/MM/YYYY')" +
                    " WHERE CICLO_ID = ?" +                    
                    " AND PERIODO_ID = TO_NUMBER(?,'99')" +
                    " AND CODIGO_ID = ?");
            
            ps.setString(1, planId);
            ps.setString(2, clasFinId);
            ps.setString(3, tipoPago);
            ps.setString(4, importe);
            ps.setString(5, inscrito); 
            ps.setString(6, numPagos);
            ps.setString(7, pagoInicial);
            ps.setString(8, fecha);
            ps.setString(9, cicloId);
            ps.setString(10, periodoId);            
            ps.setString(11, codigoId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }

            
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinCalculo|updateReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }
    
    public boolean updateFolio(Connection conn ) throws SQLException{
    	
    	Statement st 			= conn.createStatement();
    	PreparedStatement ps 	= null;
        ResultSet rs 			= null;
        boolean ok 				= false;
        try{
        	String folio 			= "1";
        	rs = st.executeQuery("SELECT COALESCE(MAX(FOLIO),1) AS MAXFOLIO FROM FIN_CALCULO WHERE CICLO_ID = '"+cicloId+"'");
            if (rs.next()){
            	folio = rs.getString("MAXFOLIO");
            }
        	
            ps = conn.prepareStatement(
                    "UPDATE FIN_CALCULO SET FOLIO = TO_NUMBER(?,'99999')" +                    
                    " WHERE CICLO_ID = ?" +                    
                    " AND PERIODO_ID = TO_NUMBER(?,'99')" +
                    " AND CODIGO_ID = ?");
            
            ps.setString(1, folio);                       
            ps.setString(2, cicloId);
            ps.setString(3, periodoId);
            ps.setString(4, codigoId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }

            
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinCalculo|updateFolio|:" + ex);
        }finally{
        	if(ps != null){ ps.close(); }
        }

        return ok;
    }
    
    
    public static boolean updateInscrito(Connection conn, String cicloId, String periodoId, String codigoId, String inscrito) throws SQLException{
    	
    	PreparedStatement ps 	= null;        
        boolean ok 				= false;
        try{       	
            ps = conn.prepareStatement(
                    "UPDATE FIN_CALCULO SET INSCRITO = ? " +
                    " WHERE CICLO_ID = ?" +
                    " AND PERIODO_ID = TO_NUMBER(?,'99')" +
                    " AND CODIGO_ID = ?");
            
            ps.setString(1, inscrito);                       
            ps.setString(2, cicloId);
            ps.setString(3, periodoId);
            ps.setString(4, codigoId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }

            
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinCalculo|updateInscrito|:" + ex);
        }finally{
        	if(ps != null){ ps.close(); }
        }

        return ok;
    }

    public boolean deleteReg(Connection conn) throws SQLException{
    	PreparedStatement ps 	= null;
    	boolean ok 				= false;        

        try {
            ps = conn.prepareStatement(
                    " DELETE FROM FIN_CALCULO" +
                    " WHERE CICLO_ID = ?" +
                    " AND PERIODO_ID = TO_NUMBER(?,'99')" +
                    " AND CODIGO_ID = ?");
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, codigoId);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }            
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinCalculo|deleteReg|:" + ex);
        }finally{        	
        	if(ps != null){ ps.close(); }
        }

        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {
		cicloId		= rs.getString("CICLO_ID");
		periodoId	= rs.getString("PERIODO_ID");
		codigoId	= rs.getString("CODIGO_ID");
		planId		= rs.getString("PLAN_ID");
		clasFinId	= rs.getString("CLASFIN_ID");
		tipoPago	= rs.getString("TIPO_PAGO");
		importe		= rs.getString("IMPORTE");
		inscrito	= rs.getString("INSCRITO");
		folio		= rs.getString("FOLIO");
		numPagos 	= rs.getString("NUMPAGOS");
		pagoInicial	= rs.getString("PAGOINICIAL");
		fecha 		= rs.getString("FECHA");
    }

    public void mapeaRegId(Connection con, String cicloId, String periodoId, String codigoId) throws SQLException{
        ResultSet rs = null;
        PreparedStatement ps = null; 
        try{
        	ps = con.prepareStatement(
        		" SELECT CICLO_ID, PERIODO_ID, CODIGO_ID, PLAN_ID, CLASFIN_ID, TIPO_PAGO, IMPORTE, " +
                " INSCRITO, FOLIO, NUMPAGOS, PAGOINICIAL, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA "+
                " FROM FIN_CALCULO" +
                " WHERE CICLO_ID = ?" +
                " AND PERIODO_ID = TO_NUMBER(?,'99')" +
                " AND CODIGO_ID = ?");
        	ps.setString(1, cicloId);
        	ps.setString(2, periodoId);
        	ps.setString(3, codigoId);
        
        	rs = ps.executeQuery();
        	if(rs.next()){
        		mapeaReg(rs);
        	}            
        }catch(Exception ex){
			System.out.println("Error - aca.fin.FinCalculo|mapeaRegId|:"+ex);
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
        	ps = conn.prepareStatement("SELECT * FROM FIN_CALCULO" +
            		" WHERE CICLO_ID = ?" +
                    " AND PERIODO_ID = TO_NUMBER(?,'99')" +
                    " AND CODIGO_ID = ?");
        	
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, codigoId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCalculo|existeReg|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return ok;
    }    
    
    public String maxReg(Connection conn, String cicloId, String periodoId) throws SQLException {
    	PreparedStatement ps	= null;        
        ResultSet rs			= null;
        String maximo			= "1";
        
        try {
        	ps = conn.prepareStatement("SELECT COALESCE(MAX(FOLIO)+1,1) AS MAXIMO FROM FIN_CALCULO" +
            		" WHERE CICLO_ID = ?" +
            		" AND PERIODO_ID = TO_NUMBER(?,'99')");
        	
            ps.setString(1, cicloId);
            ps.setString(2, cicloId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                maximo = rs.getString("MAXIMO");
            }else
            	maximo = "1";
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCalculo|maxReg|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return maximo;
    }  
    
    /* Pendiente de borrar */
    public static String pendientesPagoInicial(Connection conn, String cicloId, String periodoId) throws SQLException {
    	PreparedStatement ps	= null;        
        ResultSet rs			= null;
        String cantidad			= "0";
        
        try {
        	ps = conn.prepareStatement("SELECT COUNT(*) AS CANTIDAD FROM FIN_CALCULO "
        			+ " WHERE CICLO_ID = ? "
        			+ " AND PERIODO_ID = TO_NUMBER(?, '99') "
        			+ " AND INSCRITO = 'G' ");
        	
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            
            rs = ps.executeQuery();
            if(rs.next()){
            	cantidad = rs.getString("CANTIDAD");
            }

        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCalculo|pendientesPagoInicial|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return cantidad;
    }   
    
    public static String pendientesPago(Connection conn, String cicloId, String periodoId, String pagoId) throws SQLException {
    	PreparedStatement ps	= null;        
        ResultSet rs			= null;
        String cantidad			= "0";
        
        try {
        	ps = conn.prepareStatement("SELECT COUNT(DISTINCT(CODIGO_ID)) AS CANTIDAD FROM FIN_CALCULO_PAGO A"
        			+ " WHERE CICLO_ID = ? "
        			+ " AND PERIODO_ID = TO_NUMBER(?, '99')"
        			+ " AND PAGO_ID = TO_NUMBER(?,'99')"
        			+ " AND ESTADO = 'A'" /* Que no se hayan tomado en cuenta en alguna poliza (que no hayan sido Contabilizados) */
        			+ " AND IMPORTE > 0"
        			+ " AND CODIGO_ID IN"
        				+ " (SELECT CODIGO_ID FROM FIN_CALCULO"
        				+ " WHERE CICLO_ID = ?"
        				+ " AND PERIODO_ID = TO_NUMBER(?,'99')"
        				+ " AND INSCRITO IN ('G','P')) "
    				+ " AND CODIGO_ID NOT IN ("
    					+ " SELECT CODIGO_ID FROM ALUM_CICLO WHERE CICLO_ID=? AND ESTADO NOT IN ('I') AND PERIODO_ID=TO_NUMBER(?,'99'))"
    				+ ""); 
        	
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, pagoId);
            ps.setString(4, cicloId);
            ps.setString(5, periodoId);
            ps.setString(6, cicloId);
            ps.setString(7, periodoId);
            
            rs = ps.executeQuery();
            if(rs.next()){
            	cantidad = rs.getString("CANTIDAD");
            }

        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCalculo|pendientesPago|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return cantidad;
    }
    
    
    public static String getInscrito(Connection conn, String cicloId, String periodoId, String codigoId) throws SQLException {
    	PreparedStatement ps	= null;        
        ResultSet rs			= null;
        String estado			= "0";
        
        try {
        	ps = conn.prepareStatement("SELECT INSCRITO FROM FIN_CALCULO"
        			+ " WHERE CICLO_ID = ?"
        			+ " AND PERIODO_ID = TO_NUMBER(?,'99')"
            		+ " AND CODIGO_ID = ?");
        	
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, codigoId);
           // System.out.println("salida del metodo " + ps);
            rs = ps.executeQuery();
            if(rs.next()){
                estado = rs.getString("INSCRITO");
            }
            	
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCalculo|getInscrito|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return estado;
    }
    
}
