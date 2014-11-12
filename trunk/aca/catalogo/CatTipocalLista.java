/**
 * 
 */
package aca.catalogo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;


/**
 * @author Jose Torres
 *
 */
public class CatTipocalLista {
	public ArrayList<CatTipocal> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CatTipocal> lisEval 	= new ArrayList<CatTipocal>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT TIPOCAL_ID, TIPOCAL_NOMBRE, TIPOCAL_CORTO" +               
                " FROM CAT_TIPOCAL "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatTipocal ct = new CatTipocal();				
				ct.mapeaReg(rs);
				lisEval.add(ct);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipocalLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisEval;
	}
	
	public HashMap<String,CatTipocal> getMapAll(Connection conn, String orden ) throws SQLException{
		
		HashMap<String,CatTipocal> map = new HashMap<String,CatTipocal>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT TIPOCAL_ID, TIPOCAL_NOMBRE, TIPOCAL_CORTO" +               
                " FROM CAT_TIPOCAL "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatTipocal obj = new CatTipocal();
				obj.mapeaReg(rs);
				llave = obj.getTipocalId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipocalLista|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
}
