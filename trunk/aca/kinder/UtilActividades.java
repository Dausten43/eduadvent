package aca.kinder;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UtilActividades {
	
	private Connection con;
	
	public UtilActividades(){
		
	}
	
	public UtilActividades(Connection con){
		this.con=con;
	}
	
	public Map<Long, Actividades> getMapActividades(Long id, String inId, String ciclo_gpo_id, Long area_id, Long criterio_id, String maestro_id, Integer estado, Integer evaluacion){
		Map<Long, Actividades> salida = new HashMap<Long, Actividades>();
		try{
			String sql = "select * from kinder_actividades where id is not null ";
			
			if(!id.equals(0L)){
				sql += " and id=" + id;
			}
			
			if(!inId.equals("")){
				sql += " and id in (" + inId + ") ";
			}
			
			if(!ciclo_gpo_id.equals("")){
				sql += " and ciclo_gpo_id='"+ciclo_gpo_id +"' " ;
			}
			
			if(!area_id.equals(0L)){
				sql += " and area_id=" + area_id;
			}
			
			if(!criterio_id.equals(0L)){
				sql += " and criterio_id=" + criterio_id;
			}
			
			if(!maestro_id.equals("")){
				sql += " and maestro_id='"+maestro_id +"' " ;
			}
			
			if(!estado.equals(0)){
				sql += " and estado="+ estado;
			}
			
			if(!evaluacion.equals(0)){
				sql += " and evaluacion="+ evaluacion;
			}
			
			//System.out.println(sql);
			PreparedStatement pst = con.prepareStatement(sql);
			ResultSet rs = pst.executeQuery();
			while(rs.next()){
				Actividades a = new Actividades();
				a.setActividad(rs.getString("actividad"));
				a.setArea_id(rs.getLong("area_id"));
				a.setCiclo_grupo_id(rs.getString("ciclo_gpo_id"));
				a.setCriterio_id(rs.getLong("criterio_id"));
				a.setEstado(rs.getInt("estado"));
				a.setFecha(rs.getString("fecha"));
				a.setId(rs.getLong("id"));
				a.setMaestro_id(rs.getString("maestro_id"));
				a.setEvaluacion(rs.getInt("evaluacion"));
				salida.put(a.getId(),a);
			}
			rs.close();
			pst.close();
			
		}catch(SQLException sqle){
			System.err.println("Error en getMapActividades " + sqle);
		}
		
		return salida;
		
	}
	
	public List<Actividades> getLsActividades(Long id, String inId, String ciclo_gpo_id, Long area_id, Long criterio_id, String maestro_id, Integer estado, Integer evaluacion){
		List<Actividades> salida = new ArrayList<Actividades>();
		Map<Long, Actividades> consulta = new HashMap<Long, Actividades>();
		consulta.putAll(getMapActividades(id, inId, ciclo_gpo_id, area_id, criterio_id, maestro_id,  estado, evaluacion));
		
		List<Long> lsIdActividades = new ArrayList<Long>(consulta.keySet());
		Collections.sort(lsIdActividades);
		for(Long idactividad : lsIdActividades){
			salida.add(consulta.get(idactividad));
		} 
		return salida;
	}
	
	
	public void addActividad(Actividades a) throws SQLException{
		try{
			PreparedStatement pst = con.prepareStatement("insert into kinder_actividades(area_id, criterio_id, ciclo_gpo_id, maestro_id, actividad, fecha, evaluacion) "
					+ "values(?, ?, ?, ?, ?, to_date(?,'dd-mm-yyyy'),?)");
			pst.setLong(1, a.getArea_id());
			pst.setLong(2, a.getCriterio_id());
			pst.setString(3, a.getCiclo_grupo_id());
			pst.setString(4, a.getMaestro_id());
			pst.setString(5, a.getActividad());
			pst.setString(6, a.getFecha());
			pst.setInt(7, a.getEvaluacion());
			
			pst.executeUpdate();
			pst.close();
		}catch(SQLException sqle){
			System.out.println("Error en addActividad" + sqle);
		}
	}
	
	public void modifActividad(Actividades a){
		try{
			String sql = "update kinder_actividades set ";
			if(a.getActividad()!=null){
				sql += " actividad='"+a.getActividad()+"' ";
			}
			if(a.getEstado()!=null){
				sql+=" estado="+a.getEstado();
			}
			
			if(a.getFecha()!=null){
				sql+=" fecha=to_date('"+a.getFecha()+"','DD-MM-YYYY')";
			}
			
			sql+=" where id="+a.getId();
			PreparedStatement pst = con.prepareStatement(sql);
			
			pst.executeUpdate();
			pst.close();
		}catch(SQLException sqle){
			System.out.println("Error en modifActividad" + sqle);
		}
	}

}
