package aca.catalogo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class CatActividadEtiquetaLista {
	
	public ArrayList<CatActividadEtiqueta> getListAll(Connection conn, String unionId, String orden) throws SQLException{
		ArrayList<CatActividadEtiqueta> list 	= new ArrayList<CatActividadEtiqueta>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = "SELECT * " +
					"FROM CAT_ACTIVIDAD_ETIQUETA WHERE UNION_ID = TO_NUMBER('"+unionId+"', '99') "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				CatActividadEtiqueta obj = new CatActividadEtiqueta();				
				obj.mapeaReg(rs);
				list.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatActividadEtiquetaLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	
	public ArrayList<CatActividadEtiqueta> getListBloque(Connection conn, String unionId, String cicloId, String bloqueId, String orden) throws SQLException{
		ArrayList<CatActividadEtiqueta> list 	= new ArrayList<CatActividadEtiqueta>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = "SELECT * FROM CAT_ACTIVIDAD_ETIQUETA"
					+ " WHERE UNION_ID = TO_NUMBER('"+unionId+"', '99')"
					+ " AND ETIQUETA_ID "
					+ "    IN (SELECT ETIQUETA_ID FROM CICLO_BLOQUE_ACTIVIDAD WHERE CICLO_ID = '"+cicloId+"' AND BLOQUE_ID = '"+bloqueId+"' )"+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				CatActividadEtiqueta obj = new CatActividadEtiqueta();
				obj.mapeaReg(rs);
				list.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatActividadEtiquetaLista|getListBloque|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
}
