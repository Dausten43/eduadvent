package aca.financiero.copy;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class FinFolioLista {
	public ArrayList<FinFolio> getListFolio(Connection conn, String codigoId, String order) throws SQLException{
		ArrayList<FinFolio> lisFinFolio 	= new ArrayList<FinFolio>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, ESCUELA_ID, FOLIO_RECIBO, FOLIO_FACTURA FROM FIN_FOLIO WHERE CODIGO_ID = '"+codigoId+"' "+order;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinFolio ff = new FinFolio();				
				ff.mapeaReg(rs);
				lisFinFolio.add(ff);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.financiero.FinFolioLista|getListCuentas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisFinFolio;
	}
	
	

		public ArrayList<FinFolio> getListAll(Connection conn, String orden ) throws SQLException{
			ArrayList<FinFolio> lisFolio 	= new ArrayList<FinFolio>();
			Statement st 	= conn.createStatement();
			ResultSet rs 	= null;
			String comando	= "";
			
			try{			
				comando = "SELECT CODIGO_ID, ESCUELA_ID, FOLIO_RECIBO, FOLIO_FACTURA FROM FIN_FOLIO "+orden;			
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

}
