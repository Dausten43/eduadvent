package aca.ciclo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class CicloGpoTemaLista {

	public ArrayList<CicloGpoTema> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CicloGpoTema> lisCicloGrupoTema 	= new ArrayList<CicloGpoTema>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, MODULO_ID, TEMA_NOMBRE, " +
					"TEMA_ID, DESCRIPCION, CURSO_ID, ORDEN, FECHA FROM CICLO_GRUPO_TEMA "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloGpoTema cicloGpo = new CicloGpoTema();				
				cicloGpo.mapeaReg(rs);
				lisCicloGrupoTema.add(cicloGpo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoTemaLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCicloGrupoTema;
	}
	
	public ArrayList<CicloGpoTema> getListTemasModulo(Connection conn, String cicloGrupoId, String cursoId, String moduloId, String orden ) throws SQLException{
		ArrayList<CicloGpoTema> lisCicloGrupoTema 	= new ArrayList<CicloGpoTema>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, MODULO_ID, TEMA_NOMBRE, TEMA_ID, DESCRIPCION, CURSO_ID, ORDEN, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA " +
					" FROM CICLO_GRUPO_TEMA" +
					" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
					" AND CURSO_ID = '"+cursoId+"'" +
					" AND MODULO_ID = '"+moduloId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloGpoTema cicloGpo = new CicloGpoTema();				
				cicloGpo.mapeaReg(rs);
				lisCicloGrupoTema.add(cicloGpo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoTemaLista|getListTemasModulo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCicloGrupoTema;
	}
	

}
