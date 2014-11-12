//Clase  para la tabla CONT_LIBRO
package aca.cont;

import java.sql.*;
import java.util.ArrayList;

public class ContLibroLista {
	
	public ArrayList<ContLibro> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<ContLibro> lisContLibro 	= new ArrayList<ContLibro>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT LIBRO_ID, LIBRO_NOMBRE FROM CONT_LIBRO "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				ContLibro nivel = new ContLibro();				
				nivel.mapeaReg(rs);
				lisContLibro.add(nivel);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cont.ContLibroLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisContLibro;
	}
	
}