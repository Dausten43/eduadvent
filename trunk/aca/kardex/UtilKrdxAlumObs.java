package aca.kardex;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;



public class UtilKrdxAlumObs {
	
	private Connection con;
	
	public UtilKrdxAlumObs(){
		
	}
	
	public UtilKrdxAlumObs(Connection con){
		this.con=con;
	}
	
	
	
	
	/**
	 * @param id Long para condicion con el id o 0L
	 * @param ciclo_gpo_id String para condicion con ciclo_gpo_id o ""
	 * @param codigo_id String para condicion con codigo_id o ""
	 * @param ubicador Integer para condicion ubicador o 0
	 * @return mapa con la llave id y objeto KrdxAlumObs
	 */
	public Map<Long, KrdxAlumObs>  getObservaciones(Long id, String ciclo_gpo_id, String codigo_id, Integer ubicador){
		
		Map<Long, KrdxAlumObs> salida = new HashMap(); 
		
		
		String comando = "select * from krdx_alum_obs where id is not null ";
		
		if(!id.equals(0L)){
			comando+=" and id="+id;
		}
		if(!ciclo_gpo_id.equals("")){
			comando+=" and ciclo_grupo_id='"+ciclo_gpo_id+"' ";
		}
		if(!codigo_id.equals("")){
			comando+=" and codigo_id='"+codigo_id+"' ";
		}
		if(!ubicador.equals(0)){
			comando+=" and ubicador="+ubicador ;
		}
		
		try{
			
			PreparedStatement pst = con.prepareStatement(comando);
			ResultSet rs = pst.executeQuery();
			
			while(rs.next()){
				KrdxAlumObs ob = new KrdxAlumObs(rs.getLong("id"), 
						rs.getString("ciclo_grupo_id"), 
						rs.getString("codigo_id"), 
						rs.getInt("ubicador"), 
						rs.getString("observacion_1"), rs.getString("observacion_2"));
				
				salida.put(ob.getId(), ob);
				
			}
			rs.close();
			pst.close();
			
		}catch(SQLException sqle){
			System.err.println("Error en UtilKrdxAlumObs getObservaciones " + sqle);
		}
		return salida;
	}
	
	
	public Map<String, KrdxAlumObs>  getObservacionesComplexKey(Long id, String ciclo_gpo_id, String codigo_id, Integer ubicador){
		Map<String, KrdxAlumObs> salida = new HashMap(); 
		
		Map<Long, KrdxAlumObs> input = new HashMap<Long, KrdxAlumObs>();
		input.putAll(getObservaciones(id, ciclo_gpo_id, codigo_id, ubicador));
		
		for(Long key : input.keySet()){
			salida.put(input.get(key).getCodigo_id()+"-"+input.get(key).getUbicador(),input.get(key));
		}
		
		return salida;
	}
	
	
	/**
	 * @param obs Objeto KrdxAlumObs
	 * @return el id del elemento insertado
	 */
	public Long addObservacion(KrdxAlumObs obs){
		Long salida = 0L;
		try{
			PreparedStatement pst = con.prepareStatement("insert into krdx_alum_obs "
					+ "(ciclo_grupo_id, codigo_id, ubicador, observacion_1, observacion_2) "
					+ "values(?,?,?,?,?)returning id");
			
			pst.setString(1, obs.getCiclo_gupo_id());
			pst.setString(2, obs.getCodigo_id());
			pst.setInt(3, obs.getUbicador());
			pst.setString(4, obs.getObservacion_1());
			pst.setString(5, obs.getObservacion_2());
			
			ResultSet rs = pst.executeQuery();
			
			if(rs.next()){
				salida = rs.getLong(1);
			}
			rs.close();
			pst.close();
			
		}catch(SQLException sqle){
			System.err.println("Error en UtilKrdxAlumObs addObservacion " + sqle);
		}
		
		return salida;
	}
	
	public void updObservaciones(Long id, String observacion_1, String observacion_2){
		
		try{
			PreparedStatement pst = con.prepareStatement("update krdx_alum_obs set observacion_1='"+observacion_1+"', observacion_2='"+observacion_2+"' where id="+id);
			pst.executeUpdate();
			
		}catch(SQLException sqle){
			System.err.println("Error en UtilKrdxAlumObs updObservaciones " + sqle);
		}
	}
	
	public void delObservaciones(Long id){
		
		try{
			PreparedStatement pst = con.prepareStatement("delete from krdx_alum_obs where id="+id);
			pst.executeUpdate();
			
		}catch(SQLException sqle){
			System.err.println("Error en UtilKrdxAlumObs updObservaciones " + sqle);
		}
	}

}
