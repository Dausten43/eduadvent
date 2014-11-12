/**
 * 
 */
package aca.financiero.copy;

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
	
	public FinPago(){
		cicloId		= "";
		periodoId	= "";
		pagoId		= "";
		fecha		= "";
		descripcion	= "";
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
	
	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "INSERT INTO FIN_PAGO(CICLO_ID, PERIODO_ID, PAGO_ID, FECHA, DESCRIPCION)" +
                    " VALUES(?, TO_NUMBER(?, '99'), TO_NUMBER(?, '9999999')," +
                    " TO_DATE(?, 'DD/MM/YYYY'), ?)");
            
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, pagoId);
            ps.setString(4, fecha);
            ps.setString(5, descripcion);

            if(ps.executeUpdate() == 1){
                ok = true;
            }

            
        }catch (Exception ex){
            System.out.println("Error - aca.financiero.FinPago|insertReg|:" + ex);
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
                    "UPDATE FIN_PAGO" +
                    " SET CICLO_ID = ?," +
                    " PERIODO_ID = TO_NUMBER(?, '99')," +
                    " FECHA = TO_DATE(?, 'DD/MM/YYYY')," +
                    " DESCRIPCION = ?" +
                    " WHERE PAGO_ID = TO_NUMBER(?, '9999999')");
            
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, fecha);
            ps.setString(4, descripcion);
            ps.setString(5, pagoId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.financiero.FinPago|updateReg|:" + ex);
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
                    "DELETE FROM FIN_PAGO" +
                    " WHERE PAGO_ID = TO_NUMBER(?, '9999999')");
            
            ps.setString(1, pagoId);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.financiero.FinPago|deleteReg|:" + ex);
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
		pagoId		= rs.getString("PAGO_ID");
		fecha		= rs.getString("FECHA");
		descripcion	= rs.getString("DESCRIPCION");
    }

    public void mapeaRegId(Connection con, String pagoId) throws SQLException{
        ResultSet rs = null;
        PreparedStatement ps = null; 
        try{
	        ps = con.prepareStatement(
	                "SELECT CICLO_ID, PERIODO_ID, PAGO_ID, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, DESCRIPCION" +
	                " FROM FIN_PAGO" +
	                " WHERE PAGO_ID = TO_NUMBER(?, '9999999')");
	        
	        ps.setString(1, pagoId);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
	
	        if(rs != null){
	            rs.close();
	        }
        }finally{
	        if(ps != null){
	            ps.close();
	        }
        }
    }

    public boolean existeReg(Connection conn) throws SQLException {
        boolean ok = false;
        ResultSet rs = null;
        PreparedStatement ps = null;

        try {
            ps = conn.prepareStatement("SELECT * FROM FIN_PAGO" +
                    " WHERE PAGO_ID = TO_NUMBER(?, '9999999')");
            
            ps.setString(1, pagoId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.financiero.FinPago|existeReg|:" +ex);
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
    
    public String maximoReg(Connection conn) throws SQLException {
        String maximo			= "X";
        ResultSet rs			= null;
        PreparedStatement ps	= null;

        try {
            ps = conn.prepareStatement("SELECT COALESCE(CICLO_ID)+1,'1') AS MAXIMO FROM FIN_PAGO");
            
            rs = ps.executeQuery();
            if(rs.next()){
                maximo = rs.getString("MAXIMO");
            }else
            	maximo = "1";
        }catch(Exception ex){
            System.out.println("Error - aca.financiero.FinPago|maximoReg|:" +ex);
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
            System.out.println("Error - aca.financiero.FinPago|tieneDatos|:" +ex);
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
}
