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

public class UtilCriterios {
	
	private Connection con;

	public UtilCriterios(){
		
	}
	
	public UtilCriterios(Connection con){
		this.con = con;
	}
	
	
	/**
	 * @param id = IDENTIFICADOR UNICO PARA TRAER UN SOLO DATO
	 * @param inId = IDENTIFICADORES NUMERICOS SEPARADOS POR COMAS
	 * @param ciclo_id = DATO DE TEXTO DEL CICLO ID
	 * @param area_id = DATO TIPO LONG PARA AREA_ID
	 * @param estado = DATO NUMERICO PARA EL ESTATUS 1 ACTIVO , -1 INACTIVO
	 * @return = MAPA CRITERIOS
	 */
	public Map<Long, Criterios> getMapCriterios(Long id, String inId, String ciclo_id, Long area_id, Integer estado){
		Map<Long, Criterios> salida = new LinkedHashMap();
		
		try{
			String sql = "select * from kinder_criterios where id is not null ";
			if(!id.equals(0L)){
				sql += " and id=" + id;
			}
			
			if(!inId.equals("")){
				sql += " and id in (" + inId + ") ";
			}
			
			if(!ciclo_id.equals("")){
				sql += " and ciclo_id='"+ciclo_id +"' " ;
			}
			
			if(!area_id.equals(0L)){
				sql += " and area_id=" + area_id;
			}
			
			if(!estado.equals(0)){
				sql += " and estado="+ estado;
			}
			
			sql += " order by id ";
			
			PreparedStatement pst = con.prepareStatement(sql);
			//System.out.println("SQL "+ pst);
			ResultSet rs = pst.executeQuery();
			while(rs.next()){
				Criterios c = new Criterios();
				c.setArea_id(rs.getLong("area_id"));
				c.setCiclo_id(rs.getString("ciclo_id"));
				c.setCriterio(rs.getString("criterio"));
				c.setEstado(rs.getInt("estado"));
				c.setId(rs.getLong("id"));
				salida.put(c.getId(), c);
			}
			rs.close();
			pst.close();
			
		}catch(SQLException sqle){
			System.out.println("error al generar mapa de criterios " + sqle);
		}
		
		return salida;
	}
	
	
	/**
	 * @param id = IDENTIFICADOR UNICO PARA TRAER UN SOLO DATO
	 * @param inId = IDENTIFICADORES NUMERICOS SEPARADOS POR COMAS
	 * @param ciclo_id = DATO DE TEXTO DEL CICLO ID
	 * @param area_id = DATO TIPO LONG PARA AREA_ID
	 * @param estado = DATO NUMERICO PARA EL ESTATUS 1 ACTIVO , -1 INACTIVO
	 * @return = MAPA CRITERIOS
	 */
	public List<Criterios> getLsCriterios(Long id, String inId, String ciclo_id, Long area_id, Integer estado){
		List<Criterios> salida = new ArrayList<Criterios>();
		Map<Long, Criterios> consulta = new HashMap<Long, Criterios>();
		consulta.putAll(getMapCriterios(id, inId, ciclo_id, area_id, estado));
		
		List<Long> lsIdCriterios = new ArrayList<Long>(consulta.keySet());
		Collections.sort(lsIdCriterios);
		for(Long idcriterio : lsIdCriterios){
			salida.add(consulta.get(idcriterio));
		}
		return salida;
	}
	
	public void addCriterio(Criterios c) throws SQLException{
		try{
			PreparedStatement pst = con.prepareStatement("insert into kinder_criterios(ciclo_id, area_id, criterio) values(?, ?, ?)");
			pst.setString(1, c.getCiclo_id());
			pst.setLong(2, c.getArea_id());
			pst.setString(3, c.getCriterio());
			
			pst.executeUpdate();
			pst.close();
		}catch(SQLException sqle){
			System.out.println("Error en addCriterios" + sqle);
		}
	}
	
	public Long  addCriterioId(Criterios c) throws SQLException{
		Long salida = 0L;
		try{
			PreparedStatement pst = con.prepareStatement("insert into kinder_criterios(ciclo_id, area_id, criterio) values(?, ?, ?) Returning id");
			pst.setString(1, c.getCiclo_id());
			pst.setLong(2, c.getArea_id());
			pst.setString(3, c.getCriterio());
			
			ResultSet rs = pst.executeQuery();
			if(rs.next()){
				salida = rs.getLong(1);
			}
			rs.close();
			pst.close();
		}catch(SQLException sqle){
			System.out.println("Error en addCriterios" + sqle);
		}
		return salida;
	}
	
	public void modifCriterio(Criterios c) throws SQLException{
		try{
			
			String sql = "update kinder_criterios set ";

			
			if(c.getCriterio()!=null){
				sql+=" criterio='"+c.getCriterio()+"' ";
			}

			
			if(c.getEstado()!=null ){
				sql+=" estado="+c.getEstado()+" ";
			}
			
			sql+=" where id="+c.getId();
			
			PreparedStatement pst = con.prepareStatement(sql);
			System.out.println(pst);
			pst.executeUpdate();
			pst.close();
		}catch(SQLException sqle){
			System.out.println("Error en addArea" + sqle);
		}
	}
}
