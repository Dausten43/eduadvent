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
public class FinRecibo {
	private String reciboId;
	private String importe;
	private String fecha;
	private String cliente;
	private String domicilio;
	private String cheque;
	private String banco;
	private String observaciones;
	private String usuario;
	private String rfc;
	private String tipo;
	
	public FinRecibo(){
		reciboId		= "";
		importe			= "";
		fecha			= "";
		cliente			= "";
		domicilio		= "";
		cheque			= "";
		banco			= "";
		observaciones	= "";
		usuario			= "";
		rfc				= "";
		tipo 			= "";
	}

	/**
	 * @return the banco
	 */
	public String getBanco() {
		return banco;
	}

	/**
	 * @param banco the banco to set
	 */
	public void setBanco(String banco) {
		this.banco = banco;
	}

	/**
	 * @return the cheque
	 */
	public String getCheque() {
		return cheque;
	}

	/**
	 * @param cheque the cheque to set
	 */
	public void setCheque(String cheque) {
		this.cheque = cheque;
	}

	/**
	 * @return the cliente
	 */
	public String getCliente() {
		return cliente;
	}

	/**
	 * @param cliente the cliente to set
	 */
	public void setCliente(String cliente) {
		this.cliente = cliente;
	}

	/**
	 * @return the domicilio
	 */
	public String getDomicilio() {
		return domicilio;
	}

	/**
	 * @param domicilio the domicilio to set
	 */
	public void setDomicilio(String domicilio) {
		this.domicilio = domicilio;
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
	 * @return the observaciones
	 */
	public String getObservaciones() {
		return observaciones;
	}

	/**
	 * @param observaciones the observaciones to set
	 */
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
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
	 * @return the rfc
	 */
	public String getRfc() {
		return rfc;
	}

	/**
	 * @param rfc the rfc to set
	 */
	public void setRfc(String rfc) {
		this.rfc = rfc;
	}

	/**
	 * @return the usuario
	 */
	public String getUsuario() {
		return usuario;
	}

	/**
	 * @param usuario the usuario to set
	 */
	public void setUsuario(String usuario) {
		this.usuario = usuario;
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

	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "INSERT INTO FIN_RECIBO(RECIBO_ID, IMPORTE, FECHA, CLIENTE," +
                    " DOMICILIO, CHEQUE, BANCO, OBSERVACIONES, USUARIO, RFC, TIPO)" +
                    " VALUES(TO_NUMBER(?, '9999999')," +
                    " TO_NUMBER(?, '999999.99')," +
                    " TO_DATE(?, 'DD/MM/YYYY')," +
                    " ?, ?, ?, ?, ?, ?, ?, ?)");
            
            ps.setString(1, reciboId);
            ps.setString(2, importe);
            ps.setString(3, fecha);
            ps.setString(4, cliente);
            ps.setString(5, domicilio);
            ps.setString(6, cheque);
            ps.setString(7, banco);
            ps.setString(8, observaciones);
            ps.setString(9, usuario);
            ps.setString(10, rfc);
            ps.setString(11, tipo);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.financiero.FinRecibo|insertReg|:" + ex);
        }finally{
        	if(ps!=null) ps.close();
        }

