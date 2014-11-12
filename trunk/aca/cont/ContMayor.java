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
public class ContMayor {
	private String mayorId;
	private String tipoCta;
	private String mayorNombre;
	private String detalle;
	private String naturaleza;
	
	public ContMayor(){
		mayorId		= "";
		tipoCta		= "";
		mayorNombre	= "";
		detalle		= "";
		naturaleza	= "";
	}

	/**
	 * @return the mayorId
	 */
	public String getMayorId() {
		return mayorId;
	}

	/**
	 * @param mayorId the mayorId to set
	 */
	public void setMayorId(String mayorId) {
		this.mayorId = mayorId;
	}

	/**
	 * @return the tipoCta
	 */
	public String getTipoCta() {
		return tipoCta;
	}

	/**
	 * @param tipoCta the tipoCta to set
	 */
	public void setTipoCta(String tipoCta) {
		this.tipoCta = tipoCta;
	}

	/**
	 * @return the mayorNombre
	 */
	public String getMayorNombre() {
		return mayorNombre;
	}

	/**
	 * @param mayorNombre the mayorNombre to set
	 */
	public void setMayorNombre(String mayorNombre) {
		this.mayorNombre = mayorNombre;
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
	
	/**
	 * @return the naturaleza
	 */
	public String getNaturaleza() {
		return naturaleza;
	}

	/**
	 * @param naturaleza the naturaleza to set
	 */
	public void setNaturaleza(String naturaleza) {
		this.naturaleza = naturaleza;
	}

	/**
	 * Inserta un registro en CONT_MAYOR con los datos cargados en el Bean
	 * @param conn Conexión a la Base de Datos
	 * @return <b>true</b> si insertó bien el registro ó <b>false</b> si no lo insertó
	 * @throws SQLException
	 */
	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    " INSERT INTO CONT_MAYOR(MAYOR_ID, TIPO_CTA, MAYOR_NOMBRE, DETALLE, NATURALEZA)" +
                    " VALUES(?, ?, ?, ?, ?)");   
            ps.setString(1, mayorId);
            ps.setString(2, tipoCta);
            ps.setString(3, mayorNombre);
            ps.setString(4, detalle);
            ps.setString(5, naturaleza);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContMayor|insertReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }

	/**
	 * Actualiza un registro en CONT_MAYOR con los datos cargados en el Bean
	 * @param conn Conexión a la Base de Datos
	 * @return <b>true</b> si actualizó bien el registro ó <b>false</b> si no lo actualizó
	 * @throws SQLException
	 */
    public boolean updateReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "UPDATE CONT_MAYOR " + 
                    " SET TIPO_CTA = ?," +
                    " MAYOR_NOMBRE = ?," +
                    " DETALLE = ?," +
                    " NATURALEZA = ?" +
                    " WHERE MAYOR_ID = ?");       
            
            ps.setString(1, tipoCta);
            ps.setString(2, mayorNombre);
            ps.setString(3, detalle);
            ps.setString(4, naturaleza);
            ps.setString(5, mayorId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContMayor|updateReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }

    /**
     * Borra un registro en CONT_MAYOR segun el mayorId cargado en el Bean
     * @param conn Conexión a la Base de Datos
     * @return <b>true</b> si se borró el registro ó <b>false</b> si no se borró
     * @throws SQLException
     */
    public boolean deleteReg(Connection conn) throws SQLException{
    	PreparedStatement ps 	= null;
    	boolean ok 				= false;        

        try {
            ps = conn.prepareStatement(
                    " DELETE FROM CONT_MAYOR" +
                    " WHERE MAYOR_ID = ?");
            ps.setString(1, mayorId);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }            
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContMayor|deleteReg|:" + ex);
        }finally{        	
        	if(ps != null){ ps.close(); }
        }

        return ok;
    }

    /**
     * Relaciona los datos del <b>ResultSet</b> dado con el Bean
     * @param rs El <b>ResultSet</b> que se quiere cargar en el Bean
     * @throws SQLException
     */
    public void mapeaReg(ResultSet rs) throws SQLException {
		mayorId		= rs.getString("MAYOR_ID");
		tipoCta		= rs.getString("TIPO_CTA");
		mayorNombre	= rs.getString("MAYOR_NOMBRE");
		detalle		= rs.getString("DETALLE");
		naturaleza	= rs.getString("NATURALEZA");
    }

    /**
     * 
     * @param conn Conexión a la Base de Datos
     * @param mayorId ID del registro a buscar
     * @throws SQLException
     */
    public void mapeaRegId(Connection conn, String mayorId) throws SQLException{
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
	        ps = conn.prepareStatement(
	                " SELECT MAYOR_ID, TIPO_CTA, MAYOR_NOMBRE, DETALLE, NATURALEZA" +
	                " FROM CONT_MAYOR" +
	                " WHERE MAYOR_ID = ?");
	        ps.setString(1, mayorId);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.cont.ContMayor|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
    }

    /**
     * Revisa si existe un registro con los datos cargados en el Bean
     * @param conn Conexión a la Base de Datos
     * @return <b>true</b> si existe el registro ó <b>false</b> si no existe
     * @throws SQLException
     */
    public boolean existeReg(Connection conn) throws SQLException {
        boolean ok = false;
        ResultSet rs = null;
        PreparedStatement ps = null;

        try {
        	ps = conn.prepareStatement("SELECT MAYOR_ID FROM CONT_MAYOR" +
            		" WHERE MAYOR_ID = ?");
            ps.setString(1, mayorId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.cont.ContMayor|existeReg|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return ok;
    }
}
