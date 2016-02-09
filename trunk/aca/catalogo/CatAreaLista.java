package aca.catalogo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class CatAreaLista {
	
	public ArrayList<CatArea> getListAll(Connection conn, String orden) throws SQLException{
		ArrayList<CatArea> list 	= new ArrayList<CatArea>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = "SELECT * " +
					  "FROM CAT_AREA"+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				CatArea obj = new CatArea();				
				obj.mapeaReg(rs);
				list.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAreaLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}	
}
