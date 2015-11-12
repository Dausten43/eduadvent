package aca.rol;

import java.sql.*;
import java.util.ArrayList;

public class RolOpcionLista {
	
	public ArrayList<RolOpcion> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<RolOpcion> list 	= new ArrayList<RolOpcion>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT * FROM ROL_OPCION "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				RolOpcion obj = new RolOpcion();
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
	
	public ArrayList<RolOpcion> getList(Connection conn, String rolId, String orden ) throws SQLException{
		ArrayList<RolOpcion> list 	= new ArrayList<RolOpcion>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT * FROM ROL_OPCION WHERE ROL_ID=TO_NUMBER('"+rolId+"', '999')"+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				RolOpcion obj = new RolOpcion();
				obj.mapeaReg(rs);
				list.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.rol.RolOpciones|getList|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return list;
	}

}