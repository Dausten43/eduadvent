package aca.ciclo;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import aca.kardex.KrdxCursoAct;
import aca.kardex.KrdxCursoActLista;
import aca.util.Fecha;
import aca.vista.AlumnoProm;
import aca.vista.AlumnoPromLista;

public class UtilCiclo {
	
	private Connection con;
	private String nivel_eval;
	
	/**
	 * @return the nivel_eval
	 */
	public String getNivel_eval() {
		return nivel_eval;
	}

	/**
	 * @param nivel_eval the nivel_eval to set
	 */
	public void setNivel_eval(String nivel_eval) {
		this.nivel_eval = nivel_eval;
	}

	public UtilCiclo(){}
	
	public UtilCiclo(Connection con)throws SQLException{
		this.con=con;
	}
	
	public Map<String, String> getDatos(String escuela, String ciclo_id, String ciclo_gpo_id, String curso_id){
		Map<String,String> salida = new LinkedHashMap();

		String comando = "select q.ciclo_id, q.ciclo_nombre, q.escala, q.ciclo_escolar, q.nivel_eval, "
				+ "q.nivel_academico_sistema, q.ciclo_grupo_id, q.grupo_nombre, "
				+ "q.nivel_id,q.nivel_nombre, q.grado, q.grupo, q.curso_id, "
				+ "q.curso_nombre, q.curso_base from ( select  ci.ciclo_id, ci.ciclo_nombre, "
				+ "ci.escala, ci.ciclo_escolar, ci.nivel_eval, ci.nivel_academico_sistema , "
				+ "cg.ciclo_grupo_id, cg.grupo_nombre, cg.nivel_id,ne.nivel_nombre, cg.grado, "
				+ "cg.grupo,  cgc.curso_id, pc.curso_nombre , pc.curso_base "
				+ "from ciclo_grupo_curso cgc "
				+ "join plan_curso pc on pc.curso_id = cgc.curso_id "
				+ "join ciclo_grupo cg on cg.ciclo_grupo_id = cgc.ciclo_grupo_id "
				+ "join cat_nivel_escuela ne on ne.escuela_id='"+escuela+"' and ne.nivel_id=cg.nivel_id  "
				+ "join ciclo ci on ci.ciclo_id = cg.ciclo_id and ci.ciclo_id like '"+escuela+"%'  "
				+ "order by ci.ciclo_id, cg.grado,cg.grupo, cgc.curso_id ) as q where ciclo_id is not null ";
		
		if(!ciclo_id.equals("")){
			comando += " and ciclo_id='"+ciclo_id+"' ";
		}
		
		if(!ciclo_gpo_id.equals("")){
			comando += " and ciclo_grupo_id='"+ciclo_gpo_id+"' ";
		}
		
		 
		try{
			System.out.println("BUSQUEDA +  " + comando);
			PreparedStatement pst = con.prepareStatement(comando);
			ResultSet rs = pst.executeQuery();
			while(rs.next()){
				if(!ciclo_id.equals("")){
					if(!salida.containsKey(rs.getString("ciclo_grupo_id"))){
						salida.put(rs.getString("ciclo_grupo_id"),rs.getString("nivel_nombre") + " " + rs.getString("grupo_nombre") + " " + rs.getString("grupo"));
					}
				}
				
				if(!ciclo_gpo_id.equals("")){
					if(!salida.containsKey(rs.getString("ciclo_grupo_id"))){
						salida.put(rs.getString("curso_id"), rs.getString("curso_nombre")  + "\t" + rs.getString("curso_base"));
					}
				}
				nivel_eval=rs.getString("nivel_eval");
			}
			rs.close();
			pst.close();
			
		}catch(SQLException sqle){
			System.out.println("Error en getDatos " + sqle);
		}
		
		return salida;
	}
	
