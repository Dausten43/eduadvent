package aca.cont;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;

public class ContCierramesLista {
	public ArrayList<ContCierrames> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<ContCierrames> lisContCierrames 	= new ArrayList<ContCierrames>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT EJERCICIO_ID,MES FROM CONT_CIERRAMES "+orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				ContCierrames mes = new ContCierrames();				
				mes.mapeaReg(rs);
				lisContCierrames.add(mes);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cont.ContCierrames|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisContCierrames;
	}
}
