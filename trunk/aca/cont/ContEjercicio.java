/**
 * 
 */
package aca.cont;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Elifo
 *
 */
public class ContEjercicio {
	private String ejercicioId;
	private String ejercicioNombre;
	private String estado;
	
	public ContEjercicio(){
		ejercicioId			= "";
		ejercicioNombre		= "";
		estado				= "";
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
	 * @return the ejercicioNombre
	 */
	public String getEjercicioNombre() {
		return ejercicioNombre;
	}

	/**
	 * @param ejercicioNombre the ejercicioNombre to set
	 */
	public void setEjercicioNombre(String ejercicioNombre) {
		this.ejercicioNombre = ejercicioNombre;
	}

	/**
	 * @return the estado
	 */
	public String getEstado() {
		return estado;
	}

	/**
	 * @param estado the estado to set
	 */
	public void setEstado(String estado) {
		this.estado = estado;
	}
	
	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    " INSERT INTO CONT_EJERCICIO(EJERCICIO_ID, EJERCICIO_NOMBRE, ESTADO)" +
                    " VALUES(?, ?, ?)");   
            ps.setString(1, ejercicioId);
            ps.setString(2, ejercicioNombre);
            ps.setString(3, estado);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContEjercicio|insertReg|:" + ex);
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
                    "UPDATE CONT_EJERCICIO " + 
                    " SET EJERCICIO_NOMBRE = ?," +
                    " ESTADO = ?" +
                    " WHERE EJERCICIO_ID = ?");       
            
            ps.setString(1, ejercicioNombre);
            ps.setString(2, estado);
            ps.setString(3, ejercicioId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContEjercicio|updateReg|:" + ex);
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
                    " DELETE FROM CONT_EJERCICIO" +
                    " WHERE EJERCICIO_ID = ?");
            ps.setString(1, ejercicioId);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }            
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContEjercicio|deleteReg|:" + ex);
        }finally{        	
        	if(ps != null){ ps.close(); }
        }

        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {
		ejercicioId			= rs.getString("EJERCICIO_ID");
		ejercicioNombre		= rs.getString("EJERCICIO_NOMBRE");
		estado				= rs.getString("ESTADO");
    }

    public void mapeaRegId(Connection con, String ejercicioId) throws SQLException{
    	PreparedStatement ps = null;
    	ResultSet rs = null;
    	try{
	        ps = con.prepareStatement(
	                " SELECT EJERCICIO_ID, EJERCICIO_NOMBRE, ESTADO" +
	                " FROM CONT_EJERCICIO" +
	                " WHERE EJERCICIO_ID = ?");
	        ps.setString(1, ejercicioId);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
    	}catch(Exception ex){
			System.out.println("Error - aca.cont.ContEjercicio|mapeaRegId|:"+ex);
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
        	ps = conn.prepareStatement("SELECT EJERCICIO_ID FROM CONT_EJERCICIO" +
            		" WHERE EJERCICIO_ID = ?");
            ps.setString(1, ejercicioId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.cont.ContEjercicio|existeReg|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return ok;
    }
}