	public Map<String, String> periodos(String ciclo_id, String nivel_eval){
		Map<String, String> salida = new LinkedHashMap<String, String>();
			String comando = "";
			if(nivel_eval.equals("P")){
				comando = "select ciclo_id, promedio_id as id, nombre, corto as nombre, calculo, orden, decimales, "
						+ "valor, redondeo from ciclo_promedio where ciclo_id='"+ciclo_id+"' order by orden";
			}else if(nivel_eval.equals("E")){
				comando = "select ciclo_id, bloque_id as id, bloque_nombre as nombre, f_inicio, f_final, valor, orden, "
						+ "promedio_id, corto, decimales, redondeo, calculo from ciclo_bloque where ciclo_id='"+ciclo_id+"' order by orden";
			}
			try{
				PreparedStatement pst = con.prepareStatement(comando);
				ResultSet rs = pst.executeQuery();
				while(rs.next()){
					salida.put(rs.getString("id"), rs.getString("nombre"));
				}
				
				rs.close();
				pst.close();
			}catch(SQLException sqle){
				System.out.println("Error en periodos " + sqle);
			}
		return salida;
	}
	
	
	/**
	 * @param ciclo_id  opcional si tiene el ciclo_grupo_id
	 * @param ciclo_gpo_id opcional si tiene el ciclo_id;
	 * @param materia opcional para dividir por materias
	 * @param evaluacion_id requerido siempre
	 * @param nivel refiere al nivel de evaluacion P promedia E evalua requerido siempre 
	 * @return
	 */
	public Map<String, RepPromedio> getPromedios(String ciclo_id, String ciclo_gpo_id, String materia, String evaluacion_id, String nivel,String orden){
		String comando  ="";
		if(nivel.equals("E")){
			System.out.println("fue evalua");
			comando = "select ciclo_grupo_id, grupo_nombre, grado, grupo,codigo_id, alumno, "
					+ "  sum(suma) as suma, count(periodo), sum(promedio)/count(periodo) as promedio, '" + evaluacion_id + "' as periodo  ";
			
			if(!materia.equals("")){
				comando += ", curso_id , materia ";
			}else{
				comando+=",0 as materias ";
			}
			comando	+= "from (select ke.ciclo_grupo_id "
				+ ", cg.grupo_nombre , cg.grado, cg.grupo "
				+ ", ke.codigo_id "
				+ ", alum_apellido(ke.codigo_id) as alumno "
				+ ", ke.evaluacion_id  as periodo";
		if(!materia.equals("")){
				comando += ", curso_id , curso_nombre(curso_id) as materia";
		}
				comando += ", sum(trunc(ke.nota,1)) suma "
				+ ", count(ke.curso_id) materias "
				+ ", sum(trunc(ke.nota,1))/(select count(curso_id) from krdx_curso_act "
				+ "where ciclo_grupo_id=ke.ciclo_grupo_id and codigo_id=ke.codigo_id ";
				if(!materia.equals("")){
							comando += " and curso_id =ke.curso_id ";
				}		
						comando+= "and curso_id in (select curso_id from plan_curso where	curso_base='-'  and boleta='S')) promedio   "
				+ "from krdx_alum_eval ke  "
				+ "join ciclo_grupo cg on cg.	ciclo_grupo_id=ke.ciclo_grupo_id "
				+ "where   ";
		if(ciclo_gpo_id.equals(""))	{
				comando+= "ke.ciclo_grupo_id like '"+ciclo_id+"%'    ";
		}else{
			comando+= "ke.ciclo_grupo_id = '"+ciclo_gpo_id+"'    ";
		}
				comando+= "and ke.evaluacion_id in ("+evaluacion_id+")   "
				+ "and ke.curso_id in (select curso_id "
				+ "from plan_curso where	curso_base='-'  and boleta='S')   and ke.codigo_id || ke.curso_id in (select codigo_id || curso_id from krdx_curso_act where ciclo_grupo_id=ke.ciclo_grupo_id) "
//				+ "and ke.curso_id in (select curso_id "
//				+ "from ciclo_grupo_eval "
//				+ "where ciclo_grupo_id=ke.ciclo_grupo_id and estado in('C') and evaluacion_id=ke.evaluacion_id )   "
				+ "group by   "
				+ "ke.ciclo_grupo_id  "
				+ ", grupo_nombre  , cg.grado, cg.grupo "
				+ ", ke.evaluacion_id  "
				+ ", ke.codigo_id  ";
			if(!materia.equals("")){		
				comando+= ", curso_id   ";
			}
			comando +=") as prom group by ciclo_grupo_id, grupo_nombre, grado, grupo, codigo_id, alumno  ";
			if(!materia.equals("")){		
				comando+= ", curso_id , materia  ";
			}
			if(orden.equals("")){
				comando+= "order by  promedio desc";
			}else{
				comando+= orden;
			}
				
			}
		
			if(nivel.equals("P")){
				System.out.println("fue promedia");
				comando = "select ciclo_grupo_id, grupo_nombre, grado, grupo,codigo_id, alumno, "
						+ "  sum(suma) as suma, count(periodo), sum(promedio)/count(periodo) as promedio, '" + evaluacion_id + "' as periodo  ";
				
				if(!materia.equals("")){
					comando += ", curso_id , materia ";
				}else{
					comando+=",0 as materias ";
				}
				comando	+= "from (select ke.ciclo_grupo_id "
						+ ", cg.grupo_nombre , cg.grado, cg.grupo  "
						+ ", ke.codigo_id "
						+ ", alum_apellido(ke.codigo_id) as alumno "
						+ ", ke.promedio_id  as periodo";
				if(!materia.equals("")){
						comando += ", curso_id , curso_nombre(curso_id) as materia";
				}
						comando += ", sum(trunc(ke.nota,1)) suma "
						+ ", count(ke.curso_id) materias "
						+ ", sum(trunc(ke.nota,1))/(select count(curso_id) from krdx_curso_act "
						+ "where ciclo_grupo_id=ke.ciclo_grupo_id and codigo_id=ke.codigo_id ";
				if(!materia.equals("")){
							comando += " and curso_id =ke.curso_id ";
				}		
						comando+= "and curso_id in (select curso_id from plan_curso where	curso_base='-'  and boleta='S')) promedio   "
						+ "from krdx_alum_prom ke  "
						+ "join ciclo_grupo cg on cg.ciclo_grupo_id=ke.ciclo_grupo_id "
						+ "where   ";
				if(ciclo_gpo_id.equals(""))	{
						comando+= "ke.ciclo_grupo_id like '"+ciclo_id+"%'    ";
				}else{
					comando+= "ke.ciclo_grupo_id = '"+ciclo_gpo_id+"'    ";
				}
						comando+= "and ke.promedio_id in ("+evaluacion_id+")   "
						+ "and ke.curso_id in (select curso_id "
						+ "from plan_curso where	curso_base='-'  and boleta='S') and ke.codigo_id || ke.curso_id in (select codigo_id || curso_id from krdx_curso_act where ciclo_grupo_id=ke.ciclo_grupo_id) "
//						+ "and ke.curso_id in (select curso_id "
//						+ "from ciclo_grupo_eval "
//						+ "where ciclo_grupo_id=ke.ciclo_grupo_id and estado in('C') and evaluacion_id=ke.promedio_id )   "
//						+ "and curso_id ||'-'||promedio_id in (select curso_id ||'-'||promedio_id "
//						+ "from (select curso_id, promedio_id, sum(case when estado='A' then 1 else 0 end) activos "
//						+ "from ciclo_grupo_eval where ciclo_grupo_id='"+ciclo_gpo_id+"' "
//								+ "group by curso_id, promedio_id) cge where cge.activos=0 )"
						+ "group by   "
						+ "ke.ciclo_grupo_id  "
						+ ", grupo_nombre  , cg.grado, cg.grupo "
						+ ", ke.promedio_id  "
						+ ", ke.codigo_id  ";
					if(!materia.equals("")){		
						
						comando+= ", curso_id   ";
					}
					
					comando +=") as prom group by ciclo_grupo_id, grupo_nombre, grado, grupo, codigo_id, alumno  ";
					if(!materia.equals("")){		
						comando+= ", curso_id , materia  ";
					}
					if(orden.equals("")){
						comando+= "order by  promedio desc";
					}else{
						comando+= orden;
					}
					
			}
			System.out.println(comando);	
			Map<String, RepPromedio> salida = new LinkedHashMap();	
			
		try{
			PreparedStatement pst = con.prepareStatement(comando);
			//System.out.println(pst);
			ResultSet rs = pst.executeQuery();
			
			while(rs.next()){
			
				RepPromedio r = new RepPromedio();
			r.setCiclo_gpo_id(rs.getString("ciclo_grupo_id"));
			r.setCiclo_nombre(rs.getString("grupo_nombre") + " " + rs.getString("grupo"));
			r.setCodigo_id(rs.getString("codigo_id"));
			r.setNombre_alumno(rs.getString("alumno"));
			if(!materia.equals("")){
				r.setCurso_id(rs.getString("curso_id"));
				r.setNombre_materia(rs.getString("materia"));
			}
			r.setEvaluacion_id("0");
			r.setNumMaterias(0);
			r.setPromedio(rs.getBigDecimal("promedio"));
			r.setSuma(rs.getBigDecimal("suma"));
			if(!materia.equals("")){
				salida.put(r.getCiclo_gpo_id() + "||"+r.getCodigo_id() + "||"+r.getCurso_id(), r);
			}else{
				salida.put(r.getCiclo_gpo_id() + "||"+r.getCodigo_id() , r);
			}
			}
			
		}catch(SQLException sqle){
			System.out.println("Error en get promedios " + sqle);
		}
		
		return salida;
	}
	
