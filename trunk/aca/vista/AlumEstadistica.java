package aca.vista;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AlumEstadistica {
	private String periodoId;
	private String codigoId;
	private String nombre;
	private String aPaterno;
	private String aMaterno;	
	private String genero;
	private String fNacimiento;
	private String religion;
	private String clasfinId;
	private String planId;
	private String fecha;
	private String nivel;
	private String grado;
	private String grupo;
	
	public AlumEstadistica(){
		periodoId 	= "";
		codigoId	= "";
		nombre		= "";
		aPaterno	= "";
		aMaterno	= "";
		genero		= "";
		fNacimiento	= "";
		religion	= "";
		clasfinId	= "";
		planId		= "";
		fecha		= "";
		nivel		= "";
		grado		= "";
		grupo		= "";
	}
	

	public String getPeriodoId() {
		return periodoId;
	}


	public void setPeriodoId(String periodoId) {
		this.periodoId = periodoId;
	}


	public String getCodigoId() {
		return codigoId;
	}


	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}


	public String getNombre() {
		return nombre;
	}


	public void setNombre(String nombre) {
		this.nombre = nombre;
	}


	public String getaPaterno() {
		return aPaterno;
	}


	public void setaPaterno(String aPaterno) {
		this.aPaterno = aPaterno;
	}


	public String getaMaterno() {
		return aMaterno;
	}


	public void setaMaterno(String aMaterno) {
		this.aMaterno = aMaterno;
	}


	public String getGenero() {
		return genero;
	}


	public void setGenero(String genero) {
		this.genero = genero;
	}


	public String getfNacimiento() {
		return fNacimiento;
	}


	public void setfNacimiento(String fNacimiento) {
		this.fNacimiento = fNacimiento;
	}


	public String getReligion() {
		return religion;
	}


	public void setReligion(String religion) {
		this.religion = religion;
	}


	public String getClasfinId() {
		return clasfinId;
	}


	public void setClasfinId(String clasfinId) {
		this.clasfinId = clasfinId;
	}


	public String getPlanId() {
		return planId;
	}


	public void setPlanId(String planId) {
		this.planId = planId;
	}


	public String getFecha() {
		return fecha;
	}


	public void setFecha(String fecha) {
		this.fecha = fecha;
	}


	public String getNivel() {
		return nivel;
	}


	public void setNivel(String nivel) {
		this.nivel = nivel;
	}


	public String getGrado() {
		return grado;
	}


	public void setGrado(String grado) {
		this.grado = grado;
	}


	public String getGrupo() {
		return grupo;
	}


	public void setGrupo(String grupo) {
		this.grupo = grupo;
	}


	public void mapeaReg(ResultSet rs) throws SQLException{
		periodoId 		= rs.getString("PERIODO_ID");
		codigoId		= rs.getString("CODIGO_ID");
		nombre			= rs.getString("NOMBRE");
		aPaterno		= rs.getString("APATERNO");
		aMaterno 		= rs.getString("AMATERNO");
		genero	 		= rs.getString("GENERO");		
		fNacimiento 	= rs.getString("F_NACIMIENTO");
		religion 		= rs.getString("RELIGION");
		clasfinId 		= rs.getString("CLASFIN_ID");
		planId 			= rs.getString("PLAN_ID");
		fecha 			= rs.getString("FECHA");
		nivel 			= rs.getString("NIVEL");
		grado 			= rs.getString("GRADO");
		grupo 			= rs.getString("GRUPO");
	}
	
	public void mapeaRegId(Connection conn, String ciclo_id, String periodo_id, String codigo_id) throws SQLException{
		ResultSet rs = null;
		PreparedStatement ps = null; 
		try{
			ps = conn.prepareStatement("SELECT * FROM ALUMNO_ESTADISTICA WHERE CICLO_ID = ? AND PERIODO_ID = ? AND CODIGO_ID = ?");
			
			ps.setString(1, ciclo_id);
			ps.setString(2, periodo_id);
			ps.setString(3, codigo_id);
			
			rs = ps.executeQuery();
			if (rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumEstadistica|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
	}
	
	public boolean existeReg(Connection conn, String ciclo_id, String periodo_id, String codigo_id) throws SQLException{
		boolean 			ok 	= false;
		ResultSet 		rs		= null;
		PreparedStatement ps= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM ALUMNO_ESTADISTICA WHERE CICLO_ID = ? AND PERIODO_ID = ? AND CODIGO_ID = ? ");
			ps.setString(1, ciclo_id);
			ps.setString(2, periodo_id);
			ps.setString(3, codigo_id);
			
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumEstadistica|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
}