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
public class ContCcosto {
	private String ccostoId;
	private String nombre;
	private String detalle;
	
	public ContCcosto(){
		ccostoId	= "";
		nombre		= "";
		detalle		= "";
	}

	/**
	 * @return the ccostoId
	 */
	public String getCcostoId() {
		return ccostoId;
	}

	/**
	 * @param ccostoId the ccostoId to set
	 */
	public void setCcostoId(String ccostoId) {
		this.ccostoId = ccostoId;
	}

	/**
	 * @return the nombre
	 */
	public String getNombre() {
		return nombre;
	}

	/**
	 * @param nombre the nombre to set
	 */
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	/**
	 * @return the detalle
	 */
	public String getDetalle() {
		return detalle;
	}

	/**
	 * @param detalle the detalle to set
	 */
	public void setDetalle(String detalle) {
		this.detalle = detalle;
	}
	
	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    " INSERT INTO CONT_CCOSTO(CCOSTO_ID, NOMBRE, DETALLE)" +
                    " VALUES(?, ?, ?)");   
            ps.setString(1, ccostoId);
            ps.setString(2, nombre);
            ps.setString(3, detalle);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContCcosto|insertReg|:" + ex);
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
                    "UPDATE CONT_CCOSTO " + 
                    " SET NOMBRE = ?," +
                    " DETALLE = ?" +
                    " WHERE CCOSTO_ID = ?");       
            
            ps.setString(1, nombre);
            ps.setString(2, detalle);
            ps.setString(3, ccostoId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContCcosto|updateReg|:" + ex);
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
                    " DELETE FROM CONT_CCOSTO" +
                    " WHERE CCOSTO_ID = ?");
            ps.setString(1, ccostoId);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }            
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContCcosto|deleteReg|:" + ex);
        }finally{        	
        	if(ps != null){ ps.close(); }
        }

        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {
		ccostoId	= rs.getString("CCOSTO_ID");
		nombre		= rs.getString("NOMBRE");
		detalle		= rs.getString("DETALLE");
    }

    public void mapeaRegId(Connection con, String ccostoId) throws SQLException{
    	PreparedStatement ps = null;
    	ResultSet rs = null;
        try{
	        ps = con.prepareStatement(
	                " SELECT CCOSTO_ID, NOMBRE, DETALLE" +
	                " FROM CONT_CCOSTO" +
	                " WHERE CCOSTO_ID = ?");
	        ps.setString(1, ccostoId);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
    	}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumCiclo|mapeaRegId|:"+ex);
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
        	ps = conn.prepareStatement("SELECT CCOSTO_ID FROM CONT_CCOSTO" +
            		" WHERE CCOSTO_ID = ?");
            ps.setString(1, ccostoId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.cont.ContCcosto|existeReg|:" +ex);
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
        	ps = conn.prepareStatement("SELECT COALESCE(MAX(FOLIO)+1,'1') AS MAXIMO FROM FIN_CALCULO" +
            		" WHERE CICLO_ID = ?");
        	
            ps.setString(1, cicloId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                maximo = rs.getString("MAXIMO");
            }else
            	maximo = "1";
        }catch(Exception ex){
            System.out.println("Error - aca.cont.ContCcosto|maxReg|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return maximo;
    }
    
    public static String getCcosto(Connection conn, String escuelaId) throws SQLException {
    	aca.cont.ContMascara contMascara = new aca.cont.ContMascara();
        String ccostoId			= "";
        String ceros			= "";
        int escuelaInicio		= 0;
        int escuelaSize			= 0;
        int centroInicio		= 0;
        int centroSize			= 0;
        ResultSet rs			= null;
        PreparedStatement ps	= null;
        
        if(escuelaId.length() == 1)
        	escuelaId = "0" + escuelaId;
        
        contMascara.mapeaRegId(conn, "1");
        for(int i = 1; i <= Integer.parseInt(contMascara.getNivelContable()); i++){
        	if((i == Integer.parseInt(contMascara.getNivelContable()))){
        		escuelaInicio++;
        		escuelaSize = Integer.parseInt(String.valueOf(contMascara.getMascCcosto().charAt(i-1)));
        	}else{
        		escuelaInicio += Integer.parseInt(String.valueOf(contMascara.getMascCcosto().charAt(i-1)));
        	}
        }
        centroInicio = escuelaInicio+escuelaSize;
        for(int i = 0; i < contMascara.getMascCcosto().length(); i++){
        	centroSize += Integer.parseInt(String.valueOf(contMascara.getMascCcosto().charAt(i)));
        }
        centroSize = (centroSize+1)-centroInicio;
        for(int i = 0; i < centroSize; i++){
        	ceros += "0";
        }

        try {
        	ps = conn.prepareStatement("SELECT CCOSTO_ID FROM CONT_CCOSTO" +
        			" WHERE SUBSTR(CCOSTO_ID, "+escuelaInicio+", "+escuelaSize+") = '"+escuelaId+"'" +
        			" AND SUBSTR(CCOSTO_ID, "+centroInicio+", "+centroSize+") = '"+ceros+"'");
            
            rs = ps.executeQuery();
            if(rs.next()){
            	ccostoId = rs.getString("CCOSTO_ID");
            }else
            	ccostoId = "1";
        }catch(Exception ex){
            System.out.println("Error - aca.cont.ContCcosto|getCcosto|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return ccostoId;
    }
}