	public Map<String,Integer> getGruposAbiertos(String ciclo_id, String nivel_eval){
		Map<String,Integer> salida = new HashMap();
		
		String comando = "";
		if(nivel_eval.equals("P")){
			comando = "select ciclo_grupo_id , promedio_id as periodo, COUNT(ESTADO) as abiertas from ciclo_grupo_eval where  ciclo_grupo_id like '"+ ciclo_id +"%' AND ESTADO='C' GROUP BY CICLO_GRUPO_ID, promedio_id";
		}else if(nivel_eval.equals("E")){
			comando = "select ciclo_grupo_id , evaluacion_id as periodo, COUNT(ESTADO) as abiertas from ciclo_grupo_eval where  ciclo_grupo_id like '"+ ciclo_id +"%' AND ESTADO='C' GROUP BY CICLO_GRUPO_ID, evaluacion_id";
		}
		
		try{
			PreparedStatement pst = con.prepareStatement(comando);
			ResultSet rs = pst.executeQuery();
			while(rs.next()){
				salida.put(rs.getString("ciclo_grupo_id") + "\t"+ rs.getString("periodo"), rs.getInt("abiertas") );
			}
			rs.close();
			pst.close();
		}catch(SQLException sqle){
			System.out.println("Error en getGruposAbiertos " + sqle);
		}
		return salida;
		
	}
	
