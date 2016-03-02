package aca.catalogo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class CatSeguroLista {
	
	public ArrayList<CatActividadEtiqueta> getListAll(Connection conn, String escuelaId, String orden) throws SQLException{
		ArrayList<CatActividadEtiqueta> list 	= new ArrayList<CatActividadEtiqueta>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = "SELECT * " +
					"FROM CAT_SEGURO WHERE ESCUELA_ID = TO_NUMBER('"+escuelaId+"', '999') "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				CatActividadEtiqueta obj = new CatActividadEtiqueta();				
				obj.mapeaReg(rs);
				list.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatSeguroLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
}
