package aca.fin;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class FinFolioLista {
	public ArrayList<FinFolio> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<FinFolio> lisFolio 	= new ArrayList<FinFolio>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{			
			comando = "SELECT EJERCICIO_ID, USUARIO, RECIBO_INICIAL, RECIBO_FINAL, RECIBO_ACTUAL, ESTADO, FOLIO FROM FIN_FOLIO "+orden;			
			rs = st.executeQuery(comando);			
			while (rs.next()){			
				FinFolio folio = new FinFolio();				
				folio.mapeaReg(rs);
				lisFolio.add(folio);			
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.FinFolioLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisFolio;
	}
	
	public ArrayList<FinFolio> getListEjercicio(Connection conn, String ejercicioId,  String orden ) throws SQLException{
		ArrayList<FinFolio> lisFolio 	= new ArrayList<FinFolio>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{			
			comando = " SELECT EJERCICIO_ID, USUARIO, RECIBO_INICIAL, RECIBO_FINAL, RECIBO_ACTUAL, ESTADO, FOLIO FROM FIN_FOLIO" +
					  " WHERE EJERCICIO_ID = '"+ejercicioId+"' "+orden;			
			rs = st.executeQuery(comando);			
			while (rs.next()){			
				FinFolio folio = new FinFolio();				
				folio.mapeaReg(rs);
				lisFolio.add(folio);			
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.FinFolioLista|getListEjercicio|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisFolio;
	}

}
