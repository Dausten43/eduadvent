/**
 * 
 */
package aca.alumno;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * @author Jose Torres
 *
 */
public class AlumPersonal {
	private String codigoId;
	private String escuelaId;
	private String nombre;
	private String apaterno;
	private String amaterno;
	private String genero;
	private String curp;
	private String fNacimiento;
	private String paisId;
	private String estadoId;
	private String ciudadId;
	private String clasfinId;
	private String email;
	private String colonia;
	private String direccion;
	private String telefono;
	private String cotejado;
	private String nivelId;
	private String grado;
	private String grupo;
	private String estado;
	private String acta;
	private String crip;
	private String religion;
	private String transporte;
	private String celular;
	private String tutor;
	private String matricula;
	private String discapacidad;
	private String enfermedad;
	private String correo;
	private String iglesia;
	private String tipoSangre;
	private String tutorCedula;
	private String barrioId;
	private String urlPago;
	
	
	
	@Override
	public String toString() {
		return "AlumPersonal [codigoId=" + codigoId + ", escuelaId=" + escuelaId + ", nombre=" + nombre + ", apaterno="
				+ apaterno + ", amaterno=" + amaterno + ", genero=" + genero + ", curp=" + curp + ", fNacimiento="
				+ fNacimiento + ", paisId=" + paisId + ", estadoId=" + estadoId + ", ciudadId=" + ciudadId
				+ ", clasfinId=" + clasfinId + ", email=" + email + ", colonia=" + colonia + ", direccion=" + direccion
				+ ", telefono=" + telefono + ", cotejado=" + cotejado + ", nivelId=" + nivelId + ", grado=" + grado
				+ ", grupo=" + grupo + ", estado=" + estado + ", acta=" + acta + ", crip=" + crip + ", religion="
				+ religion + ", transporte=" + transporte + ", celular=" + celular + ", tutor=" + tutor + ", matricula="
				+ matricula + ", discapacidad=" + discapacidad + ", enfermedad=" + enfermedad + ", correo=" + correo
				+ ", iglesia=" + iglesia + ", tipoSangre=" + tipoSangre + ", tutorCedula=" + tutorCedula + ", barrioId="
				+ barrioId + ", urlPago=" + urlPago + "]";
	}

	public AlumPersonal(){
		codigoId	= "";
		escuelaId	= "";
		nombre		= "";
		apaterno	= "";
		amaterno	= "";
		genero		= "";
		curp		= "";
		fNacimiento	= "";
		paisId		= "0";
		estadoId	= "0";
		ciudadId	= "0";
		clasfinId	= "";
		email		= "";
		colonia		= "";
		direccion	= "";
		telefono	= "";
		cotejado	= "";
		nivelId		= "0";
		grado		= "0";
		grupo		= "X";
		estado		= "";
		religion	= "";
		transporte	= "";
		celular		= "";
		tutor		= "";
		matricula 	= "";
		discapacidad= "N";
		enfermedad 	= "-";
		correo 		= "-";
		iglesia		= "-";
		tipoSangre      = "";
		tutorCedula	= "-";
		barrioId 	= "0";	 
		urlPago		= "";
	}
	
	// correo del alumno
	public String getCorreo() {
		return correo;
	}
	
	// correo del alumno
	public void setCorreo(String correo) {
		this.correo = correo;
	}
	
	public String getDiscapacidad() {
		return discapacidad;
	}
	
	public void setDiscapacidad(String discapacidad) {
		this.discapacidad = discapacidad;
	}

	public String getEnfermedad() {
		return enfermedad;
	}

	public void setEnfermedad(String enfermedad) {
		this.enfermedad = enfermedad;
	}

	/**
	 * @return the matricula
	 */
	public String getMatricula() {
		return matricula;
	}
	
	/**
	 * @param matricula the matricula to set
	 */
	public void setMatricula(String matricula) {
		this.matricula = matricula;
	}
	
	/**
	 * @return the codigoId
	 */
	public String getCodigoId() {
		return codigoId;
	}