	public Map<String,Integer> getMateriasAbiertas(String ciclo_grupo_id, String nivel_eval){
		Map<String,Integer> salida = new HashMap();
		
		String comando = "";
		if(nivel_eval.equals("P")){
			comando = "select curso_id , promedio_id as periodo, COUNT(ESTADO) as abiertas from ciclo_grupo_eval where  ciclo_grupo_id = '"+ ciclo_grupo_id +"' AND ESTADO='C' GROUP BY CURSO_ID, promedio_id";
		}else if(nivel_eval.equals("E")){
			comando = "select curso_id , evaluacion_id as periodo, COUNT(ESTADO) as abiertas from ciclo_grupo_eval where  ciclo_grupo_id = '"+ ciclo_grupo_id +"' AND ESTADO='C' GROUP BY CURSO_ID, evaluacion_id";
		}
		
		try{
			PreparedStatement pst = con.prepareStatement(comando);
			ResultSet rs = pst.executeQuery();
			while(rs.next()){
				salida.put(rs.getString("curso_id") + "\t"+ rs.getString("periodo"), rs.getInt("abiertas") );
			}
			rs.close();
			pst.close();
		}catch(SQLException sqle){
			System.out.println("Error en getMateriasAbiertas " + sqle);
		}
		return salida;
		
	}
	
	public Map<String, String> getGruposAbiertasCerradas(String ciclo_id, String nivel_eval){
		Map<String, String> salida = new HashMap<String, String>();
		String comando = "";
		if(nivel_eval.equals("P")){
			comando = "select ciclo_grupo_id, promedio_id as periodo, "
					+ "case when estado='A' then count(estado) else 0 end as abiertas, "
					+ "case when estado='C' then count(estado) else 0 end as cerradas "
					+ "from ciclo_grupo_eval "
					+ "where ciclo_grupo_id like '"+ ciclo_id +"%' "
					+ "and curso_id in (select curso_id from plan_curso where curso_base='-'  and boleta='S') "
					+ "group by ciclo_grupo_id, estado, promedio_id order by ciclo_grupo_id, promedio_id";

		}else if(nivel_eval.equals("E")){
			comando = "select ciclo_grupo_id, evaluacion_id as periodo, "
					+ "case when estado='A' then count(estado) else 0 end as abiertas, "
					+ "case when estado='C' then count(estado) else 0 end as cerradas "
					+ "from ciclo_grupo_eval "
					+ "where ciclo_grupo_id like '"+ ciclo_id +"%' "
					+ "and curso_id in (select curso_id from plan_curso where curso_base='-'  and boleta='S') "
					+ "group by ciclo_grupo_id, estado, evaluacion_id order by ciclo_grupo_id, evaluacion_id";
		}
		
		try{
			PreparedStatement pst = con.prepareStatement(comando);
			ResultSet rs = pst.executeQuery();
			while(rs.next()){
				salida.put(rs.getString("ciclo_grupo_id") + "\t"+ rs.getString("periodo"), rs.getString("abiertas") + "," + rs.getString("cerradas"));
			}
			rs.close();
			pst.close();
		}catch(SQLException sqle){
			System.out.println("Error en getGruposAbiertasCerradas " + sqle);
		}
		
		
		return salida;
	}
	
