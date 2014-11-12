//Clase  para la tabla CAT_HORARIO
package aca.catalogo;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class CatHorarioPeriodoLista {
	public ArrayList<CatHorarioPeriodo> getListAll(Connection conn, String horarioId, String orden ) throws SQLException{
		ArrayList<CatHorarioPeriodo> lisCatHorario 	= new ArrayList<CatHorarioPeriodo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "Select * from cat_Horario_periodo where horario_id = "+horarioId+" "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatHorarioPeriodo hora = new CatHorarioPeriodo();				
				hora.mapeaReg(rs);
				lisCatHorario.add(hora);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorarioLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCatHorario;
	}
	
	public HashMap<String,CatHorarioPeriodo> getMapAll(Connection conn, String orden ) throws SQLException{
		
		HashMap<String,CatHorarioPeriodo> map = new HashMap<String,CatHorarioPeriodo>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "Select * from cat_Horario_periodo "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatHorarioPeriodo obj = new CatHorarioPeriodo();
				obj.mapeaReg(rs);
				llave = obj.getHorarioId()+obj.getPeriodoId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorarioLista|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
}