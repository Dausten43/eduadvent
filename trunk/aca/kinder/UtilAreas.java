package aca.kinder;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class UtilAreas {

	private Connection con;
	
	public UtilAreas(Connection con){
		this.con = con;
	}
	
	
	
	/**
	 * 
	 * @param id identificador unico para traer un solo elemento no se considera si =0
	 * @param inId identificador grupal siempre en Long pero separados por commas no se considera si =""
	 * @param ciclo_id identificador de ciclo_id no se considera = ""
	 * @param estado identificador numerico activo 1 , inactivo -1  no se considera =0
	 * @return mapa de Areas
	 */
	public Map<Long, Areas> getMapAreas(Long id, String inId, String ciclo_id, Integer estado) throws SQLException{
		Map<Long, Areas> salida = new LinkedHashMap();
		try{
			String sql = "select * from kinder_areas where id is not null ";
			
			if(!id.equals(0L)){
				sql += " and id=" + id;
			}
			
			if(!inId.equals("")){
				sql += " and id in (" + inId + ") ";
			}
			
			if(!ciclo_id.equals("")){
				sql += " and ciclo_id='"+ciclo_id +"' " ;
			}
			
			if(!estado.equals(0)){
				sql += " and estado="+ estado;
			}
			
			
			sql += " order by id ";
			
			PreparedStatement pst = con.prepareStatement(sql);
			//System.out.println("SQL "+ pst);
			ResultSet rs = pst.executeQuery();
			while(rs.next()){
				Areas a = new Areas();
				a.setArea(rs.getString("area"));
				a.setCiclo_id(rs.getString("ciclo_id"));
				a.setEstado(rs.getInt("estado"));
				a.setId(rs.getLong("id"));
				salida.put(a.getId(), a);
			}
			
			rs.close();
			pst.close();
			
		}catch(SQLException sqle){
			System.out.println("Error en getMapAreas" + sqle);
		}
		return salida;
	}
	
	/**
	 * 
	 * @param id identificador unico para traer un solo elemento no se considera si =0
	 * @param inId identificador grupal siempre en Long pero separados por commas no se considera si =""
	 * @param ciclo_id identificador de ciclo_id no se considera = ""
	 * @param estado identificador numerico activo 1 , inactivo -1  no se considera =0
	 * @param condicion_abierta campo para agregar una condicion abierta a la consulta 
	 * @return mapa de Areas
	 */
	public Map<Long, Areas> getMapAreas(Long id, String inId, String ciclo_id, Integer estado, String condicion_abierta) throws SQLException{
		Map<Long, Areas> salida = new LinkedHashMap();
		try{
			String sql = "select * from kinder_areas where id is not null ";
			
			if(!id.equals(0L)){
				sql += " and id=" + id;
			}
			
			if(!inId.equals("")){
				sql += " and id in (" + inId + ") ";
			}
			
			if(!ciclo_id.equals("")){
				sql += " and ciclo_id='"+ciclo_id +"' " ;
			}
			
			if(!estado.equals(0)){
				sql += " and estado="+ estado;
			}
			
			if(!condicion_abierta.equals("")){
				sql +=  condicion_abierta;
			}
			
			
			sql += " order by id ";
			
			PreparedStatement pst = con.prepareStatement(sql);
			//System.out.println("SQL "+ pst);
			ResultSet rs = pst.executeQuery();
			while(rs.next()){
				Areas a = new Areas();
				a.setArea(rs.getString("area"));
				a.setCiclo_id(rs.getString("ciclo_id"));
				a.setEstado(rs.getInt("estado"));
				a.setId(rs.getLong("id"));
				salida.put(a.getId(), a);
			}
			
			rs.close();
			pst.close();
			
		}catch(SQLException sqle){
			System.out.println("Error en getMapAreas" + sqle);
		}
		return salida;
	}
	
	/**
	 * 
	 * @param id identificador unico para traer un solo elemento no se considera si =0
	 * @param inId identificador grupal siempre en Long pero separados por commas no se considera si =""
	 * @param ciclo_id identificador de ciclo_id no se considera = ""
	 * @param estado identificador numerico activo 1 , inactivo -1  no se considera =0
	 * @return mapa de Areas
	 */
	public List<Areas> getLsAreas(Long id, String inId, String ciclo_id, Integer estado) throws SQLException{
		Map<Long, Areas> consulta = new HashMap<Long, Areas>();
		consulta.putAll(getMapAreas(id, inId, ciclo_id, estado));
		List<Areas> salida = new ArrayList<Areas>();
		List<Long> lsIdAreas = new ArrayList<Long>(consulta.keySet());
		Collections.sort(lsIdAreas);
		for(Long idarea : lsIdAreas){
			salida.add(consulta.get(idarea));
		}
		
		return salida;
		
	}
	
	
	public void addArea(Areas a) throws SQLException{
		try{
			PreparedStatement pst = con.prepareStatement("insert into kinder_areas(ciclo_id, area) values(?, ?)");
			pst.setString(1, a.getCiclo_id());
			pst.setString(2, a.getArea());
			
			pst.executeUpdate();
			pst.close();
		}catch(SQLException sqle){
			System.out.println("Error en addArea" + sqle);
		}
	}
	
	public Long addAreaId(Areas a) throws SQLException{
		Long salida = new Long(0);
		try{
			PreparedStatement pst = con.prepareStatement("insert into kinder_areas(ciclo_id, area) values(?, ?)Returning id");
			pst.setString(1, a.getCiclo_id());
			pst.setString(2, a.getArea());
			
			ResultSet rs = pst.executeQuery();
			if(rs.next()){
				salida = rs.getLong(1);
			}
			
			rs.close();
			pst.close();
		}catch(SQLException sqle){
			System.out.println("Error en addArea" + sqle);
		}
		return salida;
	}
	
	public void modifArea(Areas a) throws SQLException{
		try{
			
			String sql = "update kinder_areas set ";
			if(a.getArea()!=null){
				sql+=" area='"+a.getArea()+"' ";
			}
			
			
			if(a.getEstado()!=null){
				sql+=" estado='"+a.getEstado()+"' ";
			}
			
			sql+=" where id="+a.getId();
			
			PreparedStatement pst = con.prepareStatement(sql);
			System.out.println(pst);
			pst.executeUpdate();
			pst.close();
		}catch(SQLException sqle){
			System.out.println("Error en addArea" + sqle);
		}
	}
	
}
