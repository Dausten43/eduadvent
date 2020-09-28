/**
 * 
 */
package aca.empleado;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * @author Jose Torres
 *
 */
public class EmpPersonal {
	private String codigoId;
	private String escuelaId;
	private String nombre;
	private String apaterno;
	private String amaterno;
	private String genero;
	private String fNacimiento;
	private String paisId;
	private String estadoId;
	private String ciudadId;
	private String email;
	private String colonia;
	private String direccion;
	private String telefono;	
	private String estado;
	private String estadoCivil;
	private String tipoId;
	private String ocupacion;
	private String rfc;
	private String ssocial;
	private String publicar;
	private String iglesia;
	private String tipoSangre;
	
	public EmpPersonal(){
		codigoId	= "";
		escuelaId	= "";
		nombre		= "";
		apaterno	= "";
		amaterno	= "";
		genero		= "";
		fNacimiento	= "";
		paisId 		= "0";
		estadoId 	= "0";
		ciudadId	= "0";
		email 		= "";
		colonia		= "";
		direccion	= "";
		telefono 	= "";
		estado		= "";
		estadoCivil	= "";
		tipoId		= "";
		ocupacion	= "";
		rfc			= "";
		ssocial		= "";
		publicar	= "";
		iglesia 	= "";
		tipoSangre  = "";
	}

	
	public String getfNacimiento() {
		return fNacimiento;
	}


	public void setfNacimiento(String fNacimiento) {
		this.fNacimiento = fNacimiento;
	}

	/**
	 * @return Returns the amaterno.
	 */
	public String getAmaterno() {
		return amaterno;
	}
	

	/**
	 * @param amaterno The amaterno to set.
	 */
	public void setAmaterno(String amaterno) {
		this.amaterno = amaterno;
	}


	/**
	 * @return Returns the apaterno.
	 */
	public String getApaterno() {
		return apaterno;
	}
	

