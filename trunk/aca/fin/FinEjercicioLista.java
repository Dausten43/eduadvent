package aca.fin;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.TreeMap;

public class FinEjercicioLista {

	public ArrayList<FinEjercicio> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<FinEjercicio> list	 	= new ArrayList<FinEjercicio>();
		Statement st 						= conn.createStatement();
		ResultSet rs 						= null;
		String comando						= "";
		
		try{			
			comando = "SELECT EJERCICIO_ID, ESCUELA_ID, YEAR, TO_CHAR(FECHA_INI,'DD/MM/YYYY') AS FECHA_INI, TO_CHAR(FECHA_FIN,'DD/MM/YYYY') AS FECHA_FIN FROM FIN_EJERCICIO "+orden;			
			rs = st.executeQuery(comando);			
			while (rs.next()){			
				FinEjercicio ejercicio = new FinEjercicio();				
				ejercicio.mapeaReg(rs);
				list.add(ejercicio);			
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.FinEjercicioLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return list;
	}
	
	public ArrayList<FinEjercicio> getListPorEscuela(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<FinEjercicio> list	 	= new ArrayList<FinEjercicio>();
		Statement st 						= conn.createStatement();
		ResultSet rs 						= null;
		String comando						= "";
		
		try{			
			comando = "SELECT EJERCICIO_ID, ESCUELA_ID, YEAR, TO_CHAR(FECHA_INI,'DD/MM/YYYY') AS FECHA_INI, TO_CHAR(FECHA_FIN,'DD/MM/YYYY') AS FECHA_FIN FROM FIN_EJERCICIO WHERE ESCUELA_ID = '"+escuelaId+"' "+orden;			
			rs = st.executeQuery(comando);			
			while (rs.next()){			
				FinEjercicio ejercicio = new FinEjercicio();				
				ejercicio.mapeaReg(rs);
				list.add(ejercicio);			
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinEjercicioLista|getListPorEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return list;
	}
	
	public TreeMap<String, FinEjercicio> getTreePorEscuela(Connection conn, String escuelaId, String orden) throws SQLException{
		TreeMap<String, FinEjercicio> list	 	= new TreeMap<String, FinEjercicio>();
		Statement st 						= conn.createStatement();
		ResultSet rs 						= null;
		String comando						= "";
		
		try{			
			comando = "SELECT EJERCICIO_ID, ESCUELA_ID, YEAR, TO_CHAR(FECHA_INI,'DD/MM/YYYY') AS FECHA_INI, TO_CHAR(FECHA_FIN,'DD/MM/YYYY') AS FECHA_FIN FROM FIN_EJERCICIO WHERE ESCUELA_ID = '"+escuelaId+"' "+orden;			
			rs = st.executeQuery(comando);			
			while (rs.next()){			
				FinEjercicio ejercicio = new FinEjercicio();				
				ejercicio.mapeaReg(rs);
				list.put(ejercicio.getEjercicioId(), ejercicio);			
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.FinEjercicioLista|getTreePorEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return list;
	}

}
