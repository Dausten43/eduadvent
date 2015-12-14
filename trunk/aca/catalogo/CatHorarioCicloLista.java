package aca.catalogo;

import java.sql.*;
import java.util.ArrayList;

public class CatHorarioCicloLista {
	
	public ArrayList<CatHorarioCiclo> getListAll(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<CatHorarioCiclo> lis 	= new ArrayList<CatHorarioCiclo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT * FROM CAT_HORARIO_CICLO WHERE ESCUELA_ID = '"+escuelaId+"' "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatHorarioCiclo obj = new CatHorarioCiclo();				
				obj.mapeaReg(rs);
				lis.add(obj);
				
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorarioCicloLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lis;
	}
	
	public ArrayList<CatHorarioCiclo> getListCiclo(Connection conn, String escuelaId, String cicloId, String orden ) throws SQLException{
		ArrayList<CatHorarioCiclo> lis 	= new ArrayList<CatHorarioCiclo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT *"
					+ " FROM CAT_HORARIO_CICLO"
					+ " WHERE CICLOS LIKE '%"+cicloId+"%' "
					+ " AND ESCUELA_ID = '"+escuelaId+"' "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatHorarioCiclo obj = new CatHorarioCiclo();				
				obj.mapeaReg(rs);
				lis.add(obj);
				
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorarioCicloLista|getListCiclo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lis;
	}
	
	public static String getCiclos(Connection conn, String escuelaId, String folio) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nombre			= "X";		
		
		try{
			ps = conn.prepareStatement("SELECT CICLOS FROM CAT_HORARIO_CICLO WHERE ESCUELA_ID = '"+escuelaId+"' AND FOLIO = TO_NUMBER('"+folio+"', '999') ");
			rs= ps.executeQuery();		
			if(rs.next()){
				nombre = rs.getString("CICLOS");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorarioCicloLista|getCiclos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return nombre;
	}
	
}