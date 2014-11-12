package aca.fin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class FinFolios {
	
	private String ejercicioId;
	private String polizaId;
	private String usuario;
	private String recibo;
	
	public String getEjercicioId() {
		return ejercicioId;
	}
	public void setEjercicioId(String ejercicioId) {
		this.ejercicioId = ejercicioId;
	}
	public String getPolizaId() {
		return polizaId;
	}
	public void setPolizaId(String polizaId) {
		this.polizaId = polizaId;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getRecibo() {
		return recibo;
	}
	public void setRecibo(String recibo) {
		this.recibo = recibo;
	}
	
	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "INSERT INTO FIN_FOLIOS(EJERCICIO_ID, POLIZA_ID, USUARIO, RECIBO)" +
                    " VALUES(?, ?, ?, ?)");
            
            ps.setString(1, ejercicioId);
            ps.setString(2, polizaId);
            ps.setString(3, usuario);
            ps.setString(4, recibo);
            
            if(ps.executeUpdate()==1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinFolios|insertReg|:" + ex);
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
                    " UPDATE FIN_FOLIOS" +
                    " SET USUARIO = ?," +
                    " RECIBO = ?" +
                    " WHERE EJERCICIO_ID = ?" +
                    " AND POLIZA_ID = ?");
            ps.setString(1, usuario);
            ps.setString(2, recibo);
            ps.setString(3, ejercicioId);
            ps.setString(4, polizaId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
            
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinFolios|updateReg|:" + ex);
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
                    " DELETE FROM FIN_FOLIOS " +
                    " WHERE EJERCICIO_ID = ?" +
                    " AND POLIZA_ID = ?");
            
            ps.setString(1, ejercicioId);
            ps.setString(2, polizaId);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinFolios|deleteReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }
	
	public void mapeaReg(ResultSet rs) throws SQLException {
        ejercicioId		= rs.getString("EJERCICIO_ID");
		polizaId		= rs.getString("POLIZA_ID");
		usuario   		= rs.getString("USUARIO");
		recibo			= rs.getString("RECIBO");
    }

    public void mapeaRegId(Connection con, String ejercicioId, String polizaId) throws SQLException{
        ResultSet rs = null;
        PreparedStatement ps = null; 
        try{
	        ps = con.prepareStatement(
	                " SELECT EJERCICIO_ID, POLIZA_ID, USUARIO, RECIBO" +
	                " FROM FIN_FOLIOS" +
	                " WHERE EJERCICIO_ID = ?" +
	                " AND POLIZA_ID = ?");
	        ps.setString(1, ejercicioId);
	        ps.setString(2, polizaId);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.fin.FinFolios|mapeaRegId|:"+ex);
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
            ps = conn.prepareStatement("SELECT * FROM FIN_FOLIOS" +
            		" WHERE EJERCICIO_ID = ?" +
            		" AND POLIZA_ID = ?");
	        ps.setString(1, ejercicioId);
	        ps.setString(2, polizaId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinFolios|existeReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return ok;
    }
}