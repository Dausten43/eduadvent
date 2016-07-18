
package aca.kardex;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class KrdxAlumExtraLista {
	public ArrayList<KrdxAlumExtra> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<KrdxAlumExtra> lis 	= new ArrayList<KrdxAlumExtra>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID," +
                " OPORTUNIDAD, NOTA_ANTERIOR, NOTA_EXTRA, PROMEDIO,"+ 
                " FECHA" +
                " FROM KRDX_ALUM_EXTRA "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				KrdxAlumExtra obj = new KrdxAlumExtra();				
				obj.mapeaReg(rs);
				lis.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumExtraLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lis;
	}
	
	
}
