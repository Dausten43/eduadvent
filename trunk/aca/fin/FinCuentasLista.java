package aca.fin;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class FinCuentasLista {
	public ArrayList<FinCuentas> getListCuentas(Connection conn, String escuelaId, String order) throws SQLException{
		ArrayList<FinCuentas> lisFinCuentas 	= new ArrayList<FinCuentas>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT * FROM FIN_CUENTAS WHERE ESCUELA_ID = '"+escuelaId+"' "+order;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinCuentas fc = new FinCuentas();				
				fc.mapeaReg(rs);
				lisFinCuentas.add(fc);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCuentasLista|getListCuentas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisFinCuentas;
	}
	
}
