package aca.catalogo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class CatSeguroLista {
	
	public ArrayList<CatSeguro> getListAll(Connection conn, String escuelaId, String orden) throws SQLException{
		ArrayList<CatSeguro> list 	= new ArrayList<CatSeguro>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT * " +
					"FROM CAT_SEGURO WHERE ESCUELA_ID = '"+escuelaId+"' "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				CatSeguro obj = new CatSeguro();				
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
