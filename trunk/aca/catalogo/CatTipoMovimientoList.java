package aca.catalogo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * @author Sem Barba
 */

public class CatTipoMovimientoList {

	public ArrayList<CatTipoMovimiento> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CatTipoMovimiento> lisMovi 	= new ArrayList<CatTipoMovimiento>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT TIPOMOV_ID, NOMBRE, TIPO" +               
                " FROM CAT_TIPOMOV "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatTipoMovimiento ct = new CatTipoMovimiento();				
				ct.mapeaReg(rs);
				lisMovi.add(ct);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipocaMovimientoLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisMovi;
	}
	
	public HashMap<String,CatTipoMovimiento> getMapAll(Connection conn, String orden ) throws SQLException{
		
		HashMap<String,CatTipoMovimiento> map = new HashMap<String,CatTipoMovimiento>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT TIPOMOV_ID, NOMBRE, TIPO" +               
                " FROM CAT_TIPOMOV "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatTipoMovimiento obj = new CatTipoMovimiento();
				obj.mapeaReg(rs);
				llave = obj.getTipoMovId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipocaMovimientoLista|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}

}
