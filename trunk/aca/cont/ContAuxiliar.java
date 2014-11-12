package aca.cont;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ContAuxiliar {
	private String auxiliarId;
	private String auxiliarNombre;
	private String detalle;
	private String tipoId;
	
	public ContAuxiliar(){
		auxiliarId		= "";
		auxiliarNombre	= "";
		detalle			= "";
		tipoId			= "";
	}

	/**
	 * @return the auxiliarId
	 */
	public String getAuxiliarId() {
		return auxiliarId;
	}

	/**
	 * @param auxiliarId the auxiliarId to set
	 */
	public void setAuxiliarId(String auxiliarId) {
		this.auxiliarId = auxiliarId;
	}

	/**
	 * @return the auxiliarNombre
	 */
	public String getAuxiliarNombre() {
		return auxiliarNombre;
	}

	/**
	 * @param auxiliarNombre the auxiliarNombre to set
	 */
	public void setAuxiliarNombre(String auxiliarNombre) {
		this.auxiliarNombre = auxiliarNombre;
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
	 * @return true si se guardó correctamente el registro ó false si no se guardó
	 * @param conn La conexión a la Base de Datos
	 * @throws SQLException
	 * */
	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    " INSERT INTO CONT_AUXILIAR(AUXILIAR_ID, AUXILIAR_NOMBRE, DETALLE, TIPO_ID)" +
                    " VALUES(?, ?, ?, TO_NUMBER(?, '99'))");
            
            ps.setString(1, auxiliarId);
            ps.setString(2, auxiliarNombre);
            ps.setString(3, detalle);
            ps.setString(4, tipoId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContAuxiliar|insertReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }

	/**
	 * @return true si actualizó correctamente el registro ó false si no lo actualizó
	 * @param conn La conexión a la Base de Datos
	 * @throws SQLException
	 * */
    public boolean updateReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "UPDATE CONT_AUXILIAR " + 
                    " SET AUXILIAR_NOMBRE = ?," +
                    " DETALLE = ?," +
                    " TIPO_ID = ?" +
                    " WHERE AUXILIAR_ID = ?");
            
            ps.setString(1, auxiliarNombre);
            ps.setString(2, detalle);
            ps.setString(3, tipoId);
            ps.setString(4, auxiliarId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContAuxiliar|updateReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }

    /**
     * @return true si borró el registro ó false si no lo borró
     * @param conn Conexión a la Base de Datos
     * @throws SQLException
     * */
    public boolean deleteReg(Connection conn) throws SQLException{
    	PreparedStatement ps 	= null;
    	boolean ok 				= false;        

        try {
            ps = conn.prepareStatement(
                    " DELETE FROM CONT_AUXILIAR" +
                    " WHERE AUXILIAR_ID = ?");
            
            ps.setString(1, auxiliarId);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }            
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContAuxiliar|deleteReg|:" + ex);
        }finally{        	
        	if(ps != null){ ps.close(); }
        }

        return ok;
    }

    /**
     * Guarda lo que trae el ResultSet en el Bean
     * @param rs El ResultSet que se desea cargar en el Bean
     * @throws SQLException
     */
    public void mapeaReg(ResultSet rs) throws SQLException {
		auxiliarId		= rs.getString("AUXILIAR_ID");
		auxiliarNombre	= rs.getString("AUXILIAR_NOMBRE");
		detalle			= rs.getString("DETALLE");
		tipoId			= rs.getString("TIPO_ID");
    }

    /**
     * Busca un determinado registro de acuerdo a los parámetros dados
     * @param conn Conexión a la Base de Datos
     * @param auxiliarId El identificador del auxiliar a buscar
     * @param escuelaId El identificador de la escuela a la que pertenece el auxiliar
     * @throws SQLException
     */
    public void mapeaRegId(Connection conn, String auxiliarId) throws SQLException{
    	PreparedStatement ps = null;
    	ResultSet rs = null;
        try{
	        ps = conn.prepareStatement(
	                " SELECT AUXILIAR_ID, AUXILIAR_NOMBRE, DETALLE, TIPO_ID" +
	                " FROM CONT_AUXILIAR" +
	                " WHERE AUXILIAR_ID = ?");
	        
	        ps.setString(1, auxiliarId);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.cont.ContAuxiliar|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
    }

    /**
     * Identifica si existe un registro determinado de acuerdo a los parámetros cargados en el Bean
     * @param conn La conexión a la Base de Datos
     * @return true si existe el registro ó false si no existe
     * @throws SQLException
     */
    public boolean existeReg(Connection conn) throws SQLException {
        boolean ok = false;
        ResultSet rs = null;
        PreparedStatement ps = null;

        try {
        	ps = conn.prepareStatement("SELECT AUXILIAR_ID FROM CONT_AUXILIAR" +
            		" WHERE AUXILIAR_ID = ?");
        	
            ps.setString(1, auxiliarId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.cont.ContAuxiliar|existeReg|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return ok;
    }
    
    /**
     * Identifica si el auxiliar ya está ligado con alguna cuenta contable
     * @param conn Conexión a la Base de Datos
     * @param auxiliarId El auxiliar del que se quiere saber si está ligado
     * @return true si ya existe en las cuentas contables ó false si no existe
     * @throws SQLException
     */
    public static boolean estaLigado(Connection conn, String auxiliarId) throws SQLException {
        boolean ok = false;
        ResultSet rs = null;
        PreparedStatement ps = null;

        try {
        	ps = conn.prepareStatement("SELECT AUXILIAR_ID FROM CONT_RELACION" +
            		" WHERE AUXILIAR_ID = ?");
            ps.setString(1, auxiliarId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.cont.ContAuxiliar|estaLigado|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return ok;
    }
}