	public Map<String, String> getMateriasAbiertasCerradas(String ciclo_grupo_id, String nivel_eval){
		Map<String, String> salida = new HashMap<String, String>();
		String comando = "";
		if(nivel_eval.equals("P")){
			comando = "select curso_id, promedio_id as periodo, "
					+ "case when estado='A' then count(estado) else 0 end as abiertas, "
					+ "case when estado='C' then count(estado) else 0 end as cerradas "
					+ "from ciclo_grupo_eval "
					+ "where ciclo_grupo_id = '"+ ciclo_grupo_id +"' "
					+ "and curso_id in (select curso_id from plan_curso where boleta='S') "
					+ "group by curso_id, estado, promedio_id order by curso_id, promedio_id";

		}else if(nivel_eval.equals("E")){
			comando = "select curso_id, evaluacion_id as periodo, "
					+ "case when estado='A' then count(estado) else 0 end as abiertas, "
					+ "case when estado='C' then count(estado) else 0 end as cerradas "
					+ "from ciclo_grupo_eval "
					+ "where ciclo_grupo_id = '"+ ciclo_grupo_id +"' "
					+ "and curso_id in (select curso_id from plan_curso where boleta='S') "
					+ "group by curso_id, estado, evaluacion_id order by curso_id, evaluacion_id";
		}
		
		try{
			System.out.println("materias abiertas cerradas " + comando);
			PreparedStatement pst = con.prepareStatement(comando);
			ResultSet rs = pst.executeQuery();
			while(rs.next()){
				salida.put(rs.getString("curso_id") + "\t"+ rs.getString("periodo"), rs.getString("abiertas") + "," + rs.getString("cerradas"));
			}
			rs.close();
			pst.close();
		}catch(SQLException sqle){
			System.out.println("Error en getMateriasAbiertasCerradas " + sqle);
		}
		
		
		return salida;
	}
	
