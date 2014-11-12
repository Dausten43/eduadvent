package aca.est;

import java.sql.*;
import java.util.ArrayList;

public class EstEncuestaLista{
	
	public ArrayList<EstEncuesta> getListAll(Connection conn, String orden) throws SQLException{
		
		ArrayList<EstEncuesta> lis		= new ArrayList<EstEncuesta>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT ENCUESTA_ID, ENCUESTA_NOMBRE, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, "+
					  " USUARIO, TO_CHAR(FECHA_LIMITE, 'DD/MM/YYYY') AS FECHA_LIMITE, UNIONES FROM EST_ENCUESTA "+orden;	 
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				EstEncuesta obj = new EstEncuesta();
				obj.mapeaReg(rs);
				lis.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cultural.EstEncuestaLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lis;
	}
		
}