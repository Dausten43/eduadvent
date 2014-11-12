//Clase  para la tabla CONT_LIBRO
package aca.fin;

import java.sql.*;
import java.util.ArrayList;

public class FinLibroLista {
	
	public ArrayList<FinLibro> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<FinLibro> lisContLibro 	= new ArrayList<FinLibro>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT LIBRO_ID, LIBRO_NOMBRE FROM FIN_LIBRO "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				FinLibro nivel = new FinLibro();				
				nivel.mapeaReg(rs);
				lisContLibro.add(nivel);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinLibroLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisContLibro;
	}
	
}