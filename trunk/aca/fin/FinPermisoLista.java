package aca.fin;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class FinPermisoLista {
	public ArrayList<FinFolio> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<FinFolio> lisFolio 	= new ArrayList<FinFolio>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{			
			comando = "SELECT CODIGO_ID, FOLIO, FECHA_INI, FECHA_FIN, ESTADO, COMENTARIO FROM FIN_PERMISO "+orden;			
			rs = st.executeQuery(comando);			
			while (rs.next()){			
				FinFolio folio = new FinFolio();				
				folio.mapeaReg(rs);
				lisFolio.add(folio);			
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.FinPermisoLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisFolio;
	}
}
