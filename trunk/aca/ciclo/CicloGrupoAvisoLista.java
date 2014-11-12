package aca.ciclo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class CicloGrupoAvisoLista {
	
	public ArrayList<CicloGrupoAviso> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CicloGrupoAviso> lisCicloGrupoAviso 	= new ArrayList<CicloGrupoAviso>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, CURSO_ID, FOLIO, EMPLEADO_ID, CODIGO_ID, FECHA, AVISO " +
					" FROM CICLO_GRUPO_AVISO "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloGrupoAviso grupoAviso = new CicloGrupoAviso();				
				grupoAviso.mapeaReg(rs);
				lisCicloGrupoAviso.add(grupoAviso);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoAviso|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCicloGrupoAviso;
	}
	
	public ArrayList<CicloGrupoAviso> getListAlumno(Connection conn, String codigoId, String orden ) throws SQLException{
		ArrayList<CicloGrupoAviso> lisCicloGrupoAviso 	= new ArrayList<CicloGrupoAviso>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, CURSO_ID, FOLIO, EMPLEADO_ID, CODIGO_ID, FECHA, AVISO " +
					" FROM CICLO_GRUPO_AVISO " +
					" WHERE CODIGO_ID = '"+codigoId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloGrupoAviso grupoAviso = new CicloGrupoAviso();				
				grupoAviso.mapeaReg(rs);
				lisCicloGrupoAviso.add(grupoAviso);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoAviso|getListAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCicloGrupoAviso;
	}
	
	public ArrayList<CicloGrupoAviso> getListAlumno(Connection conn, String cicloGrupoId, String cursoId, String codigoId, String orden ) throws SQLException{
		ArrayList<CicloGrupoAviso> lisCicloGrupoAviso 	= new ArrayList<CicloGrupoAviso>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, CURSO_ID, FOLIO, EMPLEADO_ID, CODIGO_ID, FECHA, AVISO " +
					" FROM CICLO_GRUPO_AVISO " +
					" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
					" AND CURSO_ID = '"+cursoId+"'" +
					" AND CODIGO_ID = '"+codigoId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloGrupoAviso grupoAviso = new CicloGrupoAviso();				
				grupoAviso.mapeaReg(rs);
				lisCicloGrupoAviso.add(grupoAviso);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoAviso|getListAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCicloGrupoAviso;
	}
	
	
	
}
