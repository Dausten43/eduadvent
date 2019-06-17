package aca.reporte;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class UtilReporte {
	
	private String escuelaId;
	private String nombreEscuela;
	private String telefono;//ciudad,estado,direccion,telefono. -- numero Personal
	private String ciudad;
	private String estado;
	private String nombreDirector;
	private String nombreSecretaria; // Secretaría de registro
	private String logo;
	private String nombrePais;
	private HashMap<String, ReporteAlumno> mapaReportes;
	Gson gson = new GsonBuilder().create();
	
	public UtilReporte(){
		escuelaId = "";
		nombreEscuela = "";
		telefono = "";
		nombreDirector = "";
		nombreSecretaria = "";
		logo = "";
		nombrePais = "";
		mapaReportes = new HashMap<String, ReporteAlumno>();
	}
	
	public UtilReporte(Connection con, String escuelaId, ArrayList<String> listaAlumnos) throws SQLException{
		setEscuelaId(escuelaId);
		setNombreEscuela(aca.catalogo.CatEscuela.getNombre(con, escuelaId));
		setNombreDirector(aca.empleado.EmpPersonal.getDirectorEscuela(con, escuelaId));
		setNombreSecretaria(aca.empleado.EmpPersonal.getSecretarioDeRegistro(con, escuelaId));
		setLogo(aca.catalogo.CatEscuela.getLogo(con, escuelaId));
		mapeaRegId(con, escuelaId);
		setTelefono(telefono);
		setNombrePais(nombrePais);
		setMapaReportes(getReportes(con, escuelaId, listaAlumnos));
	}
	
	public String getJson(){
		return gson.toJson(this);
	}

	public HashMap<String, ReporteAlumno> getMapaReportes() {
		return mapaReportes;
	}

	public void setMapaReportes(HashMap<String, ReporteAlumno> hashReportes) {
		this.mapaReportes = hashReportes;
	}
	
	public String getEscuelaId() {
		return escuelaId;
	}

	public void setEscuelaId(String escuelaId) {
		this.escuelaId = escuelaId;
	}

	public String getNombreEscuela() {
		return nombreEscuela;
	}

	public void setNombreEscuela(String nombreEscuela) {
		this.nombreEscuela = nombreEscuela;
	}

	public String getTelefono() {
		return telefono;
	}

	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}

	public String getNombreSecretaria() {
		return nombreSecretaria;
	}
	
	public void setNombreSecretaria(String nombreSecretaria) {
		this.nombreSecretaria = nombreSecretaria;
	}
	
	public String getNombreDirector() {
		return nombreDirector;
	}

	public void setNombreDirector(String nombreDirector) {
		this.nombreDirector = nombreDirector;
	}
	
	public String getNombrePais() {
		return nombrePais;
	}

	public void setNombrePais(String nombrePais) {
		this.nombrePais = nombrePais;
	}
		
	public static ReporteAlumno datosReportePorAlumno(Connection con, String escuelaId, String codigoId) throws SQLException{
		ReporteAlumno datos  = new ReporteAlumno(con, escuelaId, codigoId);

    	return datos;
	}
	
	public static HashMap<String, ReporteAlumno> getReportes(Connection con, String escuelaId, ArrayList<String> listaCodigosAlumnos) throws SQLException{
		HashMap<String, ReporteAlumno> lista = new HashMap<String, ReporteAlumno>();
		for(String codigoId: listaCodigosAlumnos){
			ReporteAlumno datos = datosReportePorAlumno(con, escuelaId, codigoId);
			lista.put(codigoId, datos);
		}
		return lista;
	}
	
	public void mapeaRegId(Connection con, String escuelaId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT p.PAIS_ID, p.PAIS_NOMBRE, e.ESTADO_ID, e.ESTADO_NOMBRE, c.CIUDAD_ID, c.CIUDAD_NOMBRE, esc.DIRECCION, esc.TELEFONO "+
									"FROM CAT_ESCUELA as esc "+
									"JOIN CAT_PAIS as p on esc.PAIS_ID = p.PAIS_ID "+
									"JOIN CAT_ESTADO as e on esc.ESTADO_ID = e.ESTADO_ID "+
									"JOIN CAT_CIUDAD as c on esc.CIUDAD_ID = c.CIUDAD_ID "+
									"WHERE esc.ESCUELA_ID = ? "+
									"AND p.PAIS_ID = e.PAIS_ID "+
									"AND e.PAIS_ID = c.PAIS_ID "+
									"AND c.PAIS_ID = esc.PAIS_ID "+
									"AND e.ESTADO_ID = c.ESTADO_ID "+
									"AND c.ESTADO_ID = esc.ESTADO_ID "+
									"AND c.CIUDAD_ID = esc.CIUDAD_ID");
					
			ps.setString(1, escuelaId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				nombrePais			= rs.getString("PAIS_NOMBRE");
				telefono			= rs.getString("DIRECCION")+", "+rs.getString("TELEFONO");
				ciudad 				= rs.getString("CIUDAD_NOMBRE");
				estado 				= rs.getString("ESTADO_NOMBRE");
				
			}
		
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatCiudad|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
	}

	/**
	 * @return the ciudad
	 */
	public String getCiudad() {
		return ciudad;
	}

	/**
	 * @param ciudad the ciudad to set
	 */
	public void setCiudad(String ciudad) {
		this.ciudad = ciudad;
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

	public String getLogo() {
		return logo;
	}

	public void setLogo(String logo) {
		this.logo = logo;
	}
	
}