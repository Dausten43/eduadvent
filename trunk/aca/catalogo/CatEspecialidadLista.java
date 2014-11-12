 	//Clase  para la tabla CAT_ESCUELA
package aca.catalogo;

import java.sql.*;
import java.util.ArrayList;

public class CatEspecialidadLista {
	public ArrayList<CatEspecialidad> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CatEspecialidad> lisCatEspecialidad 	= new ArrayList<CatEspecialidad>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT ESPECIALIDAD_ID, ESPECIALIDAD_NOMBRE  " +
					"FROM CAT_ESPECIALIDAD "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatEspecialidad especialidad = new CatEspecialidad();				
				especialidad.mapeaReg(rs);
				lisCatEspecialidad.add(especialidad);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuelaLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCatEspecialidad;
	}	
}