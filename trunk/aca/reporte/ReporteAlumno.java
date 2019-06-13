package aca.reporte;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;

public class ReporteAlumno {
	private String codigoId;
	private String nombreAlumno;
	private String cip;
	private HashMap<String, GradoReporte> mapaGrados;
	
	public ReporteAlumno(){
		codigoId = "";
		nombreAlumno = "";
		mapaGrados = new HashMap<String, GradoReporte>();
	}
	
	public ReporteAlumno(Connection con, String escuelaId, String codigoId) throws SQLException {
		setCodigoId(codigoId);
		setNombreAlumno(aca.alumno.AlumPersonal.getNombre(con, codigoId, ""));
		aca.alumno.AlumPersonal alm = new aca.alumno.AlumPersonal();
		alm.mapeaRegId(con, codigoId);
		setCip(alm.getCurp());
		setMapaGrados(mapeaGradosPlan(con, codigoId));
    }
	
	public String getNombreAlumno() {
		return nombreAlumno;
	}

	public void setNombreAlumno(String nombreAlumno) {
		this.nombreAlumno = nombreAlumno;
	}
	
	public HashMap<String, GradoReporte> getMapaGrados(){
		return mapaGrados;
	}
	
	public void setMapaGrados(HashMap<String, GradoReporte> listaGrados){
		this.mapaGrados = listaGrados;
	}
	
