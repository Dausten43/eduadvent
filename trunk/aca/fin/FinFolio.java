package aca.fin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class FinFolio {
	
	private String ejercicioId;
	private String usuario;
	private String reciboInicial;
	private String reciboFinal;
	private String reciboActual;
	
	public FinFolio(){
		ejercicioId		= "";
		usuario			= "";
		reciboInicial	= "";
		reciboFinal		= "";
		reciboActual	= "-1";
	}
	
	/**
	 * @return the ejercicioId
	 */
	public String getEjercicioId() {
		return ejercicioId;
	}

	/**
	 * @param ejercicioId the ejercicioId to set
	 */
	public void setEjercicioId(String ejercicioId) {
		this.ejercicioId = ejercicioId;
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
	 * @return the reciboInicial
	 */
	public String getReciboInicial() {
		return reciboInicial;
	}

	/**
	 * @param reciboInicial the reciboInicial to set
	 */
	public void setReciboInicial(String reciboInicial) {
		this.reciboInicial = reciboInicial;
	}

	/**
	 * @return the reciboFinal
	 */
	public String getReciboFinal() {
		return reciboFinal;
	}

	/**
	 * @param reciboFinal the reciboFinal to set
	 */
	public void setReciboFinal(String reciboFinal) {
		this.reciboFinal = reciboFinal;
	}

	/**
	 * @return the reciboActual
	 */
	public String getReciboActual() {
		return reciboActual;
	}

	/**
	 * @param reciboActual the reciboActual to set
	 */
	public void setReciboActual(String reciboActual) {
		this.reciboActual = reciboActual;
	}

	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "INSERT INTO FIN_FOLIO(EJERCICIO_ID, USUARIO, RECIBO_INICIAL, RECIBO_FINAL, RECIBO_ACTUAL)" +
                    " VALUES(?, ?, TO_NUMBER(?, '9999999'), TO_NUMBER(?, '9999999'), TO_NUMBER(?, '9999999'))");
           
            ps.setString(1, ejercicioId);           
            ps.setString(2, usuario);
            ps.setString(3, reciboInicial);
            ps.setString(4, reciboFinal);
            ps.setString(5, reciboActual);
            
            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinFolio|insertReg|:" + ex);
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
            ps = conn.prepareStatement("UPDATE FIN_FOLIO SET RECIBO_INICIAL = TO_NUMBER(?, '9999999'), " +
            		"RECIBO_FINAL  = TO_NUMBER(?, '9999999') WHERE EJERCICIO_ID = ? AND USUARIO = ?");            
            ps.setString(1, reciboInicial);
            ps.setString(2, reciboFinal);
            ps.setString(3, ejercicioId);
            ps.setString(4, usuario);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinFolio|updateReg|:" + ex);
        }finally{
        	 if(ps != null){
                 ps.close();
             }
        }

        return ok;
    }

    public boolean updateReciboActual(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement("UPDATE FIN_FOLIO "
            		+ " SET RECIBO_ACTUAL = TO_NUMBER(?, '9999999') "
            		+ " WHERE EJERCICIO_ID = ? AND USUARIO = ?");            
            
            ps.setString(1, reciboActual);
            ps.setString(2, ejercicioId);
            ps.setString(3, usuario);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinFolio|updateReciboActual|:" + ex);
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
            ps = conn.prepareStatement("DELETE FROM FIN_FOLIO WHERE EJERCICIO_ID = ? AND USUARIO = ?");            
            ps.setString(1, ejercicioId);
            ps.setString(2, usuario);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }

            
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinFolio|deleteReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {
        ejercicioId		= rs.getString("EJERCICIO_ID");
        usuario			= rs.getString("USUARIO");
		reciboInicial	= rs.getString("RECIBO_INICIAL");
		reciboFinal		= rs.getString("RECIBO_FINAL");
		reciboActual	= rs.getString("RECIBO_ACTUAL");
    }
        
    public void mapeaRegId(Connection conn, String ejercicioId, String usuario) throws SQLException{
        ResultSet rs = null;
        PreparedStatement ps = null; 
        try{
	        ps = conn.prepareStatement("SELECT EJERCICIO_ID, USUARIO, RECIBO_INICIAL, RECIBO_FINAL, RECIBO_ACTUAL FROM FIN_FOLIO WHERE EJERCICIO_ID = ? AND USUARIO = ?");
	        ps.setString(1, ejercicioId);
	        ps.setString(2, usuario);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.fin.FinFolio|mapeaRegId|:"+ex);
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
            ps = conn.prepareStatement("SELECT * FROM FIN_FOLIO WHERE EJERCICIO_ID = ? AND USUARIO = ?");            
            ps.setString(1, ejercicioId);
            ps.setString(2, usuario);
            
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinFolio|existeReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        
        return ok;
    } 
}
