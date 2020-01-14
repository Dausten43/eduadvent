package aca.reporte;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

import com.google.gson.Gson;

public class UtilReporteNew {
	
	private static java.math.MathContext mc = new java.math.MathContext(4, java.math.RoundingMode.HALF_EVEN); 	// Math Context para manejar los formatos de los BigDecimal

	public static Reporte mapeaDatosEscuela(ResultSet rs) throws SQLException {
		Reporte reporte = new Reporte();
		
		reporte.setEscuelaId(rs.getString("ESCUELA_ID"));
		reporte.setNombreEscuela(rs.getString("ESCUELA_NOMBRE"));
		reporte.setTelefono(rs.getString("DIR_TEL"));
		reporte.setCiudad(rs.getString("CIUDAD"));
		reporte.setEstado(rs.getString("ESTADO"));
		reporte.setNombrePais(rs.getString("PAIS"));
		reporte.setNombreDirector(rs.getString("NOMBRE_DIRECTOR"));
		reporte.setNombreSecretaria(rs.getString("NOMBRE_SECRETARIA"));
		reporte.setLogo(rs.getString("LOGO"));
		
		return reporte;
	}
	
	public static ReporteAlumnoNew mapeaDatosAlumno(ResultSet rs) throws SQLException {
		ReporteAlumnoNew reporteAlumno = new ReporteAlumnoNew();
		
		reporteAlumno.setCodigoId(rs.getString("CODIGO_ID"));
		reporteAlumno.setNombreAlumno(rs.getString("NOMBRE"));
		reporteAlumno.setCip(rs.getString("CIP"));
		
		return reporteAlumno;
	}
	
	public static ReporteGrado mapeaGradoAlumno(ResultSet rs) throws SQLException {
		ReporteGrado reporteGrado = new ReporteGrado();
		
		reporteGrado.setCicloId(rs.getString("CICLO_ID"));
		reporteGrado.setGrado(rs.getInt("GRADO"));
		reporteGrado.setNombreGrado(aca.catalogo.CatNivel.getGradoNombre(reporteGrado.getGrado()));
		reporteGrado.setCicloGrupoId(rs.getString("CICLO_GRUPO_ID"));
		reporteGrado.setObservaciones(""); //No se de donde se van a sacar las observaciones
		reporteGrado.setNombrePlan(rs.getString("PLAN_NOMBRE"));
		reporteGrado.setFechaInicial(rs.getString("F_INICIAL"));
		reporteGrado.setFechaFinal(rs.getString("F_FINAL"));
		reporteGrado.setNivelEval(rs.getString("NIVEL_EVAL"));
		reporteGrado.setEscalaEval(rs.getInt("ESCALA"));
		reporteGrado.setRedondeo(rs.getString("REDONDEO"));
		reporteGrado.setDecimales(rs.getString("DECIMALES"));
		
		return reporteGrado;
	}
	
	public static ReporteMateria mapeaMateriaGrado(ResultSet rs) throws SQLException {
		ReporteMateria reporteMateria = new ReporteMateria();
		
		reporteMateria.setCursoId(rs.getString("CURSO_ID"));
		reporteMateria.setNombre(rs.getString("CURSO_NOMBRE"));
		reporteMateria.setHoras(rs.getString("HORAS"));
		reporteMateria.setBoleta(rs.getString("BOLETA"));
		reporteMateria.setCalificacion(rs.getString("NOTA"));
		reporteMateria.setConvalidacion(rs.getString("CONVALIDACION"));
		reporteMateria.setCursoBase(rs.getString("CURSO_BASE"));
		reporteMateria.setEmpleado(rs.getString("EMPLEADO_ID"));
		reporteMateria.setCicloGrupoId(rs.getString("CICLO_GRUPO_ID"));
		
		String jsonEval = rs.getString("EVALUACIONES");
		HashMap<Integer, ReportePromedio> mapaPromedios = mapeaPromedios(jsonEval);
		
		reporteMateria.setMapaPromedios(mapaPromedios);
		
		return reporteMateria;
	}

	
	public static Reporte cargaDatosEscuela(Connection con, String escuelaId) throws SQLException {
		Reporte reporte = new Reporte();
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			ps = con.prepareStatement("SELECT * FROM reporte_escuela(?)");
			
			ps.setString(1, escuelaId);
			
			rs = ps.executeQuery();
			
			if(rs.next()) {
				reporte = mapeaDatosEscuela(rs);
			}
		} catch(Exception ex) {
			System.out.println("Error - aca.reporte.UtilReporte|cargaDatosEscuela|:"+ex);
			ex.printStackTrace();
		} finally {
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return reporte;
	}
	
