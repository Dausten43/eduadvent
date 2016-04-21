/**
 * 
 */
package aca.fin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author elifo
 *
 */
public class FinPago {
	private String cicloId;
	private String periodoId;
	private String pagoId;
	private String fecha;
	private String descripcion;
	private String tipo;
	private String orden;
	private String fechaVence;
	
	public FinPago(){
		cicloId		= "";
		periodoId	= "";
		pagoId		= "";
		fecha		= "";
		descripcion	= "";
		tipo 		= "P";
		orden 		= "0"; 
		fechaVence	= "";
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
	 * @return the descripcion
	 */
	public String getDescripcion() {
		return descripcion;
	}

	/**
	 * @param descripcion the descripcion to set
	 */
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
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
	 * @return the pagoId
	 */
	public String getPagoId() {
		return pagoId;
	}

	/**
	 * @param pagoId the pagoId to set
	 */
	public void setPagoId(String pagoId) {
		this.pagoId = pagoId;
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
	 * @return the orden
	 */
	public String getOrden() {
		return orden;
	}

	/**
	 * @param orden the orden to set
	 */
	public void setOrden(String orden) {
		this.orden = orden;
	}

	/**
	 * @return the tipo
	 */
	public String getTipo() {
		return tipo;
	}

	/**
	 * @param tipo the tipo to set
	 */
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	
	public String getFechaVence() {
		return fechaVence;
	}

	public void setFechaVence(String fechaVence) {
		this.fechaVence = fechaVence;
	}

	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "INSERT INTO FIN_PAGO(CICLO_ID, PERIODO_ID, PAGO_ID, FECHA, DESCRIPCION, TIPO, ORDEN, FECHA_VENCE)" +
                    " VALUES(?, TO_NUMBER(?, '99'), TO_NUMBER(?, '99'), TO_DATE(?, 'DD/MM/YYYY'), ?, ?, TO_NUMBER(?, '99'),TO_DATE(?, 'DD/MM/YYYY'))");
            
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, pagoId);
            ps.setString(4, fecha);
            ps.setString(5, descripcion);
            ps.setString(6, tipo);
            ps.setString(7, orden);
            ps.setString(8, fechaVence);

            if(ps.executeUpdate() == 1){
                ok = true;
            }

            
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinPago|insertReg|:" + ex);
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
            ps = conn.prepareStatement("UPDATE FIN_PAGO"
            		+ " SET FECHA = TO_DATE(?, 'DD/MM/YYYY'), DESCRIPCION = ?, TIPO = ?, ORDEN = TO_NUMBER(?,'99'), FECHA_VENCE = TO_DATE(?, 'DD/MM/YYYY')"
            		+ " WHERE CICLO_ID = ?"
            		+ " AND PERIODO_ID = TO_NUMBER(?, '99')"
            		+ " AND PAGO_ID = TO_NUMBER(?, '99')");
            
