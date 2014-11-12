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
 * @author Elifo
 *
 */
public class CatTipocursoLista {
	public ArrayList<CatTipocurso> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CatTipocurso> lisTipo 	= new ArrayList<CatTipocurso>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT TIPOCURSO_ID, TIPOCURSO_NOMBRE" +               
                " FROM CAT_TIPOCURSO "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatTipocurso ctc = new CatTipocurso();				
				ctc.mapeaReg(rs);
				lisTipo.add(ctc);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipocursoLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisTipo;
	}
	
	public HashMap<String,CatTipocurso> getMapAll(Connection conn, String orden ) throws SQLException{
		
		HashMap<String,CatTipocurso> map = new HashMap<String,CatTipocurso>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT TIPOCURSO_ID, TIPOCURSO_NOMBRE" +               
                " FROM CAT_TIPOCURSO "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatTipocurso obj = new CatTipocurso();
				obj.mapeaReg(rs);
				llave = obj.getTipocursoId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipocursoLista|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
}