	public String getCodigoId() {
		return codigoId;
	}

	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}
	
	public static HashMap<String, GradoReporte> mapeaGradosPlan(Connection con, String codigoId) throws SQLException{
		HashMap<String, GradoReporte> mapa 	= new HashMap<String, GradoReporte>();
		LinkedHashMap<String, MateriaReporte> hashMaterias = new LinkedHashMap<String, MateriaReporte>();
		ResultSet rs 					= null;
		PreparedStatement ps 			= null;
		
		try{
			// Realiza la operación por cada plan en el que el alumno haya estado inscrito
			for(String plan_id: getPlanesId(con, codigoId)){
				String grado = "";
				GradoReporte grado_reporte = new GradoReporte();
				/*  
				 * La siguiente consulta une el listado de materias en los planes
				 * de estudio en los que haya estado inscrito el alumno con las 
				 * materias en las que ha estado inscrito directamente para, de esta forma,
				 * mapear todas las materias del plan pero poder mostrar las calificaciones
				 * en las materias que el alumno cursó.
				 * 
				 */
				ps = con.prepareStatement(" select b.CODIGO_ID, a.GRADO, b.CICLO_GRUPO_ID, a.CURSO_ID, a.HORAS, a.CURSO_NOMBRE, a.CURSO_BASE, a.BOLETA" + 
						"  from ( " + 
						"  		select grado, curso_id, horas, curso_nombre, curso_base, boleta, orden" + 
						"  		from plan_curso " + 
						"  		where plan_id = ? and estado = 'A' and boleta = 'S'" + 
						"        ) as a" + 
						"  left join (" + 
						"  		select codigo_id, ciclo_grupo_id, curso_id" + 
						"  		from krdx_curso_act " + 
						"  		where codigo_id = ? and substring(curso_id FOR 6) = ?" + 
						"     	 ) as b" + 
						"  on a.curso_id = b.curso_id" + 
						"  where substring(b.ciclo_grupo_id FOR 8) not in (" + 
						"  	select ciclo_id from ciclo where now() between f_inicial and f_final and substring(ciclo_id for 3) = substring(? for 3)" + 
						"  )" + 
						"  order by a.grado, b.codigo_id, b.ciclo_grupo_id, a.orden ");
				ps.setString(1, plan_id);
				ps.setString(2, codigoId);
				ps.setString(3, plan_id);
				ps.setString(4, codigoId);
				rs = ps.executeQuery();
				
				
				while(rs.next()){
										
					// Si la variable grado ya fue asignada 
					// y si el grado de la siguiente materia es
					// diferente a la materia anterior entonces
					// es un salto de grupo
					if(!grado.equals("") && !grado.equals(rs.getString("GRADO"))){
						// Le asigna la lista de materias al grupo que se acaba de terminar
						// Si cursó ese grado se calculan las calificaciones a la vez
						grado_reporte.setMapaMaterias(con, hashMaterias, codigoId);
						// Agrega el grado al HashMap
						mapa.put(grado, grado_reporte);
						// Se limpia la lista de materias para comenzar
						// a llenarla con las materias del siguiente grado
						hashMaterias.clear();
						// Se actualiza al grado que continua
						grado = rs.getString("GRADO");
						// Inicializa el modelo del Grado siguiente.
						// Si trae ciclo grupo id significa que el
						// alumno estuvo inscrito a esa materia
						grado_reporte = new GradoReporte(con, plan_id, rs.getString("CICLO_GRUPO_ID") == null?"":rs.getString("CICLO_GRUPO_ID"), grado);
					}
					// Si grado aún no ha sido asignado por primera vez
					else if(grado.equals("")){
						// Se asigna el grado inicial del listado
						grado = rs.getString("GRADO");
						// Se inicializa el modelo del Grado inicial.
						// Si trae ciclo grupo id significa que el
						// alumno estuvo inscrito a esa materia
						//grado_reporte = new GradoReporte(con, plan_id, rs.getString("CICLO_GRUPO_ID"), grado);
						
						grado_reporte = new GradoReporte(con, plan_id, rs.getString("CICLO_GRUPO_ID") == null?"":rs.getString("CICLO_GRUPO_ID"), grado);
					}
					// Se inicializa el modelo de la Materia
					MateriaReporte materia = new MateriaReporte(rs.getString("CURSO_ID"), rs.getString("CURSO_NOMBRE"), Double.parseDouble(rs.getString("HORAS")), "", rs.getString("CURSO_BASE"), rs.getString("BOLETA"), rs.getString("CICLO_GRUPO_ID"));
					//
					if(!hashMaterias.getOrDefault(materia.getCursoId(), new MateriaReporte()).getCursoId().equals("")) {
						hashMaterias.remove(materia.getCursoId());
					}
					hashMaterias.put(materia.getCursoId(), materia);
					// Se agrega a la lista de materias
					
					
					// Si es la última fila del ResultSet
					if(rs.isLast()){
						// Le asigna la lista de materias al grupo que se acaba de terminar
						// Si cursó ese grado se calculan las calificaciones a la vez
						grado_reporte.setMapaMaterias(con, hashMaterias, codigoId);
						// Agrega el grado al HashMap
						mapa.put(grado, grado_reporte);
						// Se limpia la lista de materias para finalizar
						hashMaterias.clear();
					}
				}
			}
		}catch(Exception ex){
			System.out.println("Hubo un error jaja saludos");
			System.out.println("Error - aca.reporte.ReporteAlumno|mapeaGradosPlan|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return mapa;
	}
	
	public static ArrayList<String> getListCiclos(Connection con, String codigoId) throws SQLException{
		ArrayList<String> lista 	= new ArrayList<String>();
		ResultSet rs 				= null;
		PreparedStatement ps 		= null;
		
		try{
			
			ps = con.prepareStatement("SELECT DISTINCT(ciclo_grupo_id) FROM KRDX_CURSO_ACT WHERE CODIGO_ID = ?");
			ps.setString(1, codigoId);
			
			rs = ps.executeQuery();
			while(rs.next()){
				lista.add(rs.getString("ciclo_grupo_id"));
			}
		}catch(Exception ex){
			System.out.println("Error - aca.reporte.ReporteAlumno|getListCiclos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return lista;
	}
	
	public static ArrayList<String> getPlanesId(Connection con, String codigoId) throws SQLException{
		ArrayList<String> lista 	= new ArrayList<String>();
		ResultSet rs 				= null;
		PreparedStatement ps 		= null;
		
		try{
			
			ps = con.prepareStatement("SELECT DISTINCT(PLAN_ID) AS PLAN_ID FROM ALUM_PLAN WHERE CODIGO_ID = ?");
			ps.setString(1, codigoId);
			
			rs = ps.executeQuery();
			while(rs.next()){
				lista.add(rs.getString("PLAN_ID"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.reporte.ReporteAlumno|getPlanesId|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return lista;
	}
	
	public static ArrayList<String> getNivelesAcademicosSistema(Connection con, String codigoId) throws SQLException {
		ArrayList<String> lista 	= new ArrayList<String>();
		ResultSet rs 				= null;
		PreparedStatement ps 		= null;
		
		try{
			
			ps = con.prepareStatement("SELECT NIVEL_ACADEMICO_SISTEMA FROM ciclo WHERE ciclo_id IN (SELECT DISTINCT(SUBSTRING(ciclo_grupo_id FOR 8)) AS ciclo FROM KRDX_CURSO_ACT WHERE codigo_id = ?)");
			ps.setString(1, codigoId);
			
			rs = ps.executeQuery();
			while(rs.next()){
				if(rs.getString("NIVEL_ACADEMICO_SISTEMA").equals("-1")){
					lista.add(rs.getString("NIVEL_ACADEMICO_SISTEMA"));
				}
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.reporte.ReporteAlumno|getNivelesAcademicosSistema|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return lista;
	}

	/**
	 * @return the cip
	 */
	public String getCip() {
		return cip;
	}

	/**
	 * @param cip the cip to set
	 */
	public void setCip(String cip) {
		this.cip = cip;
	}
}