            ps.setString(1, fecha);
            ps.setString(2, descripcion);
            ps.setString(3, tipo);
            ps.setString(4, orden);
            ps.setString(5, fechaVence);
            ps.setString(6, cicloId);
            ps.setString(7, periodoId);
            ps.setString(8, pagoId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinPago|updateReg|:" + ex);
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
        	
            ps = conn.prepareStatement("DELETE FROM FIN_PAGO WHERE CICLO_ID = ? AND PERIODO_ID = TO_NUMBER(?, '99') AND PAGO_ID = TO_NUMBER(?, '99')");
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, pagoId);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinPago|deleteReg|:" + ex);
        }finally{
        	if(ps != null) ps.close();
        }

        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {
        cicloId		= rs.getString("CICLO_ID");
		periodoId	= rs.getString("PERIODO_ID");
		pagoId		= rs.getString("PAGO_ID");
		fecha		= rs.getString("FECHA");
		descripcion	= rs.getString("DESCRIPCION");
		tipo		= rs.getString("TIPO");
		orden 		= rs.getString("ORDEN");
		fechaVence	= rs.getString("FECHA_VENCE");
    }

    public void mapeaRegId(Connection con, String cicloId, String periodoId, String pagoId) throws SQLException{
        ResultSet rs = null;
        PreparedStatement ps = null; 
        try{
	        ps = con.prepareStatement("SELECT CICLO_ID, PERIODO_ID, PAGO_ID, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, DESCRIPCION, TIPO, ORDEN, TO_CHAR(FECHA_VENCE, 'DD/MM/YYYY') AS FECHA_VENCE"
	                + " FROM FIN_PAGO"
	                + " WHERE CICLO_ID = ?"
	                + " AND PERIODO_ID = TO_NUMBER(?,'99')"
	                + " AND PAGO_ID = TO_NUMBER(?, '99')");
	        
	        ps.setString(1, cicloId);
	        ps.setString(2, periodoId);
	        ps.setString(3, pagoId);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }	
	        
        }finally{
        	if(rs != null) rs.close();
	        if(ps != null) ps.close();
	    }
    }
    
    public void mapeaRegInicial(Connection con, String cicloId, String periodoId) throws SQLException{
        ResultSet rs = null;
        PreparedStatement ps = null; 
        try{
	        ps = con.prepareStatement("SELECT CICLO_ID, PERIODO_ID, PAGO_ID, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, DESCRIPCION, TIPO, ORDEN, FECHA_VENCE"
	                + " FROM FIN_PAGO"
	                + " WHERE CICLO_ID = ?"
	                + " AND PERIODO_ID = TO_NUMBER(?, '99')"
	                + " AND TIPO = 'I'");
	        
	        ps.setString(1, cicloId);
	        ps.setString(2, periodoId);	        
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }	
	        
        }finally{
        	if(rs != null) rs.close();
	        if(ps != null) ps.close();
	    }
    }

    public boolean existeReg(Connection conn) throws SQLException {
        boolean ok = false;
        ResultSet rs = null;
        PreparedStatement ps = null;

        try {
            ps = conn.prepareStatement("SELECT * FROM FIN_PAGO WHERE CICLO_ID = ?, AND PERIODO_ID = TO_NUMBER(?, '99') AND PAGO_ID = TO_NUMBER(?, '99')");
            ps = conn.prepareStatement("SELECT * FROM FIN_PAGO WHERE CICLO_ID = ?, AND PERIODO_ID = TO_NUMBER(?,'99') AND PAGO_ID = TO_NUMBER(?,'99')");
            
            ps.setString(1, cicloId);
	        ps.setString(2, periodoId);
	        ps.setString(3, pagoId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinPago|existeReg|:" +ex);
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
    
    public String maximoReg(Connection conn, String cicloId, String periodoId) throws SQLException {
        String maximo			= "X";
        ResultSet rs			= null;
        PreparedStatement ps	= null;

        try {
            ps = conn.prepareStatement("SELECT COALESCE(MAX(PAGO_ID)+1,1) AS MAXIMO FROM FIN_PAGO" +
            	" WHERE CICLO_ID = ? AND PERIODO_ID = TO_NUMBER(?,'99')");
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                maximo = rs.getString("MAXIMO");
            }else
            	maximo = "1";
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinPago|maximoReg|:" +ex);
        }finally{	
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
	    }        
        return maximo;
    }
    
    public static boolean tieneDatos(Connection conn, String cicloId, String periodoId) throws SQLException {
        boolean ok	 			= false;
        ResultSet rs1 			= null;
        PreparedStatement ps1 	= null;

        try {
            ps1 = conn.prepareStatement("SELECT * FROM FIN_CALCULO" +
                    " WHERE CICLO_ID = ?" +
                    " AND PERIODO_ID = TO_NUMBER(?, '99')" +
                    " AND TIPO_PAGO = 'P'" +
                    " AND INSCRITO = 'S'");
            
            ps1.setString(1, cicloId);
            ps1.setString(2, periodoId);
            
            rs1 = ps1.executeQuery();
            if(rs1.next()){
            	ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinPago|tieneDatos|:" +ex);
        }finally{

	        if(rs1 != null){
	            rs1.close();
	        }
	        if(ps1 != null){
	            ps1.close();
	        }
        }	
        return ok;
    }
    
    public static String numPagosIniciales(Connection conn, String cicloId, String periodoId) throws SQLException {       
        
        PreparedStatement ps1 	= null;
        ResultSet rs1 			= null;
        String numPagoInicial	= "0"; 

        try {
            ps1 = conn.prepareStatement("SELECT COUNT(*) AS TOTAL FROM FIN_PAGO" +
                    " WHERE CICLO_ID = ?" +
                    " AND PERIODO_ID = TO_NUMBER(?, '99')" +
                    " AND TIPO = 'I'");
            
            ps1.setString(1, cicloId);
            ps1.setString(2, periodoId);
            
            rs1 = ps1.executeQuery();
            if(rs1.next()){
            	numPagoInicial = rs1.getString("TOTAL");
            }
            
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinPago|tienePagoInicial|:" +ex);
        }finally{

	        if(rs1 != null) rs1.close();
	        if(ps1 != null) ps1.close();
        }
        
        return numPagoInicial;
    }
    
    public static boolean esPagoInicial(Connection conn, String cicloId, String periodoId, String pagoId) throws SQLException {       
        
        PreparedStatement ps1 	= null;
        ResultSet rs1 			= null;
        boolean ok 				= false; 

        try {
            ps1 = conn.prepareStatement("SELECT * FROM FIN_PAGO"
            		+ " WHERE CICLO_ID = ?"
            		+ " AND PERIODO_ID = TO_NUMBER(?, '99')"
            		+ " AND PAGO_ID = TO_NUMBER(?,'99')"
            		+ " AND TIPO = 'I'");
            
            ps1.setString(1, cicloId);
            ps1.setString(2, periodoId);
            ps1.setString(3, pagoId);
            
            rs1 = ps1.executeQuery();
            if(rs1.next()){
            	ok = true;
            }
            
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinPago|esPagoInicial|:" +ex);
        }finally{

	        if(rs1 != null) rs1.close();
	        if(ps1 != null) ps1.close();
        }
        
        return ok;
    }
    
    public static String numPagos(Connection conn, String cicloId, String periodoId, String tipo) throws SQLException {
    	
        PreparedStatement ps1 	= null;
        ResultSet rs 			= null;
        String pagos			= "0";

        try {
            ps1 = conn.prepareStatement("SELECT COALESCE(COUNT(PAGO_ID),0) AS TOTAL FROM FIN_PAGO"
            		+ " WHERE CICLO_ID = ?"
            		+ " AND PERIODO_ID = TO_NUMBER(?, '99')"
            		+ " AND TIPO IN(?)");
            
            ps1.setString(1, cicloId);
            ps1.setString(2, periodoId);
            ps1.setString(3, tipo);
            
            rs = ps1.executeQuery();
            if(rs.next()){
            	pagos = rs.getString("TOTAL"); 
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinPago|numPagos|:" +ex);
        }finally{

	        if(rs != null)	rs.close();
	        if(ps1 != null)	ps1.close();
	    }	
        return pagos;
    }
    
    public static String getDescripcion(Connection conn, String cicloId, String periodoId, String pagoId) throws SQLException {
    	
        PreparedStatement ps1 	= null;
        ResultSet rs 			= null;
        String descripcion		= "-";

        try {
            ps1 = conn.prepareStatement("SELECT COALESCE(DESCRIPCION,'-') AS DESCRIPCION FROM FIN_PAGO" +
                    " WHERE CICLO_ID = ?" +
                    " AND PERIODO_ID = TO_NUMBER(?, '99')" +
                    " AND PAGO_ID = TO_NUMBER(?,'99')");
            
            ps1.setString(1, cicloId);
            ps1.setString(2, periodoId);
            ps1.setString(3, pagoId);
            
            rs = ps1.executeQuery();
            if(rs.next()){
            	descripcion = rs.getString("DESCRIPCION"); 
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinPago|numPagos|:" +ex);
        }finally{

	        if(rs != null)	rs.close();
	        if(ps1 != null)	ps1.close();
	    }	
        return descripcion;
    }
}
