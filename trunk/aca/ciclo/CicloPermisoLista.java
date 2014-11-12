//Clase  para la tabla CICLO
package aca.ciclo;

import java.sql.*;
import java.util.ArrayList;

public class CicloPermisoLista {
	
	public ArrayList<CicloPermiso> getListAll(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<CicloPermiso> lisPermiso 	= new ArrayList<CicloPermiso>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_ID, NIVEL_ID FROM CICLO_PERMISO WHERE SUBSTR(CICLO_ID,1,3) = '"+escuelaId+"' "+orden;
			
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloPermiso permiso = new CicloPermiso();		
				permiso.mapeaReg(rs);
				lisPermiso.add(permiso);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloPermisoLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisPermiso;
	}
	
	public ArrayList<CicloPermiso> getListConPermiso(Connection conn, String cicloId, String orden ) throws SQLException{
		ArrayList<CicloPermiso> lisPermiso 	= new ArrayList<CicloPermiso>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_ID, NIVEL_ID FROM CICLO_PERMISO WHERE CICLO_ID = '"+cicloId+"' "+orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloPermiso permiso = new CicloPermiso();
				permiso.mapeaReg(rs);
				lisPermiso.add(permiso);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloPermisoLista|getListConPermiso|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisPermiso;
	}
	
	public ArrayList<CicloPermiso> getListConPermiso(Connection conn, String cicloId, String planId, String orden ) throws SQLException{
		ArrayList<CicloPermiso> lisPermiso 	= new ArrayList<CicloPermiso>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_ID, NIVEL_ID FROM CICLO_PERMISO" +
					" WHERE CICLO_ID = '"+cicloId+"'" +
					" AND NIVEL_ID IN (SELECT NIVEL_ID FROM PLAN" +
									 " WHERE PLAN_ID = '"+planId+"') "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloPermiso permiso = new CicloPermiso();
				permiso.mapeaReg(rs);
				lisPermiso.add(permiso);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloPermisoLista|getListConPermiso|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisPermiso;
	}
	
	public ArrayList<CicloPermiso> getListSinPermiso(Connection conn, String cicloId, String orden ) throws SQLException{
		ArrayList<CicloPermiso> lisPermiso 	= new ArrayList<CicloPermiso>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		String escuelaId 	= cicloId.substring(0,3);
		
		try{
			comando = "SELECT '"+cicloId+"' AS CICLO_ID, NIVEL_ID FROM CAT_NIVEL_ESCUELA" +
					" WHERE NIVEL_ID NOT IN (SELECT NIVEL_ID FROM CICLO_PERMISO WHERE CICLO_ID = '"+cicloId+"')" +
					" AND ESCUELA_ID = '"+escuelaId+"' " + orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloPermiso permiso = new CicloPermiso();		
				permiso.mapeaReg(rs);
				lisPermiso.add(permiso);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloPermisoLista|getListSinPermiso|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisPermiso;
	}
}