	public int controlMateria(String ciclo_id, String ciclo_gpo_id, String periodo, String curso_id, String nivel_eval, String estado){
		
		int salida=0;
		
		String comando ="update ciclo_grupo_eval set estado='" + estado + "' where ciclo_grupo_id is not null ";

		
		if(!ciclo_gpo_id.equals("")){
			comando+=" and ciclo_grupo_id = '"+ ciclo_gpo_id +"'  and curso_id = '"+ curso_id + "'";
		}
		
		if(nivel_eval.equals("P")){
			comando += " and promedio_id="+periodo;
		}else if(nivel_eval.equals("E")){
			comando += " and evaluacion_id="+periodo;
		}
		if(!ciclo_gpo_id.equals("") && !curso_id.equals("") && !periodo.equals("") && !nivel_eval.equals("")){
			try{
				
				System.out.println("EJECUTANDO ACTUALIZACION PARA "+estado+" DE MATERIA EN CICLOGPOEVAL " + estado);
				PreparedStatement pst = con.prepareStatement(comando);
				
				salida = pst.executeUpdate();
				
				
			}catch(SQLException sqle){
				System.out.println("Error en getMateriasAbiertasCerradas " + sqle);
			}
		}
		return salida;
	}
	
	
	public Integer periodosCalificados(String nivel_eval, String ciclo_gpo_id){
		
		Integer salida=0;
		
		String comando = "select ";
		
		if(nivel_eval.equals("P")){
			comando+= " count(distinct(promedio_id)) periodos ";
		}else if(nivel_eval.equals("E")){
			comando+= " count(distinct(evaluacion_id)) periodos ";
		}
		
		comando+= " from ciclo_grupo_eval where ciclo_grupo_id= '" + ciclo_gpo_id +"' ";
		
		System.out.println(comando);
		
		try{
			PreparedStatement pst = con.prepareStatement(comando);
			ResultSet rs = pst.executeQuery();
			
			if(rs.next()){
				salida = rs.getInt("periodos");
			}
			rs.close();
			pst.close();
			
		}catch(SQLException sqle){
			System.err.println("error al contar periodos calificados " + sqle);
 		}
		return salida;
	}
	
	
	public void cierraMateria(String escuela, String curso_id, String ciclo_grupo_id, String tipo_eval, String ciclo_id){
		KrdxCursoActLista kls = new KrdxCursoActLista();
		AlumnoPromLista apl = new AlumnoPromLista();
		DecimalFormat df = new DecimalFormat("##0.0;-##0.0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
		CicloGrupoCurso cgc = new CicloGrupoCurso();
		
		
		
		try{
			
			cgc.mapeaRegId(con, ciclo_grupo_id, curso_id);
			float notaAC = Float.parseFloat(aca.plan.PlanCurso.getNotaAC(con, curso_id));
			Map<String, AlumnoProm> mapAlumProm = new TreeMap();
			mapAlumProm.putAll(apl.getTreeCurso(con,	ciclo_grupo_id, curso_id, ""));
			List<KrdxCursoAct> lsAluGpo = new ArrayList<KrdxCursoAct>();
			lsAluGpo.addAll(kls.getListAll(con, escuela, " AND CICLO_GRUPO_ID = '" + ciclo_grupo_id + "' AND CURSO_ID = '" + curso_id + "' ORDER BY ALUM_APELLIDO(CODIGO_ID)"));
			getDatos(escuela, ciclo_id, "", "");
			Map<String,String> mapPeriodos = new LinkedHashMap<String, String>();
			mapPeriodos.putAll(periodos(ciclo_id, tipo_eval));
			System.out.println(mapPeriodos.size() + "\t" + periodosCalificados(tipo_eval, ciclo_grupo_id) + "\t" + aca.ciclo.CicloGrupoEval.estanTodasCerradas(con, ciclo_grupo_id, curso_id));
			if(mapPeriodos.size()!=0 && mapPeriodos.size()==periodosCalificados(tipo_eval, ciclo_grupo_id) && aca.ciclo.CicloGrupoEval.estanTodasCerradas(con, ciclo_grupo_id, curso_id)){
				System.out.println("MATERIA cumple requerimientos de cierre y se dispone a cerrar");
				boolean isExtra= false;
				System.out.println(lsAluGpo.size());
				for(KrdxCursoAct kca : lsAluGpo ){
					double promedio = 0.0;
					if(mapAlumProm.containsKey(ciclo_grupo_id + curso_id	+ kca.getCodigoId())){
						AlumnoProm ap = mapAlumProm.get(ciclo_grupo_id + curso_id	+ kca.getCodigoId());
						promedio = Double.parseDouble(ap.getPromedio().replaceAll(",","."));						
					}
					kca.setNota(df.format(promedio));
					kca.setFNota(aca.util.Fecha.getHoy());
					
					if (promedio >= notaAC) {
						kca.setTipoCalId("2");
						System.out.println("todos pasan kca");
					}else{
						kca.setTipoCalId("3");
						isExtra = true;
						System.out.println("todos hay extra kca");
					}
					
					kca.updateReg(con);
				}
				
				if(!isExtra){
					cgc.setEstado("4");
					System.out.println("todos pasan cgc");
				}else{
					cgc.setEstado("3");
					System.out.println("todos hay extra cgc");
				}
				
				cgc.updateReg(con);
			}else{
				
			}
			
		}catch(SQLException sqle){
			System.err.println("error al cerrar materia " + sqle);
		}
	}
	
	public void abreMateria(String escuela, String curso_id, String ciclo_grupo_id, String tipo_eval, String ciclo_id){
		CicloGrupoCurso cgc = new CicloGrupoCurso();
		try{
			cgc.mapeaRegId(con, ciclo_grupo_id, curso_id);
			if(!cgc.getEstado().equals("2")){
				System.out.println("MATERIA cumple requerimientos de apertura y se dispone a abrir");
				cgc.setEstado("2");
				cgc.updateReg(con);
			}
		}catch(SQLException sqle){
			System.err.println("error al cerrar materia " + sqle);
		}
		
	}

}
