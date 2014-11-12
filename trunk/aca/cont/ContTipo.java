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
public class ContTipo {
	private String tipoId;
	private String tipoNombre;
	
	public ContTipo(){
		tipoId		= "";
		tipoNombre	= "";
	}

	/**
	 * @return the tipoId
	 */
	public String getTipoId() {
		return tipoId;
	}

	/**
	 * @param tipoId the tipoId to set
	 */
	public void setTipoId(String tipoId) {
		this.tipoId = tipoId;
	}

	/**
	 * @return the tipoNombre
	 */
	public String getTipoNombre() {
		return tipoNombre;
	}

	/**
	 * @param tipoNombre the tipoNombre to set
	 */
	public void setTipoNombre(String tipoNombre) {
		this.tipoNombre = tipoNombre;
	}
	
	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    " INSERT INTO CONT_TIPO(TIPO_ID, TIPO_NOMBRE)" +
                    " VALUES(TO_NUMBER(?, '99'), ?)");   
            ps.setString(1, tipoId);
            ps.setString(2, tipoNombre);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContTipo|insertReg|:" + ex);
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
                    "UPDATE CONT_TIPO " + 
                    " SET TIPO_NOMBRE = ?" +
                    " WHERE TIPO_ID = TO_NUMBER(?, '99')");       
            
            ps.setString(1, tipoNombre);
            ps.setString(2, tipoId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContTipo|updateReg|:" + ex);
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
                    " DELETE FROM CONT_TIPO" +
                    " WHERE TIPO_ID = TO_NUMBER(?, '99')");
            ps.setString(1, tipoId);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }            
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContTipo|deleteReg|:" + ex);
        }finally{        	
        	if(ps != null){ ps.close(); }
        }

        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {
		tipoId		= rs.getString("TIPO_ID");
		tipoNombre	= rs.getString("TIPO_NOMBRE");
    }

    public void mapeaRegId(Connection con, String mayorId) throws SQLException{
        PreparedStatement ps =null;
    	ResultSet rs = null;
        try{
	        ps = con.prepareStatement(
	                " SELECT TIPO_ID, TIPO_NOMBRE" +
	                " FROM CONT_TIPO" +
	                " WHERE TIPO_ID = TO_NUMBER(?, '99')");
	        ps.setString(1, tipoId);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.cont.ContTipo|mapeaRegId|:"+ex);
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
        	ps = conn.prepareStatement("SELECT TIPO_ID FROM CONT_TIPO" +
            		" WHERE TIPO_ID = TO_NUMBER(?, '99')");
            ps.setString(1, tipoId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.cont.ContTipo|existeReg|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return ok;
    }
    
    public String maxReg(Connection conn) throws SQLException {
        String maximo			= "";
        ResultSet rs			= null;
        PreparedStatement ps	= null;

        try {
        	ps = conn.prepareStatement("SELECT COALESCE(MAX(TIPO_ID)+1,'1') AS MAXIMO FROM CONT_TIPO" +
            		" WHERE TIPO_ID = TO_NUMBER(?, '99')");
        	
            ps.setString(1, tipoId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                maximo = rs.getString("MAXIMO");
            }else
            	maximo = "1";
        }catch(Exception ex){
            System.out.println("Error - aca.cont.ContTipo|maxReg|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return maximo;
    }
    
    public static String nombreTipo(Connection conn, String tipoId) throws SQLException {
        String nombre			= "";
        ResultSet rs			= null;
        PreparedStatement ps	= null;

        try {
        	ps = conn.prepareStatement("SELECT TIPO_NOMBRE FROM CONT_TIPO" +
            		" WHERE TIPO_ID = TO_NUMBER(?, '99')");
        	
            ps.setString(1, tipoId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                nombre = rs.getString("TIPO_NOMBRE");
            }else
            	nombre = tipoId;
        }catch(Exception ex){
            System.out.println("Error - aca.cont.ContTipo|nombreTipo|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return nombre;
    }
}
