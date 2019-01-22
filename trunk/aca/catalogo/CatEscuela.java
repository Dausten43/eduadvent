/**
 * 
 */
package aca.catalogo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Jose Torres
 *
 */
public class CatEscuela {

	private String escuelaId;
	private String escuelaNombre;
	private String nombreCorto;
	private String paisId;
	private String estadoId;
	private String ciudadId;
	private String colonia;
	private String direccion;
	private String telefono;
	private String fax;
	private String asociacionId;
	private String logo;
	private String estado;
	private String firma;
	private String seccionId;
	private String unionId;
	private String orgId;
	private String distrito;
	private String regionId;
	private String eslogan;
	private String sector;
	private String zona;
	private String barrioId;
	private String www;
	private String registro;
	
	public CatEscuela(){
		escuelaId			= "";
		escuelaNombre		= "";
		nombreCorto			= "";
		paisId				= "";
		estadoId			= "";
		ciudadId			= "";
		colonia				= "";
		direccion			= "";
		telefono			= "";
		fax					= "";
		asociacionId		= "";
		logo 				= "";
		estado 				= "";
		firma				= "";
		seccionId			= "";
		unionId				= "";
		orgId				= "";
		distrito			= "";
		regionId			= "";
		eslogan				= "";
		sector 				= "";
		zona 				= "";
		barrioId 			= "";
		www					= "";
		registro			= "";
	}

	

	public String getFirma() {
		return firma;
	}


