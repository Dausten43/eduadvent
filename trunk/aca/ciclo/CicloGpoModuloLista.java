package aca.ciclo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class CicloGpoModuloLista {

	public ArrayList<CicloGpoModulo> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CicloGpoModulo> lisCicloGrupoMod 	= new ArrayList<CicloGpoModulo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, MODULO_ID, MODULO_NOMBRE, " +
					"DESCRIPCION, ORDEN FROM CICLO_GRUPO_MODULO "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloGpoModulo cicloGpo = new CicloGpoModulo();				
				cicloGpo.mapeaReg(rs);
				lisCicloGrupoMod.add(cicloGpo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloBloqueLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCicloGrupoMod;
	}
	
	
	
	public ArrayList<CicloGpoModulo> getListCurso(Connection conn, String cicloGrupoId, String cursoId, String orden ) throws SQLException{
		ArrayList<CicloGpoModulo> lisCicloGrupoMod 	= new ArrayList<CicloGpoModulo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, MODULO_ID, MODULO_NOMBRE, " +
					"DESCRIPCION, CURSO_ID, ORDEN FROM CICLO_GRUPO_MODULO " +
					"WHERE CICLO_GRUPO_ID ='"+cicloGrupoId+"' " +
					"AND CURSO_ID = '"+cursoId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloGpoModulo cicloGpo = new CicloGpoModulo();
				cicloGpo.mapeaReg(rs);
				lisCicloGrupoMod.add(cicloGpo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloBloqueLista|getListCurso|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCicloGrupoMod;
	}
	
	public ArrayList<CicloGpoModulo> getCurso(Connection conn, String cicloGrupoId, String cursoId, String moduloId, String orden ) throws SQLException{
		ArrayList<CicloGpoModulo> lisCicloGrupoMod 	= new ArrayList<CicloGpoModulo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, MODULO_ID, MODULO_NOMBRE, " +
					"DESCRIPCION, CURSO_ID, ORDEN FROM CICLO_GRUPO_MODULO " +
					"WHERE CICLO_GRUPO_ID ='"+cicloGrupoId+"' " +
					"AND CURSO_ID = '"+cursoId+"' "+
					"AND MODULO_ID = '"+moduloId+"'"+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloGpoModulo cicloGpo = new CicloGpoModulo();
				cicloGpo.mapeaReg(rs);
				lisCicloGrupoMod.add(cicloGpo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloBloqueLista|getListCurso|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCicloGrupoMod;
	}
	
}	