//Clase  para la tabla CAT_HORARIO
package aca.catalogo;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class CatHorarioLista {
	public ArrayList<CatHorario> getListAll(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<CatHorario> lisCatHorario 	= new ArrayList<CatHorario>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "Select * from cat_Horario where escuela_id = '"+escuelaId+"' "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatHorario hora = new CatHorario();				
				hora.mapeaReg(rs);
				lisCatHorario.add(hora);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorarioLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCatHorario;
	}
	
	public ArrayList<CatHorario> getListHorariosMaestro(Connection conn, String empleadoId, String cicloId, String orden ) throws SQLException{
		ArrayList<CatHorario> lisCatHorario 	= new ArrayList<CatHorario>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT * FROM CAT_HORARIO WHERE HORARIO_ID IN"
					+ " ("
						+ " SELECT DISTINCT(HORARIO_ID) AS HORARIO_ID"
						+ " FROM CICLO_GRUPO_HORARIO"
						+ " WHERE CURSO_ID||CICLO_GRUPO_ID IN( SELECT CURSO_ID||CICLO_GRUPO_ID FROM CICLO_GRUPO_CURSO WHERE EMPLEADO_ID = '"+empleadoId+"' AND CICLO_GRUPO_ID LIKE '"+cicloId+"%'  )"
					+ ") "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatHorario hora = new CatHorario();				
				hora.mapeaReg(rs);
				lisCatHorario.add(hora);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorarioLista|getListHorariosMaestro|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCatHorario;
	}
	
	public ArrayList<CatHorario> getListHorariosAlumno(Connection conn, String codigoId, String cicloGrupoId, String orden ) throws SQLException{
		ArrayList<CatHorario> lisCatHorario 	= new ArrayList<CatHorario>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT * FROM CAT_HORARIO WHERE HORARIO_ID IN"
					+ " ("
						+ " SELECT DISTINCT(HORARIO_ID) AS HORARIO_ID"
						+ " FROM CICLO_GRUPO_HORARIO"
						+ " WHERE CURSO_ID||CICLO_GRUPO_ID IN( SELECT CURSO_ID||CICLO_GRUPO_ID FROM KRDX_CURSO_ACT WHERE CODIGO_ID = '"+codigoId+"' AND CICLO_GRUPO_ID = '"+cicloGrupoId+"'  )"
					+ ") "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatHorario hora = new CatHorario();				
				hora.mapeaReg(rs);
				lisCatHorario.add(hora);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorarioLista|getListHorariosMaestro|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCatHorario;
	}
	
	public ArrayList<CatHorario> getListHorariosGrupo(Connection conn, String cicloGrupoId, String orden ) throws SQLException{
		ArrayList<CatHorario> lisCatHorario 	= new ArrayList<CatHorario>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT * FROM CAT_HORARIO WHERE HORARIO_ID IN"
					+ " ("
						+ " SELECT DISTINCT(HORARIO_ID) AS HORARIO_ID"
						+ " FROM CICLO_GRUPO_HORARIO"
						+ " WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"' "
					+ ") "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatHorario hora = new CatHorario();				
				hora.mapeaReg(rs);
				lisCatHorario.add(hora);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorarioLista|getListHorariosGrupo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCatHorario;
	}
	
	public HashMap<String,CatHorario> getMapAll(Connection conn, String orden ) throws SQLException{
		
		HashMap<String,CatHorario> map = new HashMap<String,CatHorario>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "Select * from cat_Horario "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatHorario obj = new CatHorario();
				obj.mapeaReg(rs);
				llave = obj.getHorarioId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorarioLista|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
}