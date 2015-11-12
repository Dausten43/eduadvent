package aca.rol;

import java.sql.*;
import java.util.ArrayList;

public class RolOpcionLista {
	
	public ArrayList<Rol> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<Rol> list 	= new ArrayList<Rol>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT * FROM ROL_OPCION "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				Rol obj = new Rol();
				obj.mapeaReg(rs);
				list.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.rol.RolOpciones|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return list;
	}
	
	public ArrayList<Rol> getList(Connection conn, String rolId, String orden ) throws SQLException{
		ArrayList<Rol> list 	= new ArrayList<Rol>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT * FROM ROL_OPCION WHERE ROL_ID='"+rolId+"'"+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				Rol obj = new Rol();
				obj.mapeaReg(rs);
				list.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.rol.RolOpciones|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return list;
	}

}