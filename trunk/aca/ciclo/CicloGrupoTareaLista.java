package aca.ciclo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class CicloGrupoTareaLista {

	public ArrayList<CicloGrupoTarea> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CicloGrupoTarea> lisCicloGrupoTarea 	= new ArrayList<CicloGrupoTarea>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, TAREA_ID, TAREA_NOMBRE, DESCRIPCION, TEMA_ID, CURSO_ID, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA" +
					" FROM CICLO_GRUPO_TAREA "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloGrupoTarea cicloGrupo = new CicloGrupoTarea();				
				cicloGrupo.mapeaReg(rs);
				lisCicloGrupoTarea.add(cicloGrupo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoTareaLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCicloGrupoTarea;
	}
	
	public ArrayList<CicloGrupoTarea> getListTareasTema(Connection conn, String cicloGrupoId, String cursoId, String temaId, String orden ) throws SQLException{
		ArrayList<CicloGrupoTarea> lisCicloGrupoTarea 	= new ArrayList<CicloGrupoTarea>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, TAREA_ID, TAREA_NOMBRE, DESCRIPCION, TEMA_ID, CURSO_ID, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA" +
					" FROM CICLO_GRUPO_TAREA " +
					" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
					" AND CURSO_ID = '"+cursoId+"'" +
					" AND TEMA_ID = '"+temaId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloGrupoTarea cicloGrupo = new CicloGrupoTarea();				
				cicloGrupo.mapeaReg(rs);
				lisCicloGrupoTarea.add(cicloGrupo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoTareaLista|getListTareaTema|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCicloGrupoTarea;
	}
	
	public ArrayList<CicloGrupoTarea> getTareasFecha(Connection conn, String codigoId, String fecha, String orden ) throws SQLException{
		ArrayList<CicloGrupoTarea> lisCicloGrupoTarea 	= new ArrayList<CicloGrupoTarea>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, TAREA_ID, TAREA_NOMBRE, DESCRIPCION, TEMA_ID, CURSO_ID, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA" +
					" FROM CICLO_GRUPO_TAREA WHERE TO_CHAR(FECHA,'DD/MM/YYYY') = '"+fecha+"' " +
					" AND CICLO_GRUPO_ID||CURSO_ID " +
					" IN (SELECT CICLO_GRUPO_ID||CURSO_ID FROM KRDX_CURSO_ACT WHERE CODIGO_ID = '"+codigoId+"' ) "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloGrupoTarea cicloGrupo = new CicloGrupoTarea();				
				cicloGrupo.mapeaReg(rs);
				lisCicloGrupoTarea.add(cicloGrupo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoTareaLista|getTareasFecha|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCicloGrupoTarea;
	}

}
