package aca.ciclo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class CicloGrupoArchivoLista {

	public ArrayList<CicloGrupoArchivo> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CicloGrupoArchivo> lisArchivo 	= new ArrayList<CicloGrupoArchivo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, CURSO_ID, TEMA_ID, FOLIO, ARCHIVO, DESCRIPCION, NOMBRE" +
					" FROM CICLO_GRUPO_ARCHIVO "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloGrupoArchivo archivo = new CicloGrupoArchivo();				
				archivo.mapeaReg(rs);
				lisArchivo.add(archivo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoArchivoLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisArchivo;
	}
	
	public ArrayList<CicloGrupoArchivo> getListTema(Connection conn, String cicloGrupoId, String cursoId, String temaId, String orden ) throws SQLException{
		
		ArrayList<CicloGrupoArchivo> lisArchivo 	= new ArrayList<CicloGrupoArchivo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, CURSO_ID, TEMA_ID, FOLIO, ARCHIVO, DESCRIPCION, NOMBRE" +
					" FROM CICLO_GRUPO_ARCHIVO " +
					" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
					" AND CURSO_ID = '"+cursoId+"'" +
					" AND TEMA_ID = '"+temaId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloGrupoArchivo archivo = new CicloGrupoArchivo();				
				archivo.mapeaReg(rs);
				lisArchivo.add(archivo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoArchivoLista|getListTema|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisArchivo;
	}	

}
