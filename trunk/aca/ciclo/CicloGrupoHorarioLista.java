package aca.ciclo;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;


public class CicloGrupoHorarioLista {
	
	public ArrayList<CicloGrupoHorario> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CicloGrupoHorario> lisCicloGrupo 	= new ArrayList<CicloGrupoHorario>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT ESCUELA_ID CURSO_ID, CICLO_GRUPO_ID, SALON_ID, HORARIO_ID, DIA, PERIODO_ID" +
					  " FROM CICLO_GRUPO_HORARIO "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				CicloGrupoHorario obj = new CicloGrupoHorario();				
				obj.mapeaReg(rs);
				lisCicloGrupo.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoHorarioLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCicloGrupo;
	}
	
	public HashMap<String, CicloGrupoHorario> getMapActual(Connection conn, String escuelaId, String cursoId, String cicloGrupoId, String horarioId, String salonId) throws SQLException{
		
		HashMap<String, CicloGrupoHorario> map = new HashMap<String, CicloGrupoHorario>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT *  " +
					" FROM CICLO_GRUPO_HORARIO "+
					" WHERE ESCUELA_ID = '"+escuelaId+"' "+
					" AND CURSO_ID = '"+cursoId+"' "+
					" AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' "+
					" AND HORARIO_ID = '"+horarioId+"' "+
					" AND SALON_ID = '"+salonId+"' ";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CicloGrupoHorario obj = new CicloGrupoHorario();
				obj.mapeaReg(rs);
				
				llave = obj.getPeriodoId()+"@"+obj.getDia();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoHorarioLista|getMapActual|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public HashMap<String, CicloGrupoHorario> getMapOtrasMaterias(Connection conn, String escuelaId, String cursoId, String cicloGrupoId, String horarioId, String salonId, String ciclos) throws SQLException{
		
		HashMap<String, CicloGrupoHorario> map = new HashMap<String, CicloGrupoHorario>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT *  " +
					" FROM CICLO_GRUPO_HORARIO "+
					" WHERE ESCUELA_ID = '"+escuelaId+"' "+
					" AND CICLO_GRUPO_ID||CURSO_ID NOT IN ( '"+cicloGrupoId+"'||'"+cursoId+"' ) "+
					" AND HORARIO_ID = '"+horarioId+"' "+
					" AND SALON_ID = '"+salonId+"' "+
					" AND SUBSTR(CICLO_GRUPO_ID, 0, 9) IN ("+ciclos+") ";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CicloGrupoHorario obj = new CicloGrupoHorario();
				obj.mapeaReg(rs);
				
				llave = obj.getPeriodoId()+"@"+obj.getDia();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoHorarioLista|getMapOtrasMaterias|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public ArrayList<String> getListDeOtrosHorarios(Connection conn, String escuelaId, String horarioId, String salonId, String ciclos, String orden) throws SQLException{
		ArrayList<String> list 	= new ArrayList<String>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT"
						+ " CURSO_ID, CICLO_GRUPO_ID, HORARIO_ID, DIA, "
						+ " DIA||(SELECT HORA_INICIO||MINUTO_INICIO FROM CAT_HORARIO_PERIODO WHERE HORARIO_ID = CGH.HORARIO_ID AND PERIODO_ID = CGH.PERIODO_ID) AS HORA_INICIO,"
						+ " DIA||(SELECT HORA_FINAL||MINUTO_FINAL FROM CAT_HORARIO_PERIODO WHERE HORARIO_ID = CGH.HORARIO_ID AND PERIODO_ID = CGH.PERIODO_ID) AS HORA_FINAL"
					+ " FROM CICLO_GRUPO_HORARIO CGH "
					+ " WHERE ESCUELA_ID = '"+escuelaId+"' "
					+ " AND HORARIO_ID NOT IN ( '"+horarioId+"' ) "
					+ " AND SALON_ID = '"+salonId+"' "
					+ " AND SUBSTR(CICLO_GRUPO_ID, 0, 9) IN ("+ciclos+") "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				list.add( 
							rs.getString("CURSO_ID") + "@@" + 
							rs.getString("CICLO_GRUPO_ID") + "@@" + 
							rs.getString("HORARIO_ID") + "@@" +  
							rs.getString("DIA") + "@@" + 
							rs.getString("HORA_INICIO") + "@@" + 
							rs.getString("HORA_FINAL") 
						);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoHorarioLista|getListDeOtrosHorarios|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	public ArrayList<String> getListPeriodosHorariosAlumno(Connection conn, String escuelaId, String cicloGrupoId, String orden) throws SQLException{
		ArrayList<String> list 	= new ArrayList<String>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT"
						+ " CURSO_ID, CICLO_GRUPO_ID, HORARIO_ID, DIA, "
						+ " DIA||(SELECT HORA_INICIO||MINUTO_INICIO FROM CAT_HORARIO_PERIODO WHERE HORARIO_ID = CGH.HORARIO_ID AND PERIODO_ID = CGH.PERIODO_ID) AS HORA_INICIO,"
						+ " DIA||(SELECT HORA_FINAL||MINUTO_FINAL FROM CAT_HORARIO_PERIODO WHERE HORARIO_ID = CGH.HORARIO_ID AND PERIODO_ID = CGH.PERIODO_ID) AS HORA_FINAL"
					+ " FROM CICLO_GRUPO_HORARIO CGH "
					+ " WHERE ESCUELA_ID = '"+escuelaId+"' "
					+ " AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				list.add( 
							rs.getString("CURSO_ID") + "@@" + 
							rs.getString("CICLO_GRUPO_ID") + "@@" + 
							rs.getString("HORARIO_ID") + "@@" +  
							rs.getString("DIA") + "@@" + 
							rs.getString("HORA_INICIO") + "@@" + 
							rs.getString("HORA_FINAL") 
						);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoHorarioLista|getListPeriodosHorariosAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	public ArrayList<String> getListSalonesMaestro(Connection conn, String horarioId, String empleadoId, String ciclos) throws SQLException{
		
		ArrayList<String> list		= new ArrayList<String>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT DISTINCT(SALON_ID) AS SALON_ID "
					+ " FROM CICLO_GRUPO_HORARIO"
					+ " WHERE HORARIO_ID = '"+horarioId+"' "
					+ " AND CURSO_ID||CICLO_GRUPO_ID "
						+ " IN( SELECT CURSO_ID||CICLO_GRUPO_ID FROM CICLO_GRUPO_CURSO WHERE EMPLEADO_ID = '"+empleadoId+"' AND SUBSTR(CICLO_GRUPO_ID, 0, 9) IN ("+ciclos+")  ) ";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				list.add(rs.getString("SALON_ID"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoHorarioLista|getListSalonesMaestro|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return list;
	}
	
	public ArrayList<String> getListSalones(Connection conn, String horarioId, String cicloGrupoId) throws SQLException{
		
		ArrayList<String> list		= new ArrayList<String>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT DISTINCT(SALON_ID) AS SALON_ID "
					+ " FROM CICLO_GRUPO_HORARIO"
					+ " WHERE HORARIO_ID = '"+horarioId+"' "
					+ " AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' ";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				list.add(rs.getString("SALON_ID"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoHorarioLista|getListSalones|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return list;
	}
	
	public ArrayList<String> getListSalonesAlumno(Connection conn, String horarioId, String codigoId, String cicloGrupoId) throws SQLException{
		
		ArrayList<String> list		= new ArrayList<String>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT DISTINCT(SALON_ID) AS SALON_ID "
					+ " FROM CICLO_GRUPO_HORARIO"
					+ " WHERE HORARIO_ID = '"+horarioId+"' "
					+ " AND CURSO_ID||CICLO_GRUPO_ID "
						+ " IN( SELECT CURSO_ID||CICLO_GRUPO_ID FROM KRDX_CURSO_ACT WHERE CODIGO_ID = '"+codigoId+"' AND CICLO_GRUPO_ID = '"+cicloGrupoId+"'   ) ";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				list.add(rs.getString("SALON_ID"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoHorarioLista|getListSalonesAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return list;
	}

	public HashMap<String, CicloGrupoHorario> getMapHorarioMaestro(Connection conn, String horarioId, String empleadoId, String ciclos) throws SQLException{
		
		HashMap<String, CicloGrupoHorario> map = new HashMap<String, CicloGrupoHorario>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT * "
					+ " FROM CICLO_GRUPO_HORARIO"
					+ " WHERE HORARIO_ID = '"+horarioId+"' "
					+ " AND CURSO_ID||CICLO_GRUPO_ID "
						+ " IN( SELECT CURSO_ID||CICLO_GRUPO_ID FROM CICLO_GRUPO_CURSO WHERE EMPLEADO_ID = '"+empleadoId+"' AND SUBSTR(CICLO_GRUPO_ID, 0, 9) IN ("+ciclos+")  ) ";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CicloGrupoHorario obj = new CicloGrupoHorario();
				obj.mapeaReg(rs);
				
				llave = obj.getSalonId()+"@"+obj.getPeriodoId()+"@"+obj.getDia();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoHorarioLista|getMapHorarioMaestro|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public HashMap<String, CicloGrupoHorario> getMapHorario(Connection conn, String horarioId, String cicloGrupoId) throws SQLException{
		
		HashMap<String, CicloGrupoHorario> map = new HashMap<String, CicloGrupoHorario>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT * "
					+ " FROM CICLO_GRUPO_HORARIO"
					+ " WHERE HORARIO_ID = '"+horarioId+"' "
					+ " AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' ";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CicloGrupoHorario obj = new CicloGrupoHorario();
				obj.mapeaReg(rs);
				
				llave = obj.getSalonId()+"@"+obj.getPeriodoId()+"@"+obj.getDia();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoHorarioLista|getMapHorario|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}

	public HashMap<String, CicloGrupoHorario> getMapHorarioAlumno(Connection conn, String horarioId, String codigoId, String cicloGrupoId) throws SQLException{
		
		HashMap<String, CicloGrupoHorario> map = new HashMap<String, CicloGrupoHorario>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT * "
					+ " FROM CICLO_GRUPO_HORARIO"
					+ " WHERE HORARIO_ID = '"+horarioId+"' "
					+ " AND CURSO_ID||CICLO_GRUPO_ID "
						+ " IN( SELECT CURSO_ID||CICLO_GRUPO_ID FROM KRDX_CURSO_ACT WHERE CODIGO_ID = '"+codigoId+"' AND CICLO_GRUPO_ID = '"+cicloGrupoId+"'  ) ";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CicloGrupoHorario obj = new CicloGrupoHorario();
				obj.mapeaReg(rs);
				
				llave = obj.getSalonId()+"@"+obj.getPeriodoId()+"@"+obj.getDia();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoHorarioLista|getMapHorarioMaestro|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
}