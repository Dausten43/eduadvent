/**
 * 
 */
package aca.usuario;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * @author Elifo
 *
 */
public class Usuario {
	
	private String codigoId;
	private String tipoId;
	private String cuenta;
	private String clave;
	private String division;
	private String administrador;
	private String escuela;	
	//private String estadoEscuela;	
	private String plan;
	private String cotejador;
	private String contable;
	private String nivel;
	private String asociacion;
	private String idioma;
	
	public Usuario() {
		codigoId 		= "";
		tipoId 			= "";
		cuenta 			= "";
		clave 			= "";
		division 		= "N";
		administrador 	= "";
		escuela 		= "";	
		plan 			= "";
		cotejador 		= "";
		contable 		= "";
		nivel 			= "";
		asociacion 		= "";
		idioma 			= "";
    }
	
	public String getNivel() {
		return nivel;
	}
	public void setNivel(String nivel) {
		this.nivel = nivel;
	}
	/**
	 * @return the clave
	 */
	public String getClave() {
		return clave;
	}
	/**
	 * @param clave the clave to set
	 */
	public void setClave(String clave) {
		this.clave = clave;
	}
	/**
	 * @return the codigo
	 */
	public String getCodigoId() {
		return codigoId;
	}
	/**
	 * @param codigo the codigo to set
	 */
	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}
	/**
	 * @return the cuenta
	 */
	public String getCuenta() {
		return cuenta;
	}
	/**
	 * @param cuenta the cuenta to set
	 */
	public void setCuenta(String cuenta) {
		this.cuenta = cuenta;
	}
	/**
	 * @return the tipoId
	 */
	public String getTipoId() {
		return tipoId;
	}
	/**
	 * @param tipoId the tipo to set
	 */
	public void setTipoId(String tipoId) {
		this.tipoId = tipoId;
	}
	
		
	public String getAdministrador() {
		return administrador;
	}
	public void setAdministrador(String administrador) {
		this.administrador = administrador;
	}
	
	public String getEscuela() {
		return escuela;
	}
	public void setEscuela(String escuela) {
		this.escuela = escuela;
	}
	
	
	public String getPlan() {
		return plan;
	}
	public void setPlan(String plan) {
		this.plan = plan;
	}
	public String getCotejador() {
		return cotejador;
	}
	public void setCotejador(String cotejador) {
		this.cotejador = cotejador;
	}
	public String getContable() {
		return contable;
	}
	public void setContable(String contable) {
		this.contable = contable;
	}
	
	public String getAsociacion() {
		return asociacion;
	}
	public void setAsociacion(String asociacion) {
		this.asociacion = asociacion;
	}	
	
	public String getDivision() {
		return division;
	}
	public void setDivision(String division) {
		this.division = division;
	}
	
	public String getIdioma() {
		return idioma;
	}

	public void setIdioma(String idioma) {
		this.idioma = idioma;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO USUARIO" +
					"(CODIGO_ID, TIPO_ID, CUENTA, CLAVE, ADMINISTRADOR, ESCUELA, PLAN, COTEJADOR, CONTABLE, NIVEL, ASOCIACION, DIVISION, IDIOMA)" +
					" VALUES(?,TO_NUMBER(?, '99'),?,?,?,?,?,?,?,?,?,?,?)");
			ps.setString(1,codigoId);
			ps.setString(2,tipoId);
			ps.setString(3,cuenta);
			ps.setString(4,clave);
			ps.setString(5,administrador);
			ps.setString(6,escuela);
			ps.setString(7,plan);
			ps.setString(8,cotejador);
			ps.setString(9,contable);
			ps.setString(10,nivel);
			ps.setString(11,asociacion);
			ps.setString(12,division);
			ps.setString(13,idioma);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.Usuario|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE USUARIO" +
					" SET TIPO_ID = TO_NUMBER(?, '99')," +
					" CUENTA= ?," +
					" CLAVE= ?," +
					" ADMINISTRADOR = ?," +
					" ESCUELA = ?," +
					" PLAN = ?," +
					" COTEJADOR = ?," +
					" CONTABLE = ?," +
					" NIVEL = ?, ASOCIACION = ?, DIVISION = ?, IDIOMA = ? " +
					" WHERE CODIGO_ID = ?");			
			ps.setString(1,tipoId);
			ps.setString(2,cuenta);
			ps.setString(3,clave);
			ps.setString(4,administrador);
			ps.setString(5,escuela);
			ps.setString(6,plan);
			ps.setString(7,cotejador);
			ps.setString(8,contable);
			ps.setString(9,nivel);
			ps.setString(10, asociacion);
			ps.setString(11, division);
			ps.setString(12,idioma);
			ps.setString(13,codigoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.Usuario|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateRegPrivilegio(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE USUARIO" +
					" SET ADMINISTRADOR = ?," +
					" COTEJADOR = ?," +
					" CONTABLE = ?," +
					" ESCUELA = ?," +
					" ASOCIACION = ?, DIVISION = ?"+
					" WHERE CODIGO_ID = ?");
			
			ps.setString(1, administrador);
			ps.setString(2, cotejador);
			ps.setString(3, contable);
			ps.setString(4, escuela);
			ps.setString(5, asociacion);
			ps.setString(6, division);
			ps.setString(7, codigoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.Usuario|updateRegPrivilegio|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateIdioma(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE USUARIO SET IDIOMA = ?"+
					" WHERE CODIGO_ID = ?");
			
			ps.setString(1, idioma);
			ps.setString(2, codigoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.Usuario|updateIdioma|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn, String codigoId, String nombre, String usuarioEliminador, String nombreEliminador, String fecha, String ip) throws SQLException{
		boolean ok = false;
		PreparedStatement ps 	= null;
		PreparedStatement ps2 	= null;
		
		try{
			ps = conn.prepareStatement("DELETE FROM USUARIO WHERE CODIGO_ID = ?");
			ps.setString(1,codigoId);			
			if ( ps.executeUpdate()!= -1){
				
				//---- GUARDAR LOG --->
				ps2 = conn.prepareStatement("INSERT INTO LOG_DELETE_USUARIO"
											+ " (CODIGO_ID, NOMBRE, USUARIO_ELIMINADOR, NOMBRE_ELIMINADOR, FECHA, IP) "
											+ " VALUES('"+codigoId+"', '"+nombre+"', '"+usuarioEliminador+"', '"+nombreEliminador+"', '"+fecha+"', '"+ip+"')");
				if(ps2.executeUpdate()== 1){
					ok = true;
				}else{
					ok = false;
				}
				//---- END GUARDAR LOG --->
				
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.Usuario|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
			if (ps2!=null) ps2.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId		= rs.getString("CODIGO_ID");
		tipoId			= rs.getString("TIPO_ID");
		cuenta 			= rs.getString("CUENTA");
		clave			= rs.getString("CLAVE");
		administrador	= rs.getString("ADMINISTRADOR");
		escuela			= rs.getString("ESCUELA");
		plan			= rs.getString("PLAN");
		cotejador		= rs.getString("COTEJADOR");
		contable		= rs.getString("CONTABLE");
		nivel			= rs.getString("NIVEL");
		asociacion		= rs.getString("ASOCIACION");
		division		= rs.getString("DIVISION");
		idioma 			= rs.getString("IDIOMA");
	}
	
	public void mapeaRegId(Connection con, String codigoId) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null; 
		try{
			ps = con.prepareStatement("SELECT CODIGO_ID, TIPO_ID, CUENTA, CLAVE, ADMINISTRADOR, ESCUELA, PLAN, COTEJADOR, CONTABLE, NIVEL, ASOCIACION, DIVISION, IDIOMA " +
					" FROM USUARIO WHERE CODIGO_ID = ? ");
			ps.setString(1, codigoId);
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.Usuario|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM USUARIO WHERE CODIGO_ID = ? ");
			ps.setString(1, codigoId);
			rs= ps.executeQuery();	
			if(rs.next()){				
				ok = true;
			}else{				
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.Usuario|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public String getEsUsuario(Connection Conn, String  cuenta, String clave, String escuelaId ) throws SQLException{
		
		Statement st 			= Conn.createStatement();
		ResultSet rs 			= null;
		String comando			= "";
		String codigoId		 	= "x";
		cuenta = cuenta.replaceAll("'", "");
		try{
			comando = "SELECT CODIGO_ID FROM USUARIO "+
				"WHERE LENGTH(CUENTA) = LENGTH('"+cuenta+"') "+
				"AND LENGTH(CLAVE) = LENGTH('"+clave+"') "+
				"AND CUENTA = '"+cuenta+"' " +
				"AND CLAVE = '"+clave+"' " +
				"AND ESCUELA LIKE '%-"+escuelaId+"-%'";
			rs = st.executeQuery(comando);
			if (rs.next()){
				codigoId = rs.getString("CODIGO_ID");
			}else{
				codigoId = "x";
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.menu.ModuloUtil|getEsUsuario|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		return codigoId;
	}
	
	public String getEsUsuario(Connection conn, String cuenta, String clave) throws SQLException{
 		
 		ResultSet 		rs		= null;
 		PreparedStatement ps	= null; 		
 		String codigoId		 	= "x";
 		
 		try{
 			ps = conn.prepareStatement("SELECT CODIGO_ID FROM USUARIO "+
 				"WHERE CUENTA = ? AND CLAVE = ?");				
 			ps.setString(1,cuenta);
			ps.setString(2,clave);
 			rs = ps.executeQuery(); 
 			if (rs.next()){
				codigoId = rs.getString("CODIGO_ID");
			}else{
				codigoId = "x";
			}

 		}catch(Exception ex){
 			System.out.println("Error - aca.usuario.Usuario|getValidaClave|:"+ex);
 		}finally{
 			if (rs!=null) rs.close();
 			if (ps!=null) ps.close();
 		}
 		return codigoId;
 	}
	
	
public String getEsUsuario(Connection conn, String cuenta) throws SQLException{
 		
 		ResultSet 		rs		= null;
 		PreparedStatement ps	= null; 		
 		String codigoId		 	= "x";
 		
 		try{
 			ps = conn.prepareStatement("SELECT CODIGO_ID FROM USUARIO "+
 				"WHERE upper(CUENTA) = ? ");				
 			ps.setString(1,cuenta);
			
 			rs = ps.executeQuery(); 
 			if (rs.next()){
				codigoId = rs.getString("CODIGO_ID");
			}else{
				codigoId = "x";
			}

 		}catch(Exception ex){
 			System.out.println("Error - aca.usuario.Usuario|getValidaClave|:"+ex);
 		}finally{
 			if (rs!=null) rs.close();
 			if (ps!=null) ps.close();
 		}
 		return codigoId;
 	}
	
	public static boolean getValidaCuenta(Connection conn, String cuenta) throws SQLException{
 		
 		ResultSet 		rs		= null;
 		PreparedStatement ps	= null; 		
 		boolean valida	 		= false;
 		try{
 			ps = conn.prepareStatement("SELECT TRIM(CUENTA) FROM USUARIO "+
 				"WHERE CUENTA = ? ");			
 			ps.setString(1,cuenta);
 			rs = ps.executeQuery(); 
 			if (rs.next()){ 				 
 				valida = true;
 			}

 		}catch(Exception ex){
 			System.out.println("Error - aca.usuario.Usuario|getValidaCuenta|:"+ex);
 		}finally{
 			if (rs!=null) rs.close();
 			if (ps!=null) ps.close();
 		}	
 		return valida;
 	}
	
	
	public static boolean getValidaClave(Connection conn, String cuenta, String clave) throws SQLException{
 		
 		ResultSet 		rs		= null;
 		PreparedStatement ps	= null; 		
 		boolean valida	 		= false;
 		
 		try{
 			ps = conn.prepareStatement("SELECT CLAVE FROM USUARIO "+
 				"WHERE CUENTA = ? AND CLAVE = ?");				
 			ps.setString(1,cuenta);
			ps.setString(2,clave);
 			rs = ps.executeQuery(); 
 			if (rs.next()){ 				 
 				valida = true;
 			}

 		}catch(Exception ex){
 			System.out.println("Error - aca.usuario.Usuario|getValidaClave|:"+ex);
 		}finally{
 			if (rs!=null) rs.close();
 			if (ps!=null) ps.close();
 		}
 		return valida;
 	}
	
	public static int getTipo(Connection conn, String codigoId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		int tipoId				= 0;
		
		try{
			ps = conn.prepareStatement("SELECT TIPO_ID FROM USUARIO WHERE CODIGO_ID = ?");
			ps.setString(1, codigoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				tipoId = rs.getInt("TIPO_ID");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.Usuario|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return tipoId;
	}
	
	public static boolean existeCuenta(Connection conn, String cuenta, String codigoId) throws SQLException{
 		
 		ResultSet 		rs		= null;
 		PreparedStatement ps	= null; 		
 		boolean valida	 		= false;
 		
 		try{
 			ps = conn.prepareStatement("SELECT CUENTA FROM USUARIO WHERE CUENTA = ? AND CODIGO_ID != ?");
 			ps.setString(1, cuenta);
 			ps.setString(2, codigoId);
 			rs = ps.executeQuery(); 
 			if (rs.next()){
 				valida = true;
 			}

 		}catch(Exception ex){
 			System.out.println("Error - aca.usuario.Usuario|existeCuenta|:"+ex);
 		}finally{
 			if (rs!=null) rs.close();
 			if (ps!=null) ps.close();
 		}	
 		return valida;
 	}
	
	public static String getEscuelaUsuario(Connection conn, String codigoId, String tipo) throws SQLException{
 		 		
 		PreparedStatement ps	= null;
 		ResultSet 		rs		= null;
 		String escuela	 		= "0";
 		
 		try{
 			if (tipo.equals("1")){
 				ps = conn.prepareStatement("SELECT ESCUELA_ID FROM ALUM_PERSONAL WHERE CODIGO_ID = ?");
 			}else{
 				ps = conn.prepareStatement("SELECT ESCUELA_ID FROM EMP_PERSONAL WHERE CODIGO_ID = ?");
 			}
 			ps.setString(1, codigoId);
 		 	rs = ps.executeQuery(); 
 		 	if (rs.next()){ 			 
 				escuela = rs.getString("ESCUELA_ID");
 			}
 		}catch(Exception ex){
 			System.out.println("Error - aca.usuario.Usuario|getEscuelaUsuario|:"+ex);
 		}finally{
 			if (rs!=null) rs.close();
 			if (ps!=null) ps.close();
 		}	
 		return escuela;
 	}
	
	public static boolean esSuper(Connection conn, String codigoId) throws SQLException{
		boolean ok 				= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT SUPER FROM USUARIO WHERE CODIGO_ID = ?");
			ps.setString(1, codigoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				if(rs.getString("SUPER").equals("S"))
					ok = true;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.Usuario|esSuper|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public static boolean esAdministrador(Connection conn, String codigoId) throws SQLException{
		boolean ok 				= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT ADMINISTRADOR FROM USUARIO WHERE CODIGO_ID = ? ");
			ps.setString(1, codigoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				if(rs.getString("ADMINISTRADOR").equals("S"))
					ok = true;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.Usuario|esAdministrador|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public static boolean esDivision(Connection conn, String codigoId) throws SQLException{
		boolean ok 				= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT DIVISION FROM USUARIO WHERE CODIGO_ID = ? ");
			ps.setString(1, codigoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				if(rs.getString("DIVISION").equals("S"))
					ok = true;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.Usuario|esDivision|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public static boolean esContable(Connection conn, String codigoId) throws SQLException{
		boolean ok 				= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT CONTABLE FROM USUARIO WHERE CODIGO_ID = ? ");
			ps.setString(1, codigoId);
			
			rs = ps.executeQuery();		
			if(rs.next()){
				if(rs.getString("CONTABLE").equals("S"))
					ok = true;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.Usuario|esContable|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public String getNivel(Connection conn, String codigoId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String Nivel			= "";
		
		try{
			ps = conn.prepareStatement("SELECT NIVEL FROM USUARIO WHERE CODIGO_ID = ?");
			ps.setString(1, codigoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				Nivel = rs.getString("NIVEL");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.Usuario|getNivel|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return Nivel;
	}	
	
	public static String getIdioma(Connection conn, String codigoId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String idioma			= "es";
		
		try{
			ps = conn.prepareStatement("SELECT IDIOMA FROM USUARIO WHERE CODIGO_ID = ?");
			ps.setString(1, codigoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				idioma = rs.getString("IDIOMA");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.Usuario|getIdioma|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return idioma;
	}
	
	/* ASOCIACIONES DEL USUARIO PERO SOLO SI TIENE ACCESO POR LO MENOS A UNA ESCUELA DENTRO DE ESA ASOCIACION */
	public static java.util.ArrayList<String> AsociacionesDelUsuario(Connection conn, String codigoId) throws SQLException{
		
		Usuario usuario = new Usuario();
		aca.catalogo.CatEscuelaLista catEscuelaL = new aca.catalogo.CatEscuelaLista();
		
		usuario.mapeaRegId(conn, codigoId);
		String [] asociacionesUsuario 	= usuario.getAsociacion().trim().split("-");
		
		
		String [] escuelasUsuario 		= usuario.getEscuela().trim().split("-");
		java.util.ArrayList<String> arrayEscuelas = new java.util.ArrayList<String>();
		java.util.Collections.addAll(arrayEscuelas, escuelasUsuario);
		
		
		java.util.ArrayList<aca.catalogo.CatEscuela> escuelas = catEscuelaL.getListAll(conn, " ORDER BY ASOCIACION_ID ");
		
		java.util.ArrayList<String> EscuelasDelUsuario 					= new java.util.ArrayList<String>();
		java.util.ArrayList<String> AsociacionesDelUsuario 				= new java.util.ArrayList<String>();	
		
		for(String asoc: asociacionesUsuario){
			String schools  = "";
			for(aca.catalogo.CatEscuela escTmp: escuelas){
				String asocTmp = escTmp.getAsociacionId()==null?"*":escTmp.getAsociacionId();
				
				if(asocTmp.equals(asoc)){
					if(arrayEscuelas.contains(escTmp.getEscuelaId())){
						schools+="'"+escTmp.getEscuelaId()+"',";
					}
				}
			}
			if(!schools.equals("")){
				schools=schools.substring(0, schools.length()-1);
				EscuelasDelUsuario.add(schools);
				AsociacionesDelUsuario.add(asoc);
				
			}
		}
		
		return AsociacionesDelUsuario;
	}
	
}
