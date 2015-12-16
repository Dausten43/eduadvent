package aca.rol;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

import aca.plan.PlanCurso;

public class RolOpcionLista {
	
	public ArrayList<RolOpcion> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<RolOpcion> list 	= new ArrayList<RolOpcion>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT * FROM ROL_OPCION "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				RolOpcion obj = new RolOpcion();
				obj.mapeaReg(rs);
				list.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.rol.RolOpciones|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return list;
	}
	
	public ArrayList<RolOpcion> getList(Connection conn, String rolId, String orden ) throws SQLException{
		ArrayList<RolOpcion> list 	= new ArrayList<RolOpcion>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT * FROM ROL_OPCION WHERE ROL_ID = TO_NUMBER('"+rolId+"', '999')"+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				RolOpcion obj = new RolOpcion();
				obj.mapeaReg(rs);
				list.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.rol.RolOpciones|getList|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return list;
	}
	
	
	public HashMap<String,String> mapOpUsuarios(Connection conn, String roldId ) throws SQLException{
		
		HashMap<String,String> mapa = new HashMap<String,String>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";		
		
		try{
			comando = " SELECT ROL_ID, OPCION_ID FROM ROL_OPCION"
					+ " WHERE ROL_ID = TO_NUMBER('"+roldId+"', '999')";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				mapa.put(rs.getString("ROL_ID")+rs.getString("OPCION_ID"), rs.getString("OPCION_ID"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCursoLista|mapPlanCursos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return mapa;
	}
	

}