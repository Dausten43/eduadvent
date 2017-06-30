package aca.ciclo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;

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
				+ "q.curso_nombre from ( select  ci.ciclo_id, ci.ciclo_nombre, "
				+ "ci.escala, ci.ciclo_escolar, ci.nivel_eval, ci.nivel_academico_sistema , "
				+ "cg.ciclo_grupo_id, cg.grupo_nombre, cg.nivel_id,ne.nivel_nombre, cg.grado, "
				+ "cg.grupo,  cgc.curso_id, pc.curso_nombre "
				+ "from ciclo_grupo_curso cgc "
				+ "join plan_curso pc on pc.curso_id = cgc.curso_id and pc.urso_base<>'-'"
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
			System.out.println(comando);
			PreparedStatement pst = con.prepareStatement(comando);
			ResultSet rs = pst.executeQuery();
			while(rs.next()){
				if(!ciclo_id.equals("")){
					if(!salida.containsKey(rs.getString("ciclo_grupo_id"))){
						salida.put(rs.getString("ciclo_grupo_id"),rs.getString("nivel_nombre") + " " + rs.getString("grupo_nombre"));
					}
				}
				
				if(!ciclo_gpo_id.equals("")){
					if(!salida.containsKey(rs.getString("ciclo_grupo_id"))){
						salida.put(rs.getString("curso_id"), rs.getString("curso_nombre"));
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
	
	

}
