/**
 * @author Jose Torres
 *
 */
package aca.fin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class FinCalculoPago {
	private String cicloId;
	private String periodoId;
	private String codigoId;
	private String pagoId;
	private String importe;
	private String fecha;
	private String estado;
	private String cuentaId;
	private String beca;
	private String pagado;
	
	public FinCalculoPago(){		
		cicloId		= "";
		periodoId	= "";
		codigoId	= "";
		pagoId		= "";
		importe		= "0";
		fecha		= "";
		estado		= "";
		cuentaId	= "";
		beca 		= "0";
		pagado 		= "N";
	}	

		
	public String getCicloId() {
		return cicloId;
	}
	public void setCicloId(String cicloId) {
		this.cicloId = cicloId;
	}


	public String getPeriodoId() {
		return periodoId;
	}
	public void setPeriodoId(String periodoId) {
		this.periodoId = periodoId;
	}

	public String getCodigoId() {
		return codigoId;
	}
	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}

	public String getPagoId() {
		return pagoId;
	}
	public void setPagoId(String pagoId) {
		this.pagoId = pagoId;
	}

	public String getImporte() {
		return importe;
	}
	public void setImporte(String importe) {
		this.importe = importe;
	}


	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	
	public String getCuentaId() {
		return cuentaId;
	}

	public void setCuentaId(String cuentaId) {
		this.cuentaId = cuentaId;
	}

	public String getBeca() {
		return beca;
	}

	public void setBeca(String beca) {
		this.beca = beca;
	}

	public String getPagado() {
		return pagado;
	}

	public void setPagado(String pagado) {
		this.pagado = pagado;
	}

	/**
	 * @param Conection the conn to set
	 */
	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                 " INSERT INTO FIN_CALCULO_PAGO(CICLO_ID, PERIODO_ID, CODIGO_ID, PAGO_ID, IMPORTE, FECHA, ESTADO, CUENTA_ID, BECA)" +
                 " VALUES(?, TO_NUMBER(?, '99'), ?, TO_NUMBER(?, '99'), TO_NUMBER(?, '99999.99')," +            
                 " TO_DATE(?,'DD/MM/YYYY'), ?, ?, TO_NUMBER(?, '99999.99'),?)");
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, codigoId);
            ps.setString(4, pagoId);
            ps.setString(5, importe);
            ps.setString(6, fecha);
            ps.setString(7, estado);
            ps.setString(8, cuentaId);
            ps.setString(9, beca);
            ps.setString(10, pagado);
            
            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinCalculoPago|insertReg|:" + ex);
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
                    " UPDATE FIN_CALCULO_PAGO " + 
                    " SET IMPORTE = TO_NUMBER(?, '99999.99')," +                   
                    " FECHA = TO_DATE(?,'DD/MM/YYYY')," +
                    " ESTADO = ?, BECA = TO_NUMBER(?, '99999.99'), PAGADO = ? " +
                    " WHERE CICLO_ID = ?" +                    
                    " AND PERIODO_ID = TO_NUMBER(?,'99')" +
                    " AND CODIGO_ID = ?" +
        			" AND PAGO_ID = TO_NUMBER(?,'99') AND CUENTA_ID = ? ");
            
            ps.setString(1, importe);
            ps.setString(2, fecha);     
            ps.setString(3, estado);    
            ps.setString(4, beca);
            ps.setString(5, pagado);
            ps.setString(6, cicloId);
            ps.setString(7, periodoId);            
            ps.setString(8, codigoId);
            ps.setString(9, pagoId);
            ps.setString(10, cuentaId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }

            
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinCalculoPago|updateReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }
    
    public static boolean updateEstado(Connection conn, String cicloId, String periodoId, String codigoId, String pagoId, String cuentaId, String estado) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    " UPDATE FIN_CALCULO_PAGO " + 
                    " SET ESTADO = ?" +
                    " WHERE CICLO_ID = ?" +                    
                    " AND PERIODO_ID = TO_NUMBER(?,'99')" +
                    " AND CODIGO_ID = ?" +
        			" AND PAGO_ID = TO_NUMBER(?,'99') AND CUENTA_ID = ?");            
             
            ps.setString(1, estado);     
            ps.setString(2, cicloId);
            ps.setString(3, periodoId);            
            ps.setString(4, codigoId);
            ps.setString(5, pagoId);
            ps.setString(6, cuentaId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }

            
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinCalculoPago|updateEstado|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }
    
    public boolean deleteReg(Connection conn) throws SQLException{
    	PreparedStatement ps 	= null;
    	boolean ok 				= false;        

        try {
            ps = conn.prepareStatement(
                    " DELETE FROM FIN_CALCULO_PAGO" +
                    " WHERE CICLO_ID = ?" +
                    " AND PERIODO_ID = TO_NUMBER(?,'99')" +
                    " AND CODIGO_ID = ?" +
        			" AND PAGO_ID = TO_NUMBER(?,'99') AND CUENTA_ID = ?");
            
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, codigoId);
            ps.setString(4, pagoId);
            ps.setString(5, cuentaId);
          
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
    
    public static boolean deletePagosAlumno(Connection conn, String cicloId, String periodoId, String codigoId) throws SQLException{
    	PreparedStatement ps 	= null;
    	boolean ok 				= false;        

        try {
            ps = conn.prepareStatement(
                    " DELETE FROM FIN_CALCULO_PAGO" +
                    " WHERE CICLO_ID = ?" +
                    " AND PERIODO_ID = TO_NUMBER(?,'99')" +
                    " AND CODIGO_ID = ?");            
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, codigoId);         
          
            if(ps.executeUpdate() >= 1){
                ok = true;
            }            
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinCalculo|deletePagosAlumno|:" + ex);
        }finally{        	
        	if(ps != null){ ps.close(); }
        }

        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {
		cicloId		= rs.getString("CICLO_ID");
		periodoId	= rs.getString("PERIODO_ID");
		codigoId	= rs.getString("CODIGO_ID");
		pagoId		= rs.getString("PAGO_ID");		
		importe		= rs.getString("IMPORTE");		
		fecha 		= rs.getString("FECHA");
		estado 		= rs.getString("ESTADO");
		cuentaId	= rs.getString("CUENTA_ID");
		beca 		= rs.getString("BECA");
		pagado 		= rs.getString("PAGADO");
    }

    public void mapeaRegId(Connection con, String cicloId, String periodoId, String codigoId, String pagoId) throws SQLException{
        ResultSet rs = null;
        PreparedStatement ps = null; 
        try{
        	ps = con.prepareStatement(
        		" SELECT CICLO_ID, PERIODO_ID, CODIGO_ID, PAGO_ID, IMPORTE, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, ESTADO, CUENTA_ID, BECA, PAGADO"+
                " FROM FIN_CALCULO_PAGO" +
                " WHERE CICLO_ID = ?" +
                " AND PERIODO_ID = TO_NUMBER(?,'99')" +
                " AND CODIGO_ID = ?" +
        		" AND PAGO_ID = TO_NUMBER(?,'99') AND CUENTA_ID = ?");
        		
        	ps.setString(1, cicloId);
        	ps.setString(2, periodoId);
        	ps.setString(3, codigoId);
        	ps.setString(4, pagoId);
        	ps.setString(5, cuentaId);
        
        	rs = ps.executeQuery();
        	if(rs.next()){
        		mapeaReg(rs);
        	}            
        }catch(Exception ex){
			System.out.println("Error - aca.fin.FinCalculoPago|mapeaRegId|:"+ex);
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
        	ps = conn.prepareStatement("SELECT * FROM FIN_CALCULO_PAGO" +
            		" WHERE CICLO_ID = ?" +
                    " AND PERIODO_ID = TO_NUMBER(?,'99')" +
                    " AND CODIGO_ID  = ?" +
        			" AND PAGO_ID    = TO_NUMBER(?,'99') AND CUENTA_ID = ?");
        	
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, codigoId);
            ps.setString(4, pagoId);
            ps.setString(5, cuentaId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCalculoPago|existeReg|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }        
        return ok;
    }
    
    public static int numPagosAlumnoCuenta(Connection conn, String cicloId, String periodoId, String codigoId, String cuentaId) throws SQLException {
              
        PreparedStatement ps	= null;
        ResultSet rs 			= null;
        int pagos				= 0;

        try {
        	ps = conn.prepareStatement("SELECT COALESCE(COUNT(PAGO_ID),0) AS PAGOS FROM FIN_CALCULO_PAGO" +
            		" WHERE CICLO_ID = ?" +
                    " AND PERIODO_ID = TO_NUMBER(?,'99')" +
                    " AND CODIGO_ID  = ? AND CUENTA_ID = ? ");
        	
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, codigoId);   
            ps.setString(4, cuentaId);   
            
            rs = ps.executeQuery();
            if(rs.next()){
            	rs.getInt("PAGOS");
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCalculoPago|numPagosAlumno|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return pagos;
    }
    
    public static int numPagosAlumno(Connection conn, String cicloId, String periodoId, String codigoId) throws SQLException {
        
        PreparedStatement ps	= null;
        ResultSet rs 			= null;
        int pagos				= 0;

        try {
        	ps = conn.prepareStatement("SELECT COALESCE(COUNT(PAGO_ID),0) AS PAGOS FROM FIN_CALCULO_PAGO" +
            		" WHERE CICLO_ID = ?" +
                    " AND PERIODO_ID = TO_NUMBER(?,'99')" +
                    " AND CODIGO_ID  = ? ");
        	
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, codigoId);   
            
            rs = ps.executeQuery();
            if(rs.next()){
            	rs.getInt("PAGOS");
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCalculoPago|numPagosAlumno|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return pagos;
    }
    
    public static String getEstado(Connection conn, String cicloId, String periodoId, String codigoId, String pagoId, String cuentaId) throws SQLException {
        
        PreparedStatement ps	= null;
        ResultSet rs 			= null;
        String estado 			= "";

        try {
        	ps = conn.prepareStatement("SELECT ESTADO FROM FIN_CALCULO_PAGO " +
            		" WHERE CICLO_ID = ? " +
                    " AND PERIODO_ID = TO_NUMBER(?,'99') " +
                    " AND CODIGO_ID  = ? "+
                    " AND PAGO_ID = ? AND CUENTA_ID = ? ");
        	
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, codigoId);
            ps.setString(4, pagoId);
            ps.setString(5, cuentaId);
            
            rs = ps.executeQuery();
            if(rs.next()){
            	estado = rs.getString("ESTADO");
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCalculoPago|getEstado|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return estado;
    }
    
  
}
