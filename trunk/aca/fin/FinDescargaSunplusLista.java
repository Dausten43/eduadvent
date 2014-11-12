package aca.fin;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class FinDescargaSunplusLista {
	
	public ArrayList<FinDescargaSunplus> getDescargasUsuario(Connection conn, String codigoId, String order) throws SQLException{
		ArrayList<FinDescargaSunplus> list 	= new ArrayList<FinDescargaSunplus>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT DESCARGA_ID, CODIGO_ID, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, TIPO_POLIZA, ARCHIVO FROM FIN_DESCARGA_SUNPLUS WHERE CODIGO_ID = '"+codigoId+"' "+order;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinDescargaSunplus obj = new FinDescargaSunplus();				
				obj.mapeaReg(rs);
				list.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinDescargaSunplusLista|getDescargasUsuario|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return list;
	}
	
}
