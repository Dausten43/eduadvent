package aca.reporte;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class UtilReporte {
	
	private String escuelaId;
	private String nombreEscuela;
	private String telefono;
	private String nombreDirector;
	private HashMap<String, ReporteAlumno> mapaReportes;
	
	Gson gson = new GsonBuilder().create();
	
	public UtilReporte(){
		escuelaId = "";
		nombreEscuela = "";
		telefono = "";
		nombreDirector = "";
		mapaReportes = new HashMap<String, ReporteAlumno>();
	}
	
	public UtilReporte(Connection con, String escuelaId, ArrayList<String> listaAlumnos) throws SQLException{
		setEscuelaId(escuelaId);
		setNombreEscuela(aca.catalogo.CatEscuela.getNombre(con, escuelaId));
		setTelefono(aca.catalogo.CatEscuela.getTelefono(con, escuelaId));
		setNombreDirector(aca.empleado.EmpPersonal.getDirectorEscuela(con, escuelaId));
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

	public String getNombreDirector() {
		return nombreDirector;
	}

	public void setNombreDirector(String nombreDirector) {
		this.nombreDirector = nombreDirector;
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
	
}