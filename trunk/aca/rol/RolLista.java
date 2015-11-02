package aca.rol;

import java.sql.*;
import java.util.ArrayList;

public class RolLista {
	
	public ArrayList<Rol> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<Rol> list 	= new ArrayList<Rol>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT * FROM ROL "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				Rol obj = new Rol();
				obj.mapeaReg(rs);
				list.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.rol.Rol|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return list;
	}

}