	public static ReporteAlumnoNew cargaDatosAlumno(Connection con, String codigoId) throws SQLException {
		ReporteAlumnoNew reporteAlumno = new ReporteAlumnoNew();
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			ps = con.prepareStatement("SELECT * FROM reporte_alumno(?)");
			
			ps.setString(1, codigoId);
			
			rs = ps.executeQuery();
			
			if(rs.next()) {
				reporteAlumno = mapeaDatosAlumno(rs);
			}
		} catch(Exception ex) {
			System.out.println("Error - aca.reporte.UtilReporte|cargaDatosAlumno|:"+ex);
			ex.printStackTrace();
		} finally {
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return reporteAlumno;
	}
	
	public static ArrayList<String> listaGruposAlumno(Connection con, String codigoId) throws SQLException {
		ArrayList<String> listaGrupos = new ArrayList<String>();
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			ps = con.prepareStatement("SELECT GRUPO FROM reporte_alumno_grupos(?)");
			
			ps.setString(1, codigoId);
			
			rs = ps.executeQuery();
			
			while(rs.next()) {
				listaGrupos.add(rs.getString("GRUPO"));
			}
		} catch(Exception ex) {
			System.out.println("Error - aca.reporte.UtilReporte|cargaGradosAlumno|:"+ex);
			ex.printStackTrace();
		} finally {
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return listaGrupos;
	}
	
	public static ReporteGrado cargaGradoAlumno(Connection con, String cicloGrupoId) throws SQLException {
		ReporteGrado reporteGrado = new ReporteGrado();
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			ps = con.prepareStatement("SELECT * FROM reporte_grupo(?)");
			
			ps.setString(1, cicloGrupoId);
			
			rs = ps.executeQuery();
			
			if(rs.next()) {
				reporteGrado = mapeaGradoAlumno(rs);
			}
		} catch(Exception ex) {
			System.out.println("Error - aca.reporte.UtilReporte|cargaGradosAlumno|:"+ex);
			ex.printStackTrace();
		} finally {
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return reporteGrado;
	}
	
	public static LinkedHashMap<String, ReporteMateria> cargaMateriasAlumno(Connection con, String codigoId, String cicloGrupoId) throws SQLException {
		LinkedHashMap<String, ReporteMateria> mapaMaterias = new LinkedHashMap<String, ReporteMateria>();
		ReporteMateria reporteMateria = new ReporteMateria();
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			ps = con.prepareStatement("SELECT CURSO_ID, CURSO_NOMBRE, HORAS, BOLETA, NOTA, CONVALIDACION,"
					+ " CURSO_BASE, EMPLEADO_ID, CICLO_GRUPO_ID, EVALUACIONES FROM reporte_grupo_materias(?, ?)");
			
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			
			rs = ps.executeQuery();
			
			while(rs.next()) {
				reporteMateria = mapeaMateriaGrado(rs);
				mapaMaterias.put(reporteMateria.getCursoId(), reporteMateria);
			}
		} catch(Exception ex) {
			System.out.println("Error - aca.reporte.UtilReporte|cargaMateriasAlumno|:"+ex);
			ex.printStackTrace();
		} finally {
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return mapaMaterias;
	}
	