        return ok;
    }

    public boolean updateReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "UPDATE FIN_RECIBO" +
                    " SET IMPORTE = TO_NUMBER(?, '999999.99')," +
                    " FECHA = TO_DATE(?, 'DD/MM/YYYY')," +
                    " CLIENTE = ?," +
                    " DOMICILIO = ?," +
                    " CHEQUE = ?," +
                    " BANCO = ?," +
                    " OBSERVACIONES = ?," +
                    " USUARIO = ?," +
                    " RFC = ?," +
                    " TIPO = ?" +
                    " WHERE RECIBO_ID = TO_NUMBER(?, '9999999')");
            
            ps.setString(1, importe);
            ps.setString(2, fecha);
            ps.setString(3, cliente);
            ps.setString(4, domicilio);
            ps.setString(5, cheque);
            ps.setString(6, banco);
            ps.setString(7, observaciones);
            ps.setString(8, usuario);
            ps.setString(9, rfc);
            ps.setString(10, tipo);
            ps.setString(11, reciboId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.financiero.FinRecibo|updateReg|:" + ex);
        }finally{
        	if(ps!=null)ps.close();
        }

        return ok;
    }
    
    public static boolean updateImporte(Connection conn, String reciboId, String importe) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "UPDATE FIN_RECIBO" +
                    " SET IMPORTE = TO_NUMBER(?, '999999.99')" +   
                    " WHERE RECIBO_ID = TO_NUMBER(?, '9999999')");
            
            ps.setString(1, importe);            
            ps.setString(2, reciboId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.financiero.FinRecibo|updateImporte|:" + ex);
        }finally{
        	if(ps!=null)ps.close();
        }

        return ok;
    }

    public boolean deleteReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try {
            ps = conn.prepareStatement(
                    "DELETE FROM FIN_RECIBO" +
                    " WHERE RECIBO_ID = TO_NUMBER(?, '9999999')");
            
            ps.setString(1, reciboId);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.financiero.FinRecibo|deleteReg|:" + ex);
        }finally{
        	if(ps!=null)ps.close();
        }

        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {
        reciboId		= rs.getString("RECIBO_ID");
		importe			= rs.getString("IMPORTE");
		fecha			= rs.getString("FECHA");
		cliente			= rs.getString("CLIENTE");
		domicilio		= rs.getString("DOMICILIO");
		cheque			= rs.getString("CHEQUE");
		banco			= rs.getString("BANCO");
		observaciones	= rs.getString("OBSERVACIONES");
		usuario			= rs.getString("USUARIO");
		rfc				= rs.getString("RFC");
		tipo			= rs.getString("TIPO");
    }

    public void mapeaRegId(Connection con, String reciboId) throws SQLException{
        ResultSet rs = null;
        PreparedStatement ps = null; 
        try{
	        ps = con.prepareStatement(
	                "SELECT RECIBO_ID, IMPORTE, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, CLIENTE," +
	                " DOMICILIO, CHEQUE, BANCO, OBSERVACIONES, USUARIO, RFC, TIPO" +
	                " FROM FIN_RECIBO" +
	                " WHERE RECIBO_ID = TO_NUMBER(?, '999999.99')");        
	        ps.setString(1, reciboId);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.financiero.FinRecibido|mapeaRegId|:"+ex);
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
            ps = conn.prepareStatement("SELECT * FROM FIN_RECIBO" +
                    " WHERE RECIBO_ID = TO_NUMBER(?, '9999999')");
            
            ps.setString(1, reciboId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.financiero.FinRecibo|existeReg|:" +ex);
        }finally{
	        if(rs!=null)rs.close();	
	        if(ps!=null)ps.close();
        }

        return ok;
    }
    
    public static String sumaConceptos(Connection conn, String reciboId) throws SQLException {
        
        ResultSet rs			= null;
        PreparedStatement ps	= null;
        String suma				= "";

        try {
            ps = conn.prepareStatement("SELECT COALESCE(SUM(IMPORTE), 0) AS SUMA FROM FIN_RECIBODET WHERE RECIBO_ID = '"+reciboId+"'");
            
            rs = ps.executeQuery();
            if(rs.next()){
                suma = rs.getString("SUMA");
            }
            
        }catch(Exception ex){
            System.out.println("Error - aca.financiero.FinRecibo|maximoReg|:" +ex);
        }finally{
	        if(rs!=null)rs.close();	
	        if(ps!=null)ps.close();
        }

        return suma;
    }    
    
    public static String totalNivel(Connection conn, String fecha, String nivelId, String tipo) throws SQLException {
        
        ResultSet rs			= null;
        PreparedStatement ps	= null;
        String suma				= "";

        try {
            ps = conn.prepareStatement( "SELECT COALESCE(SUM(IMPORTE),0) AS SUMA FROM FIN_RECIBODET" +
            	" WHERE (SELECT FECHA FROM FIN_RECIBO WHERE RECIBO_ID = FIN_RECIBODET.RECIBO_ID) = TO_DATE('"+fecha+"','DD/MM/YYYY')" +
            	" AND (SELECT TIPO FROM FIN_RECIBO WHERE RECIBO_ID = FIN_RECIBODET.RECIBO_ID) = '"+tipo+"'" +
            	" AND (SELECT NIVEL_ID FROM ALUM_PERSONAL WHERE CODIGO_ID = FIN_RECIBODET.CODIGO_ID)= '"+nivelId+"'");
            
            rs = ps.executeQuery();
            if(rs.next()){
                suma = rs.getString("SUMA");
            }
            
        }catch(Exception ex){
            System.out.println("Error - aca.financiero.FinRecibo|totalNivel|:" +ex);
        }finally{
	        if(rs!=null)rs.close();	
	        if(ps!=null)ps.close();
        }

        return suma;
    }
   
    
}