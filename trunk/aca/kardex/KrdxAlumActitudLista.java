
package aca.kardex;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.TreeMap;


public class KrdxAlumActitudLista {
	
	public ArrayList<KrdxAlumActitud> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<KrdxAlumActitud> lis 	= new ArrayList<KrdxAlumActitud>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID," +
                " EVALUACION_ID, ASPECTOS_ID, NOTA " +
                " FROM KRDX_ALUM_ACTITUD "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				KrdxAlumActitud obj = new KrdxAlumActitud();				
				obj.mapeaReg(rs);
				lis.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumActitudLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lis;
	}
}