	public static LinkedHashMap<Integer, ReporteAspecto> cargaAspectosAlumno(Connection con, String codigoId, String cicloGrupoId) throws SQLException {
		LinkedHashMap<Integer, ReporteAspecto> mapaAspectos = new LinkedHashMap<Integer, ReporteAspecto>();
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			ps = con.prepareStatement("SELECT ASPECTOS_ID, ASPECTOS_NOMBRE, PROMEDIO_ID, EVALUACION_ID, NOTA FROM reporte_alumno_aspectos(?, ?)");
			
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			
			rs = ps.executeQuery();
			
			
			int aspecto_id = -1;		
			String nombre, prom_eval, nota;
			while(rs.next()) {
				if(aspecto_id != Integer.parseInt(rs.getString("ASPECTOS_ID"))) {
					
					aspecto_id = Integer.parseInt(rs.getString("ASPECTOS_ID"));
					mapaAspectos.put(aspecto_id, new ReporteAspecto());
					
					nombre = rs.getString("ASPECTOS_NOMBRE");
					mapaAspectos.get(aspecto_id).setNombre(nombre);
				}
				
				prom_eval = rs.getString("PROMEDIO_ID") + "" + rs.getString("EVALUACION_ID");
				nota = rs.getString("NOTA");
				
				mapaAspectos.get(aspecto_id).setNota(prom_eval, nota);
			}
		} catch(Exception ex) {
			System.out.println("Error - aca.reporte.UtilReporte|cargaMateriasAlumno|:"+ex);
			ex.printStackTrace();
		} finally {
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return mapaAspectos;
	}
	
	public static Reporte generaReportes(Connection con, List<String> listaAlumnos) throws SQLException{
		Reporte reporte = new Reporte();
		
		if(listaAlumnos.size() > 0) {			
			HashMap<String, ReporteAlumnoNew> mapReportes = new HashMap<String, ReporteAlumnoNew>();
			HashMap<Integer, ReporteGrado> mapGrados = new HashMap<Integer, ReporteGrado>();
			ArrayList<String> listGroups = new ArrayList<String>();
			LinkedHashMap<String, ReporteMateria> mapaMaterias = new LinkedHashMap<String, ReporteMateria>();
			LinkedHashMap<Integer,ReporteAspecto> mapaAspectos = new LinkedHashMap<Integer, ReporteAspecto>();
			
			String escuelaId = listaAlumnos.get(0).substring(0, 3);
			ReporteAlumnoNew reporteAlumno = new ReporteAlumnoNew();
			ReporteGrado reporteGrado = new ReporteGrado();
			
			reporte = cargaDatosEscuela(con, escuelaId);
			
			for(String codigoId: listaAlumnos) {
				reporteAlumno = cargaDatosAlumno(con, codigoId);
				listGroups = listaGruposAlumno(con, codigoId);
				
				for(String grupo: listGroups) {
					reporteGrado = cargaGradoAlumno(con, grupo);
					mapaMaterias = cargaMateriasAlumno(con, codigoId, grupo);
					mapaAspectos = cargaAspectosAlumno(con, codigoId, grupo);
					
					reporteGrado.setMapaMaterias(mapaMaterias);
					
					DecimalFormat frm = setFormat(reporteGrado.getDecimales(), reporteGrado.getRedondeo());
					calcularCalificacionesMaterias(reporteGrado.getMaterias(), frm);
					
					reporteGrado.setMapaAspectos(mapaAspectos);
					
					mapGrados.put(reporteGrado.getGrado(), reporteGrado);
				}
				
				reporteAlumno.setMapaGrados(mapGrados);
				mapReportes.put(codigoId, reporteAlumno);
			}
			
			reporte.setMapaReportes(mapReportes);
		}
		
		return reporte;
	}
	
	public static HashMap<Integer, ReportePromedio> mapeaPromedios(String jsonEval){
		HashMap<Integer, ReportePromedio> mapaPromedios = new HashMap<Integer, ReportePromedio>();
		
		CalificacionDTO[] lsCalfFromJson = new Gson().fromJson(jsonEval, CalificacionDTO[].class);
		List<CalificacionDTO> listCalf = Arrays.asList(lsCalfFromJson);
		
		int prom_id = -1;
		int eval_id = -1;
		for(CalificacionDTO item: listCalf) {
			if(item.getPromedioId() != prom_id) {
				prom_id = item.getPromedioId();
				mapaPromedios.put(prom_id, new ReportePromedio(item.getPromCorto(), item.getPromValor()));
			}
			if(item.getEvalId() != eval_id) {
				eval_id = item.getEvalId();
				
				// Aplica el formato a la calificacion de la evaluacion según la configuracion a nivel evaluacion
				DecimalFormat frm = setFormat(item.getEval_decimales(), item.getEval_redondeo());
				String nota = item.getNota() != null ? frm.format(Double.parseDouble(item.getNota())) : "-";
				
				// Agrega la evaluacion al mapa de evaluaciones del promedio
				String nombre = item.getEvaCorto();
				String valor = item.getEval_valor();
				mapaPromedios.get(prom_id).addEvaluacion(eval_id, new ReporteEvaluacion(nombre, nota, valor));
				
				// Asigna el formato con la configuración a nivel promedio y calcula la calificación del mismo
				frm = setFormat(item.getPromDecimales(), item.getPromRedondeo());
				String notaProm = calcularCalificacionPromedio(mapaPromedios.get(prom_id).getEvaluaciones(), frm);
				mapaPromedios.get(prom_id).setNota(notaProm);
			}
		}
		
		return mapaPromedios;
	}
	
