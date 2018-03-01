package aca.fin;

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
	private String becaPorcentaje;
	private String becaCantidad;
	private String importeBeca;
	private String pagoInicialPorcentaje;
	private String importeInicial;
	
	
	public FinCalculoDet(){
		cicloId					= "";
		periodoId				= "";
		codigoId				= "";
		cuentaId				= "";
		fecha 					= "";
		importe					= "0";
		becaPorcentaje 			= "0";
		becaCantidad 			= "0";
		importeBeca 			= "0";
		pagoInicialPorcentaje	= "0";
		importeInicial			= "0";
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

	public String getCuentaId() {
		return cuentaId;
	}

	public void setCuentaId(String cuentaId) {
		this.cuentaId = cuentaId;
	}

	public String getFecha() {
		return fecha;
	}

	public void setFecha(String fecha) {
		this.fecha = fecha;
	}

	public String getImporte() {
		return importe;
	}

	public void setImporte(String importe) {
		this.importe = importe;
	}

	public String getBecaPorcentaje() {
		return becaPorcentaje;
	}

	public void setBecaPorcentaje(String becaPorcentaje) {
		this.becaPorcentaje = becaPorcentaje;
	}

	public String getBecaCantidad() {
		return becaCantidad;
	}

	public void setBecaCantidad(String becaCantidad) {
		this.becaCantidad = becaCantidad;
	}

	public String getImporteBeca() {
		return importeBeca;
	}

	public void setImporteBeca(String importeBeca) {
		this.importeBeca = importeBeca;
	}

	public String getPagoInicialPorcentaje() {
		return pagoInicialPorcentaje;
	}


	public void setPagoInicialPorcentaje(String pagoInicialPorcentaje) {
		this.pagoInicialPorcentaje = pagoInicialPorcentaje;
	}


	public String getImporteInicial() {
		return importeInicial;
	}

	public void setImporteInicial(String importeInicial) {
		this.importeInicial = importeInicial;
	}
	
	


	@Override
	public String toString() {
		return "FinCalculoDet [cicloId=" + cicloId + ", periodoId=" + periodoId + ", codigoId=" + codigoId
				+ ", cuentaId=" + cuentaId + ", fecha=" + fecha + ", importe=" + importe + ", becaPorcentaje="
				+ becaPorcentaje + ", becaCantidad=" + becaCantidad + ", importeBeca=" + importeBeca
				+ ", pagoInicialPorcentaje=" + pagoInicialPorcentaje + ", importeInicial=" + importeInicial + "]";
	}


	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "INSERT INTO FIN_CALCULO_DET( CICLO_ID, PERIODO_ID, CODIGO_ID, CUENTA_ID, FECHA, IMPORTE, BECA_PORCENTAJE, BECA_CANTIDAD, IMPORTE_BECA, PAGO_INICIAL_PORCENTAJE, IMPORTE_INICIAL )" +
                    " VALUES(?, TO_NUMBER(?, '99'), ?, ?," +
                    " TO_DATE(?, 'DD/MM/YYYY'), " +
                    " TO_NUMBER(?, '99999.99')," +
                    " TO_NUMBER(?,'999.99')," +
                    " TO_NUMBER(?, '99999.99')," +
                    " TO_NUMBER(?, '99999.99')," +
                    " TO_NUMBER(?, '999.99')," +
                    " TO_NUMBER(?, '99999.99'))");
            
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, codigoId);
            ps.setString(4, cuentaId);
            ps.setString(5, fecha);
            ps.setString(6, importe);
            ps.setString(7, becaPorcentaje);
            ps.setString(8, becaCantidad);
            ps.setString(9, importeBeca);
            ps.setString(10, pagoInicialPorcentaje);
            ps.setString(11, importeInicial);
            
            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinCalculoDet|insertReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }   
    
    /*
     * Actualiza los valores de pago inicial e importe inicial al 100% del costo en todas las cuentas de un cálculo de cobro de contado
     * */
    public static boolean updateContado(Connection conn, String cicloId, String periodoId, String codigoId) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
        	ps = conn.prepareStatement(
                    "UPDATE FIN_CALCULO_DET" +                    
                    " SET PAGO_INICIAL_PORCENTAJE = 100," +
                    " IMPORTE_INICIAL = IMPORTE-IMPORTE_BECA" +
                    " WHERE CICLO_ID = ? " +
                    " AND PERIODO_ID = TO_NUMBER(?, '99')" +
                    " AND CODIGO_ID = ?");
        	
        	ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, codigoId);

            if(ps.executeUpdate() >= 1){
                ok = true;
            }

            
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinCalculoDet|updateContado|:" + ex);
        }finally{
        	if(ps != null){ ps.close(); }
        }

        return ok;
    }
    
    /*
     * Actualiza el pago inicial e importe inicial al % que corresponda en las cuentas de un cálculo de cobro en pagos
     * */
    public static boolean updatePagos(Connection conn, String cicloId, String periodoId, String codigoId) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
        	ps = conn.prepareStatement(
                    "UPDATE FIN_CALCULO_DET" +                    
                    " SET PAGO_INICIAL_PORCENTAJE = CUENTA_PI(CUENTA_ID)," +
                    " IMPORTE_INICIAL = ((IMPORTE-IMPORTE_BECA)*CUENTA_PI(CUENTA_ID))/100" +
                    " WHERE CICLO_ID = ? " +
                    " AND PERIODO_ID = TO_NUMBER(?, '99')" +
                    " AND CODIGO_ID = ?");
        	
        	ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, codigoId);

            if(ps.executeUpdate() >= 1){
                ok = true;
            }

            
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinCalculoDet|updatePagos|:" + ex);
        }finally{
        	if(ps != null){ ps.close(); }
        }

        return ok;
    }
    
    public boolean updatePago(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
        	ps = conn.prepareStatement(
                    " UPDATE FIN_CALCULO_DET" +                    
                    " SET PAGO_INICIAL_PORCENTAJE = TO_NUMBER(?,'999.99')," +
                    " IMPORTE_INICIAL = TO_NUMBER(?, '99999.99')" +
                    " WHERE CICLO_ID = ? " +
                    " AND PERIODO_ID = TO_NUMBER(?, '99')" +
                    " AND CODIGO_ID = ?"+
                    " AND CUENTA_ID = ?");
        	
        	ps.setString(1, pagoInicialPorcentaje);
        	ps.setString(2, importeInicial);
        	ps.setString(3, cicloId);
            ps.setString(4, periodoId);
            ps.setString(5, codigoId);
            ps.setString(6, cuentaId);

            if(ps.executeUpdate() >= 1){
                ok = true;
            }

            
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinCalculoDet|updatePago|:" + ex);
        }finally{
        	if(ps != null){ ps.close(); }
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
            System.out.println("Error - aca.fin.FinCalculoDet|deleteReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {
        cicloId					= rs.getString("CICLO_ID");
		periodoId				= rs.getString("PERIODO_ID");
		codigoId				= rs.getString("CODIGO_ID");
		cuentaId				= rs.getString("CUENTA_ID");
		fecha   				= rs.getString("FECHA");
		importe					= rs.getString("IMPORTE");
		becaPorcentaje			= rs.getString("BECA_PORCENTAJE");
		becaCantidad			= rs.getString("BECA_CANTIDAD");
		importeBeca				= rs.getString("IMPORTE_BECA");
		pagoInicialPorcentaje	= rs.getString("PAGO_INICIAL_PORCENTAJE");
		importeInicial			= rs.getString("IMPORTE_INICIAL");
    }

    public void mapeaRegId(Connection con, String cicloId, String periodoId, String codigoId, String cuentaId) throws SQLException{
        ResultSet rs = null;
        PreparedStatement ps = null; 
        try{
	        ps = con.prepareStatement(
	                " SELECT CICLO_ID, PERIODO_ID, CODIGO_ID, CUENTA_ID, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, IMPORTE, " +
	                " COALESCE(BECA_PORCENTAJE,0) AS BECA_PORCENTAJE, BECA_CANTIDAD, IMPORTE_BECA, PAGO_INICIAL_PORCENTAJE, IMPORTE_INICIAL" +
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
			System.out.println("Error - aca.fin.FinCalculoDet|mapeaRegId|:"+ex);
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
            System.out.println("Error - aca.fin.FinCalculoDet|existeReg|:" +ex);
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
            System.out.println("Error - aca.fin.FinCalculoDet|getNumDetalles|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return numDetalles;
    }    

}
