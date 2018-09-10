package aca.fin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class FinCuentas {
	
	private String cuentaId;
	private String cuentaNombre;
	private String escuelaId;
	
	public String getCuentaId() {
		return cuentaId;
	}
	public void setCuentaId(String cuentaId) {
		this.cuentaId = cuentaId;
	}
	public String getCuentaNombre() {
		return cuentaNombre;
	}
	public void setCuentaNombre(String cuentaNombre) {
		this.cuentaNombre = cuentaNombre;
	}
	public String getEscuelaId() {
		return escuelaId;
	}
	public void setEscuelaId(String escuelaId) {
		this.escuelaId = escuelaId;
	}
	
	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "INSERT INTO FIN_CUENTAS(CUENTA_ID, CUENTA_NOMBRE, ESCUELA_ID)" +
                    " VALUES(?, ?, ?)");
            
            ps.setString(1, cuentaId);
            ps.setString(2, cuentaNombre);
            ps.setString(3, escuelaId);
            
            if(ps.executeUpdate()==1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinCuentas|insertReg|:" + ex);
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
                    " UPDATE FIN_CUENTAS" +
                    " SET CUENTA_NOMBRE = ?, ESCUELA_ID = ? "+
                    " WHERE CUENTA_ID = ?");
            ps.setString(1, cuentaNombre);
            ps.setString(2, escuelaId);
            ps.setString(3, cuentaId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
            
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinCuentas|updateReg|:" + ex);
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
                    " DELETE FROM FIN_CUENTAS " +
                    " WHERE CUENTA_ID = ?");
            
            ps.setString(1, cuentaId);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinCuentas|deleteReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }
	
	public void mapeaReg(ResultSet rs) throws SQLException {
        cuentaId			= rs.getString("CUENTA_ID");
		cuentaNombre		= rs.getString("CUENTA_NOMBRE");
		escuelaId			= rs.getString("ESCUELA_ID");
    }

    public void mapeaRegId(Connection con, String cuentaId) throws SQLException{
        ResultSet rs = null;
        PreparedStatement ps = null; 
        try{
	        ps = con.prepareStatement(
	                " SELECT * " +
	                " FROM FIN_CUENTAS" +
	                " WHERE CUENTA_ID = ?");
	        ps.setString(1, cuentaId);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.fin.FinCuentas|mapeaRegId|:"+ex);
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
            ps = conn.prepareStatement("SELECT * FROM FIN_CUENTAS" +
            		" WHERE CUENTA_ID = ?");
	        ps.setString(1, cuentaId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCuentas|existeReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return ok;
    }
}