/**
 * 
 */
package aca.cont;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Administrador
 *
 */
public class ContMascara {
	private String mascaraId;
	private String mascBalance;
	private String mascResultado;
	private String mascCcosto;
	private String nivelContable;
	
	public ContMascara(){
		mascaraId		= "";
		mascBalance		= "";
		mascResultado	= "";
		mascCcosto		= "";
		nivelContable	= "";
	}

	/**
	 * @return the mascaraId
	 */
	public String getMascaraId() {
		return mascaraId;
	}

	/**
	 * @param mascaraId the mascaraId to set
	 */
	public void setMascaraId(String mascaraId) {
		this.mascaraId = mascaraId;
	}

	/**
	 * @return the mascBalance
	 */
	public String getMascBalance() {
		return mascBalance;
	}

	/**
	 * @param mascBalance the mascBalance to set
	 */
	public void setMascBalance(String mascBalance) {
		this.mascBalance = mascBalance;
	}

	/**
	 * @return the mascResultado
	 */
	public String getMascResultado() {
		return mascResultado;
	}

	/**
	 * @param mascResultado the mascResultado to set
	 */
	public void setMascResultado(String mascResultado) {
		this.mascResultado = mascResultado;
	}

	/**
	 * @return the mascCcosto
	 */
	public String getMascCcosto() {
		return mascCcosto;
	}

	/**
	 * @param mascCcosto the mascCcosto to set
	 */
	public void setMascCcosto(String mascCcosto) {
		this.mascCcosto = mascCcosto;
	}

	/**
	 * @return the nivelContable
	 */
	public String getNivelContable() {
		return nivelContable;
	}

	/**
	 * @param nivelContable the nivelContable to set
	 */
	public void setNivelContable(String nivelContable) {
		this.nivelContable = nivelContable;
	}
	
	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    " INSERT INTO CONT_MASCARA(MASCARA_ID, MASC_BALANCE, MASC_RESULTADO," +
                    " MASC_CCOSTO, NIVEL_CONTABLE)" +
                    " VALUES(TO_NUMBER(?, '99'), ?, ?," +
                    " ?, TO_NUMBER(?, '99'))");
            
            ps.setString(1, mascaraId);
            ps.setString(2, mascBalance);
            ps.setString(3, mascResultado);
            ps.setString(4, mascCcosto);
            ps.setString(5, nivelContable);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContMascara|insertReg|:" + ex);
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
                    "UPDATE CONT_MASCARA " + 
                    " SET MASC_BALANCE = ?," +
                    " MASC_RESULTADO = ?," +
                    " MASC_CCOSTO = ?," +
                    " NIVEL_CONTABLE = TO_NUMBER(?, '99')" +
                    " WHERE MASCARA_ID = TO_NUMBER(?, '99')");
            
            ps.setString(1, mascBalance);
            ps.setString(2, mascResultado);
            ps.setString(3, mascCcosto);
            ps.setString(4, nivelContable);
            ps.setString(5, mascaraId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContMascara|updateReg|:" + ex);
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
                    " DELETE FROM CONT_MASCARA" +
                    " WHERE MASCARA_ID = ?");
            ps.setString(1, mascaraId);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }            
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContMascara|deleteReg|:" + ex);
        }finally{        	
        	if(ps != null){ ps.close(); }
        }

        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {
		mascaraId		= rs.getString("MASCARA_ID");
		mascBalance		= rs.getString("MASC_BALANCE");
		mascResultado	= rs.getString("MASC_RESULTADO");
		mascCcosto		= rs.getString("MASC_CCOSTO");
		nivelContable	= rs.getString("NIVEL_CONTABLE");
    }

    public void mapeaRegId(Connection con, String mascaraId) throws SQLException{
    	PreparedStatement ps = null;
    	ResultSet rs = null;
        try{
	        ps = con.prepareStatement(
	                " SELECT MASCARA_ID, MASC_BALANCE, MASC_RESULTADO," +
	                " MASC_CCOSTO, NIVEL_CONTABLE" +
	                " FROM CONT_MASCARA" +
	                " WHERE MASCARA_ID = TO_NUMBER(?, '99')");
	        ps.setString(1, mascaraId);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.cont.ContMascara|mapeaRegId|:"+ex);
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
        	ps = conn.prepareStatement("SELECT MASCARA_ID FROM CONT_MASCARA" +
            		" WHERE MASCARA_ID = ?");
            ps.setString(1, mascaraId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.cont.ContMascara|existeReg|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return ok;
    }
    
    //pendienteeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
    public String maxReg(Connection conn, String cicloId) throws SQLException {
        String maximo			= "";
        ResultSet rs			= null;
        PreparedStatement ps	= null;

        try {
        	ps = conn.prepareStatement("SELECT COALESCE(MAX(MASCARA_ID)+1,'1') AS MAXIMO FROM CONT_MASCARA");
            
            rs = ps.executeQuery();
            if(rs.next()){
                maximo = rs.getString("MAXIMO");
            }else
            	maximo = "1";
        }catch(Exception ex){
            System.out.println("Error - aca.cont.ContMascara|maxReg|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return maximo;
    }
}