	public static String calcularCalificacionPromedio(Collection<ReporteEvaluacion> evaluaciones, DecimalFormat frm) {
		String calificacion = "";
		BigDecimal totalCalf = new BigDecimal("0", mc);
		BigDecimal totalValor = new BigDecimal("0", mc);
		BigDecimal valorEval = new BigDecimal("0", mc);
		BigDecimal notaEval = new BigDecimal("0", mc);
		for(ReporteEvaluacion eval: evaluaciones){
			// Si no tiene nota se evita realizar las operaciones para reducir el procesamiento
			if(!eval.getNota().equals("-")) {
				valorEval = new BigDecimal(eval.getValor(), mc);
				notaEval = new BigDecimal(eval.getNota(), mc);
				totalCalf = totalCalf.add(notaEval.multiply(valorEval, mc), mc);
				totalValor = totalValor.add(valorEval, mc);
			}
		}
		
		// Se verifica que tenga calificaciones para evitar divisiones con ceros
		if(!totalCalf.toString().equals("0") && !totalValor.toString().equals("0")) {
			calificacion = totalCalf.divide(totalValor, mc).toString();
		}
		
		if(!calificacion.equals("")) {
			return frm.format(Double.parseDouble(calificacion));			
		}
		
		return "-";
	}
	
	public static void calcularCalificacionesMaterias(Collection<ReporteMateria> materias, DecimalFormat frm) {
		String calificacion = "";
		BigDecimal totalCalf;
		BigDecimal totalValor;
		BigDecimal notaProm;
		BigDecimal valorProm;
		
		for(ReporteMateria reporteMateria: materias) {
			totalCalf = new BigDecimal("0", mc);
			totalValor = new BigDecimal("0", mc);
			notaProm = new BigDecimal("0", mc);
			valorProm = new BigDecimal("0", mc);
			for(ReportePromedio prom: reporteMateria.getPromedios()){
				// Si no tiene nota se evita realizar las operaciones para reducir el procesamiento
				if(!prom.getNota().equals("-")) {
					valorProm = new BigDecimal(prom.getValor(), mc);
					notaProm = new BigDecimal(prom.getNota(), mc);
					totalCalf = totalCalf.add(notaProm.multiply(valorProm, mc), mc);
					totalValor = totalValor.add(valorProm, mc);
				}
			}
			
			// Se verifica que tenga calificaciones para evitar divisiones con ceros
			if(!totalCalf.toString().equals("0") && !totalValor.toString().equals("0")) {
				calificacion = totalCalf.divide(totalValor, mc).toString();
			}
			
			if(!calificacion.equals("")) {
				reporteMateria.setCalificacion(frm.format(Double.parseDouble(calificacion)));			
			}else {
				reporteMateria.setCalificacion("-");
			}
		}
	}
	
	private static DecimalFormat setFormat(String decimales, String redondeo){
		DecimalFormat frm;
		
		if(decimales.equals("1")){
			frm = new java.text.DecimalFormat("##0.0;-##0.0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
		}else if(decimales.equals("2")){
			frm = new java.text.DecimalFormat("##0.00;-##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));
		}else{
			frm = new java.text.DecimalFormat("##0;-##0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
		}
		
		if(redondeo.equals("T")){
			frm.setRoundingMode(RoundingMode.DOWN);
		}else{
			frm.setRoundingMode(RoundingMode.HALF_UP);
		}
		
		return frm;
	}
}
