/**
 * 
 */
package aca.fin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


public class FinReciboTemp {
	private String reciboId;
	private String fecha;
	private String cliente;
	private String cuentaId;
	private String auxiliar;	
	private String descripcion;
	private String importe;
	private String referencia;
	private String escuelaId;
	private String folio;
	private String formaPago;
	private String beneficiario;
	
	public FinReciboTemp(){
		reciboId		= "";
		fecha			= "";
		cliente			= "";
		cuentaId		= "";
		auxiliar		= "";
		descripcion		= "";
		importe			= "";
		referencia		= "";
		escuelaId		= "";
		folio			= "";
		formaPago		= "";
		beneficiario	= "";
		
	}
	
	public String getReciboId() {
		return reciboId;
	}

	public void setReciboId(String reciboId) {
		this.reciboId = reciboId;
	}

	public String getFecha() {
		return fecha;
	}

	public void setFecha(String fecha) {
		this.fecha = fecha;
	}

	public String getCliente() {
		return cliente;
	}

	public void setCliente(String cliente) {
		this.cliente = cliente;
	}

	public String getCuentaId() {
		return cuentaId;
	}

	public void setCuentaId(String cuendaId) {
		this.cuentaId = cuendaId;
	}

	public String getAuxiliar() {
		return auxiliar;
	}

	public void setAuxiliar(String auxiliar) {
		this.auxiliar = auxiliar;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getImporte() {
		return importe;
	}

	public void setImporte(String importe) {
		this.importe = importe;
	}

	public String getReferencia() {
		return referencia;
	}

	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}

	public String getEscuelaId() {
		return escuelaId;
	}

	public void setEscuelaId(String escuelaId) {
		this.escuelaId = escuelaId;
	}

	public String getFolio() {
		return folio;
	}

	public void setFolio(String folio) {
		this.folio = folio;
	}

	public String getFormaPago() {
		return formaPago;
	}

	public void setFormaPago(String formaPago) {
		this.formaPago = formaPago;
	}
	
	public String getBeneficiario() {
		return beneficiario;
	}

	public void setBeneficiario(String beneficiario) {
		this.beneficiario = beneficiario;
	}

	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "INSERT INTO FIN_RECIBO_TEMP(RECIBO_ID, FECHA, CLIENTE, CUENTA_ID, AUXILIAR,"
                    +" DESCRIPCION, IMPORTE, REFERENCIA, ESCUELA_ID, FOLIO, FORMA_PAGO, BENEFICIARIO)"
                    +" VALUES(TO_NUMBER(?, '9999999'),"
                    +" TO_DATE(?,'DD/MM/YYYY'),"
                    +" ?, ?, ?, ?,"
                    +" TO_NUMBER(?, '99999999.99'),"
                    + "?, ?,"
                    + "TO_NUMBER(?, '99'),?,?)");
            
            ps.setString(1, reciboId);
            ps.setString(2, fecha);
            ps.setString(3, cliente);
            ps.setString(4, cuentaId);
            ps.setString(5, auxiliar);
            ps.setString(6, descripcion);
            ps.setString(7, importe);
            ps.setString(8, referencia);
            ps.setString(9, escuelaId);
            ps.setString(10, folio);
            ps.setString(11, formaPago);
            ps.setString(12, beneficiario);
            
            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FineReciboTemp|insertReg|:" + ex);
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
                    "UPDATE FIN_RECIBO_TEMP" +
                    " SET FECHA = TO_FECHA(?,'DD/MM/YYYY'),"
                    + " CLIENTE = ?,"
                    + " CUENTA_ID = ?,"
                    + " AUXILIAR= ?,"
                    + " DESCRIPCION= ?,"
                    + " IMPORTE= TO_NUMBER(?, 99999999.99),"
                    + " REFERENCIA = ?,"
                    + " ESCUELA_ID = ?,"
                    + " FORMA_PAGO = ?,"
                    + " BENEFICIARIO = ?"
                    + " WHERE RECIBO_ID = TO_NUMBER(?, '9999999') AND FOLIO = TO_NUMBER(?,99) ");
            
            ps.setString(1, fecha);
            ps.setString(2, cliente);
            ps.setString(3, cuentaId);
            ps.setString(4, auxiliar);
            ps.setString(5, descripcion);
            ps.setString(6, importe);
            ps.setString(7, referencia);
            ps.setString(8, escuelaId);
            ps.setString(9, formaPago);
            ps.setString(10, beneficiario);
            ps.setString(11, reciboId);
            ps.setString(12, folio);
            

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FineReciboTemp|updateReg|:" + ex);
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
                    "DELETE FROM FIN_RECIBO_TEMP" +
                    " WHERE RECIBO_ID = TO_NUMBER(?, '99999999') AND FOLIO = TO_NUMBER(?, 99)");
            
            ps.setString(1, reciboId);
            ps.setString(2, folio);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FineReciboTemp|deleteReg|:" + ex);
        }finally{
        	if(ps!=null)ps.close();
        }

        return ok;
    }
    
    
    public boolean deleteReg(Connection conn, String reciboId, String folio) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try {
            ps = conn.prepareStatement(
                    "DELETE FROM FIN_RECIBO_TEMP" +
                    " WHERE RECIBO_ID = TO_NUMBER(?, '9999999') AND FOLIO = TO_NUMBER(?, '99')");
            
            ps.setString(1, reciboId);
            ps.setString(2, folio);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FineReciboTemp|deleteReg|:" + ex);
        }finally{
        	if(ps!=null)ps.close();
        }

        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {
        reciboId		= rs.getString("RECIBO_ID");
		fecha			= rs.getString("FECHA");
		cliente			= rs.getString("CLIENTE");
		cuentaId		= rs.getString("CUENTA_ID");
		auxiliar		= rs.getString("AUXILIAR");
		descripcion		= rs.getString("DESCRIPCION");
		importe			= rs.getString("IMPORTE");
		referencia		= rs.getString("REFERENCIA");
		escuelaId		= rs.getString("ESCUELA_ID");
		folio			= rs.getString("FOLIO");
		formaPago		= rs.getString("FORMA_PAGO");
		beneficiario	= rs.getString("BENEyFICIARIO");
    }

    public void mapeaRegId(Connection con, String reciboId, String folio) throws SQLException{
        ResultSet rs = null;
        PreparedStatement ps = null; 
        try{
	        ps = con.prepareStatement(
	                "SELECT RECIBO_ID, FECHA, CLIENTE, CUENTA_ID, AUXILIAR, DESCRIPCION, IMPORTE, REFERENCIA, ESCUELA_ID, FOLIO, FORMA_PAGO, BENEFICIARIO" +
	                " FROM FIN_RECIBO_TEMP" +
	                " WHERE RECIBO_ID = TO_NUMBER(?, '99999999') AND FOLIO = TO_NUMBER(?, 99)");        
	        ps.setString(1, reciboId);
	        ps.setString(2, folio);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.fin.FinRecibido|mapeaRegId|:"+ex);
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
            ps = conn.prepareStatement("SELECT * FROM FIN_RECIBO_TEMP" +
                    " WHERE RECIBO_ID = TO_NUMBER(?, '9999999') AND FOLIO = TO_NUMBER(?, 99) ");
            
            ps.setString(1, reciboId);
            ps.setString(2, folio);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FineReciboTemp|existeReg|:" +ex);
        }finally{
	        if(rs!=null)rs.close();	
	        if(ps!=null)ps.close();
        }

        return ok;
    }
       
}