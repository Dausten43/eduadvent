package aca.fin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class FinCuenta {
	private String escuelaId;
	private String cuentaId;
	private String cuentaNombre;
	private String cuentaSunPlus;
	private String beca;
	private String tipo;
	private String pagoInicial;
	
	public FinCuenta(){
		escuelaId		= "0";
		cuentaId		= "";
		cuentaNombre	= "";
		cuentaSunPlus	= "";
		beca			= "N";
		tipo			= "";
		pagoInicial		= "0";
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
	 * @return the cuentaNombre
	 */
	public String getCuentaNombre() {
		return cuentaNombre;
	}

	/**
	 * @param cuentaNombre the cuentaNombre to set
	 */
	public void setCuentaNombre(String cuentaNombre) {
		this.cuentaNombre = cuentaNombre;
	}	

	/**
	 * @return the cuentaSunPlus
	 */
	public String getCuentaSunPlus() {
		return cuentaSunPlus;
	}

	/**
	 * @param cuentaSunPlus the cuentaSunPlus to set
	 */
	public void setCuentaSunPlus(String cuentaSunPlus) {
		this.cuentaSunPlus = cuentaSunPlus;
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
	

	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "INSERT INTO FIN_CUENTA(ESCUELA_ID, CUENTA_ID, CUENTA_NOMBRE, CUENTA_SUNPLUS, BECA, TIPO, PAGO_INICIAL)" +
                    " VALUES(?, ?, ?, ?, ?, ?, TO_NUMBER(?,'999.99'))");
            
            ps.setString(1, escuelaId);
            ps.setString(2, cuentaId);
            ps.setString(3, cuentaNombre);
            ps.setString(4, cuentaSunPlus);
            ps.setString(5, beca);
            ps.setString(6, tipo);
            ps.setString(7, pagoInicial);
            
            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinCuenta|insertReg|:" + ex);
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
            ps = conn.prepareStatement(" UPDATE FIN_CUENTA " +
            	" SET CUENTA_NOMBRE = ?, CUENTA_SUNPLUS = ?, ESCUELA_ID = ?, BECA = ?, TIPO = ?, PAGO_INICIAL = TO_NUMBER(?,'999.99')" +
            	" WHERE CUENTA_ID = ?");
            ps.setString(1, cuentaNombre);
            ps.setString(2, cuentaSunPlus);
            ps.setString(3, escuelaId);
            ps.setString(4, beca);
            ps.setString(5, tipo);
            ps.setString(6, pagoInicial);
            ps.setString(7, cuentaId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinCuenta|updateReg|:" + ex);
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
            ps = conn.prepareStatement("DELETE FROM FIN_CUENTA WHERE CUENTA_ID = ?");            
            ps.setString(1, cuentaId);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinCuenta|deleteReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {
        escuelaId		= rs.getString("ESCUELA_ID");
		cuentaId		= rs.getString("CUENTA_ID");
		cuentaNombre	= rs.getString("CUENTA_NOMBRE");
		cuentaSunPlus	= rs.getString("CUENTA_SUNPLUS");
		beca			= rs.getString("BECA");
		tipo			= rs.getString("TIPO");
		pagoInicial		= rs.getString("PAGO_INICIAL");
    }
        
    public void mapeaRegId(Connection con, String cuentaId) throws SQLException{
        ResultSet rs = null;
        PreparedStatement ps = null; 
        try{
	        ps = con.prepareStatement("SELECT ESCUELA_ID, CUENTA_ID, CUENTA_NOMBRE, CUENTA_SUNPLUS, BECA," +
	        		" COALESCE(TIPO,'-') AS TIPO, COALESCE(PAGO_INICIAL,0) AS PAGO_INICIAL" +
	        		" FROM FIN_CUENTA WHERE CUENTA_ID = ?");
	        ps.setString(1, cuentaId); 
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.fin.FinCuenta|mapeaRegId|:"+ex);
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
            ps = conn.prepareStatement("SELECT * FROM FIN_CUENTA WHERE CUENTA_ID = ?");            
            ps.setString(1, cuentaId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCuenta|existeReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return ok;
    }
    
    public boolean existeReg(Connection conn, String cuentaId) throws SQLException {
        boolean ok = false;
        ResultSet rs = null;
        PreparedStatement ps = null;

        try {
            ps = conn.prepareStatement("SELECT * FROM FIN_CUENTA WHERE CUENTA_ID = ?");
            ps.setString(1, cuentaId);   
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCuenta|existeReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return ok;
    }    
    
    public String maxReg(Connection conn, String escuelaId) throws SQLException {
        String maximo			= "01";
        ResultSet rs			= null;
        PreparedStatement ps	= null;

        try {
        	if (escuelaId.length()==1) escuelaId = "0"+escuelaId;
        	maximo = escuelaId+maximo;
            ps = conn.prepareStatement("SELECT TRIM(COALESCE(TO_CHAR(MAX(TO_NUMBER(SUBSTRING(CUENTA_ID,4,3),'999'))+1,'000'),'001')) AS MAXIMO" +
            		" FROM FIN_CUENTA WHERE ESCUELA_ID = ?");
            ps.setString(1, escuelaId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                maximo = escuelaId + rs.getString("MAXIMO");
            }            
           
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCuenta|existeReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return maximo;
    }
    
    public static String getCuentaNombre(Connection conn, String cuentaId) throws SQLException {
    	PreparedStatement ps 	= null;
    	ResultSet rs 			= null;
        String cuenta			= "X";

        try {
            ps = conn.prepareStatement("SELECT CUENTA_NOMBRE FROM FIN_CUENTA WHERE CUENTA_ID = ?");
            ps.setString(1, cuentaId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                cuenta = rs.getString("CUENTA_NOMBRE");
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCuenta|getCuentaNombre|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return cuenta;
    }
    
    public static String getCuentaSunPlus(Connection conn, String cuentaId) throws SQLException {
    	PreparedStatement ps 	= null;
    	ResultSet rs 			= null;
        String cuenta			= "X";

        try {
            ps = conn.prepareStatement("SELECT CUENTA_SUNPLUS FROM FIN_CUENTA WHERE CUENTA_ID = ?");
            ps.setString(1, cuentaId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                cuenta = rs.getString("CUENTA_SUNPLUS");
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCuenta|getCuentaSunPlus|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return cuenta;
    }
    
}