	/**
	 * @param apaterno The apaterno to set.
	 */
	public void setApaterno(String apaterno) {
		this.apaterno = apaterno;
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
	 * @return Returns the codigoId.
	 */
	public String getCodigoId() {
		return codigoId;
	}


	/**
	 * @param codigoId The codigoId to set.
	 */
	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
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
	 * @return Returns the email.
	 */
	public String getEmail() {
		return email;
	}


	/**
	 * @param email The email to set.
	 */
	public void setEmail(String email) {
		this.email = email;
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
	 * @return Returns the estado.
	 */
	public String getEstado() {
		return estado;
	}
	

	/**
	 * @param estado The estado to set.
	 */
	public void setEstado(String estado) {
		this.estado = estado;
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
	 * @return Returns the fNacimiento.
	 */
	public String getFNacimiento() {
		return fNacimiento;
	}
	

	/**
	 * @param nacimiento The fNacimiento to set.
	 */
	public void setFNacimiento(String nacimiento) {
		fNacimiento = nacimiento;
	}
	

	/**
	 * @return Returns the genero.
	 */
	public String getGenero() {
		return genero;
	}
	

	/**
	 * @param genero The genero to set.
	 */
	public void setGenero(String genero) {
		this.genero = genero;
	}
	

	/**
	 * @return Returns the nombre.
	 */
	public String getNombre() {
		return nombre;
	}
	

	/**
	 * @param nombre The nombre to set.
	 */
	public void setNombre(String nombre) {
		this.nombre = nombre;
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
	

	public String getEstadoCivil() {
		return estadoCivil;
	}


	public void setEstadoCivil(String estadoCivil) {
		this.estadoCivil = estadoCivil;
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
	 * @return the ocupacion
	 */
	public String getOcupacion() {
		return ocupacion;
	}

	/**
	 * @param ocupacion the ocupacion to set
	 */
	public void setOcupacion(String ocupacion) {
		this.ocupacion = ocupacion;
	}

	/**
	 * @return the rfc
	 */
	public String getRfc() {
		return rfc;
	}

	/**
	 * @param rfc the rfc to set
	 */
	public void setRfc(String rfc) {
		this.rfc = rfc;
	}

	/**
	 * @return the ssocial
	 */
	public String getSsocial() {
		return ssocial;
	}

	/**
	 * @param ssocial the ssocial to set
	 */
	public void setSsocial(String ssocial) {
		this.ssocial = ssocial;
	}
	
	public String getPublicar() {
		return publicar;
	}

	public void setPublicar(String publicar) {
		this.publicar = publicar;
	}
	
	/**
	 * @return Returns the iglesia.
	 */
	public String getIglesia() {
		return iglesia;
	}
	

	/**
	 * @param nombre The iglesia to set.
	 */
	public void setIglesia(String iglesia) {
		this.iglesia = iglesia;
	}
	
	public String getTipoSangre() {
		return tipoSangre;
	}

	public void setTipoSangre(String tipoSangre) {
		this.tipoSangre = tipoSangre;
	}


	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps 	= null;
		boolean ok 				= false;
		
		try{
			ps = conn.prepareStatement("INSERT INTO EMP_PERSONAL" +
					" (CODIGO_ID, ESCUELA_ID, NOMBRE," +
					" APATERNO, AMATERNO, GENERO, F_NACIMIENTO," +
					" PAIS_ID, ESTADO_ID, CIUDAD_ID," +
					" EMAIL, COLONIA, DIRECCION, TELEFONO," +
					" ESTADO, ESTADO_CIVIL, TIPO_ID, OCUPACION, RFC, SSOCIAL, PUBLICAR, IGLESIA, TIPO_SANGRE)" +
					" VALUES(?, ?, UPPER(?)," +
					" UPPER(?), UPPER(?), ?," +
					" TO_DATE(?, 'DD/MM/YYYY')," +
					" TO_NUMBER(?,'999')," +
					" TO_NUMBER(?,'999')," +
					" TO_NUMBER(?,'999')," +
					" ?,?,?,?,?,?, TO_NUMBER(?, '99'),?,?,?,?,?,?)");
			
			ps.setString( 1, codigoId);
			ps.setString( 2, escuelaId);
			ps.setString( 3, nombre);
			ps.setString( 4, apaterno);
			ps.setString( 5, amaterno);
			ps.setString( 6, genero);
			ps.setString( 7, fNacimiento);			
			ps.setString( 8, paisId);
			ps.setString( 9, estadoId);
			ps.setString(10, ciudadId);
			ps.setString(11, email);
			ps.setString(12, colonia);
			ps.setString(13, direccion);
			ps.setString(14, telefono);
			ps.setString(15, estado);	
			ps.setString(16, estadoCivil);
			ps.setString(17, tipoId);
			ps.setString(18, ocupacion);
			ps.setString(19, rfc);
			ps.setString(20, ssocial);
			ps.setString(21, publicar);
			ps.setString(22, iglesia);
			ps.setString(23, tipoSangre);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonal|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean insertPadre(Connection conn ) throws SQLException{
		PreparedStatement ps 	= null;
		boolean ok 				= false;
		
		try{
			ps = conn.prepareStatement("INSERT INTO EMP_PERSONAL" +
					" (CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO, " +
					" GENERO, TELEFONO, DIRECCION, OCUPACION, EMAIL, ESTADO, TIPO_ID )" +
					" VALUES(?, ?, UPPER(?), UPPER(?), UPPER(?)," +
					" ?,?,?,?,?,?,TO_NUMBER(?,'99'))");
			
			ps.setString( 1, codigoId);
			ps.setString( 2, escuelaId);
			ps.setString( 3, nombre);
			ps.setString( 4, apaterno);
			ps.setString( 5, amaterno);
			ps.setString( 6, genero);
			ps.setString( 7, telefono);			
			ps.setString( 8, direccion);
			ps.setString( 9, ocupacion);
			ps.setString(10, email);			
			ps.setString(11, estado);	
			ps.setString(12, tipoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonal|insertPadre|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean insertNuevo(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO EMP_PERSONAL" +
					" (CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO, GENERO, F_NACIMIENTO) " +
					" VALUES(?, ?, UPPER(RTRIM(LTRIM(?)))," +
					" UPPER(RTRIM(LTRIM(?))), UPPER(RTRIM(LTRIM(?))), ?," +
					" TO_DATE(?, 'DD/MM/YYYY'))");			
			ps.setString(1, codigoId);
			ps.setString(2, escuelaId);
			ps.setString(3, nombre);
			ps.setString(4, apaterno);
			ps.setString(5, amaterno);
			ps.setString(6, genero);			
			ps.setString(7, fNacimiento);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonal|insertNuevo|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean insertTraspaso(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			/*
			String comando =  "INSERT INTO EMP_PERSONAL(CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO,F_NACIMIENTO,GENERO,EMAIL,COLONIA," +
					" DIRECCION, TELEFONO, OCUPACION, ESTADO)" +
					" VALUES('"+codigoId+"', '"+escuelaId+"', UPPER('"+nombre+"'), UPPER('"+apaterno+"'), UPPER('"+amaterno+"'), TO_DATE('"+fNacimiento+"', 'DD/MM/YYYY')," +
					" '"+genero+"', '"+email+"', '"+colonia+"', '"+direccion+"', '"+telefono+"', '"+ocupacion+"', '"+ocupacion+"'  ";
			*/		
			ps = conn.prepareStatement("INSERT INTO EMP_PERSONAL" +
					" (CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO,F_NACIMIENTO, GENERO, EMAIL, COLONIA," +
					" DIRECCION, TELEFONO, OCUPACION, ESTADO)" +
					" VALUES(?, ?, UPPER(?), UPPER(?), UPPER(?), TO_DATE(?, 'DD/MM/YYYY'), ?, ?, ?, ?, ?, ?, ?)");			
			ps.setString(1, codigoId); 
			ps.setString(2, escuelaId);
			ps.setString(3, nombre);
			ps.setString(4, apaterno);
			ps.setString(5, amaterno);
			ps.setString(6, fNacimiento);
			ps.setString(7, genero);
			ps.setString(8, email);
			ps.setString(9, colonia);
			ps.setString(10, direccion);
			ps.setString(11, telefono);
			ps.setString(12, ocupacion);
			ps.setString(13, estado);
			
			if ( ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonal|insertTraspaso|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok			 = false;
		try{
			ps = conn.prepareStatement("UPDATE EMP_PERSONAL" +
					" SET ESCUELA_ID = ?," +
					" NOMBRE = UPPER(?)," +
					" APATERNO = UPPER(?)," +
					" AMATERNO = UPPER(?)," +
					" GENERO = ?," +
					" F_NACIMIENTO = TO_DATE(?,'DD/MM/YYYY')," +
					" PAIS_ID = TO_NUMBER(?,'999')," +
					" ESTADO_ID = TO_NUMBER(?,'999')," +
					" CIUDAD_ID = TO_NUMBER(?,'999')," +
					" EMAIL = ?," +
					" COLONIA = ?," +
					" DIRECCION = ?," +
					" TELEFONO = ?," +				
					" ESTADO = ?," +
					" ESTADO_CIVIL = ?," +
					" TIPO_ID = TO_NUMBER(?, '99')," +
					" OCUPACION = ?," +
					" RFC = ?," +
					" SSOCIAL = ?, PUBLICAR = ?, " +
					" IGLESIA = ?, " +
					" TIPO_SANGRE = ?" +
					" WHERE CODIGO_ID = ?");
			
			ps.setString( 1, escuelaId);
			ps.setString( 2, nombre);
			ps.setString( 3, apaterno);
			ps.setString( 4, amaterno);
			ps.setString( 5, genero);
			ps.setString( 6, fNacimiento);
			ps.setString( 7, paisId);
			ps.setString( 8, estadoId);
			ps.setString( 9, ciudadId);
			ps.setString(10, email);
			ps.setString(11, colonia);
			ps.setString(12, direccion);
			ps.setString(13, telefono);
			ps.setString(14, estado);
			ps.setString(15, estadoCivil);
			ps.setString(16, tipoId);		
			ps.setString(17, ocupacion);
			ps.setString(18, rfc);
			ps.setString(19, ssocial);
			ps.setString(20, publicar);
			ps.setString(21, iglesia);
			ps.setString(22, tipoSangre);
			ps.setString(23, codigoId);
			
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonal|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok 			 = false;
		
		try{
			ps = conn.prepareStatement("DELETE FROM EMP_PERSONAL" +
					" WHERE CODIGO_ID = ?");
			ps.setString(1, codigoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonal|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();			
		}
		
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId	= rs.getString("CODIGO_ID");
		escuelaId	= rs.getString("ESCUELA_ID");
		nombre		= rs.getString("NOMBRE");
		apaterno	= rs.getString("APATERNO");
		amaterno	= rs.getString("AMATERNO");
		genero		= rs.getString("GENERO");		
		fNacimiento	= rs.getString("F_NACIMIENTO");
		paisId		= rs.getString("PAIS_ID");
		estadoId	= rs.getString("ESTADO_ID");
		ciudadId	= rs.getString("CIUDAD_ID");
		email		= rs.getString("EMAIL");
		colonia		= rs.getString("COLONIA");
		direccion	= rs.getString("DIRECCION");
		telefono	= rs.getString("TELEFONO");		
		estado		= rs.getString("ESTADO");	
		estadoCivil = rs.getString("ESTADO_CIVIL");
		tipoId		= rs.getString("TIPO_ID");
		ocupacion	= rs.getString("OCUPACION");
		rfc			= rs.getString("RFC");
		ssocial		= rs.getString("SSOCIAL");
		publicar	= rs.getString("PUBLICAR");
		iglesia 	= rs.getString("IGLESIA");
		tipoSangre	= rs.getString("TIPO_SANGRE");
	}
	
	public void mapeaRegId(Connection con, String codigoId) throws SQLException{
		PreparedStatement ps =null;
		ResultSet rs = null;		
		try{
			ps = con.prepareStatement("SELECT CODIGO_ID, ESCUELA_ID, NOMBRE," +
					" APATERNO, AMATERNO, GENERO, TO_CHAR(F_NACIMIENTO, 'DD/MM/YYYY') AS F_NACIMIENTO," +
					" PAIS_ID, ESTADO_ID, CIUDAD_ID, EMAIL, COLONIA, DIRECCION," +
					" TELEFONO, ESTADO, ESTADO_CIVIL, TIPO_ID, OCUPACION, RFC, SSOCIAL, PUBLICAR, IGLESIA, TIPO_SANGRE" +
					" FROM EMP_PERSONAL" +
					" WHERE CODIGO_ID = ?");
			
			ps.setString(1, codigoId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonal|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM EMP_PERSONAL" +
					" WHERE CODIGO_ID = ?");
			ps.setString(1, codigoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonal|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public static boolean existeReg(Connection conn, String codigoId) throws SQLException{
		boolean ok 			= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM EMP_PERSONAL" +
					" WHERE CODIGO_ID = ?");
			ps.setString(1, codigoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonal|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public static String getNombre(Connection conn, String codigoId, String opcion) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		String nombre		= "-";		
		try{
			if ( opcion.equals("NOMBRE")){
				comando = "SELECT NOMBRE||' '||APATERNO||' '||AMATERNO AS NOMBRE "+
					"FROM EMP_PERSONAL WHERE CODIGO_ID = '"+codigoId+"'";
			}else{
				comando = "SELECT APATERNO||' '||AMATERNO||' '||NOMBRE AS NOMBRE "+
					"FROM EMP_PERSONAL WHERE CODIGO_ID = '"+codigoId+"'";
			}	
			rs = st.executeQuery(comando);
			if (rs.next()){
				nombre = rs.getString("NOMBRE");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonal|getNombre|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return nombre;
	}
	
	public static String getSoloNombre(Connection conn, String codigoId) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		String nombre		= "x";
		
		try{
			comando = "SELECT NOMBRE FROM EMP_PERSONAL WHERE CODIGO_ID = '"+codigoId+"'";			
			rs = st.executeQuery(comando);
			if (rs.next()){
				nombre = rs.getString("NOMBRE");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonal|getSoloNombre|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}			
		
		return nombre;
	}
	
	public static String getSoloApellido(Connection conn, String codigoId) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		String nombre		= "x";
		
		try{
			comando = "SELECT APATERNO||' '||AMATERNO AS APELLIDO FROM EMP_PERSONAL WHERE CODIGO_ID = '"+codigoId+"'";
			
			rs = st.executeQuery(comando);
			if (rs.next()){
				nombre = rs.getString("APELLIDO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonal|getSoloApellido|:"+ex);
		}
		
		if (rs!=null) rs.close();
		if (st!=null) st.close();		
		
		return nombre;
	}
	
	public String maximoRegEmp(Connection conn, String escuela) throws SQLException{
 		
 		ResultSet 		rs		= null;
 		PreparedStatement ps	= null;
 		String maximo			= "";
 		int numMaximo 			= 0;
 				
 		try{ 						
		 		ps = conn.prepareStatement("SELECT " +
		 				" COALESCE(MAX(TO_NUMBER(SUBSTR(CODIGO_ID,5,4),'9999'))+1,1) AS MAXIMO" +
		 				" FROM EMP_PERSONAL"+
						" WHERE SUBSTR(CODIGO_ID,1,4) = '"+escuela+"E'");
		 		rs = ps.executeQuery();
		 		if (rs.next()){
		 			numMaximo = rs.getInt("MAXIMO");
		 			maximo = String.valueOf(numMaximo);
		 			switch(maximo.length()){
		 				case 1:{ maximo= "000"+maximo; break;}
		 				case 2:{ maximo= "00"+ maximo; break;}
		 				case 3:{ maximo= "0"+  maximo; break;}
		 			}		 				
		 			maximo = escuela+"E"+maximo;				
		 		}else{
		 			maximo = "0000000";
		 		}	
 			} 			
 			catch(Exception ex){
 			System.out.println("Error - aca.empleado.EmpPersonal|maximoRegEmp|:"+ex);
 		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
 		}
		
 		return maximo;
 	} 

	public String maximoRegPad(Connection conn, String escuela) throws SQLException{
		
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		String maximo			= ""; 		
		int numMaximo			=0;
		
		try{ 						
	 		ps = conn.prepareStatement("SELECT " +
	 				" COALESCE(MAX(TO_NUMBER(SUBSTR(CODIGO_ID,5,4),'9999'))+1,1) AS MAXIMO" +
	 				" FROM EMP_PERSONAL"+
					" WHERE SUBSTR(CODIGO_ID,1,4) = '"+escuela+"P'");
	 		rs = ps.executeQuery();
	 		if (rs.next()){
	 			numMaximo = rs.getInt("MAXIMO");
	 			maximo = String.valueOf(numMaximo);
	 			switch(maximo.length()){
	 				case 1:{ maximo= "000"+maximo; break;}
	 				case 2:{ maximo= "00"+ maximo; break;}
	 				case 3:{ maximo= "0"+  maximo; break;}
	 			}		 				
	 			maximo = escuela+"P"+maximo;				
	 		}else{
	 			maximo = escuela+"P0001";
	 		}	
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonal|maximoRegPad|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
	
		return maximo;
	}
	
	public static String getSecretarioDeRegistro(Connection conn, String escuela) throws SQLException {
 		
 		ResultSet 		rs		= null;
 		PreparedStatement ps	= null;
 		String nombre			= ""; 		
 				
 		try{ 							
		 			ps = conn.prepareStatement("SELECT * FROM EMP_PERSONAL" +
		 					" WHERE CODIGO_ID LIKE '"+escuela+"'||'%'" +
		 					" AND TIPO_ID = 40" +
		 					" AND ESTADO = 'A'");
		 			
		 			rs = ps.executeQuery();
		 			if (rs.next())
		 				nombre = rs.getString("NOMBRE")+" "+rs.getString("APATERNO")+" "+rs.getString("AMATERNO");		
		 			else
		 				nombre = "";
 			} 			
 			catch(Exception ex){
 			System.out.println("Error - aca.empleado.EmpPersonal|getSecretarioAcademico|:"+ex);
 		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
 		}
		
 		return nombre;
 	}
	
	public static String getSecretarioAcademico(Connection conn, String escuela) throws SQLException{
 		
 		ResultSet 		rs		= null;
 		PreparedStatement ps	= null;
 		String nombre			= ""; 		
 				
 		try{ 							
		 			ps = conn.prepareStatement("SELECT * FROM EMP_PERSONAL" +
		 					" WHERE CODIGO_ID LIKE '"+escuela+"'||'%'" +
		 					" AND TIPO_ID = 4");
		 			
		 			rs = ps.executeQuery();
		 			if (rs.next())
		 				nombre = rs.getString("NOMBRE")+" "+rs.getString("APATERNO")+" "+rs.getString("AMATERNO");		
		 			else
		 				nombre = "0000000";
 			} 			
 			catch(Exception ex){
 			System.out.println("Error - aca.empleado.EmpPersonal|getSecretarioAcademico|:"+ex);
 		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
 		}
		
 		return nombre;
 	}
	
	public static String getDirectorEscuela(Connection conn, String escuela) throws SQLException{
 		
 		ResultSet 		rs		= null;
 		PreparedStatement ps	= null;
 		String nombre			= ""; 		
 				
 		try{ 							
		 			ps = conn.prepareStatement("SELECT * FROM EMP_PERSONAL" +
		 					" WHERE CODIGO_ID LIKE '"+escuela+"'||'%'" +
		 					" AND TIPO_ID = 17" +
		 					" AND ESTADO = 'A'");
		 			
		 			rs = ps.executeQuery();
		 			if (rs.next())
		 				nombre = rs.getString("NOMBRE")+" "+rs.getString("APATERNO")+" "+rs.getString("AMATERNO");		
		 			else
		 				nombre = "";
 			} 			
 			catch(Exception ex){
 			System.out.println("Error - aca.empleado.EmpPersonal|getDirectorEscuela|:"+ex);
 		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
 		}
		
 		return nombre;
 	}
	
	public static int numMaestroGenero(Connection conn, String genero) throws SQLException{
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		int total 		= 0;
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(COUNT(CODIGO_ID),0) AS TOTAL FROM EMP_PERSONAL"+
				" WHERE CODIGO_ID IN (SELECT EMPLEADO_ID FROM CICLO_GRUPO_CURSO)" +
				" AND ESTADO = 'A'" +
				" AND GENERO = '"+genero+"'");
			
			rs = ps.executeQuery();
			while(rs.next()){				
				total = rs.getInt("TOTAL");
			}		
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonal|numMaestroGenero|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return total;
	}
	
	public static int getTotalEmpleados(Connection conn, String escuelaId ) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
		
		try{
			comando = "SELECT COUNT(CODIGO_ID) AS RESULTADO FROM EMP_PERSONAL"+
					" WHERE ESCUELA_ID = '"+escuelaId+"'";		
					
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonal|getTotalEmpleados|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return numAlum;
	}
	
	
public static int getTotalEmpleadosActivos(Connection conn, String escuelaId ) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
		
		try{
			comando = " SELECT COUNT(CODIGO_ID) AS RESULTADO FROM EMP_PERSONAL"
					+ " WHERE ESCUELA_ID = '"+escuelaId+"'"
					+ " AND ESTADO = 'A'"
					+ " AND SUBSTR(CODIGO_ID, 4,1) = 'E'";
					
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonal|getTotalEmpleados|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return numAlum;
	}
	
	public static int getTotalRegistrosAsocicacion(Connection conn, String escuelas ) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numEmp			= 0;
		
		try{
			comando = " SELECT COUNT(CODIGO_ID) AS RESULTADO FROM EMP_PERSONAL"
					+ " WHERE ESCUELA_ID IN ("+escuelas+")"
					+ " AND SUBSTR(CODIGO_ID,4,1) = 'E'";
			
			rs = st.executeQuery(comando);
			if (rs.next()){
				numEmp = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonal|getTotalRegistros|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return numEmp;
	}
	
	public static boolean getEstadoEmp(Connection conn, String codigoId) throws SQLException{
		boolean activo			= false;
		Statement st		 	= conn.createStatement();
		ResultSet rs			= null;
		String comando 			= "";
		String estado			= "";
		
		try {
			comando = " SELECT ESTADO FROM EMP_PERSONAL " 
					+ " WHERE CODIGO_ID = '"+codigoId+"'";

			rs = st.executeQuery(comando);
			if(rs.next()){
				estado = rs.getString("ESTADO");	
			}
			
			if(estado.equals("A")) {
				activo = true;
			}else if(estado.equals("I")){
				activo = false;
			}
						
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonal|getEstadoEmp|:"+ex);	
		}finally {
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		return activo;
	}
	
	
}
