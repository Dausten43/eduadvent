package aca.alumno;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AlumDatos {
	private String codigoId;
	private String escuelaId;
	private String nombreTutor;
	private String parentesco;
	private String direccion;
	private String telefono;
	private String email;
	private String estudio;
	private String escuelaAnt;
	private String fax;
	private String nombrePadre;
	private String vivePadre;
	private String religionPadre;
	private String dirPadre;
	private String telPadre;
	private String telTrabajoP;
	private String celPadre;
	private String nombreMadre;
	private String viveMadre;
	private String religionMadre;
	private String dirMadre;
	private String telMadre;
	private String telTrabajoM;
	private String celMadre;
	private String estadoCivil;
	private String hermanos;
	private String preescolar;
	private String primaria;
	private String secundaria;
	private String dirEscuela;
	private String telEscuela;
	private String emailEscuela;
	
	public AlumDatos(){
		codigoId		= "";
		escuelaId		= "";
		nombreTutor		= "";
		parentesco		= "";
		direccion		= "";
		telefono		= "";
		email			= "";
		estudio			= "";
		escuelaAnt		= "";
		fax				= "";
		nombrePadre		= "";
		vivePadre		= "";
		religionPadre	= "";
		dirPadre		= "";
		telPadre		= "";
		telTrabajoP		= "";
		celPadre		= "";
		nombreMadre		= "";
		viveMadre		= "";
		religionMadre	= "";
		dirMadre		= "";
		telMadre		= "";
		telTrabajoM		= "";
		celMadre		= "";
		estadoCivil		= "";
		hermanos 		= "";
		preescolar		= "";
		primaria 		= "";
		secundaria		= "";
		dirEscuela		= "";
		telEscuela		= "";
		emailEscuela	= "";
	}
	
	public String getDirEscuela() {
		return dirEscuela;
	}

	public void setDirEscuela(String dirEscuela) {
		this.dirEscuela = dirEscuela;
	}

	public String getTelEscuela() {
		return telEscuela;
	}

	public void setTelEscuela(String telEscuela) {
		this.telEscuela = telEscuela;
	}

	public String getEmailEscuela() {
		return emailEscuela;
	}

	public void setEmailEscuela(String emailEscuela) {
		this.emailEscuela = emailEscuela;
	}

	public String getCodigoId() {
		return codigoId;
	}

	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}

	public String getNombreTutor() {
		return nombreTutor;
	}

	public void setNombreTutor(String nombreTutor) {
		this.nombreTutor = nombreTutor;
	}

	public String getParentesco() {
		return parentesco;
	}

	public void setParentesco(String parentesco) {
		this.parentesco = parentesco;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getTelefono() {
		return telefono;
	}

	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getEstudio() {
		return estudio;
	}

	public void setEstudio(String estudio) {
		this.estudio = estudio;
	}

	public String getEscuelaAnt() {
		return escuelaAnt;
	}

	public void setEscuelaAnt(String escuelaAnt) {
		this.escuelaAnt = escuelaAnt;
	}

	public String getFax() {
		return fax;
	}

	public void setFax(String fax) {
		this.fax = fax;
	}

	public String getNombrePadre() {
		return nombrePadre;
	}

	public void setNombrePadre(String nombrePadre) {
		this.nombrePadre = nombrePadre;
	}

	public String getVivePadre() {
		return vivePadre;
	}

	public void setVivePadre(String vivePadre) {
		this.vivePadre = vivePadre;
	}

	public String getReligionPadre() {
		return religionPadre;
	}

	public void setReligionPadre(String religionPadre) {
		this.religionPadre = religionPadre;
	}

	public String getDirPadre() {
		return dirPadre;
	}

	public void setDirPadre(String dirPadre) {
		this.dirPadre = dirPadre;
	}

	public String getTelPadre() {
		return telPadre;
	}

	public void setTelPadre(String telPadre) {
		this.telPadre = telPadre;
	}

	public String getTelTrabajoP() {
		return telTrabajoP;
	}

	public void setTelTrabajoP(String telTrabajoP) {
		this.telTrabajoP = telTrabajoP;
	}

	public String getCelPadre() {
		return celPadre;
	}

	public void setCelPadre(String celPadre) {
		this.celPadre = celPadre;
	}

	public String getNombreMadre() {
		return nombreMadre;
	}

	public void setNombreMadre(String nombreMadre) {
		this.nombreMadre = nombreMadre;
	}

	public String getViveMadre() {
		return viveMadre;
	}

	public void setViveMadre(String viveMadre) {
		this.viveMadre = viveMadre;
	}

	public String getReligionMadre() {
		return religionMadre;
	}

	public void setReligionMadre(String religionMadre) {
		this.religionMadre = religionMadre;
	}

	public String getDirMadre() {
		return dirMadre;
	}

	public void setDirMadre(String dirMadre) {
		this.dirMadre = dirMadre;
	}

	public String getTelMadre() {
		return telMadre;
	}

	public void setTelMadre(String telMadre) {
		this.telMadre = telMadre;
	}

	public String getTelTrabajoMadre() {
		return telTrabajoM;
	}

	public void setTelTrabajoMadre(String telTrabajoM) {
		this.telTrabajoM = telTrabajoM;
	}

	public String getCelMadre() {
		return celMadre;
	}

	public void setCelMadre(String celMadre) {
		this.celMadre = celMadre;
	}

	public String getEstadoCivil() {
		return estadoCivil;
	}

	public void setEstadoCivil(String estadoCivil) {
		this.estadoCivil = estadoCivil;
	}

	public String getHermanos() {
		return hermanos;
	}

	public void setHermanos(String hermanos) {
		this.hermanos = hermanos;
	}

	public String getPreescolar() {
		return preescolar;
	}

	public void setPreescolar(String preescolar) {
		this.preescolar = preescolar;
	}

	public String getPrimaria() {
		return primaria;
	}

	public void setPrimaria(String primaria) {
		this.primaria = primaria;
	}

	public String getSecundaria() {
		return secundaria;
	}

	public void setSecundaria(String secundaria) {
		this.secundaria = secundaria;
	}
	
	public String getEscuelaId() {
		return escuelaId;
	}

	public void setEscuelaId(String escuelaId) {
		this.escuelaId = escuelaId;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO ALUM_DATOS" +
					" (CODIGO_ID, ESCUELA_ID, NOMBRE_TUTOR, PARENTESCO," +
					" DIRECCION, TELEFONO, EMAIL," +
					" ESTUDIO, ESCUELA_ANT, FAX," +
					" NOMBRE_PADRE, VIVE_PADRE, RELIGION_PADRE," +
					" DIR_PADRE, TEL_PADRE, TELTRABAJO_PADRE," +
					" CEL_PADRE, NOMBRE_MADRE, VIVE_MADRE," +
					" RELIGION_MADRE, DIR_MADRE, TEL_MADRE, " +
					" TELTRABAJO_MADRE, CEL_MADRE, ESTADO_CIVIL," +
					" HERMANOS, PREESCOLAR, PRIMARIA, SECUNDARIA, DIR_ESC, TEL_ESC, EMAIL_ESC ) " +
					" VALUES(?, ?, UPPER(RTRIM(LTRIM(?))), ?, " +
					" ?, ?, ?," +
					" ?, ?, ?," +
					" UPPER(RTRIM(LTRIM(?))), ?, TO_NUMBER(?,'99')," +
					" ?, ?, ?," +
					" ?, UPPER(RTRIM(LTRIM(?))), ?," +
					" TO_NUMBER(?, '99'), ?, ?," +
					" ?, ?, ?, ?, TO_NUMBER(?,'99'), TO_NUMBER(?,'99'), TO_NUMBER(?,'99'),?,?,? )");
			
			ps.setString(1, codigoId);
			ps.setString(2, escuelaId);
			ps.setString(3, nombreTutor);
			ps.setString(4, parentesco);
			ps.setString(5, direccion);
			ps.setString(6, telefono);
			ps.setString(7, email);
			ps.setString(8, estudio);
			ps.setString(9, escuelaAnt);
			ps.setString(10, fax);
			ps.setString(11, nombrePadre);
			ps.setString(12, vivePadre);
			ps.setString(13, religionPadre);
			ps.setString(14, dirPadre);
			ps.setString(15, telPadre);
			ps.setString(16, telTrabajoP);
			ps.setString(17, celPadre);
			ps.setString(18, nombreMadre);
			ps.setString(19, viveMadre);
			ps.setString(20, religionMadre);
			ps.setString(21, dirMadre);
			ps.setString(22, telMadre);
			ps.setString(23, telTrabajoM);
			ps.setString(24, celMadre);
			ps.setString(25, estadoCivil);
			ps.setString(26, hermanos);
			ps.setString(27, preescolar);
			ps.setString(28, primaria);
			ps.setString(29, secundaria);
			ps.setString(30, dirEscuela);
			ps.setString(31, telEscuela);
			ps.setString(32, emailEscuela);
			
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
	
	
	public boolean updateReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement(" UPDATE ALUM_DATOS " +
					" SET NOMBRE_TUTOR = UPPER(RTRIM(LTRIM(?)))," +
					" PARENTESCO = ?," +
					" DIRECCION = ?," +
					" TELEFONO = ?," +
					" EMAIL = ?," +
					" ESTUDIO = ?," +
					" ESCUELA_ANT = ?," +
					" FAX = ?," +
					" NOMBRE_PADRE = UPPER(RTRIM(LTRIM(?)))," +
					" VIVE_PADRE = ?," +
					" RELIGION_PADRE = TO_NUMBER(?,'99')," +
					" DIR_PADRE = ?," +
					" TEL_PADRE = ?," +
					" TELTRABAJO_PADRE = ?," +
					" CEL_PADRE = ?," +
					" NOMBRE_MADRE = UPPER(RTRIM(LTRIM(?)))," +
					" VIVE_MADRE = ?," +
					" RELIGION_MADRE = TO_NUMBER(?,'99'),"+
					" DIR_MADRE = ?, " +
					" TEL_MADRE = ?, " +
					" TELTRABAJO_MADRE = ?," +
					" CEL_MADRE = ?," +
					" ESTADO_CIVIL = ?, " +
					" HERMANOS = ?, " +
					" PREESCOLAR = TO_NUMBER(?,'99')," +
					" PRIMARIA = TO_NUMBER(?,'99'), " +
					" SECUNDARIA = TO_NUMBER(?,'99')," +
					" DIR_ESC = ?," +
					" TEL_ESC = ?," +
					" EMAIL_ESC = ? " +
					" WHERE CODIGO_ID = ? " +
					" AND ESCUELA_ID = ? ");			
			
			ps.setString(1, nombreTutor);
			ps.setString(2, parentesco);
			ps.setString(3, direccion);
			ps.setString(4, telefono);
			ps.setString(5, email);
			ps.setString(6, estudio);
			ps.setString(7, escuelaAnt);
			ps.setString(8, fax);
			ps.setString(9, nombrePadre);
			ps.setString(10, vivePadre);
			ps.setString(11, religionPadre);
			ps.setString(12, dirPadre);
			ps.setString(13, telPadre);
			ps.setString(14, telTrabajoP);
			ps.setString(15, celPadre);
			ps.setString(16, nombreMadre);
			ps.setString(17, viveMadre);
			ps.setString(18, religionMadre);
			ps.setString(19, dirMadre);
			ps.setString(20, telMadre);
			ps.setString(21, telTrabajoM);
			ps.setString(22, celMadre);
			ps.setString(23, estadoCivil);
			ps.setString(24, hermanos);
			ps.setString(25, preescolar);
			ps.setString(26, primaria);
			ps.setString(27, secundaria);
			ps.setString(28, dirEscuela);
			ps.setString(29, telEscuela);
			ps.setString(30, emailEscuela);
			ps.setString(31, codigoId);
			ps.setString(32, escuelaId);

			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumDatos|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	

	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM ALUM_DATOS" +
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
		
		codigoId		= rs.getString("CODIGO_ID");
		escuelaId		= rs.getString("ESCUELA_ID");
		nombreTutor 	= rs.getString("NOMBRE_TUTOR");
		parentesco 		= rs.getString("PARENTESCO");
		direccion 		= rs.getString("DIRECCION");
		telefono 		= rs.getString("TELEFONO");
		email			= rs.getString("EMAIL");
		estudio			= rs.getString("ESTUDIO");
		escuelaAnt		= rs.getString("ESCUELA_ANT");
		fax				= rs.getString("FAX");
		nombrePadre		= rs.getString("NOMBRE_PADRE");
		vivePadre		= rs.getString("VIVE_PADRE");
		religionPadre	= rs.getString("RELIGION_PADRE");
		dirPadre		= rs.getString("DIR_PADRE");
		telPadre		= rs.getString("TEL_PADRE");
		telTrabajoP		= rs.getString("TELTRABAJO_PADRE");
		celPadre		= rs.getString("CEL_PADRE");
		nombreMadre		= rs.getString("NOMBRE_MADRE");
		viveMadre		= rs.getString("VIVE_MADRE");
		religionMadre	= rs.getString("RELIGION_MADRE");
		dirMadre		= rs.getString("DIR_MADRE");
		telMadre		= rs.getString("TEL_MADRE");
		telTrabajoM		= rs.getString("TELTRABAJO_MADRE");
		celMadre		= rs.getString("CEL_MADRE");
		estadoCivil		= rs.getString("ESTADO_CIVIL");
		hermanos		= rs.getString("HERMANOS");
		preescolar		= rs.getString("PREESCOLAR");
		primaria		= rs.getString("PRIMARIA");
		secundaria		= rs.getString("SECUNDARIA");
		dirEscuela		= rs.getString("DIR_ESC");
		telEscuela		= rs.getString("TEL_ESC");
		emailEscuela	= rs.getString("EMAIL_ESC");

	}
	
	public void mapeaRegId(Connection con, String codigoId, String escuelaId) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null;
		try{
			ps = con.prepareStatement("SELECT CODIGO_ID, ESCUELA_ID, NOMBRE_TUTOR," +
					" PARENTESCO, DIRECCION, TELEFONO," +
					" EMAIL, ESTUDIO, ESCUELA_ANT," +
					" FAX, NOMBRE_PADRE, VIVE_PADRE," +
					" RELIGION_PADRE, DIR_PADRE, TEL_PADRE," +
					" TELTRABAJO_PADRE, CEL_PADRE, NOMBRE_MADRE," +
					" VIVE_MADRE, RELIGION_MADRE, DIR_MADRE, " +
					" TEL_MADRE, TELTRABAJO_MADRE, CEL_MADRE, ESTADO_CIVIL, " +
					" HERMANOS, PREESCOLAR, PRIMARIA, SECUNDARIA, DIR_ESC, TEL_ESC, EMAIL_ESC  " +
					" FROM ALUM_DATOS" +
					" WHERE CODIGO_ID = ?" +
					" AND ESCUELA_ID = ?");
			
			ps.setString(1, codigoId);
			ps.setString(2, escuelaId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumDatos|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM ALUM_DATOS" +
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
}
