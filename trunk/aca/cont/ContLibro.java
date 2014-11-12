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
public class ContLibro {
	private String libroId;
	private String libroNombre;
	
	public ContLibro(){
		libroId		= "";
		libroNombre	= "";
	}

	/**
	 * @return the libroId
	 */
	public String getLibroId() {
		return libroId;
	}

	/**
	 * @param libroId the libroId to set
	 */
	public void setLibroId(String libroId) {
		this.libroId = libroId;
	}

	/**
	 * @return the libroNombre
	 */
	public String getLibroNombre() {
		return libroNombre;
	}

	/**
	 * @param libroNombre the libroNombre to set
	 */
	public void setLibroNombre(String libroNombre) {
		this.libroNombre = libroNombre;
	}
	
	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    " INSERT INTO CONT_LIBRO(LIBRO_ID, LIBRO_NOMBRE)" +
                    " VALUES(TO_NUMBER(?, '99'), ?)");   
            ps.setString(1, libroId);
            ps.setString(2, libroNombre);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContLibro|insertReg|:" + ex);
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
                    "UPDATE CONT_LIBRO " + 
                    " SET LIBRO_NOMBRE = ?" +
                    " WHERE LIBRO_ID = TO_NUMBER(?, '99')");       
            
            ps.setString(1, libroNombre);
            ps.setString(2, libroId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContLibro|updateReg|:" + ex);
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
                    " DELETE FROM CONT_LIBRO" +
                    " WHERE LIBRO_ID = ?");
            ps.setString(1, libroId);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }            
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContLibro|deleteReg|:" + ex);
        }finally{        	
        	if(ps != null){ ps.close(); }
        }

        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {
		libroId		= rs.getString("LIBRO_ID");
		libroNombre	= rs.getString("LIBRO_NOMBRE");
    }

    public void mapeaRegId(Connection con, String libroId) throws SQLException{
    	PreparedStatement ps =null;
    	ResultSet rs = null;
        try{
	        ps = con.prepareStatement(
	                " SELECT LIBRO_ID, LIBRO_NOMBRE" +
	                " FROM CONT_LIBRO" +
	                " WHERE LIBRO_ID = ?");
	        ps.setString(1, libroId);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.cont.ContLibro|mapeaRegId|:"+ex);
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
        	ps = conn.prepareStatement("SELECT LIBRO_ID FROM CONT_LIBRO" +
            		" WHERE LIBRO_ID = ?");
            ps.setString(1, libroId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.cont.ContLibro|existeReg|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return ok;
    }
    
    //Maximo id del catálogo
    public String maxReg(Connection conn) throws SQLException {
               
        PreparedStatement ps	= null;
        ResultSet rs			= null;
        String maximo			= "";

        try {
        	ps = conn.prepareStatement("SELECT COALESCE(MAX(LIBRO_ID)+1,'1') AS MAXIMO FROM CONT_LIBRO");
            
            rs = ps.executeQuery();
            if(rs.next()){
                maximo = rs.getString("MAXIMO");
            }else
            	maximo = "1";
        }catch(Exception ex){
            System.out.println("Error - aca.cont.ContLibro|maxReg|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return maximo;
    }
}