	public void setFirma(String firma) {
		this.firma = firma;
	}


	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
	}

	/**
	 * @return Returns the ciudadId.
	 */
	public String getCiudadId() {
		return ciudadId;
	}
	

	/**
	 * @param ciudadId The ciudadId to set.
	 */
	public void setCiudadId(String ciudadId) {
		this.ciudadId = ciudadId;
	}
	

	/**
	 * @return Returns the colonia.
	 */
	public String getColonia() {
		return colonia;
	}
	

	/**
	 * @param colonia The colonia to set.
	 */
	public void setColonia(String colonia) {
		this.colonia = colonia;
	}
	

	/**
	 * @return Returns the direccion.
	 */
	public String getDireccion() {
		return direccion;
	}
	

	/**
	 * @param direccion The direccion to set.
	 */
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	

	/**
	 * @return Returns the escuelaId.
	 */
	public String getEscuelaId() {
		return escuelaId;
	}
	

	/**
	 * @param escuelaId The escuelaId to set.
	 */
	public void setEscuelaId(String escuelaId) {
		this.escuelaId = escuelaId;
	}
	

	/**
	 * @return Returns the escuelaNombre.
	 */
	public String getEscuelaNombre() {
		return escuelaNombre;
	}
	

	/**
	 * @param escuelaNombre The escuelaNombre to set.
	 */
	public void setEscuelaNombre(String escuelaNombre) {
		this.escuelaNombre = escuelaNombre;
	}
	

	/**
	 * @return Returns the estadoId.
	 */
	public String getEstadoId() {
		return estadoId;
	}
	

	/**
	 * @param estadoId The estadoId to set.
	 */
	public void setEstadoId(String estadoId) {
		this.estadoId = estadoId;
	}
	

	/**
	 * @return Returns the nombreCorto.
	 */
	public String getNombreCorto() {
		return nombreCorto;
	}
	

	/**
	 * @param nombreCorto The nombreCorto to set.
	 */
	public void setNombreCorto(String nombreCorto) {
		this.nombreCorto = nombreCorto;
	}
	

	/**
	 * @return Returns the paisId.
	 */
	public String getPaisId() {
		return paisId;
	}
	

	/**
	 * @param paisId The paisId to set.
	 */
	public void setPaisId(String paisId) {
		this.paisId = paisId;
	}
	

	/**
	 * @return Returns the telefono.
	 */
	public String getTelefono() {
		return telefono;
	}
	

	/**
	 * @param telefono The telefono to set.
	 */
	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}
	
	
	/**
	 * @return Returns the fax.
	 */
	public String getFax() {
		return fax;
	}
	

	/**
	 * @param fax The fax to set.
	 */
	public void setFax(String fax) {
		this.fax = fax;
	}
	
	public String getAsociacionId() {
		return asociacionId;
	}

	public void setAsociacionId(String asociacionId) {
		this.asociacionId = asociacionId;
	}
	
	public String getLogo() {
		return logo;
	}

	public void setLogo(String logo) {
		this.logo = logo;
	}
	
	public String getSeccionId() {
		return seccionId;
	}

	public void setSeccionId(String seccionId) {
		this.seccionId = seccionId;
	}
	
	public String getUnionId() {
		return unionId;
	}

	public void setUnionId(String unionId) {
		this.unionId = unionId;
	}
	
	public String getOrgId() {
		return orgId;
	}

	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}

	public String getDistrito() {
		return distrito;
	}


	public void setDistrito(String distrito) {
		this.distrito = distrito;
	}


	public String getRegionId() {
		return regionId;
	}


	public void setRegionId(String regionId) {
		this.regionId = regionId;
	}


	public String getEslogan() {
		return eslogan;
	}


	public void setEslogan(String eslogan) {
		this.eslogan = eslogan;
	}


	public String getSector() {
		return sector;
	}


	public void setSector(String sector) {
		this.sector = sector;
	}


	public String getZona() {
		return zona;
	}


	public void setZona(String zona) {
		this.zona = zona;
	}
	
	public String getBarrioId() {
		return barrioId;
	}


	public void setBarrioId(String barrioId) {
		this.barrioId = barrioId;
	}

	public String getWww() {
		return www;
	}

	public void setWww(String www) {
		this.www = www;
	}
	
	public String getRegistro() {
		return registro;
	}



	public void setRegistro(String registro) {
		this.registro = registro;
	}



	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO CAT_ESCUELA" +
					" (ESCUELA_ID, ESCUELA_NOMBRE, NOMBRE_CORTO, PAIS_ID, ESTADO_ID," +					
					" CIUDAD_ID, COLONIA, DIRECCION, TELEFONO, FAX, ASOCIACION_ID, LOGO, ESTADO, FIRMA, SECCION_ID, UNION_ID, ORG_ID, DISTRITO, REGION_ID, ESLOGAN, SECTOR, ZONA, BARRIO_ID, WWW, REGISTRO)" +									
					" VALUES(?, ?, ?, TO_NUMBER(?, '999')," +								
					" TO_NUMBER(?, '999'),TO_NUMBER(?, '999'), ?, ?, ?, ?, TO_NUMBER(?, '99'), ?, ?, ?, ?,TO_NUMBER(?,'99'),? ,?, TO_NUMBER(?,'99'), ?, ?, ?,TO_NUMBER(?, '999'),?,?)");			
			ps.setString(1, escuelaId);
			ps.setString(2, escuelaNombre);
			ps.setString(3, nombreCorto);			
			ps.setString(4, paisId);
			ps.setString(5, estadoId);			
			ps.setString(6, ciudadId);
			ps.setString(7, colonia);
			ps.setString(8, direccion);
			ps.setString(9, telefono);			
			ps.setString(10, fax);
			ps.setString(11, asociacionId);
			ps.setString(12, logo);			
			ps.setString(13, estado);
			ps.setString(14, firma);
			ps.setString(15, seccionId);			
			ps.setString(16, unionId);
			ps.setString(17, orgId);
			ps.setString(18, distrito);
			ps.setString(19, regionId);
			ps.setString(20, eslogan);
			ps.setString(21, sector);
			ps.setString(22, zona);
			ps.setString(23, barrioId);
			ps.setString(24, www);
			ps.setString(25, registro);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		
		try{
			ps = conn.prepareStatement("UPDATE CAT_ESCUELA"
					+ " SET ESCUELA_NOMBRE = ?,"
					+ " NOMBRE_CORTO = ?,"
					+ " PAIS_ID = TO_NUMBER(?, '999'),"
					+ " ESTADO_ID = TO_NUMBER(?, '999'),"
					+ " CIUDAD_ID = TO_NUMBER(?, '999'),"
					+ " COLONIA = ?,"
					+ " DIRECCION = ?,"
					+ " TELEFONO = ?,"
					+ " FAX = ?, "
					+ " ASOCIACION_ID = TO_NUMBER(?, '99'), "
					+ " LOGO = ?, "
					+ " ESTADO = ?,"
					+ " FIRMA = ?, "
					+ " SECCION_ID = ?,"
					+ " UNION_ID = TO_NUMBER(?,'99'),"
					+ " ORG_ID = ?,"
					+ " DISTRITO = ?,"
					+ " REGION_ID = TO_NUMBER(?, '99'),"
					+ " ESLOGAN = ?,"
					+ " SECTOR = ?,"
					+ " ZONA = ?,"
					+ " BARRIO_ID = TO_NUMBER(?, '999'),"
					+ " WWW	= ?,"
					+ " REGISTRO	= ?"
					+ " WHERE ESCUELA_ID = ? ");			
			ps.setString(1, escuelaNombre);
			ps.setString(2, nombreCorto);
			ps.setString(3, paisId);
			ps.setString(4, estadoId);
			ps.setString(5, ciudadId);
			ps.setString(6, colonia);
			ps.setString(7, direccion);
			ps.setString(8, telefono);
			ps.setString(9, fax);
			ps.setString(10, asociacionId);
			ps.setString(11, logo);			
			ps.setString(12, estado);
			ps.setString(13, firma);
			ps.setString(14, seccionId);
			ps.setString(15, unionId);
			ps.setString(16, orgId);	
			ps.setString(17, distrito);
			ps.setString(18, regionId);
			ps.setString(19, eslogan);
			ps.setString(20, sector);
			ps.setString(21, zona);
			ps.setString(22, barrioId);
			ps.setString(23, www);
			ps.setString(24, registro);
			ps.setString(25, escuelaId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CAT_ESCUELA WHERE ESCUELA_ID = ? ");
			ps.setString(1, escuelaId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		escuelaId			= rs.getString("ESCUELA_ID");
		escuelaNombre		= rs.getString("ESCUELA_NOMBRE");
		nombreCorto			= rs.getString("NOMBRE_CORTO");
		paisId				= rs.getString("PAIS_ID");
		estadoId			= rs.getString("ESTADO_ID");
		ciudadId			= rs.getString("CIUDAD_ID");
		colonia				= rs.getString("COLONIA");
		direccion			= rs.getString("DIRECCION");
		telefono			= rs.getString("TELEFONO");
		fax					= rs.getString("FAX");
		asociacionId		= rs.getString("ASOCIACION_ID");
		logo				= rs.getString("LOGO");
		estado				= rs.getString("ESTADO");
		firma				= rs.getString("FIRMA");
		seccionId			= rs.getString("SECCION_ID");
		unionId				= rs.getString("UNION_ID");
		orgId				= rs.getString("ORG_ID");
		distrito			= rs.getString("DISTRITO");
		regionId			= rs.getString("REGION_ID");
		eslogan 			= rs.getString("ESLOGAN");
		sector 				= rs.getString("SECTOR");
		zona				= rs.getString("ZONA");
		barrioId			= rs.getString("BARRIO_ID");
		www					= rs.getString("WWW");
		registro			= rs.getString("REGISTRO");
	}
	
	public void mapeaRegId(Connection con, String escuelaId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT ESCUELA_ID, ESCUELA_NOMBRE, NOMBRE_CORTO," +
					" PAIS_ID, ESTADO_ID, CIUDAD_ID, COLONIA, DIRECCION, TELEFONO, FAX, ASOCIACION_ID, LOGO, ESTADO, FIRMA, SECCION_ID, UNION_ID, ORG_ID, DISTRITO, REGION_ID, ESLOGAN, SECTOR, ZONA, BARRIO_ID, WWW, REGISTRO" +
					" FROM CAT_ESCUELA WHERE ESCUELA_ID = ? ");
			ps.setString(1, escuelaId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
	}
	
	public boolean existeReg(Connection conn) throws SQLException{
		boolean ok 			= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CAT_ESCUELA WHERE ESCUELA_ID = ? ");
			ps.setString(1, escuelaId);
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public String maximoReg(Connection conn, String unionId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(TO_NUMBER( SUBSTR(ESCUELA_ID, 2), '99'))+1,'1') AS MAXIMO FROM CAT_ESCUELA WHERE (SELECT UNION_ID FROM CAT_ASOCIACION WHERE ASOCIACION_ID = CAT_ESCUELA.ASOCIACION_ID) = "+unionId+" ");
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
	
	public String maximoReg(Connection conn) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(TO_NUMBER( SUBSTR(ESCUELA_ID, 2), '99'))+1,'1') AS MAXIMO FROM CAT_ESCUELA ");
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
	
	public static String getNombre(Connection conn, int escuelaId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nombre			= "X";		
		
		try{
			ps = conn.prepareStatement("SELECT ESCUELA_NOMBRE FROM CAT_ESCUELA WHERE ESCUELA_ID = ? ");
			ps.setInt(1, escuelaId);
			rs= ps.executeQuery();		
			if(rs.next()){
				nombre = rs.getString("ESCUELA_NOMBRE");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|getNombre|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}			
		return nombre;
	}
	
	public static String getNombre(Connection conn, String escuelaId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nombre			= "X";		
		
		try{
			ps = conn.prepareStatement("SELECT ESCUELA_NOMBRE FROM CAT_ESCUELA WHERE ESCUELA_ID = ? ");
			ps.setString(1, escuelaId);
			rs= ps.executeQuery();		
			if(rs.next()){
				nombre = rs.getString("ESCUELA_NOMBRE");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|getNombre|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		return nombre;
	}
	
	public static String getStatus(Connection conn, String escuelaId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String status			= "X";		
		
		try{
			ps = conn.prepareStatement("SELECT ESTADO FROM CAT_ESCUELA WHERE ESCUELA_ID = ? ");
			ps.setString(1, escuelaId);
			rs= ps.executeQuery();		
			if(rs.next()){
				status = rs.getString("ESTADO");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|getStatus|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		return status;
	}
	
	public static String getNombreCorto(Connection conn, String escuelaId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nombre			= "X";
		
		try{
			ps = conn.prepareStatement("SELECT NOMBRE_CORTO FROM CAT_ESCUELA WHERE ESCUELA_ID = ? ");
			ps.setString(1, escuelaId);
			rs= ps.executeQuery();		
			if(rs.next()){
				nombre = rs.getString("NOMBRE_CORTO");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|getNombreCorto|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return nombre;
	}
	
	public static String getPais(Connection conn, String escuelaId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String pais				= "0";		
		
		try{
			ps = conn.prepareStatement("SELECT PAIS_ID FROM CAT_ESCUELA WHERE ESCUELA_ID = ? ");
			ps.setString(1, escuelaId);
			rs= ps.executeQuery();		
			if(rs.next()){
				pais = rs.getString("PAIS_ID");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|getPais|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return pais;
	}
	
	public static String getEstado(Connection conn, String escuelaId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String estado			= "0";		
		
		try{
			ps = conn.prepareStatement("SELECT ESTADO_ID FROM CAT_ESCUELA WHERE ESCUELA_ID = ? ");
			ps.setString(1, escuelaId);
			rs= ps.executeQuery();		
			if(rs.next()){
				estado = rs.getString("ESTADO_ID");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|getEstado|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return estado;
	}
	
	public static String getCiudad(Connection conn, String escuelaId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String ciudad			= "0";		
		
		try{
			ps = conn.prepareStatement("SELECT CIUDAD_ID FROM CAT_ESCUELA WHERE ESCUELA_ID = ? ");
			ps.setString(1, escuelaId);
			rs= ps.executeQuery();		
			if(rs.next()){
				ciudad = rs.getString("CIUDAD_ID");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|getCiudad|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return ciudad;
	}
	
	public static String getLogo(Connection conn, String escuelaId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String logo				= "x.jpg";		
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(LOGO,'x.jpg') AS LOGO FROM CAT_ESCUELA WHERE ESCUELA_ID = ? ");
			ps.setString(1, escuelaId);
			rs= ps.executeQuery();		
			
			if(rs.next() && !rs.getString("LOGO").equals("")){	
				logo = rs.getString("LOGO");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|getLogo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return logo;
	}
	
	public static String getFirma(Connection conn, String escuelaId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String logo				= "firma.png";		
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(FIRMA,'firma.png') AS FIRMA FROM CAT_ESCUELA WHERE ESCUELA_ID = ? ");
			ps.setString(1, escuelaId);
			rs= ps.executeQuery();		
			if(rs.next()){
				logo = rs.getString("FIRMA");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|getFirma|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return logo;
	}
	
	public static String getEstadoEscuela(Connection conn, String escuelaId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String estadoEscuela	= "";		
		try{
			ps = conn.prepareStatement("SELECT ESTADO FROM CAT_ESCUELA WHERE ESCUELA_ID = ? ");
			ps.setString(1, escuelaId);
			rs= ps.executeQuery();		
			if(rs.next()){
				estadoEscuela = rs.getString("ESTADO");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|getEstadoEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return estadoEscuela;
	}
	
	public static String getTelefono(Connection conn, String escuelaId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String telefono			= "";		
		try{
			ps = conn.prepareStatement("SELECT TELEFONO FROM CAT_ESCUELA WHERE ESCUELA_ID = ? ");
			ps.setString(1, escuelaId);
			rs= ps.executeQuery();		
			if(rs.next()){
				telefono = rs.getString("TELEFONO");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|getTelefono|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return telefono;
	}	
	
	public static String getAsociacionId(Connection conn, String escuelaId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String asociacionId		= "";		
		try{
			ps = conn.prepareStatement("SELECT ASOCIACION_ID FROM CAT_ESCUELA WHERE ESCUELA_ID = ? ");
			ps.setString(1, escuelaId);
			rs= ps.executeQuery();		
			if(rs.next()){
				asociacionId = rs.getString("ASOCIACION_ID");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|getAsociacionId|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return asociacionId;
	}	
	
	
	public static String getUnionId(Connection conn, String escuelaId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String asociacionId		= "";		
		try{
			ps = conn.prepareStatement("SELECT UNION_ID FROM CAT_ESCUELA WHERE ESCUELA_ID = ? ");
			ps.setString(1, escuelaId);
			rs= ps.executeQuery();		
			if(rs.next()){
				asociacionId = rs.getString("UNION_ID");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|getUnionId|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return asociacionId;
	}	
	
	public static String getTotalEscuelas(Connection conn) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs			= null;
		String totEscuelas		= null;
		try{
			ps = conn.prepareStatement("SELECT COUNT(*) AS ESCUELAS FROM CAT_ESCUELA");
			rs= ps.executeQuery();		
			if(rs.next()){
				totEscuelas = rs.getString("ESCUELAS");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|getTotalEscuelas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return totEscuelas;
	}	
	
	
	public static String getOrgId(Connection conn, String escuelaId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String orgId			= "";		
		try{
			ps = conn.prepareStatement("SELECT ORG_ID FROM CAT_ESCUELA WHERE ESCUELA_ID = ? ");
			ps.setString(1, escuelaId);
			rs= ps.executeQuery();		
			if(rs.next()){
				orgId = rs.getString("ORG_ID");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|getOrgId|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return orgId;
	}	
	
	public static String getDistrito(Connection conn, String escuelaId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String distrito			= "-";		
		try{
			ps = conn.prepareStatement("SELECT DISTRITO FROM CAT_ESCUELA WHERE ESCUELA_ID = ? ");
			ps.setString(1, escuelaId);
			rs= ps.executeQuery();		
			if(rs.next()){
				distrito = rs.getString("DISTRITO");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|getDistrito|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return distrito;
	}	
	
	public static String getWww(Connection conn, String escuelaId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String distrito			= "-";		
		try{
			ps = conn.prepareStatement("SELECT WWW FROM CAT_ESCUELA WHERE ESCUELA_ID = ? ");
			ps.setString(1, escuelaId);
			rs= ps.executeQuery();		
			if(rs.next()){
				distrito = rs.getString("WWW");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|getWww|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return distrito;
	}	
	
}
