package aca.kinder;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class UtilEvaluacion {

	private Connection con;

	public UtilEvaluacion() {

	}

	public UtilEvaluacion(Connection con) {
		this.con = con;
	}

	public Map<Long, Evaluacion> getMapEvaluaciones(Long id, String ciclo_gpo_id, Long actividad_id, Integer evaluacion,
			String maestro_id, String alumno_id, String condicion_libre) {
		Map<Long, Evaluacion> salida = new HashMap();
		try {
			String sql = "select * from kinder_evaluacion where id is not null ";

			if (!id.equals(0L)) {
				sql += " and id=" + id + " ";
			}

			if (!ciclo_gpo_id.equals("")) {
				sql += " and ciclo_gpo_id='" + ciclo_gpo_id + "' ";
			}

			if (!actividad_id.equals(0L)) {
				sql += " and actividad_id=" + actividad_id;
			}

			if (!evaluacion.equals(0)) {
				sql += " and evaluacion=" + evaluacion;
			}

			if (!maestro_id.equals("")) {
				sql += " and maestro_id='" + maestro_id + "' ";
			}

			if (!alumno_id.equals("")) {
				sql += " and alumno_id='" + alumno_id + "' ";
			}

			if (!condicion_libre.equals("")) {
				sql += condicion_libre;
			}

			System.out.println(sql);
			PreparedStatement pst = con.prepareStatement(sql);
			ResultSet rs = pst.executeQuery();
			while (rs.next()) {
				Evaluacion e = new Evaluacion();
				e.setId(rs.getLong("id"));
				e.setActividad_id(rs.getLong("actividad_id"));
				e.setAlumno_id(rs.getString("alumno_id"));
				e.setCalificacion(rs.getInt("calificacion"));
				e.setCiclo_gpo_id(rs.getString("ciclo_gpo_id"));
				e.setEvaluacion_id(rs.getInt("evaluacion_id"));
				e.setFecha_evaluado(rs.getString("fecha_evaluado"));
				e.setMaestro_id(rs.getString("maestro_id"));
				if(e.getAlumno_id().startsWith("H")){
					e.setCalificacionTxt(calificacionTxt(rs.getInt("calificacion")));
				}
				if(e.getAlumno_id().startsWith("S")){
					e.setCalificacionTxt(calificacionTxtSalvador(rs.getInt("calificacion")));
				}

				salida.put(e.getId(), e);

			}
			rs.close();
			pst.close();

		} catch (SQLException sqle) {
			System.err.println("Error en getMapEvaluaciones " + sqle);
		}

		return salida;

	}

	public List<Evaluacion> getLsEvaluaciones(Long id, String ciclo_gpo_id, Long actividad_id, Integer evaluacion,
			String maestro_id, String alumno_id, String condicion_libre) {
		List<Evaluacion> salida = new ArrayList();
		Map<Long, Evaluacion> consulta = new HashMap<Long, Evaluacion>();
		consulta.putAll(
				getMapEvaluaciones(id, ciclo_gpo_id, actividad_id, evaluacion, maestro_id, alumno_id, condicion_libre));

		List<Long> lsIdEvaluaciones = new ArrayList<Long>(consulta.keySet());
		Collections.sort(lsIdEvaluaciones);
		for (Long idevaluacion : lsIdEvaluaciones) {
			salida.add(consulta.get(idevaluacion));
		}
		return salida;
	}

	public void addEvaluacion(Evaluacion e) {
		try {
			PreparedStatement pst = con.prepareStatement("INSERT INTO kinder_evaluacion("
					+ "ciclo_gpo_id, actividad_id, evaluacion_id, maestro_id, alumno_id, calificacion) "
					+ "VALUES (?, ?, ?, ?, ?, ?)");
			pst.setString(1, e.getCiclo_gpo_id());
			pst.setLong(2, e.getActividad_id());
			pst.setInt(3, e.getEvaluacion_id());
			pst.setString(4, e.getMaestro_id());
			pst.setString(5, e.getAlumno_id());
			pst.setInt(6, e.getCalificacion());

			System.out.println(pst);
			pst.executeUpdate();
			pst.close();
		} catch (SQLException sqle) {
			System.out.println("Error en addEvaluacion" + sqle);
		}
	}

	public void removeEvaluacion(Evaluacion e) {
		try {
			String sql = "delete from kinder_evaluacion where id is not null";

			if (!e.getCiclo_gpo_id().equals("")) {
				sql += " and ciclo_gpo_id='" + e.getCiclo_gpo_id() + "' ";
			}
			if (!e.getActividad_id().equals(0L)) {
				sql += " and actividad_id=" + e.getActividad_id();
			}
			if (!e.getEvaluacion_id().equals(0)) {
				sql += " and evaluacion_id=" + e.getEvaluacion_id();
			}
			if (!e.getMaestro_id().equals("")) {
				sql += " and maestro_id='" + e.getMaestro_id() + "' ";
			}
			if (!e.getAlumno_id().equals("")) {
				sql += " and alumno_id='" + e.getAlumno_id() + "' ";
			}

			PreparedStatement pst = con.prepareStatement(sql);
			System.out.println(pst);
			pst.executeUpdate();
			pst.close();

		} catch (SQLException sqle) {
			System.out.println("Error en removeEvaluacion" + sqle);
		}
	}

	public String calificacionTxt(Integer calificacion) {
        String salida = "";
        if (calificacion == 1) {
            salida = "LVL";
        }

        if (calificacion == 2) {
            salida = "LEL";
        }

        if (calificacion == 3) {
            salida = "LHL";
        }
        return salida;
    }
	
	public String calificacionTxtSalvador(Integer calificacion) {
        String salida = "";
        if (calificacion == 1) {
            salida = "T";
        }

        if (calificacion == 2) {
            salida = "P";
        }

        if (calificacion == 3) {
            salida = "S";
        }
        return salida;
    }

    public Map<Long, String> getPromedioPorCriterio(String ciclo_gpo_id,
            Integer trimestre, String alumno_id) {
        Map<Long, String> salida = new HashMap<Long, String>();
        try {
            PreparedStatement pst = con
                    .prepareStatement("select kac.criterio_id, round(sum(ev.calificacion)/count(ev.id)) promedio from kinder_evaluacion ev  "
                            + "join kinder_actividades kac on kac.id=ev.actividad_id and estado=1 "
                            + "where ev.ciclo_gpo_id='" + ciclo_gpo_id + "' and ev.evaluacion_id="
                            + trimestre + " and ev.alumno_id='" + alumno_id + "' group by kac.criterio_id");
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
            	String calTxT = alumno_id.startsWith("H") ? calificacionTxt(rs.getInt("promedio")) : alumno_id.startsWith("S") ? calificacionTxtSalvador(rs.getInt("promedio")) : calificacionTxt(rs.getInt("promedio")); 
                salida.put(rs.getLong("criterio_id"), calTxT);
                System.out.println(trimestre + " " + alumno_id + " " + rs.getLong("criterio_id") + " " + calTxT);
            }
            rs.close();
            pst.close();
        } catch (SQLException sqle) {
            System.out.println("Error en getPromedioPorCriterio" + sqle);
        }
        return salida;
    }

    public Map<Integer, Map<Long, String>> mapPromedio(String ciclo_gpo_id, String alumno_id) {
        Map<Integer, Map<Long, String>> salida = new LinkedHashMap();

        List<Integer> lsTrimestres = new ArrayList<Integer>();
        lsTrimestres.add(1);
        lsTrimestres.add(2);
        lsTrimestres.add(3);

        for (Integer t : lsTrimestres) {

            Map<Long, String> mapPromediosCriterios = new HashMap<Long, String>();

            mapPromediosCriterios.putAll(getPromedioPorCriterio(ciclo_gpo_id, t, alumno_id));

            salida.put(t, mapPromediosCriterios);
        }

        return salida;

    }

}