	/**
	 * @param codigoId the codigoId to set
	 */
	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}

	/**
	 * @return the escuelaId
	 */
	public String getEscuelaId() {
		return escuelaId;
	}

	/**
	 * @param escuelaId the escuelaId to set
	 */
	
	public void setEscuelaId(String escuelaId) {
		this.escuelaId = escuelaId;
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
	 * @return the apaterno
	 */
	public String getApaterno() {
		return apaterno;
	}

	/**
	 * @param apaterno the apaterno to set
	 */
	public void setApaterno(String apaterno) {
		this.apaterno = apaterno;
	}

	/**
	 * @return the amaterno
	 */
	public String getAmaterno() {
		return amaterno;
	}

	/**
	 * @param amaterno the amaterno to set
	 */
	public void setAmaterno(String amaterno) {
		this.amaterno = amaterno;
	}

	/**
	 * @return the genero
	 */
	public String getGenero() {
		return genero;
	}

	/**
	 * @param genero the genero to set
	 */
	public void setGenero(String genero) {
		this.genero = genero;
	}

	/**
	 * @return the curp
	 */
	public String getCurp() {
		return curp;
	}

	/**
	 * @param curp the curp to set
	 */
	public void setCurp(String curp) {
		this.curp = curp;
	}

	/**
	 * @return the fNacimiento
	 */
	public String getFNacimiento() {
		return fNacimiento;
	}

	/**
	 * @param nacimiento the fNacimiento to set
	 */
	public void setFNacimiento(String nacimiento) {
		fNacimiento = nacimiento;
	}

	/**
	 * @return the paisId
	 */
	public String getPaisId() {
		return paisId;
	}

	/**
	 * @param paisId the paisId to set
	 */
	public void setPaisId(String paisId) {
		this.paisId = paisId;
	}

	/**
	 * @return the estadoId
	 */
	public String getEstadoId() {
		return estadoId;
	}

	/**
	 * @param estadoId the estadoId to set
	 */
	public void setEstadoId(String estadoId) {
		this.estadoId = estadoId;
	}

	/**
	 * @return the ciudadId
	 */
	public String getCiudadId() {
		return ciudadId;
	}

	/**
	 * @param ciudadId the ciudadId to set
	 */
	public void setCiudadId(String ciudadId) {
		this.ciudadId = ciudadId;
	}

	/**
	 * @return the clasfinId
	 */
	public String getClasfinId() {
		return clasfinId;
	}

	/**
	 * @param clasfinId the clasfinId to set
	 */
	public void setClasfinId(String clasfinId) {
		this.clasfinId = clasfinId;
	}

	/**
	 * @return the email
	 */
	public String getEmail() {
		return email;
	}

	/**
	 * @param email the email to set
	 */
	public void setEmail(String email) {
		this.email = email;
	}

	/**
	 * @return the colonia
	 */
	public String getColonia() {
		return colonia;
	}

	/**
	 * @param colonia the colonia to set
	 */
	public void setColonia(String colonia) {
		this.colonia = colonia;
	}

	/**
	 * @return the direccion
	 */
	public String getDireccion() {
		return direccion;
	}

	/**
	 * @param direccion the direccion to set
	 */
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	/**
	 * @return the telefono
	 */
	public String getTelefono() {
		return telefono;
	}

	/**
	 * @param telefono the telefono to set
	 */
	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}

	/**
	 * @return the cotejado
	 */
	public String getCotejado() {
		return cotejado;
	}

	/**
	 * @param cotejado the cotejado to set
	 */
	public void setCotejado(String cotejado) {
		this.cotejado = cotejado;
	}

	/**
	 * @return the nivelId
	 */
	public String getNivelId() {
		return nivelId;
	}

	/**
	 * @param nivelId the nivelId to set
	 */
	public void setNivelId(String nivelId) {
		this.nivelId = nivelId;
	}

	/**
	 * @return the grado
	 */
	public String getGrado() {
		return grado;
	}

	/**
	 * @param grado the grado to set
	 */
	public void setGrado(String grado) {
		this.grado = grado;
	}

	/**
	 * @return the grupo
	 */
	public String getGrupo() {
		return grupo;
	}

	/**
	 * @param grupo the grupo to set
	 */
	public void setGrupo(String grupo) {
		this.grupo = grupo;
	}

	/**
	 * @return the estado
	 */
	public String getEstado() {
		return estado;
	}

	/**
	 * @param estado the estado to set
	 */
	public void setEstado(String estado) {
		this.estado = estado;
	}

	/**
	 * @return the acta
	 */
	public String getActa() {
		return acta;
	}

	/**
	 * @param acta the acta to set
	 */
	public void setActa(String acta) {
		this.acta = acta;
	}

	/**
	 * @return the crip
	 */
	public String getCrip() {
		return crip;
	}

	/**
	 * @param crip the crip to set
	 */
	public void setCrip(String crip) {
		this.crip = crip;
	}

	/**
	 * @return the religion
	 */
	public String getReligion() {
		return religion;
	}

	/**
	 * @param religion the religion to set
	 */
	public void setReligion(String religion) {
		this.religion = religion;
	}

	/**
	 * @return the transporte
	 */
	public String getTransporte() {
		return transporte;
	}

	/**
	 * @param transporte the transporte to set
	 */
	public void setTransporte(String transporte) {
		this.transporte = transporte;
	}

	/**
	 * @return the celular
	 */
	public String getCelular() {
		return celular;
	}

	/**
	 * @param celular the celular to set
	 */
	public void setCelular(String celular) {
		this.celular = celular;
	}

	/**
	 * @return the tutor
	 */
	public String getTutor() {
		return tutor;
	}

	/**
	 * @param tutor the tutor to set
	 */
	public void setTutor(String tutor) {
		this.tutor = tutor;
	}
	
	/**
	 * @return the iglesia
	 */
	public String getIglesia() {
		return iglesia;
	}

	/**
	 * @param nombre the iglesia to set
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

	public String getTutorCedula() {
		return tutorCedula;
	}

	public void setTutorCedula(String tutorCedula) {
		this.tutorCedula = tutorCedula;
	}

	public String getBarrioId() {
		return barrioId;
	}

	public void setBarrioId(String barrioId) {
		this.barrioId = barrioId;
	}
	
	public String getUrlPago() {
		return urlPago;
	}

	public void setUrlPago(String urlPago) {
		this.urlPago = urlPago;
	}
	
	public void encoding(Connection conn) {
        try {
            PreparedStatement pst = conn.prepareStatement("SET CLIENT_ENCODING='UTF8'");
            pst.executeUpdate();
            pst.close();

        } catch (SQLException w) {
            System.err.println("Error al encoding Inscripcion" + w);
        } finally {

        }
    }

	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps	= conn.prepareStatement("INSERT INTO ALUM_PERSONAL"
				+ " (CODIGO_ID, ESCUELA_ID, NOMBRE,"
				+ " APATERNO, AMATERNO, GENERO,"
				+ " CURP, F_NACIMIENTO, PAIS_ID,"
				+ " ESTADO_ID, CIUDAD_ID, CLASFIN_ID,"
				+ " EMAIL, COLONIA, DIRECCION,"
				+ " TELEFONO, COTEJADO, NIVEL_ID, GRADO, GRUPO, ESTADO,"
				+ " ACTA, CRIP, RELIGION, TRANSPORTE, CELULAR, TUTOR, MATRICULA,"
				+ " DISCAPACIDAD, ENFERMEDAD, CORREO, IGLESIA, TIPO_SANGRE, TUTOR_CEDULA, BARRIO_ID, URL_PAGO)"
				+ " VALUES(?, ?, UPPER(RTRIM(LTRIM(?))),"
				+ " UPPER(RTRIM(LTRIM(?))), UPPER(RTRIM(LTRIM(?))), ?, ?,"
				+ " TO_DATE(?, 'DD/MM/YYYY'), TO_NUMBER(?, '999'),"
				+ " TO_NUMBER(?, '999'), TO_NUMBER(?, '999'), TO_NUMBER(?, '99'),"
				+ " ?, ?, ?,"
				+ " ?, ?, TO_NUMBER(?, '99'),"
				+ " TO_NUMBER(?, '99'), ?, ?, ?, ?, TO_NUMBER(?, '99'),"
				+ " ?, ?, ?, ?, ?, ?, ?, ?, TO_NUMBER(?,'999'), ?)");
			
			ps.setString(1, codigoId);
			ps.setString(2, escuelaId);
			ps.setString(3, nombre);
			ps.setString(4, apaterno);
			ps.setString(5, amaterno);
			ps.setString(6, genero);
			ps.setString(7, curp);
			ps.setString(8, fNacimiento);
			ps.setString(9, paisId);
			ps.setString(10, estadoId);
			ps.setString(11, ciudadId);
			ps.setString(12, clasfinId);
			ps.setString(13, email);
			ps.setString(14, colonia);
			ps.setString(15, direccion);
			ps.setString(16, telefono);
			ps.setString(17, cotejado);
			ps.setString(18, nivelId);
			ps.setString(19, grado);
			ps.setString(20, grupo);
			ps.setString(21, estado);
			ps.setString(22, acta);
			ps.setString(23, crip);
			ps.setString(24, religion);
			ps.setString(25, transporte);
			ps.setString(26, celular);
			ps.setString(27, tutor);
			ps.setString(28, matricula);
			ps.setString(29, discapacidad);
			ps.setString(30, enfermedad);
			ps.setString(31, correo);
			ps.setString(32, iglesia);
			ps.setString(33, tipoSangre);
			ps.setString(34, tutorCedula);
			ps.setString(35, barrioId);
			ps.setString(36, urlPago);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	
	public boolean insertNuevo(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			System.out.println(toString());
			ps = conn.prepareStatement("INSERT INTO ALUM_PERSONAL" +
					" (CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO, GENERO, CURP, F_NACIMIENTO, " +
					" EMAIL, DIRECCION, COLONIA, TELEFONO, MATRICULA," +
					" ACTA, CRIP, CELULAR, TUTOR," +
					" NIVEL_ID, CLASFIN_ID, DISCAPACIDAD, CORREO, TRANSPORTE)" +
					" VALUES(?, ?," +
					" UPPER(RTRIM(LTRIM(?)))," +
					" UPPER(RTRIM(LTRIM(?)))," +
					" UPPER(RTRIM(LTRIM(?))), ?," +
					" ?, TO_DATE(?, 'DD/MM/YYYY')," +
					" ?,?,?,?,?,?,?,?,?," +
					" ?,?,?,?,?)");
			ps.setString(1, codigoId);
			ps.setString(2, escuelaId);
			ps.setString(3, nombre);
			ps.setString(4, apaterno);
			ps.setString(5, amaterno);
			ps.setString(6, genero);
			ps.setString(7, curp);
			ps.setString(8, fNacimiento);
			ps.setString(9, "-");
			ps.setString(10, "-");
			ps.setString(11, "-");
			ps.setString(12, "-");
			ps.setString(13, "-");			
			ps.setString(14, "-");
			ps.setString(15, "-");
			ps.setString(16, "-");
			ps.setString(17, "-");
			ps.setInt(18, 1);
			ps.setInt(19, 1);
			ps.setString(20, "-");
			ps.setString(21, "-");
			ps.setString(22, "-");
			
			if ( ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|insertNuevo|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean insertTraspaso(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			
			ps = conn.prepareStatement("INSERT INTO ALUM_PERSONAL" +
					" (CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO,F_NACIMIENTO, GENERO, CORREO, COLONIA," +
					" DIRECCION, TELEFONO, CELULAR, NIVEL_ID, GRADO, GRUPO)" +
					" VALUES(?, ?, ?, ?, ?, TO_DATE(?, 'DD/MM/YYYY'), ?, ?, ?, ?, ?, ?, TO_NUMBER(?, '99'), TO_NUMBER(?, '99'), ?)");			
			ps.setString(1, codigoId); 
			ps.setString(2, escuelaId);
			ps.setString(3, nombre);
			ps.setString(4, apaterno);
			ps.setString(5, amaterno);
			ps.setString(6, fNacimiento);
			ps.setString(7, genero);
			ps.setString(8, correo);
			ps.setString(9, colonia);
			ps.setString(10, direccion);
			ps.setString(11, telefono);
			ps.setString(12, celular);
			ps.setString(13, nivelId);
			ps.setString(14, grado);			
			ps.setString(15, grupo);
			
			if ( ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|insertTraspaso|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE ALUM_PERSONAL" +
					" SET ESCUELA_ID = ?," +
					" NOMBRE = RTRIM(LTRIM(UPPER(?)))," +
					" APATERNO = RTRIM(LTRIM(UPPER(?)))," +
					" AMATERNO = UPPER(?)," +
					" GENERO = ?," +
					" CURP = ?," +
					" F_NACIMIENTO = TO_DATE(?,'DD/MM/YYYY')," +
					" PAIS_ID = TO_NUMBER(?, '999')," +
					" ESTADO_ID = TO_NUMBER(?, '999')," +
					" CIUDAD_ID = TO_NUMBER(?, '999')," +
					" CLASFIN_ID = TO_NUMBER(?, '99')," +
					" EMAIL = ?," +
					" COLONIA = ?," +
					" DIRECCION = ?," +
					" TELEFONO = ?," +
					" COTEJADO = ?," +
					" NIVEL_ID = TO_NUMBER(?, '99')," +
					" GRADO = TO_NUMBER(?, '99')," +
					" GRUPO = ?,"+
					" ESTADO = ?, " +
					" ACTA = ?, " +
					" CRIP = ?," +
					" RELIGION = TO_NUMBER(?, '99')," +
					" TRANSPORTE = ?, " +
					" CELULAR = ?, " +
					" TUTOR = ?," +
					" MATRICULA = ?, " +
					" DISCAPACIDAD = ? ," +
					" ENFERMEDAD = ?, " +
					" CORREO = ?, " +
					" IGLESIA = ?, " +
					" TIPO_SANGRE = ?, " +
					" TUTOR_CEDULA = ?, " +
					" BARRIO_ID = TO_NUMBER(?,'999'), " +
					" URL_PAGO = ? " +
					" WHERE CODIGO_ID = ? ");			
			
			ps.setString(1, escuelaId);
			ps.setString(2, nombre);
			ps.setString(3, apaterno);
			ps.setString(4, amaterno);
			ps.setString(5, genero);
			ps.setString(6, curp);
			ps.setString(7, fNacimiento);
			ps.setString(8, paisId);
			ps.setString(9, estadoId);
			ps.setString(10, ciudadId);
			ps.setString(11, clasfinId);
			ps.setString(12, email);
			ps.setString(13, colonia);
			ps.setString(14, direccion);
			ps.setString(15, telefono);
			ps.setString(16, cotejado);
			ps.setString(17, nivelId);
			ps.setString(18, grado);
			ps.setString(19, grupo);
			ps.setString(20, estado);
			ps.setString(21, acta);
			ps.setString(22, crip);
			ps.setString(23, religion);
			ps.setString(24, transporte);
			ps.setString(25, celular);
			ps.setString(26, tutor);
			ps.setString(27, codigoId);
			ps.setString(28, discapacidad);
			ps.setString(29, enfermedad);
			ps.setString(30, correo);
			ps.setString(31, iglesia);
			ps.setString(32, tipoSangre);
			ps.setString(33, tutorCedula);
			ps.setString(34, barrioId);
			ps.setString(35, urlPago);
			ps.setString(36, codigoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateRegDatos(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;		
		try{
			
			ps = conn.prepareStatement("UPDATE ALUM_PERSONAL " +
					" PAIS_ID = TO_NUMBER(?, '999'), " +
					" ESTADO_ID = TO_NUMBER(?, '999'), " +
					" CIUDAD_ID = TO_NUMBER(?, '999'), " +
					" EMAIL = ?, " +
					" COLONIA = ?, " +
					" DIRECCION = ?, " +
					" TELEFONO = ? " +
					" WHERE CODIGO_ID = ? ");
			
			ps.setString(1, paisId);
			ps.setString(2, estadoId);
			ps.setString(3, ciudadId);
			ps.setString(4, email);
			ps.setString(5, colonia);
			ps.setString(6, direccion);
			ps.setString(7, telefono);
			ps.setString(8, codigoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateRegPromover(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{			
			ps = conn.prepareStatement("UPDATE ALUM_PERSONAL" +
					" SET NIVEL_ID = TO_NUMBER(?,'99'), GRADO = TO_NUMBER(?, '99'), GRUPO = ? WHERE CODIGO_ID = ?");
			ps.setString(1, nivelId);
			ps.setString(2, grado);
			ps.setString(3, grupo);
			ps.setString(4, codigoId);
			if ( ps.executeUpdate()== 1){			
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|updateRegPromover|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM ALUM_PERSONAL" +
					" WHERE CODIGO_ID = ?");
			ps.setString(1, codigoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|deleteReg|:"+ex);
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
		curp		= rs.getString("CURP");
		fNacimiento	= rs.getString("F_NACIMIENTO");
		paisId		= rs.getString("PAIS_ID");
		estadoId	= rs.getString("ESTADO_ID");
		ciudadId	= rs.getString("CIUDAD_ID");
		clasfinId	= rs.getString("CLASFIN_ID");
		email		= rs.getString("EMAIL");
		colonia		= rs.getString("COLONIA");
		direccion	= rs.getString("DIRECCION");
		telefono	= rs.getString("TELEFONO");
		cotejado	= rs.getString("COTEJADO");
		nivelId		= rs.getString("NIVEL_ID");
		grado		= rs.getString("GRADO");
		grupo		= rs.getString("GRUPO");
		estado		= rs.getString("ESTADO");
		acta		= rs.getString("ACTA");
		crip		= rs.getString("CRIP");
		religion	= rs.getString("RELIGION");
		transporte	= rs.getString("TRANSPORTE");
		celular		= rs.getString("CELULAR");
		tutor		= rs.getString("TUTOR");
		matricula	= rs.getString("MATRICULA");
		discapacidad= rs.getString("DISCAPACIDAD");
		enfermedad	= rs.getString("ENFERMEDAD");
		correo		= rs.getString("CORREO");
		iglesia		= rs.getString("IGLESIA");
		tipoSangre	= rs.getString("TIPO_SANGRE");
		tutorCedula = rs.getString("TUTOR_CEDULA");
		barrioId 	= rs.getString("BARRIO_ID");
		urlPago 	= rs.getString("URL_PAGO");
		
	}
	
	public void mapeaRegNombres(ResultSet rs ) throws SQLException{
		codigoId	= rs.getString("CODIGO_ID");
		nombre		= rs.getString("NOMBRE");
		apaterno	= rs.getString("APATERNO");
		amaterno	= rs.getString("AMATERNO");
	}
	
	public void mapeaRegId(Connection con, String codigoId) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null;
		try{
			ps = con.prepareStatement("SELECT CODIGO_ID, ESCUELA_ID, NOMBRE," +
					" APATERNO, AMATERNO, GENERO," +
					" COALESCE(CURP,'-') AS CURP, TO_CHAR(F_NACIMIENTO, 'DD/MM/YYYY') AS F_NACIMIENTO, PAIS_ID," +
					" ESTADO_ID, CIUDAD_ID, CLASFIN_ID," +
					" COALESCE(EMAIL,'-') AS EMAIL, COALESCE(COLONIA,'-') AS COLONIA, COALESCE(DIRECCION,'-') AS DIRECCION," +
					" COALESCE(TELEFONO,'-') AS TELEFONO, COALESCE(COTEJADO,'-') AS COTEJADO, NIVEL_ID," +
					" GRADO, GRUPO, ESTADO, COALESCE(ACTA,'-') AS ACTA, COALESCE(CRIP,'-') AS CRIP," +
					" RELIGION, COALESCE(TRANSPORTE,'-') AS TRANSPORTE, COALESCE(CELULAR,'-') AS CELULAR," +
					" COALESCE(TUTOR,'-') AS TUTOR, MATRICULA, DISCAPACIDAD, COALESCE(ENFERMEDAD,'-') AS ENFERMEDAD, COALESCE(CORREO,'-') AS CORREO, " +
					" COALESCE(IGLESIA,'-') AS IGLESIA, TIPO_SANGRE, TUTOR_CEDULA, BARRIO_ID, URL_PAGO" +
					" FROM ALUM_PERSONAL" +
					" WHERE CODIGO_ID = ?");
			
			ps.setString(1, codigoId);
			
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
	
	public boolean existeReg(Connection conn) throws SQLException{
		boolean ok 			= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM ALUM_PERSONAL" +
					" WHERE CODIGO_ID = ?");
			ps.setString(1, codigoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean existeReg(Connection conn, String codigoId) throws SQLException{
		boolean ok 			= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM ALUM_PERSONAL" +
					" WHERE CODIGO_ID = ?");
			ps.setString(1, codigoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public static String getNombre(Connection conn, String codigoId, String Opcion) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		String nombre		= "-";
		
		try{
			if ( Opcion.equals("NOMBRE")){
				comando = "SELECT NOMBRE||' '||APATERNO||' '||AMATERNO AS NOMBRE "+
					"FROM ALUM_PERSONAL WHERE CODIGO_ID = '"+codigoId+"'";
			}else{
				comando = "SELECT APATERNO||' '||AMATERNO||' '||NOMBRE AS NOMBRE "+
					"FROM ALUM_PERSONAL WHERE CODIGO_ID = '"+codigoId+"'";
			}	
			rs = st.executeQuery(comando);
			if (rs.next()){
				nombre = rs.getString("NOMBRE");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getNombre|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();		
		}
		return nombre;
	}
	
	public static String getNombreCorto(Connection conn, String codigoId, String Opcion) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		String nombre		= "-";
		
		try{
			if ( Opcion.equals("NOMBRE")){
				comando = "SELECT NOMBRE||' '||APATERNO AS NOMBRE "+
					"FROM ALUM_PERSONAL WHERE CODIGO_ID = '"+codigoId+"'";
			}else{
				comando = "SELECT APATERNO||' '||NOMBRE AS NOMBRE "+
					"FROM ALUM_PERSONAL WHERE CODIGO_ID = '"+codigoId+"'";
			}	
			rs = st.executeQuery(comando);
			if (rs.next()){
				nombre = rs.getString("NOMBRE");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getNombreCorto|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();		
		}
		return nombre;
	}
	
	public String maximoReg(Connection conn, String escuelaId) throws SQLException{
 		
 		ResultSet 		rs		= null;
 		PreparedStatement ps	= null;
 		String maximo			= "";
 		String year				= "";
 		
 		try{
 			
 			ps = conn.prepareStatement("SELECT" +
 					" COALESCE( MAX( TO_NUMBER(SUBSTR(CODIGO_ID,6,3),'999')+1), 1) AS MAXIMO," +
 					" TO_CHAR(NOW(), 'YY') AS YEAR" +
 				" FROM ALUM_PERSONAL" +
 				" WHERE SUBSTR(CODIGO_ID,1,3) = '"+escuelaId+"'" +
 				" AND SUBSTR(CODIGO_ID,4,2) = TO_CHAR(NOW(), 'YY')");
 					
 			rs = ps.executeQuery();
 			if (rs.next()){
 				maximo 	= String.valueOf(rs.getInt("MAXIMO"));
 				year 	= rs.getString("YEAR");
 				switch(maximo.length()){
 					case 1: maximo = "00"+maximo; break;
 					case 2: maximo = "0"+ maximo; break;
 				}
 				maximo = escuelaId+year+maximo;
 			}else{
 				maximo = "0000000";
 			}	
			
			for(int i = maximo.length(); i < 7; i++){
				maximo = "0" + maximo;
			}
 			
 		}catch(Exception ex){
 			System.out.println("Error - aca.alumno.AlumPersonal|maximoReg|:"+ex);
 		}finally{
 			if (rs!=null) rs.close();
 			if (ps!=null) ps.close();
 		}
 		return maximo;
 	}
	
	public static int getTotalRegistros(Connection conn, String escuelaId ) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
		
		try{
			comando = "SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL"+
					" WHERE ESCUELA_ID = '"+escuelaId+"'";		
					
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getTotalRegistros|:"+ex);
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
		int numAlum			= 0;
		
		try{
			comando = "SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL"+
					" WHERE ESCUELA_ID IN ("+escuelas+")";		
					
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getTotalRegistros|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return numAlum;
	}
	
	public static String getMaxReg(Connection conn, String escuelaId ) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		String year 		= String.valueOf(aca.util.Fecha.getYearNum());
		String maximo		= escuelaId+year.substring(2,4)+"000";
		
		try{
			comando = "SELECT COALESCE(MAX(CODIGO_ID),'"+maximo+"') AS MAXIMO FROM ALUM_PERSONAL"+
					" WHERE ESCUELA_ID = '"+escuelaId+"'";		
					
			rs = st.executeQuery(comando);
			if (rs.next()){
				maximo = rs.getString("MAXIMO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getTotalRegistros|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return maximo;
	}
	
	public static int getCantidad(Connection conn, String cicloId, int nivel, int grado, String grupo) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
		
		try{
			comando = "SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL" +
					" WHERE CODIGO_ID IN " +
					" 	(SELECT CODIGO_ID FROM ALUM_CICLO WHERE CICLO_ID = '"+cicloId+"'"+
							" AND NIVEL = '"+nivel+"' AND GRADO = '"+grado+"' "+
							" AND GRUPO = '"+grupo+"' AND ESTADO = 'I')" ;
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getCantidad|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return numAlum;
	}
	
	public static int getCantidad(Connection conn, String cicloId, int periodoId, int nivel, int grado, String grupo) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
		
		try{
			comando = "SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL " +
					"WHERE NIVEL_ID = '"+nivel+"' AND GRADO = '"+grado+"' "+
					"AND GRUPO = '"+grupo+"'" +
					" AND CODIGO_ID IN (SELECT CODIGO_ID FROM ALUM_CICLO" +
															" WHERE CICLO_ID = '"+cicloId+"'" +
															" AND PERIODO_ID = '"+periodoId+"'" +
															" AND ESTADO = 'I')" ;			
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getCantidad|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return numAlum;
	}
	
	public static int getCantidad(Connection conn, String cicloId, String nivel, String grado ) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
		
		try{
			comando = "SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL " +
					"WHERE NIVEL_ID = TO_NUMBER('"+nivel+"', '99') AND GRADO = TO_NUMBER('"+grado+"', '99') "+
					" AND CODIGO_ID IN (SELECT CODIGO_ID FROM ALUM_CICLO" +
															" WHERE CICLO_ID = '"+cicloId+"'" +
															" AND ESTADO = 'I')" ;		
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getCantidad|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return numAlum;
	}
	
	public static int getCantidadPorNivel(Connection conn, String cicloId, String nivel ) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
		
		try{
			comando = "SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL " +
					"WHERE NIVEL_ID = TO_NUMBER('"+nivel+"', '99') "+
					" AND CODIGO_ID IN (SELECT CODIGO_ID FROM ALUM_CICLO" +
															" WHERE CICLO_ID = '"+cicloId+"'" +
															" AND ESTADO = 'I')" ;		
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getCantidadPorNivel|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return numAlum;
	}
	
	public static int getCantidadPorNivelEscuela(Connection conn, String escuelas, String nivel ) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
		
		try{
			comando = "SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL " +
					"WHERE NIVEL_ID = TO_NUMBER('"+nivel+"', '99') "+
					" AND ESCUELA_ID IN ("+escuelas+") AND CODIGO_ID IN(SELECT CODIGO_ID FROM ALUM_CICLO WHERE ESTADO='I' AND CICLO_ID IN (SELECT CICLO_ID FROM CICLO WHERE NOW() BETWEEN F_INICIAL AND F_FINAL) ) " ;		
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getCantidadPorNivelEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return numAlum;
	}

	public static int getCantidadTodos(Connection conn, String escuelaId, int nivel, int grado, String grupo) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
		
		try{
			comando = "SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL " +
					"WHERE ESCUELA_ID = '"+escuelaId+"' AND NIVEL_ID = '"+nivel+"' AND GRADO = '"+grado+"' "+
					"AND GRUPO = '"+grupo+"'" ;			
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getCantidadTodos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return numAlum;
	}
	
	public static int getNumHombres(Connection conn, String nivel, String grado, String cicloId) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
		
		try{
			comando = "SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL " +
					"WHERE NIVEL_ID = TO_NUMBER('"+nivel+"', '99') AND GRADO = TO_NUMBER('"+grado+"', '99') AND GENERO='M'"+
					" AND CODIGO_ID IN (SELECT CODIGO_ID FROM ALUM_CICLO" +
															" WHERE CICLO_ID = '"+cicloId+"'" +
															" AND ESTADO = 'I')" ;		
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getNumHombres|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return numAlum;
	}
	
	public static int getNumHombresTodos(Connection conn, String nivel, String grado ) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
		
		try{
			comando = "SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL " +
					"WHERE NIVEL_ID = TO_NUMBER('"+nivel+"', '99') AND GRADO = TO_NUMBER('"+grado+"', '99') AND GENERO='M'" ;		
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getNumHombresTodos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return numAlum;
	}	

	public static int getNumHombresTotal(Connection conn, String cicloId) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
		
		try{
			comando = "SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL " +
					"WHERE GENERO='M'"+
					" AND CODIGO_ID IN (SELECT CODIGO_ID FROM ALUM_CICLO" +
															" WHERE CICLO_ID = '"+cicloId+"'" +
															" AND ESTADO = 'I')" ;		
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getNumHombres|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return numAlum;
	}
	
	public static int getNumHombresTotalEscuela(Connection conn, String escuelas) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
		
		try{
			comando = "SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL " +
					"WHERE GENERO='M'"+
					" AND ESCUELA_ID IN ("+escuelas+") AND CODIGO_ID IN(SELECT CODIGO_ID FROM ALUM_CICLO WHERE ESTADO='I' AND CICLO_ID IN (SELECT CICLO_ID FROM CICLO WHERE NOW() BETWEEN F_INICIAL AND F_FINAL))" ;		
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getNumHombresTotalEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return numAlum;
	}

	public static int getNumMujeres(Connection conn, String nivel, String grado, String cicloId) throws SQLException{
	
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
	
		try{
			comando = "SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL " +
				"WHERE NIVEL_ID = TO_NUMBER('"+nivel+"', '99') AND GRADO = TO_NUMBER('"+grado+"', '99') AND GENERO='F'"+
				" AND CODIGO_ID IN (SELECT CODIGO_ID FROM ALUM_CICLO" +
														" WHERE CICLO_ID = '"+cicloId+"'" +
														" AND ESTADO = 'I')" ;		
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
		
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getNumMujeres|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
	
		return numAlum;
	}	
	
	public static int getNumMujeresTodos(Connection conn, String nivel, String grado) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
	
		try{
			comando = "SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL " +
				"WHERE NIVEL_ID = TO_NUMBER('"+nivel+"', '99') AND GRADO = TO_NUMBER('"+grado+"', '99') AND GENERO='F'" ;		
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
		
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getNumMujeresTodas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
	
		return numAlum;
	}
	
	public static int getNumMujeresTotal(Connection conn, String cicloId) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
	
		try{
			comando = "SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL " +
				"WHERE GENERO='F'"+
				" AND CODIGO_ID IN (SELECT CODIGO_ID FROM ALUM_CICLO" +
									" WHERE CICLO_ID = '"+cicloId+"'" +
									" AND ESTADO = 'I')" ;		
			
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
		
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getNumMujeres|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
	
		return numAlum;
	}
	
	public static int getNumMujeresTotalEscuela(Connection conn, String escuelas) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
	
		try{
			comando = "SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL " +
				"WHERE GENERO='F'"+
				" AND ESCUELA_ID IN ("+escuelas+") AND CODIGO_ID IN(SELECT CODIGO_ID FROM ALUM_CICLO WHERE ESTADO='I' AND CICLO_ID IN (SELECT CICLO_ID FROM CICLO WHERE NOW() BETWEEN F_INICIAL AND F_FINAL))" ;		
			
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
		
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getNumMujeresTotalEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
	
		return numAlum;
	}
	
	public static int getNumAcfe(Connection conn, String nivel, String grado, String cicloId) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
		
		try{
			comando = "SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL " +
					"WHERE NIVEL_ID = TO_NUMBER('"+nivel+"', '99') AND GRADO = TO_NUMBER('"+grado+"', '99') AND RELIGION =1"+
					" AND CODIGO_ID IN (SELECT CODIGO_ID FROM ALUM_CICLO" +
															" WHERE CICLO_ID = '"+cicloId+"'" +
															" AND ESTADO = 'I')" ;		
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getCantidad|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return numAlum;
	}	
	
	public static int getNumAcfeTodos(Connection conn, String nivel, String grado) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
		
		try{
			comando = "SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL " +
					"WHERE NIVEL_ID = TO_NUMBER('"+nivel+"', '99') AND GRADO = TO_NUMBER('"+grado+"', '99') AND RELIGION =1 ";		
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getCantidad|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return numAlum;
	}	
	
	public static int getNumAcfeTotal(Connection conn, String cicloId) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
		
		try{
			comando = "SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL " +
					"WHERE CLASFIN_ID=1"+
					" AND CODIGO_ID IN (SELECT CODIGO_ID FROM ALUM_CICLO" +
															" WHERE CICLO_ID = '"+cicloId+"'" +
															" AND ESTADO = 'I')" ;		
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getNumAcfeTotal|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return numAlum;
	}
	
	public static int getNumAcfeTotalEscuela(Connection conn, String escuelas) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
		
		try{
			comando = "SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL " +
					"WHERE CLASFIN_ID=1"+
					" AND ESCUELA_ID IN ("+escuelas+") AND CODIGO_ID IN(SELECT CODIGO_ID FROM ALUM_CICLO WHERE ESTADO='I' AND CICLO_ID IN (SELECT CICLO_ID FROM CICLO WHERE NOW() BETWEEN F_INICIAL AND F_FINAL)) " ;		
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getNumAcfeTotalEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return numAlum;
	}

	public static int getNumNAcfe(Connection conn, String nivel, String grado, String cicloId) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
		
		try{
			comando = "SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL " +
					"WHERE NIVEL_ID = TO_NUMBER('"+nivel+"', '99') AND GRADO = TO_NUMBER('"+grado+"', '99') AND RELIGION != 1"+
					" AND CODIGO_ID IN (SELECT CODIGO_ID FROM ALUM_CICLO" +
															" WHERE CICLO_ID = '"+cicloId+"'" +
															" AND ESTADO = 'I')" ;		
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getCantidad|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return numAlum;
	}
	
	public static int getNumNAcfeTodos(Connection conn, String nivel, String grado) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
		
		try{
			comando = "SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL " +
					"WHERE NIVEL_ID = TO_NUMBER('"+nivel+"', '99') AND GRADO = TO_NUMBER('"+grado+"', '99') AND RELIGION != 1" ;		
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getCantidad|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return numAlum;
	}
	
	public static int getNumNAcfeTotal(Connection conn, String cicloId) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
		
		try{
			comando = "SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL " +
					"WHERE CLASFIN_ID=2"+
					" AND CODIGO_ID IN (SELECT CODIGO_ID FROM ALUM_CICLO" +
															" WHERE CICLO_ID = '"+cicloId+"'" +
															" AND ESTADO = 'I')" ;		
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getNumNAcfeTotal|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return numAlum;
	}
	
	public static int getNumNAcfeTotalEscuela(Connection conn, String escuelas) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
		
		try{
			comando = "SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL " +
					"WHERE CLASFIN_ID=2"+
					" AND ESCUELA_ID IN ("+escuelas+") AND CODIGO_ID IN(SELECT CODIGO_ID FROM ALUM_CICLO WHERE ESTADO='I' AND CICLO_ID IN (SELECT CICLO_ID FROM CICLO WHERE NOW() BETWEEN F_INICIAL AND F_FINAL)) " ;		
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getNumNAcfeTotalEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return numAlum;
	}
	
	public static int getEdad(Connection conn, String codigoId) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int edad			= 0;
	
		try{
			comando = "SELECT ALUM_EDAD(CODIGO_ID) AS EDAD FROM " +
					"ALUM_PERSONAL WHERE CODIGO_ID = '"+codigoId+"'";			
			rs = st.executeQuery(comando);
			if (rs.next()){
				edad = rs.getInt("EDAD");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getEdad|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return edad;
	}
	
	public static String getEscuela(Connection conn, String codigoId) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		String escuela		= "";
	
		try{
			comando = "SELECT ESCUELA_ID FROM ALUM_PERSONAL WHERE CODIGO_ID = '"+codigoId+"'";
			rs = st.executeQuery(comando);
			if (rs.next()){
				escuela = rs.getString("ESCUELA");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return escuela;
	}
	
	public static String getGenero(Connection conn, String codigoId) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		String genero		= "x";
	
		try{
			comando = "SELECT GENERO FROM " +
					"ALUM_PERSONAL WHERE CODIGO_ID = '"+codigoId+"'";			
			rs = st.executeQuery(comando);
			if (rs.next()){
				genero = rs.getString("GENERO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getEdad|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return genero;
	}

	public static int getNivel(Connection conn, String codigoId) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int nivel			= 0;
	
		try{
			comando = "SELECT NIVEL_ID FROM " +
					"ALUM_PERSONAL WHERE CODIGO_ID = '"+codigoId+"'";			
			rs = st.executeQuery(comando);
			if (rs.next()){
				nivel = rs.getInt("NIVEL_ID");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getNivel|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return nivel;
	}
	
	public static int getGrado(Connection conn, String codigoId) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int grado			= 0;
	
		try{
			comando = "SELECT GRADO FROM " +
					"ALUM_PERSONAL WHERE CODIGO_ID = '"+codigoId+"'";			
			rs = st.executeQuery(comando);
			if (rs.next()){
				grado = rs.getInt("GRADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getGrado|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return grado;
	}
	
	public static String getGrupo(Connection conn, String codigoId) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		String grado		= "";
	
		try{
			comando = "SELECT GRUPO FROM " +
					"ALUM_PERSONAL WHERE CODIGO_ID = '"+codigoId+"'";			
			rs = st.executeQuery(comando);
			if (rs.next()){
				grado = rs.getString("GRUPO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getGrupo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return grado;
	}
	
	public static int getNumEdades(Connection conn, int edad, String cicloId) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
		
		try{
			comando = " SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL " +
					  " WHERE TO_NUMBER(ALUM_EDAD(CODIGO_ID), '9999') = "+edad+" " +
					  " AND CODIGO_ID IN (SELECT CODIGO_ID FROM ALUM_CICLO" +
					  " WHERE CICLO_ID = '"+cicloId+"'  " +
					  " AND ESTADO = 'I')" ;		
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getNumAcfeTotal|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return numAlum;
	}
	
	public static int getNumEdadesEscuela(Connection conn, int edad, String escuelas) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
		
		try{
			comando = " SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL " +
					  " WHERE TO_NUMBER(ALUM_EDAD(CODIGO_ID), '9999') = "+edad+" " +
					  " AND ESCUELA_ID IN (11,99,21,20,19,22,18,13,14,15,16,17,7,8,6,10,12,9,5)" +
					  " AND CODIGO_ID IN (SELECT CODIGO_ID FROM ALUM_CICLO" +
					  " WHERE ESTADO = 'I')" ;		
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getNumEdadesEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return numAlum;
	}
	
	
	public static String getPrimerAlumno(Connection conn, String escuelaId ) throws SQLException{
		
 		PreparedStatement ps	= null;
 		ResultSet 		rs		= null;
 		String minimo			= "x";
 		
 		try{
 			
 			ps = conn.prepareStatement("SELECT COALESCE( MIN( TO_NUMBER(SUBSTR(CODIGO_ID,4,5),'99999')), 1) AS MINIMO"+				
 				" FROM ALUM_PERSONAL" +
 				" WHERE ESCUELA_ID = '"+escuelaId+"'");
 			
 			rs = ps.executeQuery();
 			if (rs.next()){
 				minimo 	= escuelaId+rs.getString("MINIMO");			
 			}	
			
 			
 		}catch(Exception ex){
 			System.out.println("Error - aca.alumno.AlumPersonal|PrimerAlumno|:"+ex);
 		}finally{
 			if (rs!=null) rs.close();
 			if (ps!=null) ps.close();
 		}
 		
 		return minimo;
 		
	}
	
	public static String getClasFinId(Connection conn, String codigoId) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		String clasFin		= "";
	
		try{
			comando = "SELECT CLASFIN_ID FROM " +
					"ALUM_PERSONAL WHERE CODIGO_ID = '"+codigoId+"'";			
			rs = st.executeQuery(comando);
			if (rs.next()){
				clasFin = rs.getString("CLASFIN_ID");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getClasFinId|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return clasFin;
	}
	
	public static String getTotalClas(Connection conn, String escuelaId, String clasfin,String ciclo) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		String clasFin		= "";
	
		try{
			comando = " SELECT COUNT(CLASFIN_ID) AS TOTAL FROM " +
					  " ALUM_PERSONAL WHERE ESCUELA_ID ='"+escuelaId+"' AND CLASFIN_ID = TO_NUMBER('"+clasfin+"', '99') "+
					  " AND CODIGO_ID IN (SELECT CODIGO_ID FROM ALUM_CICLO WHERE CICLO_ID = '"+ciclo+"' AND ESTADO = 'I') ";			
			rs = st.executeQuery(comando);
			if (rs.next()){
				clasFin = rs.getString("TOTAL");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getTotalClas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return clasFin;
	}
	
	public static int getNumInscritosPorAsociacion(Connection conn, String escuelas) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
		
		try{
			comando = " SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL WHERE ESCUELA_ID IN ("+escuelas+") " +
					" AND CODIGO_ID IN(SELECT CODIGO_ID FROM ALUM_CICLO WHERE ESTADO='I' AND CICLO_ID IN (SELECT CICLO_ID FROM CICLO WHERE NOW() BETWEEN F_INICIAL AND F_FINAL));" ;		
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getNumInscritosPorAsociacion|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return numAlum;
	}
	
	public static int getNumInscritosPorEscuela(Connection conn, String escuelaId) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		int numAlum			= 0;
		
		try{
			comando = " SELECT COUNT(CODIGO_ID) AS RESULTADO FROM ALUM_PERSONAL WHERE ESCUELA_ID = '"+escuelaId+"' " +
					" AND CODIGO_ID IN(SELECT CODIGO_ID FROM ALUM_CICLO WHERE ESTADO='I' AND CICLO_ID IN (SELECT CICLO_ID FROM CICLO WHERE NOW() BETWEEN F_INICIAL AND F_FINAL));" ;		
			rs = st.executeQuery(comando);
			if (rs.next()){
				numAlum = rs.getInt("RESULTADO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|getNumInscritosPorEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return numAlum;
	}
}
