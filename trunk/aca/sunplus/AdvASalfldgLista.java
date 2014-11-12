package aca.sunplus;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class AdvASalfldgLista {
	
	public ArrayList<AdvASalfldg> getListAll(Connection Conn, String orden) throws SQLException{
		
		ArrayList<AdvASalfldg> lis 	= new ArrayList<AdvASalfldg>();
		Statement st 				= Conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = " SELECT ACCNT_CODE " +
					" FROM ADV_A_SALFLDG "+orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				AdvASalfldg obj = new AdvASalfldg();
				obj.mapeaReg(rs);
				lis.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.sunplus.AdvASalfldgLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lis;
	}
	
}
