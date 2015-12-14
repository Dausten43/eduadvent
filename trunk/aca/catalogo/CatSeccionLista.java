package aca.catalogo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class CatSeccionLista {
		
	public ArrayList<CatSeccion> getListAll(Connection conn, String orden ) throws SQLException{
		
		ArrayList<CatSeccion> lis	= new ArrayList<CatSeccion>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT SECCION_ID, SECCION_NOMBRE, TIPO, UNION_ID FROM CAT_SECCION "+ orden; 
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				CatSeccion seccion = new CatSeccion();
				seccion.mapeaReg(rs);
				lis.add(seccion);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatSeccionLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lis;
	}
	
	public ArrayList<CatSeccion> getListTipoUnion(Connection conn,String tipo, String unionId, String orden ) throws SQLException{
		
		ArrayList<CatSeccion> lis	= new ArrayList<CatSeccion>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT SECCION_ID, SECCION_NOMBRE, TIPO, UNION_ID FROM CAT_SECCION WHERE TIPO = '"+tipo+"' AND UNION_ID = TO_NUMBER('"+unionId+"', '99')"+ orden; 
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				CatSeccion seccion = new CatSeccion();
				seccion.mapeaReg(rs);
				lis.add(seccion);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatSeccionLista|getListTipoUnion|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lis;
	}
	
	public ArrayList<CatSeccion> getListUnion(Connection conn, String unionId, String orden ) throws SQLException{
		
		ArrayList<CatSeccion> lis	= new ArrayList<CatSeccion>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT SECCION_ID, SECCION_NOMBRE, TIPO, UNION_ID FROM CAT_SECCION WHERE UNION_ID = TO_NUMBER('"+unionId+"', '99')"+ orden; 
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				CatSeccion seccion = new CatSeccion();
				seccion.mapeaReg(rs);
				lis.add(seccion);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatSeccionLista|getListUnion|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lis;
	}
}