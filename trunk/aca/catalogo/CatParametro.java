package aca.catalogo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CatParametro {
	private String escuelaId;
	private String firmaBoleta;
	private String firmaPadre;
	private String sunPlus;
	private String ipServer;
	private String baseDatos;
	private String puerto;
	private String caja;	
	private String tipoBoleta;
	private String bloqueaPortal;
	
	public CatParametro(){
		escuelaId		= "";
		firmaBoleta		= "N";
		firmaPadre		= "N";
		sunPlus			= "N";
		ipServer		= "0.0.0.0";
		baseDatos		= "";
		puerto			= "";
		caja			= "";
		tipoBoleta		= "";
		bloqueaPortal 	= "100000"; 
	}

	
	public String getTipoBoleta() {
		return tipoBoleta;
	}


	public void setTipoBoleta(String tipoBoleta) {
		this.tipoBoleta = tipoBoleta;
	}


	public String getEscuelaId() {
		return escuelaId;
	}

	public void setEscuelaId(String escuelaId) {
		this.escuelaId = escuelaId;
	}

	public String getFirmaBoleta() {
		return firmaBoleta;
	}

	public void setFirmaBoleta(String firmaBoleta) {
		this.firmaBoleta = firmaBoleta;
	}

	public String getFirmaPadre() {
		return firmaPadre;
	}

	public void setFirmaPadre(String firmaPadre) {
		this.firmaPadre = firmaPadre;
	}
	
		
	/**
	 * @return the sunPlus
	 */
	public String getSunPlus() {
		return sunPlus;
	}


	/**
	 * @param sunPlus the sunPlus to set
	 */
	public void setSunPlus(String sunPlus) {
		this.sunPlus = sunPlus;
	}


	/**
	 * @return the ipServer
	 */
	public String getIpServer() {
		return ipServer;
	}


	/**
	 * @param ipServer the ipServer to set
	 */
	public void setIpServer(String ipServer) {
		this.ipServer = ipServer;
	}
	
	

	public String getBaseDatos() {
		return baseDatos;
	}


	public void setBaseDatos(String baseDatos) {
		this.baseDatos = baseDatos;
	}


	public String getPuerto() {
		return puerto;
	}


	public void setPuerto(String puerto) {
		this.puerto = puerto;
	}

	/**
	 * @return the caja
	 */
	public String getCaja() {
		return caja;
	}

	/**
	 * @param caja the caja to set
	 */
	public void setCaja(String caja) {
		this.caja = caja;
	}
	
	
	/**
	 * @return the bloqueaPortal
	 */
	public String getBloqueaPortal() {
		return bloqueaPortal;
	}

	/**
	 * @param bloqueaPortal the bloqueaPortal to set
	 */
	public void setBloqueaPortal(String bloqueaPortal) {
		this.bloqueaPortal = bloqueaPortal;
	}


	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("INSERT INTO CAT_PARAMETRO" +
					" (ESCUELA_ID, FIRMA_BOLETA, FIRMA_PADRE, SUNPLUS, IP_SERVER, BASEDATOS, PUERTO, CAJA, TIPO_BOLETA, BLOQUEA_PORTAL)" + 
					" VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, TO_NUMBER(?,'999999.99'))");
			ps.setString(1, escuelaId);
			ps.setString(2, firmaBoleta);
			ps.setString(3, firmaPadre);
			ps.setString(4, sunPlus);
			ps.setString(5, ipServer);
			ps.setString(6, baseDatos);
			ps.setString(7, puerto);
			ps.setString(8, caja);
			ps.setString(9, tipoBoleta);
			ps.setString(10, bloqueaPortal);
			if ( ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;
			}
						
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatParametro|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("UPDATE CAT_PARAMETRO" +
					" SET FIRMA_BOLETA = ?," +
					" FIRMA_PADRE = ?," +
					" SUNPLUS 	= ?," +
					" IP_SERVER = ?," +
					" BASEDATOS = ?," +
					" PUERTO	= ?," +
					" CAJA 		= ?," +
					" TIPO_BOLETA	= ?,"+
					" BLOQUEA_PORTAL = TO_NUMBER(?,'999999.99')" +
					" WHERE ESCUELA_ID = ?");
			ps.setString(1, firmaBoleta);
			ps.setString(2, firmaPadre);
			ps.setString(3, sunPlus);
			ps.setString(4, ipServer);				
			ps.setString(5, baseDatos);
			ps.setString(6, puerto);
			ps.setString(7, caja);
			ps.setString(8, tipoBoleta);
			ps.setString(9, bloqueaPortal);
			ps.setString(10, escuelaId);
						
			if ( ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatParametro|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CAT_PARAMETRO WHERE ESCUELA_ID = ? ");
			ps.setString(1, escuelaId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatParametro|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		escuelaId		= rs.getString("ESCUELA_ID");
		firmaBoleta		= rs.getString("FIRMA_BOLETA");
		firmaPadre		= rs.getString("FIRMA_PADRE");
		sunPlus			= rs.getString("SUNPLUS");
		ipServer		= rs.getString("IP_SERVER");
		baseDatos		= rs.getString("BASEDATOS");
		puerto			= rs.getString("PUERTO");
		caja			= rs.getString("CAJA");
		tipoBoleta		= rs.getString("TIPO_BOLETA");
		bloqueaPortal	= rs.getString("BLOQUEA_PORTAL");		
	}
	
	public void mapeaRegId(Connection con, String escuelaId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT ESCUELA_ID, FIRMA_BOLETA, FIRMA_PADRE, SUNPLUS, IP_SERVER, BASEDATOS, PUERTO, CAJA, TIPO_BOLETA, BLOQUEA_PORTAL" +
					" FROM CAT_PARAMETRO" +
					" WHERE ESCUELA_ID = ? ");
			
			ps.setString(1, escuelaId);			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatParametro|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
	}
	
	public boolean existeReg(Connection conn) throws SQLException{
		boolean ok 				= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CAT_PARAMETRO" +
					" WHERE ESCUELA_ID = ? ");
			ps.setString(1, escuelaId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatParametro|existeReg|:"+ex);
		}
		if (rs!=null) rs.close();
		if (ps!=null) ps.close();
		
		return ok;
	}
	
	public static boolean esSunPlus(Connection conn, String escuelaId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		boolean ok 				= false;
		
		try{
			ps = conn.prepareStatement("SELECT SUNPLUS FROM CAT_PARAMETRO WHERE ESCUELA_ID = ?");
			ps.setString(1, escuelaId);
			
			rs	= ps.executeQuery();		
			if(rs.next()){
				if (rs.getString("SUNPLUS").equals("S")){
					ok = true;
				}
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatParametro|esSunPlus|:"+ex);
		}
		if (rs!=null) rs.close();
		if (ps!=null) ps.close();
		
		return ok;
	}
	
	public static String getTipoBoleta(Connection conn, String escuelaId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String tipoBoleta		= "1";
		
		try{
			ps = conn.prepareStatement("SELECT TIPO_BOLETA FROM CAT_PARAMETRO WHERE ESCUELA_ID=?");
			ps.setString(1, escuelaId);
			rs= ps.executeQuery();		
			if(rs.next()){
				tipoBoleta = rs.getString("TIPO_BOLETA");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatParametro|getUnionEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return tipoBoleta;
	}
	
	public static String getBloqueaPortal(Connection conn, String escuelaId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String tipoBoleta		= "1";
		
		try{
			ps = conn.prepareStatement("SELECT BLOQUEA_PORTAL FROM CAT_PARAMETRO WHERE ESCUELA_ID = ? ");
			ps.setString(1, escuelaId);
			rs= ps.executeQuery();		
			if(rs.next()){
				tipoBoleta = rs.getString("BLOQUEA_PORTAL");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatParametro|getBloqueaPortal|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return tipoBoleta;
	}	
}