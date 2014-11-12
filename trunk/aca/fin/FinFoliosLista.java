package aca.fin;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class FinFoliosLista {

	public ArrayList<FinFolios> getFoliosPorEjercicio(Connection conn, String escuelaId, String orden) throws SQLException{
		
		ArrayList<FinFolios> lisFolio 	= new ArrayList<FinFolios>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{			
			comando = "SELECT * FROM FIN_FOLIOS WHERE SUBSTR(EJERCICIO_ID, 1, 3)='"+escuelaId+"' "+orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinFolios folio = new FinFolios();				
				folio.mapeaReg(rs);
				lisFolio.add(folio);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinFoliosLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		return lisFolio;
	}
	
	public ArrayList<FinFolios> getFoliosPorUsuario(Connection conn, String usuario, String orden) throws SQLException{
		ArrayList<FinFolios> lisFolio 	= new ArrayList<FinFolios>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{			
			comando = "SELECT * FROM FIN_FOLIOS WHERE USUARIO = '"+usuario+"' "+orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinFolios folio = new FinFolios();				
				folio.mapeaReg(rs);
				lisFolio.add(folio);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.FinFoliosLista|getFoliosPorUsuario|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		return lisFolio;
	}
}