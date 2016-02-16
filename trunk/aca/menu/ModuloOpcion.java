// Clase para la tabla de Modulo_opcion
package aca.menu;

import java.sql.*;

public class ModuloOpcion  implements java.io.Serializable{	
	
	private static final long serialVersionUID = 1L;	
	private String	moduloId;
	private String	opcionId;
	private String	nombreOpcion;
	private String	url;
	private String	orden;
	private String acceso;
	private String estado;
	
	// Constructor
	public ModuloOpcion(){
		moduloId 		= "";
		opcionId		= "";
		nombreOpcion	= "";
		url 			= "";
		orden 			= "";
		acceso 			= "";
		estado 			= "";
	}	
	

	/**
	 * @return the moduloId
	 */
	public String getModuloId() {
		return moduloId;
	}
	/**
	 * @param moduloId the moduloId to set
	 */
	public void setModuloId(String moduloId) {
		this.moduloId = moduloId;
	}
	/**
	 * @return the opcionId
	 */
	public String getOpcionId() {
		return opcionId;
	}
	/**
	 * @param opcionId the opcionId to set
	 */
	public void setOpcionId(String opcionId) {
		this.opcionId = opcionId;
	}
	/**
	 * @return the nombreOpcion
	 */
	public String getNombreOpcion() {
		return nombreOpcion;
	}
	/**
	 * @param nombreOpcion the nombreOpcion to set
	 */
	public void setNombreOpcion(String nombreOpcion) {
		this.nombreOpcion = nombreOpcion;
	}
	/**
	 * @return the url
	 */
	public String getUrl() {
		return url;
	}
	/**
	 * @param url the url to set
	 */
	public void setUrl(String url) {
		this.url = url;
	}
	/**
	 * @return the orden
	 */
	public String getOrden() {
		return orden;
	}
	/**
	 * @param orden the orden to set
	 */
	public void setOrden(String orden) {
		this.orden = orden;
	}
	/**
	 * @return the acceso
	 */
	public String getAcceso() {
		return acceso;
	}
	/**
	 * @param acceso the acceso to set
	 */
	public void setAcceso(String acceso) {
		this.acceso = acceso;
	}

	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO MODULO_OPCION (MODULO_ID,"+
										" OPCION_ID, NOMBRE_OPCION, URL, ORDEN, ACCESO, ESTADO) "+
										" VALUES(?,TO_NUMBER(?, '999'),?,?,TO_NUMBER(?, '99'),?,?)");
			ps.setString(1, moduloId);
			ps.setString(2, opcionId);
			ps.setString(3, nombreOpcion);
			ps.setString(4, url);
			ps.setString(5, orden);
			ps.setString(6, acceso);
			ps.setString(6, estado);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.menu.ModuloOpcion|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE MODULO_OPCION"+
				" SET NOMBRE_OPCION = ?, URL= ?, ORDEN = TO_NUMBER(?,'99'), ACCESO = ?, ESTADO = ? "+
				" WHERE MODULO_ID = ? AND OPCION_ID = TO_NUMBER(?, '999')");
			ps.setString(1, nombreOpcion);
			ps.setString(2, url);
			ps.setString(3, orden);
			ps.setString(4, acceso);
			ps.setString(5, estado);
			ps.setString(6, moduloId);
			ps.setString(7, opcionId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.menu.ModuloOpcion|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM MODULO_OPCION WHERE MODULO_ID = ? AND OPCION_ID = TO_NUMBER(?, '999')");
			ps.setString(1, moduloId);
			ps.setString(2, opcionId);
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.menu.ModuloOpcion|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();			
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		moduloId 		= rs.getString("MODULO_ID");
		opcionId 		= rs.getString("OPCION_ID");
		nombreOpcion	= rs.getString("NOMBRE_OPCION");
		url 			= rs.getString("URL");
		orden 			= rs.getString("ORDEN");
		acceso 			= rs.getString("ACCESO");
		estado 			= rs.getString("ESTADO");
	}
	
	public void mapeaRegId(Connection conn, String moduloId, String opcionId) throws SQLException{
		ResultSet rs = null;
		PreparedStatement ps = null; 
		try{
			ps = conn.prepareStatement("SELECT MODULO_ID, OPCION_ID, NOMBRE_OPCION, URL,"+
							" ORDEN, ACCESO, ESTADO FROM MODULO_OPCION WHERE MODULO_ID = ? AND OPCION_ID = TO_NUMBER(?, '999') ");
			ps.setString(1, moduloId);
			ps.setString(2, opcionId);
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.menu.ModuloOpcion|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
	}
	
	public void mapeaRegId(Connection conn, String opcionId) throws SQLException{
		ResultSet rs = null;
		PreparedStatement ps = null; 
		try{	
			ps = conn.prepareStatement("SELECT MODULO_ID, OPCION_ID, NOMBRE_OPCION, URL,"+
							" ORDEN, ACCESO, ESTADO FROM MODULO_OPCION WHERE OPCION_ID = TO_NUMBER(?, '999') ");
			ps.setString(1, opcionId);
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.menu.ModuloOpcion|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
	}
	
	public boolean existeOpcion(Connection conn) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		boolean ok 				= false;
		
		try{			
			ps = conn.prepareStatement("SELECT * FROM MODULO_OPCION WHERE OPCION_ID = TO_NUMBER(?, '999')");			
			ps.setString(1, opcionId);
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.menu.ModuloOpcion|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean existeReg(Connection conn) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		boolean ok 				= false;
		
		try{			
			ps = conn.prepareStatement("SELECT * FROM MODULO_OPCION WHERE MODULO_ID = ? AND OPCION_ID = TO_NUMBER(?, '999')");
			ps.setString(1, moduloId);
			ps.setString(2, opcionId);
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.menu.ModuloOpcion|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public static String getOpcionNombre(Connection conn, String opcionId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String modulo			= "X";
	
		try{			
			ps = conn.prepareStatement("SELECT NOMBRE_OPCION FROM MODULO_OPCION " +
					"WHERE OPCION_ID = TO_NUMBER(?, '999')");
			ps.setString(1, opcionId);
			rs= ps.executeQuery();		
			if(rs.next()){
				modulo = rs.getString("NOMBRE_OPCION");
			}
		
		}catch(Exception ex){
			System.out.println("Error - aca.menu.ModuloOpcion|getOpcionNombre|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
	
		return modulo;		
	}
	
}