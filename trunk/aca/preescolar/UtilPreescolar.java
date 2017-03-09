package aca.preescolar;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import aca.ciclo.CicloBloqueActividad;
import aca.ciclo.CicloBloqueActividadLista;
import aca.ciclo.CicloGrupo;
import aca.conecta.Conectar;
import oracle.sql.BLOB;

public class UtilPreescolar {

	private Connection con;

	public UtilPreescolar() {
		con = new Conectar().conEliasPostgres();
	}

	public void close() {
		try {
			con.close();
		} catch (SQLException sqle) {

		}
	}

	public List<Integer> getListaBloques(String ciclo_id) {
		List<Integer> salida = new ArrayList();

		try {
			PreparedStatement pst = con
					.prepareStatement("select pr.ciclo_id,pr.promedio_id, pr.bloque_id, cp.nombre, bloque_nombre "
							+ "from ciclo_bloque pr "
							+ "join ciclo_promedio cp on cp.promedio_id=pr.promedio_id and cp.ciclo_id=pr.ciclo_id "
							+ "where pr.ciclo_id=? " + "ORDER BY pr.bloque_id , pr.promedio_id");
			pst.setString(1, ciclo_id);
			ResultSet rs = pst.executeQuery();
			while (rs.next()) {
				salida.add(rs.getInt("bloque_id"));
			}
			rs.close();
			pst.close();

		} catch (SQLException sqle) {
			System.err.println("ERROR EN getListaBloques  " + sqle);
		}
		return salida;
	}
	
	public List<Integer> getListaBloques(String ciclo_id, Integer promedio_id) {
		List<Integer> salida = new ArrayList();

		try {
			PreparedStatement pst = con
					.prepareStatement("select pr.ciclo_id,pr.promedio_id, pr.bloque_id, cp.nombre, bloque_nombre "
							+ "from ciclo_bloque pr "
							+ "join ciclo_promedio cp on cp.promedio_id=pr.promedio_id and cp.ciclo_id=pr.ciclo_id "
							+ "where pr.ciclo_id=? and pr.promedio_id=? " + "ORDER BY pr.bloque_id , pr.promedio_id");
			
			
			pst.setString(1, ciclo_id);
			pst.setInt(2, promedio_id);
			
			ResultSet rs = pst.executeQuery();
			while (rs.next()) {
				salida.add(rs.getInt("bloque_id"));
			}
			rs.close();
			pst.close();

		} catch (SQLException sqle) {
			System.err.println("ERROR EN getListaBloques  " + sqle);
		}
		return salida;
	}

	public List<CicloBloqueActividad> getCicloBloqueActividad(String ciclo_id) throws SQLException {
		CicloBloqueActividadLista cba = new CicloBloqueActividadLista();
		List<CicloBloqueActividad> lscba = new ArrayList();
		lscba.addAll(cba.getListAll(con, ciclo_id, "order by bloque_id, actividad_id"));
		return lscba;
	}

	public Map<Integer, String> actividades() {
		Map<Integer, String> salida = new LinkedHashMap();

		salida.put(1, "TRIMESTRE I");
		salida.put(2, "TRIMESTRE II");
		salida.put(3, "TRIMESTRE III");

		return salida;
	}

	public void generaTrimestres(String ciclo_id) throws SQLException {
		List<Integer> lsBloques = new ArrayList<Integer>();
		List<CicloBloqueActividad> lsCBA = new ArrayList<CicloBloqueActividad>();

		lsBloques.addAll(getListaBloques(ciclo_id));
		lsCBA.addAll(getCicloBloqueActividad(ciclo_id));

		Map<Integer, List<Integer>> mapActividadBloque = new HashMap<Integer, List<Integer>>();

		for (Integer bloque : lsBloques) {

			List<Integer> lsActividad = new ArrayList<Integer>();
			List<String> lsActividadBloque = new ArrayList<String>();

			for (CicloBloqueActividad cba : lsCBA) {
				if (cba.getBloqueId().equals(bloque.toString()))
					lsActividad.add(new Integer(cba.getActividadId()));
			}
			mapActividadBloque.put(bloque, lsActividad);

		}

		try {
			PreparedStatement pst = con.prepareStatement("INSERT INTO ciclo_bloque_actividad("
					+ "ciclo_id, bloque_id, actividad_id, actividad_nombre, fecha, valor, "
					+ "tipoact_id, etiqueta_id) " + "VALUES (?, ?, ?, ?, current_timestamp, 33.33, 57, 0)");
			for (Integer bloque : lsBloques) {
				{
					if (mapActividadBloque.containsKey(bloque) && mapActividadBloque.get(bloque).isEmpty()) {

						
						for (Integer actTmpl : actividades().keySet()) {
							pst.setString(1, ciclo_id);
							pst.setInt(2, bloque);
							pst.setInt(3, actTmpl);
							pst.setString(4, actividades().get(actTmpl));
							System.out.println(pst);
							int salida = pst.executeUpdate();
						}

					} else {
						System.err.println("EL BLOQUE " + bloque + " YA CONTIENE DATOS ");
					}
				}
			}
			pst.close();
		} catch (SQLException sqle) {
			System.err.println("error al guardar ciclo_bloque_actividad en generaTrimestres(String) " + sqle);
		}
	}
	
