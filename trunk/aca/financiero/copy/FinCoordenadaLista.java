package aca.financiero.copy;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class FinCoordenadaLista {
	
	public ArrayList<FinCoordenada> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<FinCoordenada> lisFinCoordenada	= new ArrayList<FinCoordenada>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT USUARIO, TIPO, CLIENTE, DOMICILIO," +
                    " RFC, OBSERVACIONES, LETRA, TOTAL, CODIGO, NOMBRE, CONCEPTO, IMPORTE, FECHA" +
					" FROM FIN_COORDENADA "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinCoordenada fr = new FinCoordenada();				
				fr.mapeaReg(rs);
				lisFinCoordenada.add(fr);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.financiero.FinCoordenadaLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisFinCoordenada;
	}
}
