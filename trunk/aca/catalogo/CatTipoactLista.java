package aca.catalogo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

public class CatTipoactLista {
		
	public ArrayList<CatTipoact> getListAll(Connection conn, String orden ) throws SQLException{
		
		ArrayList<CatTipoact> lis	= new ArrayList<CatTipoact>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT TIPOACT_ID, TIPOACT_NOMBRE, UNION_ID FROM CAT_TIPOACT "+ orden; 
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				CatTipoact tipo = new CatTipoact();
				tipo.mapeaReg(rs);
				lis.add(tipo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipoactLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lis;
	}
	
	public ArrayList<CatTipoact> getListUnion(Connection conn, String unionId, String orden) throws SQLException{
		
		ArrayList<CatTipoact> lis	= new ArrayList<CatTipoact>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT TIPOACT_ID, TIPOACT_NOMBRE, UNION_ID FROM CAT_TIPOACT WHERE UNION_ID ='"+unionId+"'"+ orden; 
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				CatTipoact tipo = new CatTipoact();
				tipo.mapeaReg(rs);
				lis.add(tipo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipoactLista|getListUnion|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lis;
	}
	
	public HashMap<String,CatTipoact> getMapAll(Connection conn, String orden ) throws SQLException{
		
		HashMap<String,CatTipoact> map = new HashMap<String,CatTipoact>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT TIPOACT_ID, TIPOACT_NOMBRE UNION_ID FROM CAT_TIPOACT "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatTipoact obj = new CatTipoact();
				obj.mapeaReg(rs);
				llave = obj.getTipoactId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipoactLista|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
}