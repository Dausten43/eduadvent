//Clase  para la tabla CICLO
package aca.ciclo;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;


public class CicloGrupoLista {
	public ArrayList<CicloGrupo> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CicloGrupo> lisCicloGrupo 	= new ArrayList<CicloGrupo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, CICLO_ID, GRUPO_NOMBRE, " +
			 		"EMPLEADO_ID, HORARIO_ID, SALON_ID, NIVEL_ID, GRADO, GRUPO, PLAN_ID "+
					"FROM CICLO_GRUPO "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				CicloGrupo obj = new CicloGrupo();				
				obj.mapeaReg(rs);
				lisCicloGrupo.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCicloGrupo;
	}
	
	public static ArrayList<String> getMaestroGrupos(Connection conn, String cicloId, String maestroId) throws SQLException{
		PreparedStatement ps		= null;
		ResultSet rs				= null;
		ArrayList<String> list  	= new ArrayList<String>();
		
		try{						
			ps = conn.prepareStatement("SELECT DISTINCT(CICLO_GRUPO_ID) AS GRUPO FROM CICLO_GRUPO "+
				" WHERE CICLO_ID = ? AND EMPLEADO_ID = ?");
			ps.setString(1, cicloId);
			ps.setString(2, maestroId);
			
			rs = ps.executeQuery();
			while(rs.next()){
				list.add(rs.getString("GRUPO"));
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoLista|getMaestroGrupos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return list;
	}
	
	public ArrayList<CicloGrupo> getListGrupos(Connection conn, String cicloId, String orden ) throws SQLException{
		ArrayList<CicloGrupo> lisCicloGrupo 	= new ArrayList<CicloGrupo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, CICLO_ID, GRUPO_NOMBRE, " +
			 		"EMPLEADO_ID, HORARIO_ID, SALON_ID, NIVEL_ID, GRADO, GRUPO, PLAN_ID "+
					"FROM CICLO_GRUPO AS CG WHERE CICLO_ID = '"+cicloId+"' "+ 
			 		"AND PLAN_ID NOT IN (SELECT PLAN_ID FROM PLAN WHERE PLAN_ID = CG.PLAN_ID AND ESTADO = 'I') "+
					orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloGrupo cicle = new CicloGrupo();				
				cicle.mapeaReg(rs);
				lisCicloGrupo.add(cicle);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoLista|getListGrupos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCicloGrupo;
	}
	
	public ArrayList<CicloGrupo> getListGrupos(Connection conn, String cicloId, String planId, String orden ) throws SQLException{
		ArrayList<CicloGrupo> lisCicloGrupo 	= new ArrayList<CicloGrupo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, CICLO_ID, GRUPO_NOMBRE," +
			 		" EMPLEADO_ID, HORARIO_ID, SALON_ID, NIVEL_ID, GRADO, GRUPO, PLAN_ID"+
					" FROM CICLO_GRUPO" +
					" WHERE CICLO_ID = '"+cicloId+"'" +
					" AND PLAN_ID = '"+planId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloGrupo cicle = new CicloGrupo();			
				cicle.mapeaReg(rs);
				lisCicloGrupo.add(cicle);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoLista|getListGrupos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCicloGrupo;
	}
	
	public ArrayList<CicloGrupo> getListGruposDelCiclo(Connection conn, String cicloId, String orden ) throws SQLException{
		ArrayList<CicloGrupo> lisCicloGrupo 	= new ArrayList<CicloGrupo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, CICLO_ID, GRUPO_NOMBRE," +
			 		" EMPLEADO_ID, HORARIO_ID, SALON_ID, NIVEL_ID, GRADO, GRUPO, PLAN_ID"+
					" FROM CICLO_GRUPO" +
					" WHERE CICLO_ID = '"+cicloId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloGrupo cicle = new CicloGrupo();			
				cicle.mapeaReg(rs);
				lisCicloGrupo.add(cicle);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoLista|getListGruposDelCiclo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCicloGrupo;
	}
	
	
	public HashMap<String,CicloGrupo> getReprobonesPorNivel(Connection conn, String cicloId, String bloqueId, String orden ) throws SQLException{
		
		HashMap<String,CicloGrupo> map 	= new HashMap<String,CicloGrupo>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";
		String llave					= "";
		
		try{//EL NUMERO DE REPROBADOS SE PONDRA EN LA COLUMNA 'GRUPO_NOMBRE'
			comando = "SELECT CICLO_GRUPO_ID, CICLO_ID," +
					" EMPLEADO_ID, HORARIO_ID, SALON_ID, NIVEL_ID, GRADO, GRUPO, PLAN_ID, " +
					" (SELECT COUNT(CURSO_ID) FROM KRDX_ALUM_EVAL WHERE CICLO_GRUPO_ID = CICLO_GRUPO.CICLO_GRUPO_ID AND EVALUACION_ID = "+bloqueId+" AND NOTA < (SELECT NOTA_AC FROM PLAN_CURSO WHERE CURSO_ID = KRDX_ALUM_EVAL.CURSO_ID)) AS GRUPO_NOMBRE" +
					" FROM CICLO_GRUPO WHERE CICLO_ID = '"+cicloId+"' "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CicloGrupo obj = new CicloGrupo();
				obj.mapeaReg(rs);
				llave = obj.getNivelId()+obj.getGrado()+obj.getGrupo();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoLista|getReprobonesPorNivel|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
}