	public void generaTrimestres(String ciclo_id, Integer promedio_id) throws SQLException {
		List<Integer> lsBloques = new ArrayList<Integer>();
		List<CicloBloqueActividad> lsCBA = new ArrayList<CicloBloqueActividad>();

		lsBloques.addAll(getListaBloques(ciclo_id,promedio_id));
		lsCBA.addAll(getCicloBloqueActividad(ciclo_id));

		Map<Integer, List<Integer>> mapActividadBloque = new HashMap<Integer, List<Integer>>();

		for (Integer bloque : lsBloques) {

			List<Integer> lsActividad = new ArrayList<Integer>();
			List<String> lsActividadBloque = new ArrayList<String>();

			for (CicloBloqueActividad cba : lsCBA) {
				if (cba.getBloqueId().equals(bloque.toString()))
					lsActividad.add(new Integer(cba.getActividadId()));
			}
			mapActividadBloque.put(bloque, lsActividad);

		}

		try {
			PreparedStatement pst = con.prepareStatement("INSERT INTO ciclo_bloque_actividad("
					+ "ciclo_id, bloque_id, actividad_id, actividad_nombre, fecha, valor, "
					+ "tipoact_id, etiqueta_id) " + "VALUES (?, ?, ?, ?, current_timestamp, 33.33, 57, 0)");
			for (Integer bloque : lsBloques) {
				{
					if (mapActividadBloque.containsKey(bloque) && mapActividadBloque.get(bloque).isEmpty()) {

						
						for (Integer actTmpl : actividades().keySet()) {
							pst.setString(1, ciclo_id);
							pst.setInt(2, bloque);
							pst.setInt(3, actTmpl);
							pst.setString(4, actividades().get(actTmpl));
							System.out.println(pst);
							int salida = pst.executeUpdate();
						}

					} else {
						System.err.println("EL BLOQUE " + bloque + " YA CONTIENE DATOS ");
					}
				}
			}
			pst.close();
		} catch (SQLException sqle) {
			System.err.println("error al guardar ciclo_bloque_actividad en generaTrimestres(String) " + sqle);
		}
	}
	
	public void addTareaKinder(CicloGrupoKinderTareas cgkt){
		try{
			PreparedStatement pst = con.prepareStatement("INSERT INTO ciclo_grupo_kinder_tareas("
					+ "ciclo_gpo_id, curso_id, evaluacion_id, actividad_id, "
					+ "actividad, observacion)    VALUES (?, ?, ?, ?, "
					+ "?, ?);");
			pst.setString(1, cgkt.getCiclo_gpo_id());
			pst.setString(2, cgkt.getCurso_id());
			pst.setLong(3, cgkt.getEvaluacion_id());
			pst.setLong(4, cgkt.getActividad_id());
			pst.setString(5, cgkt.getActividad());
			pst.setString(6, cgkt.getObservacion());
			
			pst.executeUpdate();
			
			pst.close();
			
		}catch(SQLException sqle){
			System.out.println("Error en addTareaKinder : " + sqle);
		}
	}
	
	public List<CicloGrupoKinderTareas> getTareas(String cicloGrupoId, String cursoId, int evaluacionId, int actividadId){
		List<CicloGrupoKinderTareas> salida = new ArrayList();
		String sql = "select * from ciclo_grupo_kinder_tareas where id_kinder_tarea is not null ";
		if(!cicloGrupoId.equals("")){
			sql += " and ciclo_gpo_id='"+cicloGrupoId+"' ";
		}
		if(!cicloGrupoId.equals("")){
			sql += " and curso_id='"+cursoId+"' ";
		}
		
		if(evaluacionId!=0){
			sql += " and evaluacion_id="+evaluacionId+"";
		}
		if(actividadId!=0){
			sql += " and evaluacion_id="+actividadId+"";
		}
		
		try{
			PreparedStatement pst = con.prepareStatement(sql);
			ResultSet rs = pst.executeQuery();
			while(rs.next()){
				
				CicloGrupoKinderTareas kt = new CicloGrupoKinderTareas(
						rs.getLong("id_kinder_tarea"),
						rs.getString("ciclo_gpo_id"),
						rs.getString("curso_id "),
						rs.getLong("evaluacion_id"),
						rs.getLong("actividad_id"),
						rs.getString("actividad"),
						rs.getString("observacion")
						);
				
			}
			rs.close();
			pst.close();
		}catch(SQLException sqle ){
			System.out.println("Error en getTareas " + sqle);
		}
		return salida;
	}

}
