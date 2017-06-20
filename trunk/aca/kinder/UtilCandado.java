package aca.kinder;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UtilCandado {

	private Connection con;
	private List<Long> lsCriterios;
	private List<Long> lsActividades;
	private List<Long> lsEvaluaciones;
	private List<Long> lsAreas;
	
	public UtilCandado(){
		
	}
	
	public UtilCandado(Connection con){
		this.con=con;
	}
	 
	
	
	/**
	 * @return the lsAreas
	 */
	public List<Long> getLsAreas() {
		return lsAreas;
	}

	/**
	 * @param lsAreas the lsAreas to set
	 */
	public void setLsAreas(List<Long> lsAreas) {
		this.lsAreas = lsAreas;
	}

	/**
	 * @return the con
	 */
	public Connection getCon() {
		return con;
	}

	/**
	 * @param con the con to set
	 */
	public void setCon(Connection con) {
		this.con = con;
	}

	/**
	 * @return the lsCriterios
	 */
	public List<Long> getLsCriterios() {
		return lsCriterios;
	}

	/**
	 * @param lsCriterios the lsCriterios to set
	 */
	public void setLsCriterios(List<Long> lsCriterios) {
		this.lsCriterios = lsCriterios;
	}

	/**
	 * @return the lsActividades
	 */
	public List<Long> getLsActividades() {
		return lsActividades;
	}

	/**
	 * @param lsActividades the lsActividades to set
	 */
	public void setLsActividades(List<Long> lsActividades) {
		this.lsActividades = lsActividades;
	}

	/**
	 * @return the lsEvaluaciones
	 */
	public List<Long> getLsEvaluaciones() {
		return lsEvaluaciones;
	}

	/**
	 * @param lsEvaluaciones the lsEvaluaciones to set
	 */
	public void setLsEvaluaciones(List<Long> lsEvaluaciones) {
		this.lsEvaluaciones = lsEvaluaciones;
	}

	public void getBloqueaActividad(String ciclo_id, String ciclo_gpo_id){
		lsActividades = new ArrayList<Long>();
		try{
			String sql = "select distinct(ev.actividad_id) as actividad from kinder_evaluacion ev where id is not null" ;
			
			if(!ciclo_id.equals(""))
				sql+= " and ciclo_gpo_id like '"+ciclo_id+"' ";
			
			if(!ciclo_gpo_id.equals(""))
				sql+= " and ciclo_gpo_id = '"+ciclo_gpo_id+"' ";
			
			System.out.println("------ " + sql );
			PreparedStatement pst = con.prepareStatement(sql);
			ResultSet rs = pst.executeQuery();
			while(rs.next()){
				System.out.println(rs.getLong("actividad"));
				lsActividades.add(rs.getLong("actividad"));
			}
			
			rs.close();
			pst.close();
			
		}catch(SQLException sqle){
			System.err.println("Error en getBloqueaActividad" + sqle);
		}
	}
	
	public void getBloqueaCriterio(String ciclo_id, String ciclo_gpo_id){
		lsCriterios = new ArrayList<Long>();
		try{
			String sql = "select distinct(ac.criterio_id) criterio from kinder_actividades ac where id is not null and ac.estado=1 " ;
			
			if(!ciclo_id.equals(""))
				sql+= " and ciclo_gpo_id like '"+ciclo_id+"%' ";
			
			if(!ciclo_gpo_id.equals(""))
				sql+= " and ciclo_gpo_id = '"+ciclo_gpo_id+"' ";
			
			PreparedStatement pst = con.prepareStatement(sql);
			ResultSet rs = pst.executeQuery();
			while(rs.next()){
				lsCriterios.add(rs.getLong("criterio"));
			}
			rs.close();
			pst.close();
			
		}catch(SQLException sqle){
			System.err.println("Error en getBloqueaCriterio " + sqle);
		}
	}
	
	public void getBloqueaArea(String ciclo_id){
		lsAreas = new ArrayList<Long>();
		try{
			String sql = "select distinct(cr.area_id) areas from kinder_criterios cr where cr.id is not null and cr.estado=1 " ;
			
			if(!ciclo_id.equals(""))
				sql+= " and cr.ciclo_id = '"+ciclo_id+"' ";

			PreparedStatement pst = con.prepareStatement(sql);
			ResultSet rs = pst.executeQuery();
			while(rs.next()){
				lsAreas.add(rs.getLong("areas"));
			}
			rs.close();
			pst.close();
			
		}catch(SQLException sqle){
			System.err.println("Error en getBloqueaArea " + sqle);
		}
	}
	
}
