package aca.financiero.copy;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import aca.catalogo.CatReligion;

public class FinCuentaLista {
	public ArrayList<FinCuenta> getListCuentas(Connection conn, String escuelaId, String order) throws SQLException{
		ArrayList<FinCuenta> lisFinCuenta 	= new ArrayList<FinCuenta>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT ESCUELA_ID, CUENTA_ID, CUENTA_NOMBRE FROM FIN_CUENTA WHERE ESCUELA_ID = '"+escuelaId+"' "+order;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinCuenta fc = new FinCuenta();				
				fc.mapeaReg(rs);
				lisFinCuenta.add(fc);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.financiero.FinCuentaLista|getListCuentas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisFinCuenta;
	}
	
	

		public ArrayList<CatReligion> getListAll(Connection conn, String orden ) throws SQLException{
			ArrayList<CatReligion> lisCatReligion 	= new ArrayList<CatReligion>();
			Statement st 	= conn.createStatement();
			ResultSet rs 	= null;
			String comando	= "";
			
			try{			
				comando = "SELECT ESCUELA_ID,CUENTA_ID, CUENTA_NOMBRE FROM FIN_CUENTA "+orden;			
				rs = st.executeQuery(comando);			
				while (rs.next()){			
					CatReligion religion = new CatReligion();				
					religion.mapeaReg(rs);
					lisCatReligion.add(religion);			
				}
				
			}catch(Exception ex){
				System.out.println("Error - aca.catalogo.CatReligionLista|getListAll|:"+ex);
			}finally{
				if (rs!=null) rs.close();
				if (st!=null) st.close();
			}		
			
			return lisCatReligion;
		}

}
