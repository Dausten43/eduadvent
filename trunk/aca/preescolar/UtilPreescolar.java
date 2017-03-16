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
							//System.out.println(pst);
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
							//System.out.println(pst);
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
					+ "actividad, observacion, ciclo_id, promedio_id)    VALUES (?, ?, ?, ?, "
					+ "?, ?, ?, ?);");
			pst.setString(1, cgkt.getCiclo_gpo_id());
			pst.setString(2, cgkt.getCurso_id());
			pst.setLong(3, cgkt.getEvaluacion_id());
			pst.setLong(4, cgkt.getActividad_id());
			pst.setString(5, cgkt.getActividad());
			pst.setString(6, cgkt.getObservacion());
			pst.setString(7, cgkt.getCiclo_id());
			pst.setLong(8, cgkt.getPromedio_id());
			pst.executeUpdate();
			
			pst.close();
			
		}catch(SQLException sqle){
			System.out.println("Error en addTareaKinder : " + sqle);
		}
	}
	
	public void  desactivarActividad(Integer id_kinder_tarea){
		try{
			PreparedStatement pst = con.prepareStatement("update ciclo_grupo_kinder_tareas set status=0 where id_kinder_tarea=?");
			pst.setInt(1, id_kinder_tarea);
			pst.executeUpdate();
			pst.close();
		}catch(SQLException sqle){
			System.err.println("error al eliminar tarea " + sqle);
		}
	}
	
	public Map<String,Integer> getNumeroTareas(String cicloGrupoId, String cursoId, String cicloId){
		Map<String,Integer> salida = new HashMap();
		
		try{
			PreparedStatement pst = con.prepareStatement("select promedio_id, evaluacion_id, actividad_id, count(id_kinder_tarea) as contador "
					+ "from ciclo_grupo_kinder_tareas "
					+ "where ciclo_gpo_id=? and curso_id=? and ciclo_id=? and status=1 "
					+ "group by promedio_id, evaluacion_id, actividad_id ");
			pst.setString(1, cicloGrupoId);
			pst.setString(2, cursoId);
			pst.setString(3, cicloId);
			
			ResultSet rs = pst.executeQuery();
			while(rs.next()){
				salida.put(rs.getString("promedio_id")+"-"+rs.getString("evaluacion_id")+"-"+rs.getString("actividad_id"), rs.getInt("contador"));
			}
			rs.close();
			pst.close();
		}catch(SQLException sqle){
			
		}
		
		return salida;
	}
	
	public List<CicloGrupoKinderTareas> getTareas(String cicloGrupoId, String cursoId, int evaluacionId, int actividadId, String cicloId, int status, int promedio_id, int actividad_id){
		List<CicloGrupoKinderTareas> salida = new ArrayList();
		String sql = "select * from ciclo_grupo_kinder_tareas where id_kinder_tarea is not null ";
		
		if(!cicloGrupoId.equals("")){
			sql += " and ciclo_gpo_id='"+cicloGrupoId+"' ";
		}
		
		if(!cursoId.equals("")){
			sql += " and curso_id='"+cursoId+"' ";
		}
		
		if(!cicloId.equals("")){
			sql += " and ciclo_id='"+cicloId+"' ";
		}
		
		if(evaluacionId!=0){
			sql += " and evaluacion_id="+evaluacionId+"";
		}
		
		if(status!=-1){
			sql += " and status="+status+"";
		}
		
		if(promedio_id!=0){
			sql += " and promedio_id="+promedio_id+"";
		}
		
		if(actividad_id!=0){
			sql += " and actividad_id="+actividad_id+"";
		}
		
		//System.out.println(sql);
		try{
			PreparedStatement pst = con.prepareStatement(sql);
			ResultSet rs = pst.executeQuery();
			while(rs.next()){
				
				CicloGrupoKinderTareas kt = new CicloGrupoKinderTareas(
						rs.getLong("id_kinder_tarea"),
						rs.getString("ciclo_gpo_id"),
						rs.getString("curso_id"),
						rs.getLong("evaluacion_id"),
						rs.getLong("actividad_id"),
						rs.getString("actividad"),
						rs.getString("observacion"),
						rs.getString("ciclo_id"),
						rs.getInt("status"),
						rs.getLong("promedio_id")
						);
				salida.add(kt);
			}
			rs.close();
			pst.close();
		}catch(SQLException sqle ){
			System.out.println("Error en getTareas " + sqle);
		}
		return salida;
	}
	
	public List<CicloActividadEvaluacionPromedio> getCAEP(String ciclo_id, String curso_id, String ciclo_grupo_id){
		List<CicloActividadEvaluacionPromedio> salida = new ArrayList<CicloActividadEvaluacionPromedio>();
		try{
			PreparedStatement pst = con.prepareStatement("SELECT cga.ciclo_grupo_id, cga.curso_id,  "
					+ "cge.promedio_id,  cp.nombre,  cga.evaluacion_id,  cge.evaluacion_nombre,  "
					+ "cga.actividad_id,  cga.actividad_nombre,         cga.fecha, cga.valor, "
					+ "cga.tipoact_id, cga.etiqueta_id, cga.mostrar   "
					+ "FROM ciclo_grupo_actividad cga    "
					+ "join ciclo_grupo_eval cge on cge.evaluacion_id=cga.evaluacion_id and cge.curso_id=cga.curso_id and cge.ciclo_grupo_id=cga.ciclo_grupo_id   "
					+ "join ciclo_promedio cp on cp.promedio_id=cge.promedio_id and cp.ciclo_id=?   "
					+ "where cga.ciclo_grupo_id =? AND cga.curso_id=?   "
					+ "order by cga.evaluacion_id,actividad_id");
			pst.setString(1, ciclo_id);
			pst.setString(2, ciclo_grupo_id);
			pst.setString(3, curso_id);
			
			//System.out.println(pst);
			ResultSet rs = pst.executeQuery();
			while(rs.next()){
				CicloActividadEvaluacionPromedio cgep = new CicloActividadEvaluacionPromedio(
						ciclo_grupo_id,
						curso_id,
						rs.getInt("promedio_id"),
						rs.getString("nombre"),
						rs.getInt("evaluacion_id"),
						rs.getString("evaluacion_nombre"),
						rs.getInt("actividad_id"),
						rs.getString("actividad_nombre")
						);
				salida.add(cgep);
			}
			rs.close();
			pst.close();
			
		}catch(SQLException sqle){
			System.err.println("error en getCAEP  " + sqle);
		}
		
		
		return salida;
		
	}
	
	public Map<Integer, Map<Integer,List<Integer>>> getEstructura(String ciclo_id, String curso_id, String ciclo_grupo_id){
		
		List<CicloActividadEvaluacionPromedio> lsDatos = new ArrayList();
		
		lsDatos.addAll(getCAEP(ciclo_id, curso_id, ciclo_grupo_id));
		
		//System.out.println("entro a la cosa 2  " + lsDatos.size());
		
		
		
		
		Integer p = 0;
		Integer e = 0;
	
		Map<Integer, Map<Integer,List<Integer>>>mPE = new LinkedHashMap();
		for(CicloActividadEvaluacionPromedio c : lsDatos){
			p=c.getPromedioId();
			Map<Integer, List<Integer>>mEA = new LinkedHashMap();
			for(CicloActividadEvaluacionPromedio cc : lsDatos){
				if(cc.getPromedioId().equals(p)){
					e=cc.getEvaluacionId();
					List<Integer> lsAc = new ArrayList();
					for(CicloActividadEvaluacionPromedio ccc : lsDatos){
						if(ccc.getEvaluacionId().equals(e)){
							lsAc.add(ccc.getActividadId());
						}
					}
					mEA.put(e, lsAc);
				}
			}
			mPE.put(p, mEA);
		}
		//System.out.println("mPE size " + mPE.size());
		return mPE;
		
	}

	public static void main(String[] a){
		UtilPreescolar up = new UtilPreescolar();
		//System.out.println("entro a la cosa ");
		Map<Integer,Map<Integer,List<Integer>>> mPE = new LinkedHashMap<Integer, Map<Integer,List<Integer>>>();
		
		mPE.putAll(up.getEstructura("H981717A", "H98-03HABI01", "H981717A001"));
		
		for(Integer p : mPE.keySet()){
			System.out.println("p " + p);
			//System.out.println("size p " + mPE.get(p).size());
			for(Integer e : mPE.get(p).keySet()){
				//System.out.println("  e " + e);
				for(Integer ac : mPE.get(p).get(e)){
					System.out.println("     a "+ac);
				}
			}
		}
		
		up.close();
	}
	
}
